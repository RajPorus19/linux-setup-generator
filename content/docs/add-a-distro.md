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
  "install_package_command": "dnf install -y",
  "logo": "/img/distros/fedora.png"
}
```

| Field | What it means |
|---|---|
| `name` | The display name shown in the UI |
| `slug` | A short, unique identifier (lowercase, hyphens only). Used as the key in each program's `package_names`. |
| `description` | A short sentence shown on the distro card |
| `install_package_command` | The command used to install packages — everything before the package name(s) |
| `logo` | Path to a 128×128 PNG logo relative to `static/`. Displayed on the distro selection card. Optional — the card renders without it. |

## Step 3 — Add a logo

Place a **128×128 PNG** in `static/img/distros/<slug>.png` and set the `logo` field to `/img/distros/<slug>.png`.

To create one from an SVG (e.g. from [simple-icons](https://simpleicons.org/)), use `rsvg-convert`:

```bash
rsvg-convert -w 128 -h 128 input.svg -o static/img/distros/<slug>.png
```

All existing logos use a light grey rounded background (`#f8f9fa`) with the brand color filled icon, so new logos look consistent with the rest.

## Step 4 — Add package names to programs

Once the distro is registered, open any `content/programs/<slug>/program.json` and add an entry for your distro's slug:

```json
"package_names": {
  "default": "firefox",
  "fedora": "firefox"
}
```

If the package name is the same as `default`, you can skip it — the generator will fall back to `default` automatically.

## Step 5 — Test locally

Run the dev server and go to the Setup Generator:

```bash
hugo server -b http://localhost:1313 -p 1313
```

Your new distro should appear as a card in Step 1 with its logo. Select it and verify the generated script uses the correct install command.

## Step 6 — Submit a pull request

Once everything looks good locally, open a pull request against the main repository:

**[github.com/RajPorus19/linux-setup-generator](https://github.com/RajPorus19/linux-setup-generator)**

Fork the repo, push your changes to a branch, and open a PR from that branch to `main`. See the [Contributing](/docs/contributing/) guide for a step-by-step walkthrough.
