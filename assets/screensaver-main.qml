/*
 * Nostalgia screensaver.
 *
 * Usage:
 *   mount --bind ./screensaver-main.qml /usr/palm/applications/com.webos.app.screensaver/qml/main.qml
 *
 * Test launch (no way to trigger on "No signal" screen)
 *   luna-send -n 1 'luna://com.webos.service.tvpower/power/turnOnScreenSaver' '{}'
 */
import QtQuick 2.4
import Eos.Window 0.1
import QtQuick.Window 2.2

WebOSWindow {
    id: window

    width: 1920
    height: 1080

    windowType: "_WEBOS_WINDOW_TYPE_SCREENSAVER"
    color: "black"

    title: "Screensaver"
    appId: "com.webos.app.screensaver"
    visible: true

    Item {
        id: root

        Rectangle {
            anchors.fill: parent
            color: 'black'
        }

        Rectangle {
            id: boing

            color: 'black'
            width: 320
            height: 163

            function setRandomColor() {
                var colors = ['#f00', '#0f0', '#00f', '#ff0', '#f0f', '#0ff', '#fff'];
                var index = (Math.random() * colors.length) | 0;
                boing.color = colors[index];
            }

            Image {
                anchors.fill: parent
                source: 'data:image/png;base64,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'            }

            Component.onCompleted: {
                boing.setRandomColor();
            }

            SequentialAnimation on x {
                loops: Animation.Infinite
                PropertyAnimation {
                    easing.type: Easing.Linear
                    duration: 1920 * 11
                    to: 1920 - boing.width
                }

                ScriptAction { script: boing.setRandomColor(); }
                PropertyAnimation {
                    easing.type: Easing.Linear
                    duration: 1920 * 11
                    to: 0
                }
                ScriptAction { script: boing.setRandomColor(); }
            }

            SequentialAnimation on y {
                loops: Animation.Infinite
                PropertyAnimation {
                    easing.type: Easing.Linear
                    duration: 1080 * 7
                    to: 1080 - boing.height
                }
                ScriptAction { script: boing.setRandomColor(); }
                PropertyAnimation {
                    easing.type: Easing.Linear
                    duration: 1080 * 7
                    to: 0
                }
                ScriptAction { script: boing.setRandomColor(); }
            }
        }
    }
}
