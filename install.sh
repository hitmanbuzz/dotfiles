#!/usr/bin/env bash
set -euo pipefail

# install-packages.sh
# Installs all packages found in either pacman-packages.txt or paru-packages.txt
# Pacman packages are installed first; duplicates are ignored.

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

read_pkg_list() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo ""
    return
  fi
  sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$file" | awk 'NF'
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

run_or_dry() {
  local cmd="$*"
  if $DRY_RUN; then
    echo "[DRY-RUN] $cmd"
  else
    log "Running: $cmd"
    eval "$cmd"
  fi
}

# --- START ---

log "Starting package installer."

pacman_pkgs=$(read_pkg_list "$PACMAN_LIST")
paru_pkgs=$(read_pkg_list "$PARU_LIST")

# Merge package lists and remove duplicates
# Prefer pacman list (it overrides same-name entries from paru list)
if [[ -n "$pacman_pkgs" && -n "$paru_pkgs" ]]; then
  merged_pkgs=$(printf "%s\n%s\n" "$pacman_pkgs" "$paru_pkgs" | awk '!seen[$0]++')
elif [[ -n "$pacman_pkgs" ]]; then
  merged_pkgs="$pacman_pkgs"
else
  merged_pkgs="$paru_pkgs"
fi

if [[ -z "$merged_pkgs" ]]; then
  echo "No packages found in $PACMAN_LIST or $PARU_LIST. Exiting."
  exit 0
fi

# Split by origin
IFS=$'\n' read -rd '' -a pacman_array <<<"$pacman_pkgs" || true
IFS=$'\n' read -rd '' -a paru_array <<<"$paru_pkgs" || true

echo "📦 Pacman packages:"
printf '  - %s\n' "${pacman_array[@]}"
echo
echo "📦 Paru packages:"
printf '  - %s\n' "${paru_array[@]}"
echo

confirm_or_exit "Proceed with installation?"

# --- Step 1: Pacman ---
if [[ "${#pacman_array[@]}" -gt 0 ]]; then
  log "Updating system..."
  run_or_dry sudo pacman -Syu --noconfirm

  cmd="sudo pacman -S --needed --noconfirm"
  for pkg in "${pacman_array[@]}"; do
    cmd+=" $pkg"
  done
  run_or_dry bash -c "$cmd"
else
  log "No pacman packages found; skipping pacman step."
fi

# --- Step 2: Ensure paru exists ---
if [[ "${#paru_array[@]}" -gt 0 ]]; then
  if ! command -v paru >/dev/null 2>&1; then
    log "paru not found — installing from AUR"
    if $DRY_RUN; then
      echo "[DRY-RUN] Would build paru from AUR"
    else
      confirm_or_exit "paru not found. Clone and build paru now?"
      tmpdir="$(mktemp -d)"
      run_or_dry git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
      cd "$tmpdir/paru"
      makepkg -si --noconfirm
      cd - >/dev/null || true
      rm -rf "$tmpdir"
    fi
  else
    log "paru already installed."
  fi
fi

# --- Step 3: Paru ---
if [[ "${#paru_array[@]}" -gt 0 ]]; then
  cmd="paru -S --needed --noconfirm"
  for pkg in "${paru_array[@]}"; do
    # skip if already listed in pacman
    if grep -qx "$pkg" <<<"$pacman_pkgs"; then
      log "Skipping $pkg (already in pacman list)"
      continue
    fi
    cmd+=" $pkg"
  done
  run_or_dry bash -c "$cmd"
else
  log "No paru packages found; skipping paru step."
fi

log "✅ Installation complete."
echo "Check $LOGFILE for detailed logs."
