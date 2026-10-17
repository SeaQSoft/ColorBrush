import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: root

    // ---------- State ----------
    readonly property var history: Plasmoid.configuration.history
    readonly property bool hasColor: history.length > 0
    readonly property string currentHex: hasColor ? history[0] : "#FF2D55"
    readonly property string mode: Plasmoid.configuration.displayMode === "rgb" ? "rgb" : "hex"

    property bool reopenAfterPick: false

    signal copied(string text)

    preferredRepresentation: compactRepresentation
    switchWidth: Kirigami.Units.gridUnit * 16
    switchHeight: Kirigami.Units.gridUnit * 18

    Plasmoid.icon: "color-picker"
    toolTipMainText: "ColorBrush"
    toolTipSubText: hasColor
        ? i18n("Current: %1", format(currentHex))
        : i18n("Brush: pick a color · Splat: open history")

    // ---------- Helpers ----------
    function _hex2(v) {
        const s = Math.round(v * 255).toString(16).toUpperCase();
        return s.length < 2 ? "0" + s : s;
    }
    function colorToHex(c) {
        return "#" + _hex2(c.r) + _hex2(c.g) + _hex2(c.b);
    }
    function hexToRgb(hex) {
        const h = hex.replace("#", "");
        return "rgb(" + parseInt(h.substr(0, 2), 16) + ", "
                      + parseInt(h.substr(2, 2), 16) + ", "
                      + parseInt(h.substr(4, 2), 16) + ")";
    }
    function format(hex, m) {
        return (m || mode) === "rgb" ? hexToRgb(hex) : hex.toUpperCase();
    }
    function setMode(m) {
        Plasmoid.configuration.displayMode = m;
    }

    function addColor(c) {
        const hex = (typeof c === "string") ? c.toUpperCase() : colorToHex(c);
        const list = [hex];
        for (let i = 0; i < history.length; ++i) {
            if (history[i].toUpperCase() !== hex)
                list.push(history[i]);
        }
        Plasmoid.configuration.history = list.slice(0, Plasmoid.configuration.maxEntries);
        return hex;
    }
    function removeAt(index) {
        const list = [];
        for (let i = 0; i < history.length; ++i)
            if (i !== index) list.push(history[i]);
        Plasmoid.configuration.history = list;
    }
    function clearHistory() {
        Plasmoid.configuration.history = [];
    }

    function copy(text) {
        clipboardHelper.text = text;
        clipboardHelper.selectAll();
        clipboardHelper.copy();
        root.copied(text);
    }

    // Close the popup, wait a moment, then start KWin's screen color picker
    function pick(fromPopup) {
        reopenAfterPick = !!fromPopup;
        root.expanded = false;
        pickTimer.start();
    }

    Timer {
        id: pickTimer
        interval: 260
        onTriggered: executable.connectSource(root.pickCommand)
    }

    // KWin color picker via D-Bus (gdbus ships with glib2 on virtually every distro).
    // The reply looks like "(uint32 4294914389,)"  → ARGB value
    readonly property string pickCommand:
        "gdbus call --session --timeout 300 --dest org.kde.KWin "
        + "--object-path /ColorPicker --method org.kde.kwin.ColorPicker.pick"

    property string lastError: ""

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (source, data) => {
            disconnectSource(source);
            const out = data["stdout"] || "";
            const match = out.match(/uint32\s+(\d+)/);
            if (data["exit code"] === 0 && match) {
                const argb = Number(match[1]);
                const r = Math.floor(argb / 65536) % 256;
                const g = Math.floor(argb / 256) % 256;
                const b = argb % 256;
                const hex = root.addColor(Qt.rgba(r / 255, g / 255, b / 255, 1));
                root.lastError = "";
                if (Plasmoid.configuration.autoCopy)
                    root.copy(root.format(hex));
            } else {
                // Cancelling with Esc ends up here too – only remember real errors
                const err = (data["stderr"] || "").trim();
                root.lastError = err.indexOf("Cancel") >= 0 ? "" : err;
                if (err) console.warn("ColorBrush:", err);
            }
            if (root.reopenAfterPick)
                root.expanded = true;
            root.reopenAfterPick = false;
        }
    }

    // invisible helper for clipboard access
    TextEdit {
        id: clipboardHelper
        visible: false
    }

    // ---------- Panel icon ----------
    // Brush = pick a color right away · Splat = open the history popup
    compactRepresentation: Item {
        id: compact

        readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
        // Icon size = panel height (or panel width for a vertical panel)
        readonly property real cell: vertical ? width : height
        readonly property real gap: Math.round(cell * 0.08)

        Layout.minimumWidth: vertical ? Kirigami.Units.iconSizes.small : cell * 2 + gap
        Layout.preferredWidth: Layout.minimumWidth
        Layout.maximumWidth: Layout.minimumWidth
        Layout.minimumHeight: vertical ? cell * 2 + gap : Kirigami.Units.iconSizes.small
        Layout.preferredHeight: Layout.minimumHeight
        Layout.maximumHeight: Layout.minimumHeight

        Grid {
            anchors.fill: parent
            columns: compact.vertical ? 1 : 2
            spacing: compact.gap

            // ----- Brush -----
            MouseArea {
                id: brushArea
                width: compact.cell
                height: compact.cell
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.pick(false)

                BrushIcon {
                    anchors.fill: parent
                    paint: root.currentHex
                    hovered: brushArea.containsMouse
                    showStroke: false
                    scale: brushArea.pressed ? 0.9 : 1
                    Behavior on scale { NumberAnimation { duration: 90 } }
                }
            }

            // ----- Splat -----
            MouseArea {
                id: splatArea
                property bool wasExpanded: false
                width: compact.cell
                height: compact.cell
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: wasExpanded = root.expanded
                onClicked: root.expanded = !wasExpanded

                Splat {
                    anchors.fill: parent
                    anchors.margins: compact.cell * 0.06
                    paint: root.currentHex
                    hovered: splatArea.containsMouse
                    pressed: splatArea.pressed
                }
            }
        }
    }

    // ---------- Popup ----------
    fullRepresentation: FullView {
        app: root
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Pick color")
            icon.name: "color-picker"
            onTriggered: root.pick(false)
        },
        PlasmaCore.Action {
            text: root.mode === "hex" ? i18n("Show as RGB") : i18n("Show as HEX")
            icon.name: "format-text-code"
            onTriggered: root.setMode(root.mode === "hex" ? "rgb" : "hex")
        },
        PlasmaCore.Action {
            text: i18n("Clear history")
            icon.name: "edit-clear-history"
            enabled: root.hasColor
            onTriggered: root.clearHistory()
        }
    ]
}
