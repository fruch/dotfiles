# Dotfiles

Personal dotfiles for development environment setup.

## Terminal Setup: Foot + Zellij

Replaces GNOME Terminal + tmux with a modern Wayland-native stack.

- **Foot** — fast Wayland-native terminal with RTL/BiDi support
- **Zellij** — modern terminal multiplexer (tmux replacement)
- **Zellaude** — Claude Code-aware status bar plugin for Zellij
- **zjstatus** — customizable status bar plugin (clock + battery)

### Quick Install

```bash
# Install foot terminal + themes
sudo apt install -y foot foot-themes

# Install wl-clipboard (Wayland copy/paste)
sudo apt install -y wl-clipboard

# Install zellij (latest release)
curl -sL "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz" \
  | tar xz -C /tmp && sudo mv /tmp/zellij /usr/local/bin/

# Install zellij plugins
mkdir -p ~/.config/zellij/plugins
curl -sL "https://github.com/ishefi/zellaude/releases/latest/download/zellaude.wasm" \
  -o ~/.config/zellij/plugins/zellaude.wasm
curl -sL "https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" \
  -o ~/.config/zellij/plugins/zjstatus.wasm
```

### Key Bindings (tmux-compatible)

Zellij is configured with `Ctrl+a` as the prefix key, matching tmux.

| Action | Binding |
|---|---|
| Split right | `C-a \|` or `C-a %` |
| Split down | `C-a -` or `C-a "` |
| Next tab | `C-a Space` or `C-a n` |
| Previous tab | `C-a p` |
| Toggle last tab | `C-a C-a` or `C-a Tab` |
| New tab | `C-a c` |
| Close pane | `C-a x` |
| Zoom pane | `C-a z` |
| Rename tab | `C-a ,` |
| Tab by number | `C-a 1-9` |
| Cycle panes | `C-a o` |
| Detach | `C-a d` |
| Scroll/copy mode | `C-a [` |
| Session manager | `C-a w` |

### Copy/Paste

| Action | Binding |
|---|---|
| Copy | Select with mouse (auto-copies to clipboard) |
| Paste | `Ctrl+V`, `Ctrl+Shift+V`, or `Shift+Insert` |

### Config Files

- `~/.config/foot/foot.ini` — terminal config
- `~/.config/zellij/config.kdl` — zellij config + keybindings
- `~/.config/zellij/layouts/clean.kdl` — status bar layout (zellaude + zjstatus)
- `~/.config/zellij/scripts/battery.sh` — battery widget script
