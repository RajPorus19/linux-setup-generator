# Testing Spec — Linux Setup Generator

Test automatisé de tous les scripts d'installation sur toutes les distributions, via conteneurs Docker isolés.

## Objectif

Valider que chaque `program.json` + `custom_install/install.sh` produit un script fonctionnel sur chaque distribution. Un programme est considéré **valide** si son installation réussit dans un conteneur Docker frais de la distribution cible.

## Architecture

```
┌─────────────────────────────────────────────────┐
│                 test.yml (CI)                   │
│  matrix: [alpine, arch, debian, fedora,         │
│           opensuse, ubuntu, void]               │
│                                                 │
│  Pour chaque distro (7 jobs parallèles) :        │
│    1. docker build -f Dockerfile.<distro>       │
│    2. python runner.py --distro <distro>         │
│    3. Upload rapport JSON → artifacts           │
└─────────────────────────────────────────────────┘
```

## Fichiers

```
tests/
├── docker/
│   ├── Dockerfile.alpine      # FROM alpine:latest
│   ├── Dockerfile.arch        # FROM archlinux:latest
│   ├── Dockerfile.debian      # FROM debian:stable
│   ├── Dockerfile.fedora      # FROM fedora:latest
│   ├── Dockerfile.opensuse    # FROM opensuse/leap:latest
│   ├── Dockerfile.ubuntu      # FROM ubuntu:latest
│   └── Dockerfile.void        # FROM voidlinux/voidlinux:latest
├── script_generator.py        # Port Python du ScriptGenerator JS
├── runner.py                  # Orchestrateur de test
└── report.py                  # Formattage du rapport
```

## `script_generator.py`

Port Python de [`static/js/script-generator.js`](../static/js/script-generator.js). Même algorithme, même comportement. Pourquoi Python plutôt que Node.js ? Pas de dépendance supplémentaire, et le reste de l'infra de test est en Python.

### Classe `ScriptGenerator`

```python
class ScriptGenerator:
    def __init__(self, distro: dict, programs: list, dependencies: list):
        self.distro = distro
        self.programs = programs
        self.dependencies = dependencies
        self.privilege_escalation = ""  # root dans Docker → pas de sudo

    def _find_item(self, slug: str) -> dict | None:
        """Cherche un slug dans programs puis dependencies."""

    def _retrieve_package_names(self) -> tuple[list, list]:
        """Retourne (package_names, custom_slugs)."""

    def _build_package_install_cmd(self, package_names: list) -> str:
        """sudo pacman -S pkg1 pkg2 pkg3"""

    def _resolve_dependencies(self, slug: str, visited: set, result: dict):
        """DFS récursif post-order. Remplit result.order et result.packages."""

    def _get_custom_install(self, slug: str, visited: set) -> str:
        """Résout dépendances + lit install.sh depuis le filesystem."""

    def _custom_installs(self, custom_slugs: list) -> str:
        """Itère sur tous les CUSTOM_INSTALL avec visited partagé."""

    def _script_header(self) -> str:
        """Shebang + commentaire distro."""

    def build_script(self) -> str:
        """Assemble le script final."""
```

### Différences avec la version JS

| JS (navigateur) | Python (test) |
|---|---|
| `fetch(/programs/<slug>/custom_install/install.sh)` | `open(content/programs/<slug>/custom_install/install.sh).read()` |
| `sudo` prefixé aux commandes | Pas de `sudo` (root dans Docker) |
| Script retourné comme string | Script sauvegardé dans `/tmp/test_script.sh` |

## `runner.py`

### Flux

```
1. Charger la distro (content/distros/<distro>.json)
2. Charger tous les programmes (content/programs/*/program.json)
3. Charger toutes les dépendances (content/dependencies/*/program.json)
4. Instancier ScriptGenerator(distro, all_programs, all_deps)
5. Générer le script → test_script.sh
6. docker build -t lsg-test:<distro> -f Dockerfile.<distro> .
7. docker run --rm -v $(pwd)/test_script.sh:/test_script.sh:ro lsg-test:<distro> bash /test_script.sh 2>&1 | tee test_output.txt
8. Parser test_output.txt pour identifier les échecs
9. Générer report.json
```

### Parsing des erreurs

Le script bash doit être généré avec un wrapper qui loggue chaque programme :

```bash
#!/bin/bash
# Wrapper qui teste chaque programme individuellement

install_program() {
    local name="$1"
    shift
    echo "▶️ [$name] Starting..."
    if "$@" 2>&1; then
        echo "✅ [$name] PASSED"
    else
        echo "❌ [$name] FAILED (exit code: $?)"
        return 1
    fi
}
```

Le runner parse les lignes `❌ [nom] FAILED` pour construire le rapport.

### Mode batch

Pour éviter des runs de 8 heures, le runner supporte un mode batch :

```bash
# Teste les programmes par lot de 50
python runner.py --distro void --batch 1/6   # programmes 1-50
python runner.py --distro void --batch 2/6   # programmes 51-100
...
```

## `Dockerfile.<distro>` — spécifications par distro

Chaque Dockerfile doit :
1. Partir de l'image officielle minimale
2. Installer les outils de build de base
3. Être root (pas de sudo)
4. Désactiver les prompts interactifs

### Dockerfile.alpine
```dockerfile
FROM alpine:latest
RUN apk add --no-cache bash curl git build-base cmake nodejs npm python3 cargo rust
```

### Dockerfile.arch
```dockerfile
FROM archlinux:latest
RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel git curl nodejs npm python cargo
```

### Dockerfile.debian
```dockerfile
FROM debian:stable
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential curl git cmake nodejs npm python3 python3-pip cargo bash
```

### Dockerfile.fedora
```dockerfile
FROM fedora:latest
RUN dnf install -y make automake gcc gcc-c++ kernel-devel curl git cmake nodejs npm python3 cargo
```

### Dockerfile.opensuse
```dockerfile
FROM opensuse/leap:latest
RUN zypper install -y -t pattern devel_basis && zypper install -y curl git cmake nodejs npm python3 cargo
```

### Dockerfile.ubuntu
```dockerfile
FROM ubuntu:latest
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential curl git cmake nodejs npm python3 python3-pip cargo
```

### Dockerfile.void
```dockerfile
FROM voidlinux/voidlinux:latest
RUN xbps-install -Syu && xbps-install -y base-devel curl git cmake nodejs npm python3 cargo
```

## Rapport de test

### Format (`report.json`)

```json
{
  "distro": "void",
  "distro_slug": "void",
  "timestamp": "2026-06-10T12:00:00Z",
  "total": 291,
  "passed": 273,
  "failed": 18,
  "skipped": 0,
  "duration_seconds": 1847,
  "failures": [
    {
      "slug": "virtualbox",
      "name": "VirtualBox",
      "error_message": "package 'virtualbox' not found in repository",
      "exit_code": 1,
      "install_method": "native",
      "attempted_command": "xbps-install -S virtualbox",
      "suggestion": "Pas dans les repos Void. Utiliser CUSTOM_INSTALL avec curl vers le .run Oracle."
    }
  ]
}
```

### Génération du rapport HTML (optionnel)

```bash
python report.py report.json --html → report.html
```

## CI/CD Integration (`.github/workflows/test.yml`)

```yaml
name: Test install scripts
on:
  push:
    branches: [develop]
    paths:
      - 'content/programs/**'
      - 'content/distros/**'
      - 'tests/**'
  pull_request:
    paths:
      - 'content/programs/**'
      - 'content/distros/**'
  workflow_dispatch:

jobs:
  test:
    strategy:
      matrix:
        distro: [alpine, arch, debian, fedora, opensuse, ubuntu, void]
      fail-fast: false  # un échec sur Alpine n'arrête pas Arch
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t lsg-test:${{ matrix.distro }} -f tests/docker/Dockerfile.${{ matrix.distro }} .
      - name: Run tests
        run: python3 tests/runner.py --distro ${{ matrix.distro }}
      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: report-${{ matrix.distro }}
          path: report.json
```

## Workflow humain

```
1. PR modifie ou ajoute un program.json / install.sh
       │
2. CI déclenchée → 7 jobs Docker parallèles
       │
3. Chaque job génère un rapport
       │
4. Reviewer regarde les ❌ dans le rapport
       │
5. Corrige le program.json / install.sh
       │
6. Repush → CI relancée → ✅
```

## Règles de priorité d'installation

Rappel : ces règles guident le choix de la méthode d'installation quand on corrige un échec.

| Priorité | Méthode | Exemple | Quand l'utiliser |
|---|---|---|---|
| **1** | Package manager natif | `xbps-install -S firefox` | Le package existe dans les repos officiels |
| **2** | Dépôt tiers (apt repo, copr, AUR) | `add-apt-repository ... && apt install` | Package non-officiel mais packagé pour la distro |
| **3** | curl/wget binaire | `curl -L url | bash` ou téléchargement d'un .deb/.rpm | Binary release officielle dispo |
| **4** | Flatpak / Snap / AppImage | `flatpak install flathub org.app.Nom` | Package isolé, dispo cross-distro |
| **5** | Gestionnaire de langage (pip, cargo, npm, gem) | `cargo install starship` | Outil écrit dans un langage spécifique, pas packagé |
| **6** | Compilation from source | `git clone && make && make install` | Dernier recours — dépendances de build doivent être installées AVANT |

### Règle compile : dépendances d'abord

Quand on compile, le `custom_install/install.sh` doit **toujours** installer les dépendances de build avant la compilation :

```bash
#!/bin/bash
# Exemple : installation de dwm depuis les sources
set -e

# 1. Dépendances de build
sudo apt-get install -y build-essential libx11-dev libxft-dev libxinerama-dev

# 2. Clone + compile
git clone https://git.suckless.org/dwm /tmp/dwm
cd /tmp/dwm
make
sudo make install
```

Les dépendances de build doivent être déclarées dans `dependencies` du `program.json` pour que le `ScriptGenerator` les résolve automatiquement.

## Notes d'implémentation

### Pourquoi Docker plutôt que des VMs ?

- **Vitesse** : un conteneur se lance en < 1s, une VM en 30s+
- **CI-native** : GitHub Actions a Docker préinstallé
- **Reproductible** : le Dockerfile est la spec exacte de l'environnement
- **Isolation** : chaque distro dans son conteneur, pas de conflits

### Pourquoi `script_generator.py` plutôt que réutiliser le JS ?

- La CI n'a pas de navigateur
- Node.js serait une dépendance supplémentaire pour 136 lignes de logique
- Python est déjà présent dans l'environnement de CI
- La logique est suffisamment simple pour un port fidèle

### Gestion du temps

291 programmes × ~10s par installation (moyenne) = ~50 minutes par distro en série.
Avec 7 runners parallèles : ~50 minutes total.

Les compilations from source (dwm, st, etc.) prennent plus longtemps mais sont rares.
