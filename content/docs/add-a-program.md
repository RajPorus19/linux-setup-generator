---
title: "Add a program"
weight: 3
---

Each program in the catalog lives in its own folder inside `content/programs/`. Adding a new one means creating that folder and filling in a single JSON file.

## Step 1 — Create the program folder

Inside `content/programs/`, create a new folder named after the program's slug (lowercase, hyphens for spaces):

```
content/programs/htop/
```

## Step 2 — Create program.json

Inside that folder, create a file called `program.json`:

```
content/programs/htop/program.json
```

Fill it in with the program's details:

```json
{
  "name": "htop",
  "slug": "htop",
  "description": "An interactive process viewer for the terminal.",
  "website": "https://htop.dev/",
  "git_repo": "https://github.com/htop-dev/htop",
  "license": "GPL-2.0",
  "categories": ["system", "terminal"],
  "package_names": {
    "default": "htop",
    "ubuntu": "htop",
    "arch": "htop",
    "void": "htop"
  }
}
```

## Field reference

| Field | Required | What it means |
|---|---|---|
| `name` | Yes | Display name shown in the catalog |
| `slug` | Yes | Must match the folder name exactly |
| `description` | Yes | One-sentence description shown under the name |
| `website` | No | Official website URL |
| `git_repo` | No | Source code repository URL |
| `license` | No | Short license identifier (e.g. `MIT`, `GPL-2.0`) |
| `categories` | Yes | Array of category slugs. Must match existing files in `content/categories/`. |
| `package_names` | Yes | Map of distro slug → package name |

## Package names

The generator looks up the distro slug chosen by the user in `package_names`. If no entry is found, it falls back to `"default"`.

```json
"package_names": {
  "default": "htop",
  "void": "htop"
}
```

If a program is not available through the standard package manager on a given distro, use the `"CUSTOM_INSTALL"` sentinel value — see the [Custom install protocol](/docs/add-custom-install/) guide.

## Categories

Categories must already exist in `content/categories/`. Each file there is a JSON object with a `slug` and a `name`. If the category you need does not exist yet, create it:

```json
{
  "slug": "system",
  "name": "System"
}
```

## Step 3 — Test locally

```bash
hugo server -b http://localhost:1313 -p 1313
```

Open the Programs page and search for your program by name. Then go through the Setup Generator and verify your program appears in the selection list and in the generated script.
