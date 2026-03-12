---
title: "Custom install protocol"
weight: 4
---

Some programs are not available through a distro's standard package manager — for example, tools installed via a curl pipe, a manual binary download, or a series of build steps. For these, the generator supports a **custom install** protocol.

## When to use it

Use `CUSTOM_INSTALL` when the program:

- Is not in the distro's official repositories
- Requires extra setup steps beyond a single package install
- Needs a specific version that the package manager does not provide

## Step 1 — Set the sentinel value

In `program.json`, set the package name to `"CUSTOM_INSTALL"` for the relevant distros:

```json
"package_names": {
  "default": "CUSTOM_INSTALL"
}
```

You can also use it for specific distros only, while keeping a normal package name for others:

```json
"package_names": {
  "default": "alacritty",
  "ubuntu": "CUSTOM_INSTALL"
}
```

## Step 2 — Create the install script

Inside the program's folder, create a `custom_install/` sub-folder and add an `install.sh` file:

```
content/programs/alacritty/
└── custom_install/
    └── install.sh
```

The script should be a valid bash script that installs the program. Keep it focused — it runs inside a larger generated script that already has a `#!/bin/bash` header.

```bash
# Install Alacritty (Ubuntu — not in standard repos)
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt-get update
sudo apt-get install -y alacritty
```

## Step 3 — Declare dependencies (optional)

If the install script relies on other programs or libraries that need to be present first, list them in the `dependencies` field of `program.json`:

```json
"dependencies": ["curl", "git", "libssl-dev"]
```

Each entry is either:

- A **known program slug** from `content/programs/` — the generator will include that program's install steps (recursively, in the correct order).
- A **known dependency slug** from `content/dependencies/` — for build-time libs and `-dev` packages that should not appear in the user-facing catalog. See [Add a dependency](/docs/add-a-dependency/).
- A **raw package name** — treated as a plain package to be installed via the package manager before the custom script runs.

## How the generator handles it

When the user selects a `CUSTOM_INSTALL` program, the generator:

1. Collects all declared dependencies and resolves them recursively (so dependencies of dependencies are also handled).
2. Generates a package manager install command for any dependency packages.
3. Fetches and appends the `install.sh` script.

This means the final generated script will always install prerequisites before the custom install steps.

## Tips for writing install.sh

- **Make it idempotent** — running the script twice should not break anything.
- **Keep it minimal** — only include the steps required to install this one program.
- **No `#!/bin/bash` header** — the generator adds this once at the top of the full script.
- **Test on a clean system** if possible, to make sure no steps are missing.
