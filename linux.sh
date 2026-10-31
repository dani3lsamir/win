#!/usr/bin/env bash
# Win Setup for Linux - my apps and settings installer.
# by: dani3lsamir
#
# Usage:  curl -fsSL dani3lsamir.github.io/win/linux | bash
#
# Works on Debian/Ubuntu/Mint (apt), Fedora (dnf), Arch (pacman) and openSUSE (zypper).
# Desktop apps come from Flathub so they are always up to date on any distro.

# ==========================================================================
#  APPS
#  key | category | name | method | what to install | on by default (1/0)
#
#  methods:
#    flatpak  -> Flathub id
#    pkg      -> distro packages, per package manager: apt:a,b;dnf:a,b;pacman:a;zypper:a
#    script   -> special installers handled in install_script()
# ==========================================================================
APPS=(
  "brave|Browser|Brave Origin|script|brave-origin|1"

  "obsidian|AI & Notes|Obsidian|flatpak|md.obsidian.Obsidian|1"

  "7zip|Utilities|7-Zip (also opens .rar)|pkg|apt:7zip;dnf:7zip;pacman:7zip;zypper:7zip|1"
  "localsend|Utilities|LocalSend|flatpak|org.localsend.localsend_app|1"
  "tailscale|Utilities|Tailscale|script|tailscale|1"

  "dropbox|Cloud|Dropbox|flatpak|com.dropbox.Client|1"
  "nextcloud|Cloud|Nextcloud|flatpak|com.nextcloud.desktopclient.nextcloud|1"

  "vlc|Media|VLC|flatpak|org.videolan.VLC|1"
  "obs|Media|OBS Studio|flatpak|com.obsproject.Studio|1"
  "strawberry|Media|Strawberry (like AIMP)|flatpak|org.strawberrymusicplayer.strawberry|0"
  "kid3|Media|Kid3 (like Mp3tag)|flatpak|org.kde.kid3|0"

  "git|Development|Git|pkg|apt:git;dnf:git;pacman:git;zypper:git|1"
  "node|Development|Node.js|pkg|apt:nodejs,npm;dnf:nodejs,npm;pacman:nodejs,npm;zypper:nodejs,npm|1"
  "python|Development|Python 3|pkg|apt:python3,python3-pip,python3-venv;dnf:python3,python3-pip;pacman:python,python-pip;zypper:python3,python3-pip|1"
  "jdk17|Development|OpenJDK 17|pkg|apt:openjdk-17-jdk;dnf:java-17-openjdk-devel;pacman:jdk17-openjdk;zypper:java-17-openjdk-devel|1"
  "androidstudio|Development|Android Studio|flatpak|com.google.AndroidStudio|1"
  "adb|Development|Android Platform Tools (adb)|pkg|apt:adb,fastboot;dnf:android-tools;pacman:android-tools;zypper:android-tools|1"
)

# ==========================================================================
#  SETTINGS
#  key | name | on by default (1/0)
# ==========================================================================
TWEAKS=(
  "update|Update the whole system first|1"
  "dark|Dark mode|1"
  "battery|Battery percentage in the top bar (GNOME, laptops)|1"
  "numlock|Num Lock on at login|1"
  "sticky|Disable Sticky Keys|1"
  "buttons|Minimize and maximize buttons on windows (GNOME)|0"
)

# Violet theme for the menus
export NEWT_COLORS='
root=brightmagenta,black
roottext=lightgray,black
border=brightmagenta,black
window=white,black
shadow=black,black
title=brightmagenta,black
textbox=white,black
button=white,magenta
actbutton=black,brightmagenta
compactbutton=lightgray,black
checkbox=white,black
actcheckbox=black,brightmagenta
listbox=white,black
actlistbox=black,brightmagenta
sellistbox=brightmagenta,black
actsellistbox=black,brightmagenta
entry=white,black
'
BACKTITLE="Win Setup for Linux  -  by: dani3lsamir"

violet() { printf '\033[95m%s\033[0m\n' "$*"; }
green()  { printf '\033[92m%s\033[0m\n' "$*"; }
red()    { printf '\033[91m%s\033[0m\n' "$*"; }
gray()   { printf '\033[90m%s\033[0m\n' "$*"; }

detect_pm() {
  for pm in apt dnf pacman zypper; do
    if command -v "$pm" >/dev/null 2>&1; then echo "$pm"; return; fi
  done
}

pm_update_index() {
  case "$PM" in
    apt)    $SUDO apt-get update -qq ;;
    dnf)    $SUDO dnf makecache -q ;;
    pacman) $SUDO pacman -Sy --noconfirm ;;
    zypper) $SUDO zypper --non-interactive refresh ;;
  esac
}

pm_install() {
  case "$PM" in
    apt)    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y "$@" ;;
    dnf)    $SUDO dnf install -y "$@" ;;
    pacman) $SUDO pacman -S --needed --noconfirm "$@" ;;
    zypper) $SUDO zypper --non-interactive install "$@" ;;
  esac
}

pm_upgrade() {
  case "$PM" in
    apt)    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y ;;
    dnf)    $SUDO dnf upgrade -y ;;
    pacman) $SUDO pacman -Syu --noconfirm ;;
    zypper) $SUDO zypper --non-interactive update ;;
  esac
}

# Picks the package list for this distro out of "apt:a,b;dnf:c;..."
pkgs_for_pm() {
  local spec="$1" part
  IFS=';' read -ra parts <<< "$spec"
  for part in "${parts[@]}"; do
    if [[ "$part" == "$PM:"* ]]; then
      local list="${part#*:}"
      echo "${list//,/ }"
      return
    fi
  done
}

install_script() {
  case "$1" in
    brave-origin) curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh ;;
    tailscale)    curl -fsSL https://tailscale.com/install.sh | sh ;;
  esac
}

ensure_flathub() {
  [[ -n "$FLATHUB_READY" ]] && return 0
  if ! command -v flatpak >/dev/null 2>&1; then
    violet "Installing Flatpak..."
    pm_install flatpak || return 1
  fi
  $SUDO flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || return 1
  FLATHUB_READY=1
}

has_gnome() { [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] && command -v gsettings >/dev/null 2>&1; }
has_kde()   { [[ "${XDG_CURRENT_DESKTOP:-}" == *KDE* ]]; }
kwrite()    { if command -v kwriteconfig6 >/dev/null 2>&1; then kwriteconfig6 "$@"; else kwriteconfig5 "$@"; fi; }

apply_tweak() {
  case "$1" in
    update)
      pm_upgrade ;;
    dark)
      if has_gnome; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
      elif has_kde; then
        if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
          plasma-apply-lookandfeel -a org.kde.breezedark.desktop
        else
          lookandfeeltool -a org.kde.breezedark.desktop
        fi
      else
        gray "   (only GNOME and KDE are supported)"; return 1
      fi ;;
    battery)
      has_gnome || { gray "   (GNOME only)"; return 1; }
      gsettings set org.gnome.desktop.interface show-battery-percentage true ;;
    numlock)
      if has_gnome; then
        gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state false
        gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
      elif has_kde; then
        kwrite --file kcminputrc --group Keyboard --key NumLock 0
      else
        gray "   (only GNOME and KDE are supported)"; return 1
      fi ;;
    sticky)
      if has_gnome; then
        gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable false
        gsettings set org.gnome.desktop.a11y.keyboard enable false
      elif has_kde; then
        kwrite --file kaccessrc --group Keyboard --key StickyKeys false
      else
        gray "   (only GNOME and KDE are supported)"; return 1
      fi ;;
    buttons)
      has_gnome || { gray "   (GNOME only)"; return 1; }
      gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' ;;
  esac
}

main() {
  echo
  violet "  =============================="
  violet "     W I N   S E T U P  (Linux)"
  gray   "         by: dani3lsamir"
  violet "  =============================="
  echo

  if [[ ! -r /dev/tty ]]; then
    red "This needs an interactive terminal."; exit 1
  fi

  if [[ $EUID -eq 0 ]]; then
    SUDO=""
    gray "Running as root: desktop settings will apply to root, not your user."
  else
    SUDO="sudo"
    violet "Your password is needed to install apps."
    sudo -v < /dev/tty || { red "sudo failed."; exit 1; }
  fi

  PM=$(detect_pm)
  if [[ -z "$PM" ]]; then
    red "No supported package manager found (apt, dnf, pacman, zypper)."; exit 1
  fi
  gray "Package manager: $PM"
  FLATHUB_READY=""

  if ! command -v whiptail >/dev/null 2>&1; then
    violet "Installing whiptail (for the menus)..."
    pm_update_index
    case "$PM" in
      apt) pm_install whiptail ;;
      pacman) pm_install libnewt ;;
      *) pm_install newt ;;
    esac
  fi

  # ---- Apps menu ----
  local args=() entry key cat name method arg def
  for entry in "${APPS[@]}"; do
    IFS='|' read -r key cat name method arg def <<< "$entry"
    args+=("$key" "$(printf '%-30s %s' "$name" "$cat")" "$([[ $def == 1 ]] && echo ON || echo OFF)")
  done
  local sel_apps
  sel_apps=$(whiptail --backtitle "$BACKTITLE" --title " Apps " --separate-output \
    --checklist "Space = check/uncheck   Enter = continue" 22 76 14 \
    "${args[@]}" 3>&1 1>&2 2>&3 < /dev/tty) || { echo "Cancelled."; exit 0; }

  # ---- Settings menu ----
  args=()
  for entry in "${TWEAKS[@]}"; do
    IFS='|' read -r key name def <<< "$entry"
    args+=("$key" "$name" "$([[ $def == 1 ]] && echo ON || echo OFF)")
  done
  local sel_tweaks
  sel_tweaks=$(whiptail --backtitle "$BACKTITLE" --title " Settings " --separate-output \
    --checklist "Space = check/uncheck   Enter = install" 16 76 6 \
    "${args[@]}" 3>&1 1>&2 2>&3 < /dev/tty) || { echo "Cancelled."; exit 0; }

  local failed=()

  # "Update the whole system" runs before installing apps
  if grep -qxF update <<< "$sel_tweaks"; then
    echo; violet "Updating the system..."
    apply_tweak update || failed+=("System update")
  fi

  # ---- Install apps ----
  local selected=() total i=0
  mapfile -t selected <<< "$sel_apps"
  [[ -z "${selected[0]:-}" ]] && selected=()
  total=${#selected[@]}
  if (( total > 0 )); then
    [[ "$PM" == "apt" || "$PM" == "zypper" ]] && pm_update_index
  fi
  for entry in "${APPS[@]}"; do
    IFS='|' read -r key cat name method arg def <<< "$entry"
    grep -qxF "$key" <<< "$sel_apps" || continue
    i=$((i + 1))
    echo; violet "[$i/$total] $name"
    local ok=0
    case "$method" in
      flatpak) ensure_flathub && $SUDO flatpak install -y --noninteractive flathub "$arg" && ok=1 ;;
      script)  install_script "$arg" && ok=1 ;;
      pkg)
        local pkgs; pkgs=$(pkgs_for_pm "$arg")
        if [[ -z "$pkgs" ]]; then gray "   Not available for $PM"
        else
          # shellcheck disable=SC2086
          pm_install $pkgs && ok=1
        fi ;;
    esac
    if (( ok )); then green "   Installed"; else red "   Failed"; failed+=("$name"); fi
  done

  # ---- Apply settings ----
  if [[ -n "$(grep -vxF update <<< "$sel_tweaks")" ]]; then
    echo; violet "Applying settings..."
    for entry in "${TWEAKS[@]}"; do
      IFS='|' read -r key name def <<< "$entry"
      [[ "$key" == "update" ]] && continue
      grep -qxF "$key" <<< "$sel_tweaks" || continue
      if apply_tweak "$key"; then green "   OK  $name"; else red "   Skipped  $name"; failed+=("$name"); fi
    done
  fi

  echo
  if (( ${#failed[@]} > 0 )); then
    local list; list=$(printf '%s, ' "${failed[@]}")
    red "Finished with problems in: ${list%, }"
  else
    green "Done. Log out and back in (or restart) so new apps show up in the menu."
  fi
}

main "$@"
