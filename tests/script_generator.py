"""
Port Python du ScriptGenerator JavaScript (static/js/script-generator.js).

Même algorithme, même comportement. Utilisé par le test runner pour générer
des scripts d'installation sans passer par le navigateur.

Usage:
    from script_generator import ScriptGenerator

    gen = ScriptGenerator(distro, programs, dependencies)
    script = gen.build_script()
"""

import json
from pathlib import Path


class ScriptGenerator:
    """
    Génère un script bash d'installation pour une distribution donnée.

    Attributs:
        distro (dict):  Distribution cible (slug, name, install_package_command)
        programs (list):  Liste des programmes sélectionnés (format program.json)
        dependencies (list):  Liste des dépendances build-time (format program.json)
        content_root (Path):  Racine du dossier content/ pour lire les install.sh
    """

    def __init__(self, distro, programs, dependencies, content_root="content"):
        self.distro = distro
        self.programs = programs
        self.dependencies = dependencies
        self.content_root = Path(content_root)
        # Pas de sudo dans Docker (root)
        self.privilege_escalation = ""

    def _find_item(self, slug):
        """
        Cherche un slug dans programs puis dans dependencies.
        Retourne (item, folder) ou None.
        """
        for prog in self.programs:
            if prog.get("slug") == slug:
                return prog, "programs"
        for dep in self.dependencies:
            if dep.get("slug") == slug:
                return dep, "dependencies"
        return None

    def _retrieve_package_names(self):
        """
        Sépare les programmes en deux catégories :
        - package_names : installations via package manager natif
        - custom_slugs   : installations via CUSTOM_INSTALL
        """
        package_names = []
        custom_slugs = []

        for program in self.programs:
            names = program.get("package_names", {})
            pkg_name = names.get(self.distro["slug"], names.get("default"))
            if pkg_name == "CUSTOM_INSTALL":
                custom_slugs.append(program["slug"])
            elif pkg_name:
                package_names.append(pkg_name)

        return package_names, custom_slugs

    def _build_package_install_cmd(self, package_names):
        """Construit la commande d'installation groupée pour les packages natifs."""
        if not package_names:
            return ""
        cmd = f"{self.distro['install_package_command']} {' '.join(package_names)}"
        if self.privilege_escalation:
            cmd = f"{self.privilege_escalation} {cmd}"
        return cmd

    def _resolve_dependencies(self, slug, visited, result):
        """
        DFS récursif post-order (topological sort).
        
        Args:
            slug: Slug du programme à résoudre
            visited: Set partagé des slugs déjà traités
            result: dict avec 'order' (list) et 'packages' (list)
        """
        if slug in visited:
            return
        visited.add(slug)

        found = self._find_item(slug)
        deps = found[0].get("dependencies", []) if found else []

        for dep in deps:
            dep_found = self._find_item(dep)

            if not dep_found:
                # Pas un slug connu → nom de paquet raw
                if dep not in result["packages"]:
                    result["packages"].append(dep)
                continue

            pkg_name = (
                dep_found[0].get("package_names", {}).get(self.distro["slug"])
                or dep_found[0].get("package_names", {}).get("default")
            )

            if pkg_name == "CUSTOM_INSTALL":
                # Récurse dans la dépendance avant de continuer (post-order)
                self._resolve_dependencies(dep, visited, result)
            elif pkg_name and pkg_name not in result["packages"]:
                result["packages"].append(pkg_name)

        # Post-order : ajouter le slug APRÈS ses dépendances
        result["order"].append({
            "slug": slug,
            "folder": found[1] if found else "programs",
        })

    def _get_custom_install(self, slug, visited):
        """
        Résout les dépendances d'un CUSTOM_INSTALL puis lit son install.sh
        depuis le filesystem. Le visited set est partagé entre tous les
        CUSTOM_INSTALL pour éviter les doublons.
        """
        result = {"order": [], "packages": []}
        self._resolve_dependencies(slug, visited, result)

        parts = []

        if result["packages"]:
            for pkg in result["packages"]:
                cmd = f"{self.distro['install_package_command']} {pkg}"
                if self.privilege_escalation:
                    cmd = f"{self.privilege_escalation} {cmd}"
                parts.append(f'install_native "{pkg}" {cmd}')

        for entry in result["order"]:
            s = entry["slug"]
            folder = entry["folder"]
            install_path = (
                self.content_root / folder / s / "custom_install" / "install.sh"
            )
            if install_path.exists():
                content = install_path.read_text()
                # Strip shebang and set -e (already in header)
                lines = content.strip().split("\n")
                clean_lines = [
                    l for l in lines
                    if not l.startswith("#!") and l.strip() != "set -e"
                ]
                parts.append("\n".join(clean_lines))

        return "\n".join(p for p in parts if p)

    def _custom_installs(self, custom_slugs):
        """
        Itère sur tous les slugs CUSTOM_INSTALL avec un visited set partagé.
        Chaque programme est wrappé dans une fonction de logging pour le runner.
        """
        visited = set()
        parts = []

        for slug in custom_slugs:
            # Trouver le nom du programme pour le log
            prog = next((p for p in self.programs if p.get("slug") == slug), None)
            name = prog["name"] if prog else slug

            script = self._get_custom_install(slug, visited)
            if script:
                parts.append(f'echo "▶️  [{name}] Installing..."')
                parts.append(script)
                parts.append(f'echo "✅ [{name}] PASSED"')

        return "\n".join(parts)

    def _script_header(self):
        """Génère le shebang et les helpers de logging."""
        return """#!/bin/bash
# Run all programs, collect all failures (don't stop on first error)
set +e

# Wrapper de logging pour les packages natifs
install_native() {
    local name="$1"
    shift
    echo "▶️  [$name] Installing..."
    if "$@" 2>&1; then
        echo "✅ [$name] PASSED"
    else
        local rc=$?
        echo "❌ [$name] FAILED (exit code: $rc)"
        echo "   Command: $*"
        return $rc
    fi
}

# Wrapper de logging pour les scripts custom
install_custom() {
    local name="$1"
    shift
    echo "▶️  [$name] Installing (custom)..."
    if bash -c "$*" 2>&1; then
        echo "✅ [$name] PASSED"
    else
        local rc=$?
        echo "❌ [$name] FAILED (exit code: $rc)"
        return $rc
    fi
}
"""

    def build_script(self):
        """
        Assemble le script final : header + packages natifs + customs.
        
        Returns:
            str: Le script bash complet
        """
        package_names, custom_slugs = self._retrieve_package_names()

        # Packages natifs — installés en groupe, mais loggés individuellement
        native_section = ""
        if package_names:
            # On génère une commande d'install par package pour le logging individuel
            native_cmds = []
            for pkg in package_names:
                cmd = f"{self.distro['install_package_command']} {pkg}"
                if self.privilege_escalation:
                    cmd = f"{self.privilege_escalation} {cmd}"
                native_cmds.append(f'install_native "{pkg}" {cmd}')
            native_section = "\n".join(native_cmds)

        # Customs — chaque CUSTOM_INSTALL est déjà wrappé dans _custom_installs()
        custom_section = self._custom_installs(custom_slugs) if custom_slugs else ""

        parts = [self._script_header()]
        if native_section:
            parts.append(f"# === Native packages ({len(package_names)}) ===\n{native_section}")
        if custom_section:
            parts.append(f"\n# === Custom installs ({len(custom_slugs)}) ===\n{custom_section}")

        return "\n".join(parts) + "\n"
