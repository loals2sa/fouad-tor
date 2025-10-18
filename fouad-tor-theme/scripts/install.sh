#!/usr/bin/env bash
set -euo pipefail

# Fouad Tor Theme Installer
# Applies neon hacker styling to a Tor Browser bundle profile.

NAME="Fouad Tor"
ACCENT="#00ff7f"
MAKE_SHORTCUT=1
UNINSTALL=0
TOR_DIR=""
ICON=""

usage(){
  cat <<USAGE
Usage: $0 --tor-dir "/path/to/tor-browser" --icon "/abs/path/to/icon.png" [options]

Options:
  --name "Fouad Tor"      Display name for shortcut (default: Fouad Tor)
  --accent "#00ff7f"      Hex accent color (default: #00ff7f)
  --make-shortcut         Create ~/Desktop/<NAME>.desktop (default)
  --no-shortcut           Skip desktop shortcut creation
  --uninstall             Restore backups and remove shortcut
  -h, --help              Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tor-dir) TOR_DIR="$2"; shift 2;;
    --icon) ICON="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --accent) ACCENT="$2"; shift 2;;
    --make-shortcut) MAKE_SHORTCUT=1; shift;;
    --no-shortcut) MAKE_SHORTCUT=0; shift;;
    --uninstall) UNINSTALL=1; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1;;
  esac
done

if [[ -z "$TOR_DIR" ]]; then echo "--tor-dir is required" >&2; exit 1; fi
if [[ $UNINSTALL -eq 0 && -z "$ICON" ]]; then echo "--icon is required (absolute path)" >&2; exit 1; fi

# Resolve profile directory
PROFILE_DIR="$TOR_DIR/Browser/TorBrowser/Data/Browser/profile.default"
CHROME_DIR="$PROFILE_DIR/chrome"
mkdir -p "$CHROME_DIR"

if [[ $UNINSTALL -eq 1 ]]; then
  for f in user.js chrome/userChrome.css chrome/userContent.css; do
    if [[ -e "$PROFILE_DIR/${f}.bak" ]]; then
      mv -f "$PROFILE_DIR/${f}.bak" "$PROFILE_DIR/${f}"
    else
      rm -f "$PROFILE_DIR/${f}"
    fi
  done
  if [[ $MAKE_SHORTCUT -eq 1 ]]; then
    rm -f "$HOME/Desktop/${NAME}.desktop"
  fi
  echo "Uninstall complete."; exit 0
fi

# Backups
for f in user.js chrome/userChrome.css chrome/userContent.css; do
  if [[ -e "$PROFILE_DIR/$f" ]]; then cp -f "$PROFILE_DIR/$f" "$PROFILE_DIR/$f.bak"; fi
done

# Write user.js
cat > "$PROFILE_DIR/user.js" <<EOF
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.startup.homepage", "file://${PROFILE_DIR}/fouad-home.html");
user_pref("browser.startup.page", 1);
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_override_url", "");
EOF

# Inject CSS templates with variable substitution
sed "s|__ACCENT__|$ACCENT|g; s|__ICON_URI__|file://$ICON|g" \
  "$(dirname "$0")/../templates/userChrome.css" > "$CHROME_DIR/userChrome.css"

sed "s|__ACCENT__|$ACCENT|g; s|__ICON_URI__|file://$ICON|g; s|__BANNER_TEXT__|$NAME|g" \
  "$(dirname "$0")/../templates/userContent.css" > "$CHROME_DIR/userContent.css"

# Homepage
sed "s|__ICON_URI__|file://$ICON|g; s|__TITLE__|$NAME|g" \
  "$(dirname "$0")/../templates/fouad-home.html" > "$PROFILE_DIR/fouad-home.html"

# Desktop shortcut (optional)
if [[ $MAKE_SHORTCUT -eq 1 ]]; then
  DESKTOP_FILE="$HOME/Desktop/${NAME}.desktop"
  mkdir -p "$HOME/Desktop"
  TOR_START="$TOR_DIR/Browser/start-tor-browser"
  sed "s|__NAME__|$NAME|g; s|__ICON__|$ICON|g; s|__EXEC__|$TOR_START --detach|g" \
    "$(dirname "$0")/../templates/Fouad Tor.desktop" > "$DESKTOP_FILE"
  chmod +x "$DESKTOP_FILE"
  echo "Shortcut written to: $DESKTOP_FILE"
fi

echo "Done. Launch Tor Browser. If theme doesn’t appear, fully close and relaunch."
