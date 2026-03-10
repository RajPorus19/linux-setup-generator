# Colors for Alacritty

COLOR_BACKGROUND={{TERMINAL_COLOR_BACKGROUND}}
COLOR_FOREGROUND={{TERMINAL_COLOR_FOREGROUND}}

COLOR_CURSOR={{TERMINAL_COLOR_CURSOR}}
COLOR_CURSOR_TEXT={{TERMINAL_COLOR_CURSOR_TEXT}}

COLOR_NORMAL_BLACK={{TERMINAL_COLOR_NORMAL_BLACK}}
COLOR_NORMAL_BLUE={{TERMINAL_COLOR_NORMAL_BLUE}}
COLOR_NORMAL_CYAN={{TERMINAL_COLOR_NORMAL_CYAN}}
COLOR_NORMAL_GREEN={{TERMINAL_COLOR_NORMAL_GREEN}}
COLOR_NORMAL_MAGENTA={{TERMINAL_COLOR_NORMAL_MAGENTA}}
COLOR_NORMAL_RED={{TERMINAL_COLOR_NORMAL_RED}}
COLOR_NORMAL_WHITE={{TERMINAL_COLOR_NORMAL_WHITE}}
COLOR_NORMAL_YELLOW={{TERMINAL_COLOR_NORMAL_YELLOW}}

COLOR_BRIGHT_BLACK={{TERMINAL_COLOR_BRIGHT_BLACK}}
COLOR_BRIGHT_BLUE={{TERMINAL_COLOR_BRIGHT_BLUE}}
COLOR_BRIGHT_CYAN={{TERMINAL_COLOR_BRIGHT_CYAN}}
COLOR_BRIGHT_GREEN={{TERMINAL_COLOR_BRIGHT_GREEN}}
COLOR_BRIGHT_MAGENTA={{TERMINAL_COLOR_BRIGHT_MAGENTA}}
COLOR_BRIGHT_RED={{TERMINAL_COLOR_BRIGHT_RED}}
COLOR_BRIGHT_WHITE={{TERMINAL_COLOR_BRIGHT_WHITE}}
COLOR_BRIGHT_YELLOW={{TERMINAL_COLOR_BRIGHT_YELLOW}}

COLOR_SELECTION_BACKGROUND={{TERMINAL_COLOR_SELECTION_BACKGROUND}}
COLOR_SELECTION_TEXT={{TERMINAL_COLOR_SELECTION_TEXT}}

# Default XDG_CONFIG_HOME if not set
LOG_PREFIX="Alacritty - setting custom color scheme: "
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

candidates=(
  "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  "$XDG_CONFIG_HOME/alacritty.toml"
  "$HOME/.config/alacritty/alacritty.toml"
  "$HOME/.alacritty.toml"
)

for path in "${candidates[@]}"; do
  echo "$LOG_PREFIX Checking for config file at: $path"
  if [ -f "$path" ]; then
    echo "$LOG_PREFIX Found config file at: $path"
    CONFIG_PATH="$path"
    break
  fi
done

if [ -z "$CONFIG_PATH" ]; then
  echo "$LOG_PREFIX No config file found, creating default config"
  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  cp /etc/alacritty/alacritty.toml "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  echo "$LOG_PREFIX Default config created: $XDG_CONFIG_HOME/alacritty/alacritty.toml"
  CONFIG_PATH="$XDG_CONFIG_HOME/alacritty/alacritty.toml"
else
  echo "$LOG_PREFIX Config file found at: $CONFIG_PATH"
fi

echo "$LOG_PREFIX Setting custom color scheme"
sed -i 's/colors = "~/.colors = "~/.config/alacritty/colors.toml/g' "$CONFIG_PATH"
echo "$LOG_PREFIX Custom color scheme set"

# Now we edit the config (in TOML format) to set the colors, in pure bash of course

# Sets a key in a TOML section; adds the section/key if absent, overrides if present.
# Usage: set_toml_value <file> <section> <key> <value>
set_toml_value() {
  local file="$1"
  local section="$2"
  local key="$3"
  local value="$4"
  local escaped_section
  escaped_section=$(printf '%s' "$section" | sed 's/\./\\./g')

  if grep -qF "[$section]" "$file"; then
    if awk -v sec="$escaped_section" -v k="$key" '
      $0 ~ "^\\[" sec "\\]"         { found=1; next }
      found && /^\[/                 { found=0 }
      found && $0 ~ "^" k "[[:space:]]*=" { exit 0 }
      END                            { exit 1 }
    ' "$file"; then
      # Key exists in section — replace it
      awk -v sec="$escaped_section" -v k="$key" -v v="$value" '
        $0 ~ "^\\[" sec "\\]"              { in_sec=1; print; next }
        in_sec && /^\[/                    { in_sec=0 }
        in_sec && $0 ~ "^" k "[[:space:]]*=" { print k " = " v; next }
        { print }
      ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    else
      # Section exists but key is absent — insert key right after section header
      awk -v sec="$escaped_section" -v k="$key" -v v="$value" '
        $0 ~ "^\\[" sec "\\]" { print; print k " = " v; next }
        { print }
      ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    fi
  else
    # Section absent — append section + key at end of file
    printf '\n[%s]\n%s = %s\n' "$section" "$key" "$value" >> "$file"
  fi
}

set_toml_value "$CONFIG_PATH" "colors.primary"   "background" "$COLOR_BACKGROUND"
set_toml_value "$CONFIG_PATH" "colors.primary"   "foreground" "$COLOR_FOREGROUND"
set_toml_value "$CONFIG_PATH" "colors.cursor"    "cursor"     "$COLOR_CURSOR"
set_toml_value "$CONFIG_PATH" "colors.cursor"    "text"       "$COLOR_CURSOR_TEXT"
set_toml_value "$CONFIG_PATH" "colors.normal"    "black"      "$COLOR_NORMAL_BLACK"
set_toml_value "$CONFIG_PATH" "colors.normal"    "blue"       "$COLOR_NORMAL_BLUE"
set_toml_value "$CONFIG_PATH" "colors.normal"    "cyan"       "$COLOR_NORMAL_CYAN"
set_toml_value "$CONFIG_PATH" "colors.normal"    "green"      "$COLOR_NORMAL_GREEN"
set_toml_value "$CONFIG_PATH" "colors.normal"    "magenta"    "$COLOR_NORMAL_MAGENTA"
set_toml_value "$CONFIG_PATH" "colors.normal"    "red"        "$COLOR_NORMAL_RED"
set_toml_value "$CONFIG_PATH" "colors.normal"    "white"      "$COLOR_NORMAL_WHITE"
set_toml_value "$CONFIG_PATH" "colors.normal"    "yellow"     "$COLOR_NORMAL_YELLOW"
set_toml_value "$CONFIG_PATH" "colors.bright"    "black"      "$COLOR_BRIGHT_BLACK"
set_toml_value "$CONFIG_PATH" "colors.bright"    "blue"       "$COLOR_BRIGHT_BLUE"
set_toml_value "$CONFIG_PATH" "colors.bright"    "cyan"       "$COLOR_BRIGHT_CYAN"
set_toml_value "$CONFIG_PATH" "colors.bright"    "green"      "$COLOR_BRIGHT_GREEN"
set_toml_value "$CONFIG_PATH" "colors.bright"    "magenta"    "$COLOR_BRIGHT_MAGENTA"
set_toml_value "$CONFIG_PATH" "colors.bright"    "red"        "$COLOR_BRIGHT_RED"
set_toml_value "$CONFIG_PATH" "colors.bright"    "white"      "$COLOR_BRIGHT_WHITE"
set_toml_value "$CONFIG_PATH" "colors.bright"    "yellow"     "$COLOR_BRIGHT_YELLOW"
set_toml_value "$CONFIG_PATH" "colors.selection" "background" "$COLOR_SELECTION_BACKGROUND"
set_toml_value "$CONFIG_PATH" "colors.selection" "text"       "$COLOR_SELECTION_TEXT"

echo "$LOG_PREFIX Color scheme applied successfully"
