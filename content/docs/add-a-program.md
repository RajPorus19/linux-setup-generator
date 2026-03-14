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
| `logo` | No | Path to a 64×64 PNG logo (see below) |

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

## Adding a logo (optional)

A logo is displayed as a small 28×28 icon next to the program name in both the Programs catalog and the Setup Generator.

### File location

Place a **64×64 PNG** in the static folder, mirroring the program's content path:

```
static/programs/htop/logo.png
```

Then add the `logo` field to `program.json`:

```json
{
  "name": "htop",
  "slug": "htop",
  "logo": "/programs/htop/logo.png",
  ...
}
```

### Finding a logo

The best source for clean, consistent logos is [simple-icons](https://simpleicons.org/) — a free library of SVG brand icons. Search for the program name there first.

If the program is not in simple-icons, check:
- The program's GitHub repository (look for a logo in `README.md`, `.github/`, or `docs/`)
- The program's official website favicon

### Converting an SVG to PNG

Use `rsvg-convert` to render the SVG at 64×64. The snippet below wraps the icon in a light rounded background with the brand color, which matches the style used by all existing logos:

```bash
python3 - input.svg "#HEXCOLOR" static/programs/htop/logo.png << 'EOF'
import sys, re, subprocess, os

svg_path, color, out_path = sys.argv[1], sys.argv[2], sys.argv[3]
with open(svg_path) as f:
    content = f.read()

vb = re.search(r'viewBox="([^"]+)"', content)
vb_vals = [float(x) for x in vb.group(1).split()] if vb else [0, 0, 24, 24]
src_w, src_h = vb_vals[2], vb_vals[3]

inner = re.sub(r'<\?xml[^>]*\?>', '', content)
inner = re.sub(r'<svg[^>]*>', '', inner, count=1)
inner = re.sub(r'</svg>\s*$', '', inner.strip()).strip()

pad, icon_size = 8, 48
scale = icon_size / max(src_w, src_h)

wrapped = f"""<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="10" fill="#f8f9fa"/>
  <g fill="{color}" transform="translate({pad},{pad}) scale({scale})">
    {inner}
  </g>
</svg>"""

tmp = svg_path + '.tmp.svg'
with open(tmp, 'w') as f: f.write(wrapped)
subprocess.run(['rsvg-convert', '-w', '64', '-h', '64', tmp, '-o', out_path], check=True)
os.remove(tmp)
EOF
```

Replace `#HEXCOLOR` with the program's brand color (found on the simple-icons page next to the icon).

### Programs without a logo

The `logo` field is entirely optional. Programs without one simply display their name without an icon — no placeholder or broken image is shown.

## Step 3 — Test locally

```bash
hugo server -b http://localhost:1313 -p 1313
```

Open the Programs page and search for your program by name. Then go through the Setup Generator and verify your program appears in the selection list and in the generated script.
