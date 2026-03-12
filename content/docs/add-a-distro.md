---
title: "Add a distro"
weight: 2
---

Adding a new Linux distribution takes less than five minutes. All you need to know is the name of the package manager command used to install packages on that distro.

## Step 1 — Create the distro file

Inside the `content/distros/` folder, create a new JSON file named after the distro slug (lowercase, no spaces):

```
content/distros/fedora.json
```

## Step 2 — Fill in the fields

```json
{
  "name": "Fedora",
  "slug": "fedora",
  "description": "A cutting-edge, community-supported Linux distribution.",
  "install_package_command": "dnf install -y"
}
```

| Field | What it means |
|---|---|
| `name` | The display name shown in the UI |
| `slug` | A short, unique identifier (lowercase, hyphens only). Used as the key in each program's `package_names`. |
| `description` | A short sentence shown on the distro card |
| `install_package_command` | The command used to install packages — everything before the package name(s) |

## Step 3 — Add package names to programs

Once the distro is registered, you can start mapping programs to their correct package names. Open any `content/programs/<slug>/program.json` and add an entry for your distro's slug:

```json
"package_names": {
  "default": "firefox",
  "fedora": "firefox"
}
```

If the package name is the same as `default`, you can skip it — the generator will fall back to `default` automatically.

## Step 4 — Test locally

Run the dev server and go to the Setup Generator:

```bash
hugo server -b http://localhost:1313 -p 1313
```

Your new distro should appear as a card in Step 1. Select it and verify the generated script uses the correct install command.
