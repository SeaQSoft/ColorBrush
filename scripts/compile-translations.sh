#!/usr/bin/env bash
# Compiles po/<lang>.po into package/contents/locale/<lang>/LC_MESSAGES/*.mo
set -euo pipefail
cd "$(dirname "$0")/.."

DOMAIN="plasma_applet_org.seaq.colorbrush"
for po in po/*.po; do
    lang=$(basename "$po" .po)
    dir="package/contents/locale/$lang/LC_MESSAGES"
    mkdir -p "$dir"
    msgfmt --check -o "$dir/$DOMAIN.mo" "$po"
    echo "  $lang ✓"
done
