#!/usr/bin/env bash
# Extracts all i18n() strings into the .pot template and merges them into every .po file.
set -euo pipefail
cd "$(dirname "$0")/.."

DOMAIN="plasma_applet_org.seaq.colorbrush"
xgettext --from-code=UTF-8 -L JavaScript -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 \
    --package-name=ColorBrush --msgid-bugs-address=https://github.com/Swenix-dev/ColorBrush/issues \
    -o "po/$DOMAIN.pot" package/contents/ui/*.qml
for po in po/*.po; do
    msgmerge -q -U --backup=none "$po" "po/$DOMAIN.pot"
done
echo "Template updated."
