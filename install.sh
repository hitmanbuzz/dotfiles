#!/usr/bin/env bash
set -euo pipefail

# install-packages.sh
# Usage:
#   ./install.sh           # interactive (prompts before actions)
#   ./install.sh --yes     # assume yes (no interactive prompts)
#   ./install.sh --dry-run # don't run installs, just show what would run

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$DOTFILES_DIR/packages"
PACMAN_LIST="$PKG_DIR/pacman-packages.txt"
PARU_LIST="$PKG_DIR/paru-packages.txt"
LOGFILE="$DOTFILES_DIR/install-packages.log"

ASSUME_YES=false
DRY_RUN=false

while [[ "${1:-}" != "" ]]; do
  case "$1" in
    --yes|-y) ASSUME_YES=true ;;
    --dry-run) DRY_RUN=true ;;
    --help|-h)
      echo "Usage: $0 [--yes|-y] [--dry-run]"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

log() {
  echo "[$(timestamp)] $*"
  echo "[$(timestamp)] $*" >> "$LOGFILE"
}

# read package list helper (strips comments and blank lines)
read_pkg_list() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo ""
    return
  fi
  # remove comments (#...), trim lines, drop empty lines
  sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$file" \
    | awk 'NF' 
}

confirm_or_exit() {
  local msg="$1"
  if $ASSUME_YES || $DRY_RUN; then
    log "Auto-confirmed: $msg"
    return 0
  fi
  read -r -p "$msg [y/N] " ans
  case "$ans" in
    [Yy]*) return 0 ;;
    *) echo "Aborting."; exit 1 ;;
  esac
}

# Dry-run wrapper
run_or_dry() {
  local cmd="$*"
  if $DRY_RUN; then
    echo "[DRY-RUN] $cmd"
  else
    log "Running: $cmd"
    eval "$cmd"
  fi
}

log "Starting installer (DOTFILES_DIR=$DOTFILES_DIR)".

pacman_pkgs="$(read_pkg_list "$PACMAN_LIST")"
paru_pkgs="$(read_pkg_list "$PARU_LIST")"

if [[ -z "$pacman_pkgs" && -z "$paru_pkgs" ]]; then
  echo "No packages found in $PACMAN_LIST or $PARU_LIST. Nothing to do."
  exit 0
fi

# 1) Pacman: update and install packages
if [[ -n "$pacman_pkgs" ]]; then
  echo "Pacman packages to install:"
  echo "$pacman_pkgs"
  confirm_or_exit "Proceed to sync and install pacman packages?"

  # system update first
  run_or_dry sudo pacman -Syu --noconfirm

  # install pacman packages, --needed skips already-installed packages
  # split into array to preserve spaces in package names (rare) safely
  IFS=$'\n' read -rd '' -a pacman_array <<<"$pacman_pkgs" || true
  if [[ "${#pacman_array[@]}" -gt 0 ]]; then
    # build install command
    cmd="sudo pacman -S --needed --noconfirm"
    for pkg in "${pacman_array[@]}"; do
      cmd+=" $pkg"
    done
    run_or_dry bash -c "$cmd"
  fi
else
  log "No pacman packages defined; skipping pacman step."
fi

# 2) AUR: ensure paru is available, then install AUR packages
if [[ -n "$paru_pkgs" ]]; then
  echo "AUR packages to install via paru:"
  echo "$paru_pkgs"
  confirm_or_exit "Proceed to install AUR packages with paru?"

  if ! command -v paru >/dev/null 2>&1; then
    log "paru not found."
    if $DRY_RUN; then
      echo "[DRY-RUN] Would install paru from AUR (git+makepkg)."
    else
      echo "paru is not installed. I'll attempt to build/install paru from AUR using the current user."
      confirm_or_exit "Clone and build paru now? This requires base-devel and git to be installed and will run makepkg."
      # minimal attempt to install paru
      tmpdir="$(mktemp -d)"
      log "Cloning paru into $tmpdir/paru"
      run_or_dry git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
      if ! $DRY_RUN; then
        cd "$tmpdir/paru"
        log "Building paru with makepkg -si --noconfirm"
        # The user must have base-devel and git installed; we run as the normal user.
        makepkg -si --noconfirm
        cd - >/dev/null || true
        rm -rf "$tmpdir"
      fi
      if command -v paru >/dev/null 2>&1; then
        log "paru installed successfully."
      else
        echo "Failed to install paru. Please install paru manually (e.g. from AUR) and re-run this script."
        exit 1
      fi
    fi
  else
    log "paru found at $(command -v paru)"
  fi

  # install paru packages
  IFS=$'\n' read -rd '' -a paru_array <<<"$paru_pkgs" || true
  if [[ "${#paru_array[@]}" -gt 0 ]]; then
    cmd="paru -S --needed --noconfirm"
    for pkg in "${paru_array[@]}"; do
      cmd+=" $pkg"
    done
    run_or_dry bash -c "$cmd"
  fi
else
  log "No paru (AUR) packages defined; skipping paru step."
fi

log "Package installation process finished."
echo "Done. Check $LOGFILE for details."
