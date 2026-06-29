#!/bin/sh
# Idempotent bootstrap / migration for these dotfiles. Safe to re-run.
set -eu

DOTFILES=$(cd "$(dirname "$0")" && pwd)
log() { printf '==> %s\n' "$*"; }

command -v stow >/dev/null || {
    echo "install GNU stow first" >&2
    exit 1
}

# Stale symlinks left behind by packages that were removed from the repo.
log "pruning dead symlinks"
find "$HOME/.config/zsh" "$HOME/.scripts" -xtype l -delete 2>/dev/null || true
rm -f "$HOME/.config/nushell/config.nu" "$HOME/.config/nushell/env.nu" 2>/dev/null || true

# Keep the compinit dump out of the repo and out of ~/.config/zsh.
log "relocating zcompdump to the cache"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
rm -f "$HOME/.config/zsh/.zcompdump" "$HOME/.config/zsh/.zcompdump.zwc"

# Machine-specific zsh -- sourced by .zshrc and on PATH.
mkdir -p "$HOME/.setup"

# zsh plugins (plugins.zsh also self-heals at runtime).
log "cloning missing zsh plugins"
clone() { [ -d "$HOME/.zsh/$2" ] || git clone --depth 1 "https://github.com/$1/$2" "$HOME/.zsh/$2"; }
clone zsh-users zsh-syntax-highlighting
clone kutsan zsh-system-clipboard
clone zsh-users zsh-autosuggestions
clone sindresorhus pure

# Test/format tooling (best-effort, never fatal).
command -v shellcheck >/dev/null || sudo apt-get install -y shellcheck || true
command -v just >/dev/null || sudo apt-get install -y just || true

# Restow: creates ~/.config/zsh/exit (fixes M-r), ~/.tmux_templates, ~/.config/dprint,
# and refolds ~/.config/zsh/programs after the prune.
log "stowing"
stow -d "$DOTFILES" -t "$HOME" -R zsh scripts tmux neovim dprint fzf mason nnn opencode

# Self-test.
log "checks:"
zsh -ic 'echo "  zsh loads ok"'
[ -e "$HOME/.config/zsh/exit/.zshrc" ] && echo "  M-r exit-mode present" || echo "  WARN: exit/ missing"
[ -z "$(find "$HOME/.config/zsh" -xtype l 2>/dev/null)" ] && echo "  no broken zsh links" || echo "  WARN: broken links remain"

cat <<'MSG'

done. reload running sessions:  tmux M-R   |   swaymsg reload
optional -- bluetuith for the bluetooth right-click menu (pair new devices):
  curl -fsSL https://github.com/bluetuith-org/bluetuith/releases/download/v0.2.6/bluetuith_0.2.6_Linux_x86_64.tar.gz | tar xz -C ~/.local/bin bluetuith && chmod +x ~/.local/bin/bluetuith
MSG
