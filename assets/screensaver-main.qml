/*
 * Apple Aerial screensaver.
 *
 * Usage:
 *   mount --bind ./screensaver-main.qml /usr/palm/applications/com.webos.app.screensaver/qml/main.qml
 *
 * Test launch (no way to trigger on "No signal" screen)
 *   luna-send -n 1 'luna://com.webos.service.tvpower/power/turnOnScreenSaver' '{}'
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.XmlListModel 2.15
import QtMultimedia 5.15

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

        Video {
            id: videoPlayer
            width: 1920
            height: 1080
            autoPlay: true
            loops: Video.Infinite

            onStatusChanged: {
                if (videoPlayer.status === Video.EndOfMedia) {
                    playRandomVideo();
                }
            }

            MediaPlayer {
                id: mediaPlayer
                source: videoPlayer.source
                onPositionChanged: {
                    updatePointsOfInterest(mediaPlayer.position);
                }
            }
        }

        Text {
            id: pointsOfInterestText
            anchors.centerIn: parent
            font.pixelSize: 24
            color: "white"
            text: ""
        }

        XmlListModel {
            id: jsonModel

            // Set the path to your JSON file
            source: "https://raw.githubusercontent.com/OrangeJedi/Aerial/master/videos.json"

            XmlRole { name: "id"; query: "id/string()" }
            XmlRole { name: "accessibilityLabel"; query: "accessibilityLabel/string()" }
            XmlRole { name: "name"; query: "name/string()" }
            XmlRole { name: "pointsOfInterest"; query: "pointsOfInterest/string()" }
            XmlRole { name: "type"; query: "type/string()" }
            XmlRole { name: "srcH2641080p"; query: "src/H2641080p/string()" }

            onStatusChanged: {
                if (jsonModel.status === XmlListModel.Ready) {
                    playRandomVideo();
                }
            }
        }

        function playRandomVideo() {
            var h264Videos = jsonModel.map(function(item) {
                return item.srcH2641080p;
            }).filter(function(url) {
                return url !== undefined;
            });

            if (h264Videos.length > 0) {
                var randomIndex = Math.floor(Math.random() * h264Videos.length);
                var videoUrl = h264Videos[randomIndex];
                var pointsOfInterest = jsonModel.get(randomIndex).pointsOfInterest;

                // Set the video source
                videoPlayer.source = videoUrl;

                // Set pointsOfInterest text
                updatePointsOfInterest(0); // Initial update
                pointsOfInterestText.text = "";

                // Play the video
                videoPlayer.play();
            }
        }

        function updatePointsOfInterest(position) {
            // Find the closest key in pointsOfInterest
            var closestKey = Object.keys(pointsOfInterest).reduce(function(prev, curr) {
                return Math.abs(curr - position) < Math.abs(prev - position) ? curr : prev;
            });

            // Set the pointsOfInterest text
            pointsOfInterestText.text = pointsOfInterest[closestKey];
        }
    }
}
