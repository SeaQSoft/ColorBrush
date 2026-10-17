#!/usr/bin/env bash
# Installs or updates ColorBrush for the current user (KDE Plasma 6).
set -euo pipefail
cd "$(dirname "$0")"

ID="org.seaq.colorbrush"

# Remove the pre-release package (ChromaBrush) if it is still installed
if kpackagetool6 -t Plasma/Applet -s org.seaq.chromabrush >/dev/null 2>&1; then
    kpackagetool6 -t Plasma/Applet -r org.seaq.chromabrush
    echo "Removed old ChromaBrush package."
fi

if kpackagetool6 -t Plasma/Applet -s "$ID" >/dev/null 2>&1; then
    kpackagetool6 -t Plasma/Applet -u package
    echo "ColorBrush updated."
else
    kpackagetool6 -t Plasma/Applet -i package
    echo "ColorBrush installed."
fi

echo
echo "Right-click your panel → Add Widgets… → search for \"ColorBrush\"."
echo "After an update, reload Plasma:  systemctl --user restart plasma-plasmashell"
