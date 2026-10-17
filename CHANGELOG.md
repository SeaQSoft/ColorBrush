# Changelog

All notable changes to ColorBrush are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [1.3.0] – 2026-10-17

First public release.

### Added
- Paint brush and paint splat in the panel – both take on the last picked color with a smooth fade.
- Click the **brush** to pick a color from anywhere on screen; click the **splat** to open the history.
- Clean, modern popup with a large color preview, history list and a segmented **HEX | RGB** switch.
- One-click copy for every color, plus automatic copy right after picking.
- Manual color selection through the color dialog.
- Light and dark appearance that follows your Plasma color scheme.
- Automatic UI language based on your system locale: English, German, French, Spanish, Italian, Dutch, Polish, Brazilian Portuguese and Turkish.
- Context menu actions: pick color, toggle HEX/RGB, clear history.

### Changed
- Renamed from the pre-release name *ChromaBrush* to **ColorBrush** (new plugin id `org.seaq.colorbrush`).
- Screen picking now talks to KWin directly over D-Bus, so it no longer needs the private Plasma color picker module that Plasma 6.7 removed.

[1.3.0]: https://github.com/Swenix-dev/ColorBrush/releases/tag/v1.3.0
