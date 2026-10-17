import QtQuick
import QtQuick.Shapes

// Stylized paint splat with arms and droplets – takes on the picked color.
Item {
    id: splat

    property color paint: "#FF2D55"
    property bool hovered: false
    property bool pressed: false

    implicitWidth: 64
    implicitHeight: 64

    property color _paint: paint
    Behavior on _paint { ColorAnimation { duration: 380; easing.type: Easing.OutCubic } }

    readonly property color _light: Qt.lighter(_paint, 1.45)
    readonly property color _dark: Qt.darker(_paint, 1.55)
    readonly property string _path: "M 31.00 14.60 C 33.22 14.66 35.34 16.28 37.58 17.11 C 39.82 17.94 42.85 18.03 44.44 19.56 C 46.02 21.10 46.21 24.10 47.08 26.34 C 47.94 28.58 49.66 30.81 49.60 33.00 C 49.54 35.19 47.54 37.24 46.71 39.51 C 45.87 41.77 46.07 44.95 44.58 46.58 C 43.08 48.20 40.00 48.49 37.74 49.26 C 35.47 50.03 33.21 51.28 31.00 51.20 C 28.79 51.12 26.68 49.60 24.46 48.80 C 22.23 47.99 19.24 47.88 17.64 46.36 C 16.03 44.85 15.69 41.92 14.83 39.70 C 13.98 37.47 12.45 35.21 12.50 33.00 C 12.55 30.79 14.28 28.67 15.11 26.42 C 15.94 24.17 15.97 21.11 17.49 19.49 C 19.02 17.88 22.01 17.56 24.26 16.74 C 26.52 15.92 28.78 14.54 31.00 14.60 Z M 31.16 19.49 Q 37.30 16.25 40.00 11.17 L 44.06 13.33 Q 41.36 18.41 42.11 25.32 Z M 39.45 10.34 A 3.6 3.6 0 1 1 46.65 10.34 A 3.6 3.6 0 1 1 39.45 10.34 Z M 44.19 31.84 Q 47.93 36.93 52.86 38.72 L 51.42 42.67 Q 46.49 40.87 40.36 42.37 Z M 50.83 41.31 A 3.0 3.0 0 1 1 56.83 41.31 A 3.0 3.0 0 1 1 50.83 41.31 Z M 28.66 46.40 Q 21.66 48.86 17.81 53.78 L 14.03 50.83 Q 17.87 45.90 18.57 38.52 Z M 10.71 54.10 A 3.8 3.8 0 1 1 18.31 54.10 A 3.8 3.8 0 1 1 10.71 54.10 Z M 18.00 33.14 Q 14.99 28.58 10.82 26.89 L 12.24 23.37 Q 16.41 25.06 21.75 23.87 Z M 7.33 24.53 A 2.7 2.7 0 1 1 12.73 24.53 A 2.7 2.7 0 1 1 7.33 24.53 Z M 52.90 9.50 A 2.1 2.1 0 1 1 57.10 9.50 A 2.1 2.1 0 1 1 52.90 9.50 Z M 58.50 40.00 A 1.5 1.5 0 1 1 61.50 40.00 A 1.5 1.5 0 1 1 58.50 40.00 Z M 4.30 24.00 A 1.7 1.7 0 1 1 7.70 24.00 A 1.7 1.7 0 1 1 4.30 24.00 Z M 41.10 59.00 A 1.9 1.9 0 1 1 44.90 59.00 A 1.9 1.9 0 1 1 41.10 59.00 Z"

    Item {
        width: 64
        height: 64
        anchors.centerIn: parent
        scale: Math.min(splat.width, splat.height) / 64 * (splat.pressed ? 0.88 : splat.hovered ? 1.06 : 1)
        rotation: splat.hovered ? 8 : 0
        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }
        Behavior on rotation { NumberAnimation { duration: 260; easing.type: Easing.OutBack } }

        // soft shadow
        Shape {
            x: 0.6; y: 1.2
            width: 64; height: 64
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                fillRule: ShapePath.WindingFill
                strokeColor: "transparent"
                fillColor: Qt.rgba(0, 0, 0, 0.18)
                PathSvg { path: splat._path }
            }
        }

        // splat
        Shape {
            width: 64; height: 64
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                fillRule: ShapePath.WindingFill
                strokeColor: "transparent"
                fillGradient: RadialGradient {
                    centerX: 26; centerY: 24; centerRadius: 34
                    focalX: 24; focalY: 22
                    GradientStop { position: 0.0; color: splat._light }
                    GradientStop { position: 0.5; color: splat._paint }
                    GradientStop { position: 1.0; color: splat._dark }
                }
                PathSvg { path: splat._path }
            }
            // highlights
            ShapePath {
                strokeColor: Qt.rgba(1, 1, 1, 0.65)
                strokeWidth: 2.6
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                PathSvg { path: "M 21 25 C 24 20 30 18 35 19.5" }
            }
            ShapePath {
                strokeColor: "transparent"
                fillColor: Qt.rgba(1, 1, 1, 0.55)
                PathSvg { path: "M 18.1 30 A 1.5 1.5 0 1 1 21.1 30 A 1.5 1.5 0 1 1 18.1 30 Z" }
            }
        }
    }
}
