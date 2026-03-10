# Alacritty Custom Color Scheme Config

`set_config.sh` is a template script that applies a custom color scheme to an existing Alacritty TOML config file. It is meant to be rendered before execution — all `{{TERMINAL_COLOR_*}}` placeholders are replaced with actual hex color values by whatever tooling manages this config.

## How it works

### 1. Color variables (top of file)

The script opens with a block of shell variable assignments:

```sh
COLOR_BACKGROUND={{TERMINAL_COLOR_BACKGROUND}}
COLOR_FOREGROUND={{TERMINAL_COLOR_FOREGROUND}}
...
```

Each `{{...}}` is a template placeholder. After rendering, these become quoted hex strings (e.g. `'#343d46'`). The variables cover every color slot Alacritty exposes: primary, cursor, 8 normal colors, 8 bright colors, and selection.

### 2. Config file discovery

The script searches for the Alacritty config file in the standard locations, in order:

| Priority | Path |
|----------|------|
| 1 | `$XDG_CONFIG_HOME/alacritty/alacritty.toml` |
| 2 | `$XDG_CONFIG_HOME/alacritty.toml` |
| 3 | `$HOME/.config/alacritty/alacritty.toml` |
| 4 | `$HOME/.alacritty.toml` |

The first path that points to an existing file wins and is stored in `CONFIG_PATH`.

If no file is found, a default config is bootstrapped by copying `/etc/alacritty/alacritty.toml` into `$XDG_CONFIG_HOME/alacritty/`.

### 3. TOML patching — `set_toml_value`

The core of the script is the `set_toml_value` function:

```sh
set_toml_value <file> <section> <key> <value>
```

It edits the TOML file in pure bash (using `grep` and `awk`) without any external TOML library. It handles three cases:

- **Section and key both exist** — the existing value is replaced in-place, scoped to that section only (identical keys in other sections are untouched).
- **Section exists, key is absent** — the key is inserted on the line immediately after the section header.
- **Section is absent** — the section header and key are appended at the end of the file.

Section names like `colors.primary` are dot-escaped before being used as awk regex patterns so the dot matches literally.

### 4. Applying the colors

After the function is defined, it is called once per color slot across all five TOML sections:

| TOML section | Keys written |
|---|---|
| `[colors.primary]` | `background`, `foreground` |
| `[colors.cursor]` | `cursor`, `text` |
| `[colors.normal]` | `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white` |
| `[colors.bright]` | same 8 keys as normal |
| `[colors.selection]` | `background`, `text` |
