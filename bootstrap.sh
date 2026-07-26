#!/bin/sh
# Idempotent bootstrap / migration for these dotfiles. Safe to re-run.
#
#   ./bootstrap.sh                      # interactive
#   ./bootstrap.sh terminal             # terminal programs + dotfiles (wsl, servers)
#   ./bootstrap.sh gui                  # terminal + graphical programs + all dotfiles
#   ./bootstrap.sh dotfiles [pkg ...]   # stow only (default: every package)
#
# Installs programs itself; neovim, fzf and stylua come from github releases
# because apt's are too old (nvim needs >= 0.11, fzf >= 0.48).
set -eu

DOTFILES=$(cd "$(dirname "$0")" && pwd)
BIN="$HOME/.local/bin"
log() { printf '==> %s\n' "$*"; }

TERMINAL_PKGS="zsh scripts tmux neovim git dprint fzf mason nnn opencode claude"
GUI_PKGS="sway waybar foot zathura"

SUDO=sudo
[ "$(id -u)" = 0 ] && SUDO=

is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }

apt_install() {
    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
        --no-install-recommends "$@" >/dev/null
}

ver_ge() { # have need
    [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

latest_tag() { # owner/repo
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name
}

install_terminal_programs() {
    log "apt packages"
    $SUDO apt-get update -qq
    apt_install ca-certificates curl git git-lfs jq unzip tar xz-utils \
        zsh stow tmux ripgrep fd-find nnn perl gh bat tree \
        build-essential libsqlite3-dev python3-venv python3-pip nodejs npm \
        shellcheck shfmt just
    is_wsl || apt_install wl-clipboard

    mkdir -p "$BIN"

    # apt names them fdfind/batcat; everything here calls them fd/bat
    command -v fd >/dev/null || ln -sf "$(command -v fdfind)" "$BIN/fd"
    command -v bat >/dev/null || ln -sf "$(command -v batcat)" "$BIN/bat"

    if [ "$(uname -m)" != x86_64 ]; then
        log "WARN: not x86_64 -- install nvim/fzf/stylua/lazygit yourself"
        return
    fi

    # the nvim config needs vim.lsp.config/enable (0.11+); apt 24.04 has 0.9
    if ! command -v nvim >/dev/null ||
        ! ver_ge "$(nvim --version | head -n1 | sed 's/^NVIM v//;s/[-+].*//')" 0.11.0; then
        log "neovim (github release)"
        curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz |
            $SUDO tar xz -C /opt
        $SUDO ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    fi

    # fzf.zsh does `fzf --zsh`, which needs 0.48+; apt 24.04 has 0.44
    if ! command -v fzf >/dev/null ||
        ! ver_ge "$(fzf --version | cut -d' ' -f1)" 0.48.0; then
        log "fzf (github release)"
        tag=$(latest_tag junegunn/fzf)
        # /usr/local/bin, not ~/.local/bin: fzf.zsh runs `fzf --zsh` before
        # path.zsh has put ~/.local/bin on PATH
        curl -fsSL "https://github.com/junegunn/fzf/releases/download/$tag/fzf-${tag#v}-linux_amd64.tar.gz" |
            $SUDO tar xz -C /usr/local/bin fzf
    fi

    if ! command -v stylua >/dev/null; then
        log "stylua (github release)"
        tag=$(latest_tag JohnnyMorganz/StyLua)
        tmp=$(mktemp -d)
        curl -fsSL "https://github.com/JohnnyMorganz/StyLua/releases/download/$tag/stylua-linux-x86_64.zip" \
            -o "$tmp/stylua.zip"
        unzip -oq "$tmp/stylua.zip" -d "$BIN" && chmod +x "$BIN/stylua"
        rm -rf "$tmp"
    fi

    if ! command -v dprint >/dev/null && [ ! -x "$HOME/.dprint/bin/dprint" ]; then
        log "dprint (official installer)"
        curl -fsSL https://dprint.dev/install.sh | sh -s >/dev/null 2>&1
    fi
}

install_gui_programs() {
    log "gui apt packages"
    $SUDO apt-get update -qq
    apt_install sway swaylock swayidle foot waybar bemenu \
        grim slurp wl-clipboard brightnessctl pavucontrol zathura \
        network-manager bluez fontconfig firefox blueman imv wev xclip
    if [ ! -d "$HOME/.fonts/adobe-fonts/source-code-pro" ]; then
        log "source code pro font"
        git clone -q --depth 1 https://github.com/adobe-fonts/source-code-pro \
            "$HOME/.fonts/adobe-fonts/source-code-pro"
        fc-cache -f "$HOME/.fonts/adobe-fonts/source-code-pro" >/dev/null
    fi
}

# zsh plugins, cloned before stowing: the git package rewrites github https
# urls to ssh, and a fresh machine has no keys yet (plugins.zsh self-heals at
# runtime too).
clone_zsh_plugins() {
    log "cloning missing zsh plugins"
    clone() { [ -d "$HOME/.zsh/$2" ] || git clone -q --depth 1 "https://github.com/$1/$2" "$HOME/.zsh/$2"; }
    clone zsh-users zsh-syntax-highlighting
    clone kutsan zsh-system-clipboard
    clone zsh-users zsh-autosuggestions
    clone sindresorhus pure
}

stow_dotfiles() { # packages...
    command -v stow >/dev/null || {
        echo "install stow first (or run a mode that installs programs)" >&2
        exit 1
    }

    # Stale symlinks left behind by packages that were removed from the repo.
    log "pruning dead symlinks"
    find "$HOME/.config/zsh" "$HOME/.scripts" -xtype l -delete 2>/dev/null || true

    # Keep the compinit dump out of the repo and out of ~/.config/zsh.
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    rm -f "$HOME/.config/zsh/.zcompdump" "$HOME/.config/zsh/.zcompdump.zwc"

    # Machine-specific zsh -- sourced by .zshrc and on PATH.
    mkdir -p "$HOME/.setup"

    # A pre-existing real ~/.gitconfig (say, from `git config --global` before
    # this ran) blocks stowing the git package -- keep it, out of the way.
    if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
        log "moving existing ~/.gitconfig to ~/.setup/gitconfig.pre-stow"
        mv "$HOME/.gitconfig" "$HOME/.setup/gitconfig.pre-stow"
    fi

    # Must exist before stowing claude/, or stow folds all of ~/.claude
    # (runtime state, credentials) into the repo.
    mkdir -p "$HOME/.claude"

    clone_zsh_plugins

    log "stowing: $*"
    stow -d "$DOTFILES" -t "$HOME" -R "$@"
}

make_zsh_login_shell() {
    case "$(getent passwd "$(id -un)" | cut -d: -f7)" in
        */zsh) ;;
        *) chsh -s "$(command -v zsh)" || log "WARN: chsh failed -- run: chsh -s $(command -v zsh)" ;;
    esac
}

checks() {
    log "checks:"
    if command -v zsh >/dev/null; then zsh -ic 'echo "  zsh loads ok"'; else echo "  WARN: no zsh"; fi
    if command -v nvim >/dev/null; then echo "  $(nvim --version | head -n1)"; else echo "  WARN: no nvim"; fi
    if command -v fzf >/dev/null; then echo "  fzf $(fzf --version)"; else echo "  WARN: no fzf"; fi
    [ -e "$HOME/.config/zsh/exit/.zshrc" ] && echo "  M-r exit-mode present" || echo "  WARN: exit/ missing"
    [ -z "$(find "$HOME/.config/zsh" -xtype l 2>/dev/null)" ] && echo "  no broken zsh links" || echo "  WARN: broken links remain"
}

terminal_pkgs() {
    pkgs=$TERMINAL_PKGS
    if is_wsl; then pkgs="$pkgs wsl_zsh_clipboard"; fi
    echo "$pkgs"
}

mode=${1:-}
[ $# -gt 0 ] && shift
if [ -z "$mode" ]; then
    printf '1) terminal  -- install terminal programs + dotfiles (wsl, servers)\n'
    printf '2) gui       -- terminal + graphical programs + all dotfiles\n'
    printf '3) dotfiles  -- stow only\n'
    printf 'what to do [1-3]? '
    read -r ans
    case $ans in
        1) mode=terminal ;;
        2) mode=gui ;;
        3) mode=dotfiles ;;
        *) exit 1 ;;
    esac
fi

case $mode in
    terminal)
        install_terminal_programs
        # shellcheck disable=SC2046 # package list is intentionally split
        stow_dotfiles $(terminal_pkgs)
        make_zsh_login_shell
        checks
        ;;
    gui)
        install_terminal_programs
        install_gui_programs
        # shellcheck disable=SC2086,SC2046
        stow_dotfiles $(terminal_pkgs) $GUI_PKGS
        make_zsh_login_shell
        checks
        ;;
    dotfiles)
        all="$TERMINAL_PKGS $GUI_PKGS"
        is_wsl && all="$all wsl_zsh_clipboard"
        if [ $# -eq 0 ] && [ -t 0 ]; then
            printf 'packages: %s\n' "$all"
            printf 'stow which [all]? '
            read -r sel
            if [ -n "$sel" ] && [ "$sel" != all ]; then
                # shellcheck disable=SC2086 # user input is a word list
                set -- $sel
            fi
        fi
        # shellcheck disable=SC2086
        [ $# -eq 0 ] && set -- $all
        stow_dotfiles "$@"
        checks
        ;;
    *)
        echo "usage: $0 [terminal|gui|dotfiles [pkg ...]]" >&2
        exit 1
        ;;
esac

cat <<'MSG'

done. reload running sessions:  tmux M-R   |   swaymsg reload
nvim plugin sync clones over ssh (git insteadOf) -- put keys in ~/.ssh, then
open nvim once for lazy + :Mason.
optional -- bluetuith for the bluetooth right-click menu (pair new devices):
  curl -fsSL https://github.com/bluetuith-org/bluetuith/releases/download/v0.2.6/bluetuith_0.2.6_Linux_x86_64.tar.gz | tar xz -C ~/.local/bin bluetuith && chmod +x ~/.local/bin/bluetuith
MSG
