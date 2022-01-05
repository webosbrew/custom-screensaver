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
                source: 'data:image/png;base64,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'
            }

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
