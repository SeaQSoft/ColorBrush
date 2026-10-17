import QtQuick

// Segmented switch (HEX | RGB)
Rectangle {
    id: seg

    property var options: ["HEX", "RGB"]
    property int currentIndex: 0
    property color fillColor: "#E9E9EE"
    property color knobColor: "#FFFFFF"
    property color textColor: "#1D1D1F"
    property color dimTextColor: "#6E6E73"

    signal activated(int index)

    implicitWidth: 116
    implicitHeight: 28
    radius: 8
    color: fillColor

    readonly property real _segW: (width - 4) / Math.max(1, options.length)

    // shadow below the knob
    Rectangle {
        x: knob.x
        y: knob.y + 1
        width: knob.width
        height: knob.height
        radius: knob.radius
        color: Qt.rgba(0, 0, 0, 0.12)
    }
    Rectangle {
        id: knob
        y: 2
        x: 2 + seg.currentIndex * seg._segW
        width: seg._segW
        height: seg.height - 4
        radius: 6
        color: seg.knobColor
        border.color: Qt.rgba(0, 0, 0, 0.05)
        Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    }

    Row {
        x: 2
        y: 2
        Repeater {
            model: seg.options
            delegate: Item {
                required property string modelData
                required property int index
                width: seg._segW
                height: seg.height - 4
                Text {
                    anchors.centerIn: parent
                    text: parent.modelData
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    font.letterSpacing: 0.4
                    color: seg.currentIndex === parent.index ? seg.textColor : seg.dimTextColor
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: seg.activated(parent.index)
                }
            }
        }
    }
}
