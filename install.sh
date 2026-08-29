#!/usr/bin/env bash
#
# install.sh — bootstrap script for personal macOS dotfiles
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#
# Safe to re-run: every step below is idempotent, so run it again any time
# after adding a new tool to the Brewfile or a new folder under .config/.

set -euo pipefail

#ensures Homebrew and pipx binaries are available across the entire script
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

# ---------------------------------------------------------------------------
# Setup & config
# ---------------------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Top-level dotfiles that get symlinked directly into $HOME
TOP_LEVEL_LINKS=(".zshrc" ".bashrc" ".profile")

# Subfolders of .config/ that get symlinked into ~/.config/
# for every tool in .config this must be added into this array
CONFIG_LINKS=(aerospace bat borders btop flameshot kitty shell sketchybar skhd wal)

# GitHub Actions (and most CI systems) auto-set CI=true. A CI runner has no
# GUI session, so anything that needs to actually render (AeroSpace, borders,
# sketchybar, skhd) can't be meaningfully started or verified there — only on
# a real, logged-in Mac. Everything else (Brewfile, raypaper, pywal, symlinks)
# still runs and gets checked in CI.
IS_CI="${CI:-false}"

# Declared here, not down in the verification section — earlier steps
# (pywal priming, the macOS defaults script) can also flip this to 1, and a
# later `FAILED=0` would silently wipe those out before the final check.
FAILED=0

log()  { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }
ok()   { printf '  \033[1;32m✔\033[0m %s\n' "$1"; }
fail() { printf '  \033[1;31m✘\033[0m %s\n' "$1"; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS only. Detected: $(uname)."
  exit 1
fi


# ---------------------------------------------------------------------------
# Xcode Command Line Tools (Homebrew needs these, and so does raypaper's build)
# ---------------------------------------------------------------------------
log "Checking Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  echo "Installing Command Line Tools (a GUI installer window will pop up)..."
  xcode-select --install
  echo "Re-run this script once that installer finishes."
  exit 1
else
  ok "Command Line Tools already installed"
fi


# ---------------------------------------------------------------------------
# Homebrew
# ---------------------------------------------------------------------------
log "Checking Homebrew"
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"      # Apple Silicon
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"         # Intel
fi
ok "Homebrew ready ($(brew --version | head -1))"


# ---------------------------------------------------------------------------
# Brewfile — taps, formulae, casks, go/npm tools
# ---------------------------------------------------------------------------
log "Installing packages from Brewfile"
if [[ -f "$BREWFILE" ]]; then
  brew bundle install --file="$BREWFILE"
  ok "brew bundle install finished"
else
  fail "No Brewfile found at $BREWFILE — skipping."
  echo "    Run 'brew bundle dump --file=$BREWFILE --force' on a working machine first."
fi


# ---------------------------------------------------------------------------
# Bash was installed via Homebrew, but additional steps are required
# to ensure macOS uses the correct Bash version instead of the old
# preinstalled Bash version that ships with macOS.
# https://til.codeinthehole.com/posts/how-to-make-homebrewinstalled-bash-your-default-shell/
# ---------------------------------------------------------------------------
log "Setting default shell to Homebrew bash"

BASH_PROFILE="$HOME/.bash_profile"
BASHRC="$HOME/.bashrc"
BREW_BASH="$(brew --prefix)/bin/bash"

grep -qxF "$BREW_BASH" /etc/shells || echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
CURRENT_SHELL="$(dscl . -read "/Users/$(whoami)" UserShell 2>/dev/null | awk '{print $2}')"
if [[ "$CURRENT_SHELL" != "$BREW_BASH" ]]; then
  sudo dscl . -create "/Users/$(whoami)" UserShell "$BREW_BASH"
  ok "default shell set to $BREW_BASH (takes effect next login)"
else
  ok "default shell already $BREW_BASH"
fi

# on mac_os bash_profile gets sourced instead of .bashrc https://superuser.com/questions/244964/mac-os-x-bashrc-not-working
ln -sf "$BASHRC" "$BASH_PROFILE"

# ---------------------------------------------------------------------------
# pywal — no Homebrew formula exists, it's a pip package (installed via pipx)
# ---------------------------------------------------------------------------
log "Installing pywal via pipx"
if command -v pipx &>/dev/null; then
  # `pipx ensurepath` only edits ~/.zshrc/~/.bashrc for FUTURE interactive
  # shells — it can never affect this already-running script (a script can't
  # retroactively change its own PATH by writing to a file nothing re-reads).
  # Pinning PIPX_BIN_DIR explicitly, to the same dir already on $PATH at the
  # top of this script, guarantees `wal` is callable immediately in this
  # same run — no dependency on shell rc files at all.
  export PIPX_BIN_DIR="$HOME/.local/bin"
  mkdir -p "$PIPX_BIN_DIR"
  pipx list 2>/dev/null | grep -q pywal || pipx install pywal16
  pipx ensurepath &>/dev/null || true   # still worth doing, for your *next* new terminal
  if command -v wal &>/dev/null; then
    ok "pywal installed ($(command -v wal))"
  else
    fail "wal still not found on PATH after install — pipx's actual output above should say why"
    echo "    expected at: $PIPX_BIN_DIR/wal"
    ls -la "$PIPX_BIN_DIR" 2>/dev/null || true
    FAILED=1
  fi
else
  fail "pipx not found — check pipx is in your Brewfile"
  FAILED=1
fi

# ---------------------------------------------------------------------------
# raypaper — built from source
# ---------------------------------------------------------------------------
log "Building raypaper"
RAYPAPER_SRC="$HOME/.local/src/raypaper"
mkdir -p "$(dirname "$RAYPAPER_SRC")"
if [[ -d "$RAYPAPER_SRC" ]]; then
  git -C "$RAYPAPER_SRC" pull --quiet
else
  git clone --quiet https://github.com/SgSiegens/raypaper.git "$RAYPAPER_SRC"
fi
make -C "$RAYPAPER_SRC" >/dev/null
if [[ -w /usr/local/bin ]]; then
  make -C "$RAYPAPER_SRC" install >/dev/null
else
  sudo make -C "$RAYPAPER_SRC" install >/dev/null
fi
ok "raypaper built and installed to /usr/local/bin"

# ---------------------------------------------------------------------------
# Symlink dotfiles with GNU Stow
# ---------------------------------------------------------------------------
log "Symlinking dotfiles"

# Keep stow from symlinking repo-internal, non-dotfile stuff into $HOME. 
# edit if you want to change what stow ignores.
STOW_IGNORE="$DOTFILES_DIR/.stow-local-ignore"
if [[ ! -f "$STOW_IGNORE" ]]; then
  cat > "$STOW_IGNORE" <<'EOF'
(^|/)\.git$
(^|/)\.github$
(^|/)\.gitignore$
(^|/)\.DS_Store$
(^|/)README(\..*)?$
(^|/)Brewfile$
(^|/)install\.sh$
(^|/)setup_macos\.sh$
EOF
  echo "  created $STOW_IGNORE — sanity-check it with 'stow -n -v' if unsure"
fi

# Make sure ~/.config is a real directory (not a symlink) BEFORE stowing, so
# stow places individual symlinks *inside* it instead of folding the whole
# directory into one link (which would break every other app's config dir).
mkdir -p "$HOME/.config"


backup_if_real() {
  local target="$1"
  local expected="$2"   # what stow would point $target at, if it doesn't already
 
  if [[ -L "$target" ]]; then
    if [[ -e "$expected" && "$target" -ef "$expected" ]]; then
      return 0   # already correctly stowed — nothing to do
    fi
    # falls through: broken symlink, or pointing somewhere else — back it up
  elif [[ ! -e "$target" ]]; then
    return 0   # nothing there — nothing to back up
  fi
 
  local rel="${target#"$HOME"/}"
  mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
  mv "$target" "$BACKUP_DIR/$rel"
  echo " backed up existing $target -> $BACKUP_DIR/$rel"
}
for f in "${TOP_LEVEL_LINKS[@]}"; do backup_if_real "$HOME/$f" "$DOTFILES_DIR/$f"; done
for d in "${CONFIG_LINKS[@]}"; do backup_if_real "$HOME/.config/$d" "$DOTFILES_DIR/.config/$d"; done
 
stow -v -t "$HOME" -d "$(dirname "$DOTFILES_DIR")" "$(basename "$DOTFILES_DIR")"
ok "stow finished"

# ---------------------------------------------------------------------------
# Start background services
# ---------------------------------------------------------------------------
if [[ "$IS_CI" == "true" ]]; then
  log "Running in CI — skipping AeroSpace/borders/sketchybar/skhd (no GUI session)"
else
  log "Starting services"
  brew services start borders    &>/dev/null || true
  brew services start sketchybar &>/dev/null || true
  if command -v skhd &>/dev/null; then
    skhd --start-service &>/dev/null || true
  fi
  open -g -a "AeroSpace" &>/dev/null || true
fi


# Prime pywal once
# ---------------------------------------------------------------------------
# flameshot.ini, borders' bordersrc, and btop's theme are symlinks  pointing 
# at files pywal generates under ~/.cache/wal/.
# On a fresh machine those targets don't exist until wal actually runs once,
# so right after stow those symlinks are dangling. This runs it once, using
# whatever the desktop wallpaper already is, so those app configs resolve to
# real content immediately instead of staying broken until you manually pick
# a wallpaper. 

log "Initializing Pywal theme and dynamic symlinks"

if command -v wal &>/dev/null; then
  DEFAULT_WALLPAPER="$DOTFILES_DIR/default_wallpaper.jpg"
  if [[ ! -f "$DEFAULT_WALLPAPER" ]]; then
    fail "default wallpaper not found at $DEFAULT_WALLPAPER — symlinks below will stay dangling"
    FAILED=1
  elif wal -i "$DEFAULT_WALLPAPER" -q; then
    ok "Pywal initial cache populated in ~/.cache/wal"
  else
    fail "wal failed to generate the initial cache (see output above) — symlinks below will stay dangling"
    FAILED=1
  fi

  # Ensure destination config directories exist
  mkdir -p "$HOME/.config/flameshot" "$HOME/.config/borders" "$HOME/.config/btop/themes"

  # 3. Dynamically symlink target configs to ~/.cache/wal/
  ln -sf "$HOME/.cache/wal/flameshot.ini" "$HOME/.config/flameshot/flameshot.ini"
  ln -sf "$HOME/.cache/wal/bordersrc"     "$HOME/.config/borders/bordersrc"
  ln -sf "$HOME/.cache/wal/btopwal.theme" "$HOME/.config/btop/themes/btopwal.theme"

  ok "Dynamic Pywal symlinks created in ~/.config/"
else
  fail "wal binary not found — skipping cache generation and symlinking"
  FAILED=1
fi



# ---------------------------------------------------------------------------
# mac os setup script
# set some stuff like key bindings, hide dock , etc.
# ---------------------------------------------------------------------------
log "Applying macOS defaults (setup_macos.sh)"
MACOS_SETUP="$DOTFILES_DIR/setup_macos.sh"

if [[ -f "$MACOS_SETUP" ]]; then
  chmod +x "$MACOS_SETUP"
  if "$MACOS_SETUP"; then
    ok "macOS defaults script executed successfully"
  else
    fail "macOS defaults script failed during execution"
    FAILED=1
  fi
else
  fail "macOS defaults script not found at $MACOS_SETUP"
  FAILED=1
fi



# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------
log "Verifying setup"

check() {
  local desc="$1"; shift
  if "$@" &>/dev/null; then ok "$desc"; else fail "$desc"; FAILED=1; fi
}

# --- symlinks landed where expected ---
for f in "${TOP_LEVEL_LINKS[@]}"; do
  check "$f is symlinked"          test -L "$HOME/$f"
done
for d in "${CONFIG_LINKS[@]}"; do
  check ".config/$d is symlinked"  test -L "$HOME/.config/$d"
done

# --- tools that don't run as daemons are actually on PATH ---
check "brew is installed"       command -v brew
check "stow is installed"       command -v stow
check "pywal (wal) is installed" command -v wal
check "raypaper is installed"  command -v raypaper

# --- window manager + bar + hotkeys are actually alive — only meaningful
# --- with a real GUI session, so skip in headless CI ---
if [[ "$IS_CI" == "true" ]]; then
  echo "  (skipping AeroSpace/borders/sketchybar/skhd liveness checks — no GUI session in CI)"
else
  check "AeroSpace running"       pgrep -x AeroSpace

  if brew services list --json | jq -e '.[] | select(.name=="borders" and .status=="started")' &>/dev/null; then
    ok "borders service running"
  else
    fail "borders service not running"; FAILED=1
  fi

  if brew services list --json | jq -e '.[] | select(.name=="sketchybar" and .status=="started")' &>/dev/null; then
    ok "sketchybar service running"
  else
    fail "sketchybar service not running"; FAILED=1
  fi

  if launchctl list 2>/dev/null | grep -qi skhd; then
    ok "skhd loaded"
  else
    fail "skhd not loaded"; FAILED=1
  fi

  # make the wallpaper utils executable 
  chmod +x "$HOME/scripts/pywal16.sh"
  chmod +x "$HOME/scripts/wallpapermenu.sh"

  "$HOME/scripts/pywal16.sh"
fi

echo
if [[ $FAILED -eq 1 ]]; then
  echo "Finished with some checks failing — see ✘ above."
  exit 1
fi



echo "All checks passed."
echo "Note: AeroSpace tiling and Accessibility-permission prompts may still need a login/logout to fully kick in."
echo "Note: Close this terminal and open a new shell window for the new Homebrew Bash version and PATH changes to take effect."
