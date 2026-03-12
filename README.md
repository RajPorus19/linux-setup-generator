# Linux Setup Generator

A browser-based tool that generates a personalised Linux install script in a few clicks — no terminal knowledge required.

**Live site:** https://rajporus19.github.io/linux-setup-generator/

---

## What it does

Setting up a fresh Linux install means hunting down package names, copy-pasting install commands, and hoping you don't forget anything. This tool replaces all of that with a simple 3-step wizard:

1. **Pick your distro** — Ubuntu, Arch, or Void Linux
2. **Choose your programs** — browse and search 86 curated apps across 58 categories
3. **Get your script** — a ready-to-run bash script is generated and can be copied or downloaded

Everything runs in the browser. No account, no server, no data collection.

---

## Screenshots

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/540d8799-87d4-4177-9d1e-8601ae77eae3" /></td>
    <td><img src="https://github.com/user-attachments/assets/3a7fb949-9d07-4069-81ed-92589adb520c" /></td>
    <td><img src="https://github.com/user-attachments/assets/98be6bcc-9ba9-437b-a8df-1d05ddcd2443" /></td>
    <td><img src="https://github.com/user-attachments/assets/cf0dc649-521d-43f2-b597-ed00af931623" /></td>
  </tr>
</table>



## How to use

### Copy & paste
1. Go to the [Setup Generator](https://rajporus19.github.io/linux-setup-generator/setup-generator/)
2. Select your distro
3. Click the programs you want to install
4. Click **Generate script**
5. Click **Copy to clipboard**, open a terminal, paste with `Ctrl+Shift+V`, and press `Enter`

### Download & run
1. Follow steps 1–4 above
2. Click **Download script.sh**
3. Open a terminal in the same folder and run:
   ```bash
   bash script.sh
   ```

> You may be prompted for your password — this is normal. The script only runs the install commands for the programs you selected.

---

## Features

- **Step progress bar** — always know where you are in the flow
- **Category sidebar** — filter programs by type (terminal, editor, media player…)
- **Real-time search** — search by name, description, or category
- **Distro-aware packages** — uses the correct package name for each distro automatically
- **Custom installs** — programs not in standard repos ship their own `install.sh`
- **Browser back button support** — step state is tracked in the URL
- **Copy / Download** — get the script into your system in one click
- **Beginner friendly** — inline instructions explain every step

---

## Project structure

```
├── content/
│   ├── distros/          # Distro definitions (JSON)
│   ├── programs/         # Program catalog (one folder per program)
│   │   └── <slug>/
│   │       ├── program.json
│   │       └── custom_install/
│   │           └── install.sh   # Only for CUSTOM_INSTALL programs
│   └── categories/       # Category definitions (JSON)
├── layouts/
│   ├── _default/
│   │   └── baseof.html   # Base template (nav, styles, footer)
│   ├── index.html         # Home page
│   ├── programs/
│   │   └── list.html      # Programs catalog page
│   ├── setup-generator/
│   │   └── single.html    # 3-step generator wizard
│   └── partials/
│       ├── program-browser.html     # Shared program list + sidebar HTML
│       └── program-browser-js.html  # Shared program browser logic
├── static/
│   └── js/
│       └── script-generator.js   # Script generation class
└── .github/
    └── workflows/
        └── hugo.yml       # GitHub Pages deploy workflow
```

---

## Adding a program

Create a folder under `content/programs/<slug>/` and add a `program.json`:

```json
{
  "name": "Alacritty",
  "slug": "alacritty",
  "description": "A fast, GPU-accelerated terminal emulator",
  "git_repo": "https://github.com/alacritty/alacritty",
  "website": "https://alacritty.org/",
  "license": "MIT",
  "categories": ["terminal"],
  "package_names": {
    "default": "alacritty",
    "ubuntu": "alacritty",
    "arch": "alacritty",
    "void": "alacritty"
  }
}
```

### Distro-specific package names

The `package_names` object maps distro slugs to package names. If the target distro is not listed, `default` is used as a fallback.

### Custom install

If a program is not available through the standard package manager, set the package name to `"CUSTOM_INSTALL"` and add an install script at `custom_install/install.sh`:

```json
"package_names": {
  "default": "CUSTOM_INSTALL"
}
```

If the program has dependencies that need to be installed first, list them in a `dependencies` array:

```json
"dependencies": ["curl", "git"]
```

---

## Adding a distro

Create a file under `content/distros/<slug>.json`:

```json
{
  "name": "Ubuntu",
  "slug": "ubuntu",
  "description": "Ubuntu is a Debian-based Linux distribution.",
  "install_package_command": "apt-get install -y"
}
```

---

## Local development

**Requirements:** [Hugo extended](https://gohugo.io/installation/) v0.155+

```bash
# Clone the repo
git clone https://github.com/rajporus19/linux-setup-generator.git
cd linux-setup-generator

# Start the dev server
hugo server -b http://localhost:1313 -p 1313
```

The site will be available at `http://localhost:1313/`.

---

## Deployment

The site deploys automatically to GitHub Pages on every push to `main` via the workflow at `.github/workflows/hugo.yml`.

**Setup (one time):**
1. Go to **Settings → Pages** in your GitHub repo
2. Set **Source** to **GitHub Actions**
3. Push to `main` — the workflow will build and deploy the site

---

## Tech stack

| Layer | Technology |
|---|---|
| Static site generator | [Hugo](https://gohugo.io/) |
| Templating | Hugo templates (Go template syntax) |
| Styling | Plain CSS (no framework) |
| JavaScript | Vanilla JS, no dependencies |
| Script generation | Custom `ScriptGenerator` class |
| Hosting | GitHub Pages |
| CI/CD | GitHub Actions |

---

## License

GPL-3.0
