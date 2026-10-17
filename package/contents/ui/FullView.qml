import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Item {
    id: view

    required property var app

    Layout.preferredWidth: Kirigami.Units.gridUnit * 21
    Layout.preferredHeight: Kirigami.Units.gridUnit * 28
    Layout.minimumWidth: Kirigami.Units.gridUnit * 18
    Layout.minimumHeight: Kirigami.Units.gridUnit * 20

    // ---------- Color palette (follows the system's light/dark scheme) ----------
    readonly property bool dark: Kirigami.Theme.backgroundColor.hslLightness < 0.5
    readonly property color bg:        dark ? "#1C1C1E" : "#F2F2F7"
    readonly property color card:      dark ? "#2C2C2E" : "#FFFFFF"
    readonly property color hoverFill: dark ? "#3A3A3C" : "#F2F2F7"
    readonly property color label:     dark ? "#F5F5F7" : "#1D1D1F"
    readonly property color secondary: dark ? "#98989D" : "#6E6E73"
    readonly property color separator: dark ? "#38383A" : "#E5E5EA"
    readonly property color fill:      dark ? "#3A3A3C" : "#E3E3E8"
    readonly property color knob:      dark ? "#636366" : "#FFFFFF"
    readonly property color accent:    dark ? "#0A84FF" : "#007AFF"
    readonly property color danger:    dark ? "#FF453A" : "#FF3B30"
    readonly property string mono: Kirigami.Theme.fixedWidthFont.family

    // ---------- Small icon button ----------
    component IconButton: Rectangle {
        id: btn
        property string iconName
        property color tint: view.secondary
        property string tip
        signal clicked()
        implicitWidth: 28
        implicitHeight: 28
        radius: 7
        color: area.containsMouse ? view.hoverFill : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }
        Kirigami.Icon {
            anchors.centerIn: parent
            width: 16; height: 16
            source: btn.iconName
            color: btn.tint
            isMask: true
        }
        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.clicked()
            onPressed: btn.scale = 0.9
            onReleased: btn.scale = 1
        }
        Behavior on scale { NumberAnimation { duration: 90 } }
    }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: view.bg
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        // ---------- Header ----------
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Splat {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                paint: view.app.currentHex
            }
            Text {
                text: "ColorBrush"
                color: view.label
                font.pixelSize: 15
                font.weight: Font.Bold
            }
            Item { Layout.fillWidth: true }
            SegmentedControl {
                options: ["HEX", "RGB"]
                currentIndex: view.app.mode === "rgb" ? 1 : 0
                fillColor: view.fill
                knobColor: view.knob
                textColor: view.label
                dimTextColor: view.secondary
                onActivated: index => view.app.setMode(index === 1 ? "rgb" : "hex")
            }
        }

        // ---------- Current color ----------
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            radius: 14
            color: view.card
            border.color: view.separator

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 14

                Rectangle {
                    id: swatch
                    Layout.preferredWidth: 68
                    Layout.preferredHeight: 68
                    radius: 14
                    color: view.app.currentHex
                    border.color: Qt.rgba(0, 0, 0, 0.12)
                    Behavior on color { ColorAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    // gloss
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.30) }
                            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.0) }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: view.app.hasColor ? i18n("Current color") : i18n("No color yet")
                        color: view.secondary
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        font.capitalization: Font.AllUppercase
                        font.letterSpacing: 0.8
                    }
                    Text {
                        Layout.fillWidth: true
                        text: view.app.format(view.app.currentHex)
                        color: view.label
                        font.family: view.mono
                        font.pixelSize: view.app.mode === "rgb" ? 16 : 22
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        opacity: view.app.hasColor ? 1 : 0.4
                    }
                    Text {
                        text: view.app.mode === "rgb" ? view.app.currentHex : view.app.hexToRgb(view.app.currentHex)
                        color: view.secondary
                        font.family: view.mono
                        font.pixelSize: 11
                        opacity: view.app.hasColor ? 1 : 0.4
                    }
                }

                IconButton {
                    iconName: "edit-copy"
                    tint: view.accent
                    visible: view.app.hasColor
                    onClicked: view.app.copy(view.app.format(view.app.currentHex))
                }
            }
        }

        // ---------- Actions ----------
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Rectangle {
                id: pickButton
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                radius: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.lighter(view.accent, pickArea.containsMouse ? 1.18 : 1.08) }
                    GradientStop { position: 1.0; color: view.accent }
                }
                scale: pickArea.pressed ? 0.97 : 1
                Behavior on scale { NumberAnimation { duration: 90 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Kirigami.Icon {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 16; height: 16
                        source: "color-picker"
                        color: "white"
                        isMask: true
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: i18n("Pick color")
                        color: "white"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }
                }
                MouseArea {
                    id: pickArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: view.app.pick(true)
                }
            }

            // choose a color manually
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                radius: 10
                color: plusArea.containsMouse ? view.hoverFill : view.card
                border.color: view.separator
                scale: plusArea.pressed ? 0.94 : 1
                Behavior on scale { NumberAnimation { duration: 90 } }
                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: 16; height: 16
                    source: "color-management"
                    color: view.label
                    isMask: true
                }
                MouseArea {
                    id: plusArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        colorDialog.selectedColor = view.app.currentHex;
                        colorDialog.open();
                    }
                }
            }
        }

        // ---------- Error notice ----------
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: errText.implicitHeight + 16
            visible: view.app.lastError !== ""
            radius: 10
            color: Qt.rgba(view.danger.r, view.danger.g, view.danger.b, 0.12)
            Text {
                id: errText
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: Text.WordWrap
                color: view.danger
                font.pixelSize: 11
                text: i18n("Color picker failed: %1", view.app.lastError)
            }
        }

        // ---------- History ----------
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 2
            Text {
                text: i18n("History")
                color: view.label
                font.pixelSize: 13
                font.weight: Font.Bold
            }
            Text {
                text: view.app.history.length
                color: view.secondary
                font.pixelSize: 12
                visible: view.app.hasColor
            }
            Item { Layout.fillWidth: true }
            Text {
                text: i18n("Clear")
                visible: view.app.hasColor
                color: clearArea.containsMouse ? Qt.lighter(view.accent, 1.2) : view.accent
                font.pixelSize: 12
                font.weight: Font.Medium
                MouseArea {
                    id: clearArea
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: view.app.clearHistory()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: view.card
            border.color: view.separator
            clip: true

            ListView {
                id: list
                anchors.fill: parent
                anchors.margins: 4
                model: view.app.history
                boundsBehavior: Flickable.StopAtBounds
                spacing: 0

                add: Transition { NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 200 } }

                delegate: Item {
                    id: row
                    required property string modelData
                    required property int index
                    width: ListView.view.width
                    height: 46

                    HoverHandler { id: hover }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: 9
                        color: hover.hovered ? view.hoverFill : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: view.app.copy(view.app.format(row.modelData))
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 6
                        spacing: 12

                        Rectangle {
                            Layout.preferredWidth: 28
                            Layout.preferredHeight: 28
                            radius: 14
                            color: row.modelData
                            border.color: Qt.rgba(0, 0, 0, 0.14)
                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.28) }
                                    GradientStop { position: 0.55; color: Qt.rgba(1, 1, 1, 0.0) }
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: view.app.format(row.modelData)
                            color: view.label
                            font.family: view.mono
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        IconButton {
                            iconName: "edit-copy"
                            opacity: hover.hovered ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                            onClicked: view.app.copy(view.app.format(row.modelData))
                        }
                        IconButton {
                            iconName: "edit-delete"
                            tint: view.danger
                            opacity: hover.hovered ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                            onClicked: view.app.removeAt(row.index)
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 50
                        height: 1
                        color: view.separator
                        visible: row.index < list.count - 1 && !hover.hovered
                    }
                }
            }

            // empty state
            Column {
                anchors.centerIn: parent
                spacing: 10
                visible: !view.app.hasColor
                BrushIcon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 64; height: 64
                    paint: view.accent
                    opacity: 0.55
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: i18n("No colors yet")
                    color: view.label
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Kirigami.Units.gridUnit * 13
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: i18n("Click the brush or “Pick color”, then choose any spot on your screen.")
                    color: view.secondary
                    font.pixelSize: 11
                }
            }
        }
    }

    // ---------- "Copied" toast ----------
    Rectangle {
        id: toast
        property string message
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 22
        width: toastRow.implicitWidth + 28
        height: 32
        radius: 16
        color: view.dark ? "#E5E5EA" : "#1D1D1F"
        opacity: 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 180 } }

        Row {
            id: toastRow
            anchors.centerIn: parent
            spacing: 6
            Kirigami.Icon {
                anchors.verticalCenter: parent.verticalCenter
                width: 14; height: 14
                source: "checkmark"
                color: "#34C759"
                isMask: true
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: i18n("Copied: %1", toast.message)
                color: view.dark ? "#1D1D1F" : "#F5F5F7"
                font.pixelSize: 12
                font.weight: Font.DemiBold
            }
        }
        Timer {
            id: toastTimer
            interval: 1400
            onTriggered: toast.opacity = 0
        }
    }

    Connections {
        target: view.app
        function onCopied(text) {
            toast.message = text;
            toast.opacity = 1;
            toastTimer.restart();
        }
    }

    ColorDialog {
        id: colorDialog
        title: i18n("Choose color")
        onAccepted: view.app.addColor(selectedColor)
    }
}
