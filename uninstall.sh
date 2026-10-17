#!/usr/bin/env bash
# Removes ColorBrush for the current user.
set -euo pipefail
kpackagetool6 -t Plasma/Applet -r org.seaq.colorbrush
echo "ColorBrush removed."
