// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.FluentWinUI3  // Qt 6.8+ Fluent WinUI3 Style
import QtMultimedia

Window {
    id: root
    visible: true
    title: "媒体录制器"
    width: Style.screenWidth
    height: Style.screenHeigth

    // ========== Apply Fluent WinUI3 Theme ==========
    color: Style.backgroundPrimary

    // Enable Fluent style for all controls
    FluentWinUI3.theme: FluentWinUI3.Light
    FluentWinUI3.primary: Style.primary

    onWidthChanged: {
        Style.calculateRatio(root.width, root.height)
    }

    // ========== Video Output (Background) ==========
    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        visible: !playback.playing
    }

    // ========== Error Popup ==========
    Popup {
        id: recorderError
        anchors.centerIn: Overlay.overlay
        padding: 24
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: Style.radiusLarge
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFF" }
                GradientStop { position: 1.0; color: Style.backgroundSecondary }
            }

            // Shadow for popup
            layer.enabled: true
            layer.effect: Item {
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -8
                    radius: parent.radius + 8
                    color: "transparent"
                    opacity: 0.25
                    color: "#000000"
                }
            }
        }

        contentItem: ColumnLayout {
            spacing: 12

            Text {
                id: recorderErrorText
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: Style.fontSizeLarge
                font.weight: Font.Medium
                color: Style.textPrimary
                wrapMode: Text.Wrap
            }

            Button {
                Layout.alignment: Qt.AlignHCenter
                text: "确定"
                onClicked: recorderError.close()

                background: Rectangle {
                    anchors.fill: parent
                    radius: Style.radiusMedium
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Style.primaryHover }
                        GradientStop { position: 1.0; color: Style.primary }
                    }
                }

                contentItem: Text {
                    text: "确定"
                    font.pointSize: Style.fontSize
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: Style.animationNormal }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: Style.animationNormal; easing.type: Easing.OutBack }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: Style.animationFast }
        }
    }

    // ========== Capture Session ==========
    CaptureSession {
        id: captureSession
        recorder: recorder
        audioInput: controls.audioInput
        camera: controls.camera
        screenCapture: controls.screenCapture
        windowCapture: controls.windowCapture
        videoOutput: videoOutput
    }

    // ========== Media Recorder ==========
    MediaRecorder {
        id: recorder
        onRecorderStateChanged: (state) => {
            if (state === MediaRecorder.StoppedState) {
                root.contentOrientation = Qt.PrimaryOrientation
                mediaList.append()
            } else if (state === MediaRecorder.RecordingState && captureSession.camera) {
                root.contentOrientation = root.screen.orientation;
                videoOutput.grabToImage(function(res) { console.log("Preview captured") })
            }
        }
        onActualLocationChanged: (url) => {
            mediaList.mediaUrl = url
        }
        onErrorOccurred: {
            recorderErrorText.text = recorder.errorString;
            recorderError.open();
        }
    }

    // ========== Playback Overlay ==========
    Playback {
        id: playback
        anchors {
            fill: parent
            margins: 50
        }
        active: controls.capturesVisible
    }

    // ========== Media List Panel (Slide-in from right) ==========
    Frame {
        id: mediaListFrame
        height: 160
        width: parent.width
        anchors.bottom: controlsFrame.top
        x: controls.capturesVisible ? 0 : parent.width

        background: Rectangle {
            anchors.fill: parent
            radius: Style.mediaListRadius

            // Glassmorphism effect
            color: Style.mediaListBg

            // Top border accent line
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 3
                radius: Style.mediaListRadius
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Style.primaryLight }
                    GradientStop { position: 1.0; color: Style.primary }
                }
            }

            // Subtle shadow at top
            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 8
                radius: 4
                color: "transparent"

                // Shadow effect using gradient opacity
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "rgba(0, 0, 0, 0.08)" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        MediaList {
            id: mediaList
            anchors.fill: parent
            playback: playback
        }
    }

    // ========== Controls Panel (Bottom Bar) ==========
    Frame {
        id: controlsFrame

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: controls.height + Style.interSpacing * 2 +
                (settingsEncoder.visible ? settingsEncoder.height + Style.interSpacing : 0) +
                (savePathSettings.visible ? savePathSettings.height + Style.interSpacing : 0) +
                (settingsMetaData.visible ? settingsMetaData.height : 0) + 12

        background: Rectangle {
            anchors.fill: parent
            radius: Style.controlPanelRadius

            // Modern glassmorphism background
            color: Style.controlPanelBg

            // Top border with gradient accent
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0, 120/255, 212/255, 0.6) }
                    GradientStop { position: 0.5; color: Qt.rgba(96/255, 205/255, 255/255, 0.4) }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 120/255, 212/255, 0.2) }
                }
            }

            // Subtle inner shadow / highlight at top
            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 2
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "rgba(255, 255, 255, 0.5)" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            // Bottom shadow for depth
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -6
                anchors.left: parent.left
                anchors.right: parent.right
                height: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "rgba(0, 0, 0, 0.06)" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: Style.interSpacing

            Controls {
                Layout.alignment: Qt.AlignHCenter
                id: controls
                recorder: recorder
            }

            // Separator Line
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                visible: controls.settingsVisible
                width: controls.width - 40
                height: 1
                radius: 0.5
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Style.borderDefault }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                Behavior on visible { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 } }
            }

            SettingsEncoder {
                id: settingsEncoder
                Layout.alignment: Qt.AlignHCenter
                visible: controls.settingsVisible
                padding: Style.intraSpacing
                recorder: recorder
            }

            SavePathSettings {
                id: savePathSettings
                Layout.alignment: Qt.AlignHCenter
                visible: controls.settingsVisible
                padding: Style.intraSpacing
                recorder: recorder
            }

            SettingsMetaData {
                id: settingsMetaData
                Layout.alignment: Qt.AlignHCenter
                visible: !Style.isMobile() && controls.settingsVisible
                recorder: recorder
            }
        }
    }

    // ========== Window Title Bar Decoration (Top Accent Strip) ==========
    Rectangle {
        id: titleBarAccent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 3
        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.primaryDark }
            GradientStop { position: 0.3; color: Style.primary }
            GradientStop { position: 0.7; color: Style.primaryLight }
            GradientStop { position: 1.0; color: Style.primary }
        }

        // Subtle glow under the accent bar
        Rectangle {
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 8
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0, 120/255, 212/255, 0.15) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    // ========== App Title Watermark (Subtle branding) ==========
    Text {
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 16
        text: "Media Recorder"
        font.pointSize: Style.fontSizeSmall
        font.weight: Font.Light
        font.family: "Segoe UI Light, -apple-system, sans-serif"
        color: Qt.rgba(26/255, 26/255, 26/255, 0.3)
        opacity: 0.6
    }
}
