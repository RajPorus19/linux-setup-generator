"""
Test runner — orchestre le test d'installation pour une distribution.

Usage:
    python runner.py --distro void           # Tous les programmes
    python runner.py --distro arch --batch 1/5  # 1er lot sur 5
    python runner.py --distro ubuntu --slug neovim,tmux  # Programmes spécifiques

Flow:
    1. Charge la distro + tous les programmes + dépendances
    2. Génère le script via ScriptGenerator
    3. Build l'image Docker
    4. Exécute le script dans le conteneur
    5. Parse la sortie → rapport JSON
"""

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

from script_generator import ScriptGenerator


# Racine du projet (où se trouve content/)
PROJECT_ROOT = Path(__file__).resolve().parent.parent


def load_json(path):
    """Charge un fichier JSON, retourne un dict."""
    with open(path) as f:
        return json.load(f)


def load_distro(slug):
    """Charge la définition d'une distribution."""
    path = PROJECT_ROOT / "content" / "distros" / f"{slug}.json"
    if not path.exists():
        raise FileNotFoundError(f"Distro not found: {path}")
    return load_json(path)


def load_all_programs():
    """Charge tous les programs.json du catalogue."""
    programs = []
    programs_dir = PROJECT_ROOT / "content" / "programs"
    for folder in sorted(programs_dir.iterdir()):
        if folder.is_dir():
            program_json = folder / "program.json"
            if program_json.exists():
                programs.append(load_json(program_json))
    return programs


def load_all_dependencies():
    """Charge toutes les dépendances build-time."""
    deps = []
    deps_dir = PROJECT_ROOT / "content" / "dependencies"
    if deps_dir.exists():
        for folder in sorted(deps_dir.iterdir()):
            if folder.is_dir():
                dep_json = folder / "program.json"
                if dep_json.exists():
                    deps.append(load_json(dep_json))
    return deps


def filter_programs(all_programs, slugs=None, batch=None):
    """
    Filtre les programmes par slugs ou par batch.
    
    Args:
        all_programs: Liste complète des programmes
        slugs: Liste de slugs spécifiques (optionnel)
        batch: Tuple (numéro, total) pour le mode batch (optionnel)
    
    Returns:
        Liste filtrée de programmes
    """
    if slugs:
        slug_set = set(slugs.split(","))
        return [p for p in all_programs if p["slug"] in slug_set]

    if batch:
        batch_num, total = batch
        batch_size = len(all_programs) // total + 1
        start = (batch_num - 1) * batch_size
        end = start + batch_size
        return all_programs[start:end]

    return all_programs


def build_docker_image(distro_slug):
    """Build l'image Docker pour la distro."""
    dockerfile = PROJECT_ROOT / "tests" / "docker" / f"Dockerfile.{distro_slug}"
    tag = f"lsg-test:{distro_slug}"

    print(f"🔨 Building Docker image: {tag}")
    result = subprocess.run(
        ["docker", "build", "-t", tag, "-f", str(dockerfile), "."],
        cwd=PROJECT_ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"❌ Docker build failed:\n{result.stderr}")
        sys.exit(1)
    print(f"✅ Image built: {tag}")
    return tag


def run_test_script(image_tag, script_path):
    """Exécute le script de test dans le conteneur Docker."""
    print(f"🚀 Running test in {image_tag}...")

    result = subprocess.run(
        [
            "docker", "run", "--rm",
            "-v", f"{script_path}:/test_script.sh:ro",
            image_tag,
            "bash", "/test_script.sh",
        ],
        cwd=PROJECT_ROOT,
        capture_output=True,
        text=True,
    )

    return result.stdout + result.stderr, result.returncode


def parse_output(output):
    """
    Parse la sortie du script pour extraire les succès et échecs.
    
    Format attendu (généré par le wrapper dans script_generator.py):
        ▶️  [nom] Installing...
        ✅ [nom] PASSED
        ❌ [nom] FAILED (exit code: N)
           Command: ...
    """
    failures = []
    passed = []
    current_program = None
    current_install_type = None

    for line in output.split("\n"):
        # Détecter le début d'une installation
        if "▶️ " in line and "Installing..." in line:
            # Extraire le nom entre crochets
            if "[" in line and "]" in line:
                current_program = line[line.index("[") + 1 : line.index("]")]
                current_install_type = (
                    "custom" if "(custom)" in line else "native"
                )

        # Détecter un succès
        elif "✅" in line and "PASSED" in line and current_program:
            if "[" in line and "]" in line:
                name = line[line.index("[") + 1 : line.index("]")]
                passed.append(name)
            current_program = None

        # Détecter un échec
        elif "❌" in line and "FAILED" in line and current_program:
            exit_code = "1"
            if "exit code:" in line:
                exit_code = line.split("exit code:")[1].split(")")[0].strip()

            failure = {
                "slug": current_program.lower().replace(" ", "-"),
                "name": current_program,
                "exit_code": int(exit_code),
                "install_method": current_install_type or "unknown",
                "error_message": line.strip(),
                "attempted_command": "",
            }
            current_program = None

        # Récupérer la commande qui a échoué (ligne suivante)
        elif "Command:" in line and failures:
            failures[-1]["attempted_command"] = line.split("Command:")[1].strip()

    return passed, failures


def generate_report(distro, all_programs, passed, failures, duration, output_file):
    """Génère le rapport JSON."""
    report = {
        "distro": distro["name"],
        "distro_slug": distro["slug"],
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "total": len(all_programs),
        "passed": len(passed),
        "failed": len(failures),
        "skipped": len(all_programs) - len(passed) - len(failures),
        "duration_seconds": round(duration, 1),
        "failures": failures,
    }

    with open(output_file, "w") as f:
        json.dump(report, f, indent=2)

    return report


def main():
    parser = argparse.ArgumentParser(
        description="Test d'installation pour une distribution Linux"
    )
    parser.add_argument(
        "--distro", required=True,
        choices=["alpine", "arch", "debian", "fedora", "opensuse", "ubuntu", "void"],
        help="Distribution à tester"
    )
    parser.add_argument(
        "--batch",
        help="Mode batch: 'N/TOTAL' (ex: '1/5' pour le 1er lot sur 5)"
    )
    parser.add_argument(
        "--slugs",
        help="Slugs spécifiques à tester, séparés par des virgules"
    )
    parser.add_argument(
        "--output", default="report.json",
        help="Fichier de sortie du rapport (défaut: report.json)"
    )
    parser.add_argument(
        "--no-docker", action="store_true",
        help="Génère le script sans l'exécuter dans Docker"
    )
    args = parser.parse_args()

    # 1. Charger les données
    print(f"📦 Loading distro: {args.distro}")
    distro = load_distro(args.distro)

    print("📦 Loading programs...")
    all_programs = load_all_programs()
    print(f"   → {len(all_programs)} programs loaded")

    print("📦 Loading dependencies...")
    dependencies = load_all_dependencies()
    print(f"   → {len(dependencies)} dependencies loaded")

    # 2. Filtrer les programmes
    batch = None
    if args.batch:
        try:
            num, total = args.batch.split("/")
            batch = (int(num), int(total))
        except ValueError:
            print("❌ Invalid batch format. Use 'N/TOTAL' (ex: '1/5')")
            sys.exit(1)

    programs = filter_programs(all_programs, args.slugs, batch)
    print(f"🎯 Testing {len(programs)} programs")

    # 3. Générer le script
    print("📝 Generating install script...")
    gen = ScriptGenerator(
        distro,
        programs,
        dependencies,
        content_root=str(PROJECT_ROOT / "content"),
    )
    script = gen.build_script()

    script_path = PROJECT_ROOT / "test_script.sh"
    script_path.write_text(script)
    script_path.chmod(0o755)
    print(f"   → Script written to {script_path} ({len(script)} bytes)")

    if args.no_docker:
        print("⏭️  Skipping Docker execution (--no-docker)")
        print(f"   Script: {script_path}")
        return

    # 4. Build Docker
    image_tag = build_docker_image(args.distro)

    # 5. Run
    start_time = time.time()
    raw_output, exit_code = run_test_script(str(image_tag), str(script_path))
    duration = time.time() - start_time

    # 6. Parse
    passed, failures = parse_output(raw_output)

    # 7. Report
    report = generate_report(
        distro, programs, passed, failures, duration, args.output
    )

    # 8. Résumé
    print(f"\n{'='*60}")
    print(f"📊 Results for {distro['name']} ({distro['slug']})")
    print(f"   Total:    {report['total']}")
    print(f"   Passed:   {report['passed']} ✅")
    print(f"   Failed:   {report['failed']} ❌")
    print(f"   Skipped:  {report['skipped']}")
    print(f"   Duration: {report['duration_seconds']}s")
    print(f"   Report:   {args.output}")

    if failures:
        print(f"\n❌ Failures ({len(failures)}):")
        for f in failures:
            print(f"   - {f['name']} ({f['install_method']}): {f['error_message'][:80]}")

    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
