import QtQuick
import QtQuick.Shapes

// Vector paint brush: the bristles and the paint stroke take on the picked color.
Item {
    id: icon

    property color paint: "#FF2D55"
    property bool hovered: false
    property bool showStroke: true

    implicitWidth: 64
    implicitHeight: 64

    // smooth color fade when a new color is picked
    property color _paint: paint
    Behavior on _paint { ColorAnimation { duration: 380; easing.type: Easing.OutCubic } }

    readonly property color _light: Qt.lighter(_paint, 1.35)
    readonly property color _dark: Qt.darker(_paint, 1.5)

    Item {
        id: canvas
        width: 64
        height: 64
        anchors.centerIn: parent
        scale: Math.min(icon.width, icon.height) / 64

        // paint stroke below the brush tip
        Shape {
            anchors.fill: parent
            visible: icon.showStroke
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeColor: icon._paint
                strokeWidth: 5.5
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                PathSvg { path: "M 12 57 C 20 61 27 53 35 57 C 41 60 46 59 51 56" }
            }
            ShapePath {
                strokeColor: Qt.rgba(1, 1, 1, 0.35)
                strokeWidth: 1.4
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                PathSvg { path: "M 16 57.2 C 22 58.8 27 55 33 55.6" }
            }
        }

        // the brush itself (20 × 64, rotated)
        Item {
            id: brush
            x: 22
            y: -1
            width: 20
            height: 64
            transformOrigin: Item.Center
            rotation: icon.hovered ? 32 : 40
            Behavior on rotation { NumberAnimation { duration: 260; easing.type: Easing.OutBack } }

            Shape {
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer

                // handle (glossy graphite)
                ShapePath {
                    strokeColor: "transparent"
                    fillGradient: LinearGradient {
                        x1: 5; y1: 0; x2: 15; y2: 0
                        GradientStop { position: 0.0; color: "#48484A" }
                        GradientStop { position: 0.35; color: "#A1A1A6" }
                        GradientStop { position: 0.6; color: "#636366" }
                        GradientStop { position: 1.0; color: "#2C2C2E" }
                    }
                    PathSvg { path: "M 7.2 2.5 Q 10 -0.5 12.8 2.5 L 15.2 33.5 L 4.8 33.5 Z" }
                }

                // ferrule (metal)
                ShapePath {
                    strokeColor: "transparent"
                    fillGradient: LinearGradient {
                        x1: 3; y1: 0; x2: 17; y2: 0
                        GradientStop { position: 0.0; color: "#AEAEB2" }
                        GradientStop { position: 0.3; color: "#FFFFFF" }
                        GradientStop { position: 0.65; color: "#C7C7CC" }
                        GradientStop { position: 1.0; color: "#7C7C80" }
                    }
                    PathSvg { path: "M 3 34 Q 3 33 4 33 L 16 33 Q 17 33 17 34 L 17 42.5 Q 17 43.5 16 43.5 L 4 43.5 Q 3 43.5 3 42.5 Z" }
                }
                ShapePath {
                    strokeColor: "#8E8E93"
                    strokeWidth: 0.7
                    fillColor: "transparent"
                    PathSvg { path: "M 3.4 36.4 L 16.6 36.4 M 3.4 39.8 L 16.6 39.8" }
                }

                // bristles in the picked color
                ShapePath {
                    strokeColor: icon._dark
                    strokeWidth: 0.6
                    fillGradient: LinearGradient {
                        x1: 3; y1: 0; x2: 17; y2: 0
                        GradientStop { position: 0.0; color: icon._light }
                        GradientStop { position: 0.45; color: icon._paint }
                        GradientStop { position: 1.0; color: icon._dark }
                    }
                    PathSvg { path: "M 3.6 43.5 C 2 50 2.8 55.5 6 59.5 C 7.8 61.8 9.2 63.4 10 64 C 10.8 63.4 12.2 61.8 14 59.5 C 17.2 55.5 18 50 16.4 43.5 Z" }
                }
                // bristle strands
                ShapePath {
                    strokeColor: Qt.rgba(icon._dark.r, icon._dark.g, icon._dark.b, 0.55)
                    strokeWidth: 0.6
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathSvg { path: "M 8 45 C 7.4 51 8 56 9.4 61 M 12 45 C 12.6 51 12.2 56 10.8 61" }
                }
                // highlight
                ShapePath {
                    strokeColor: Qt.rgba(1, 1, 1, 0.55)
                    strokeWidth: 1.1
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathSvg { path: "M 5.6 46 C 4.8 50 5.4 54 7 57" }
                }
            }
        }
    }
}
