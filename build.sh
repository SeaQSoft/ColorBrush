#!/usr/bin/env bash
# Builds ColorBrush-<version>.plasmoid from the package/ folder.
set -euo pipefail
cd "$(dirname "$0")"

# Recompile translations if gettext is available
if command -v msgfmt >/dev/null 2>&1; then
    ./scripts/compile-translations.sh
fi

VERSION=$(grep -oP '"Version":\s*"\K[^"]+' package/metadata.json)
OUT="ColorBrush-${VERSION}.plasmoid"

rm -f "$OUT"
(cd package && zip -qr "../$OUT" . -x '*.swp' '*~')
echo "Built $OUT"
