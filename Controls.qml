// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Row {
    id: root
    required property MediaRecorder recorder

    property bool settingsVisible: false
    property bool capturesVisible: false

    property alias audioInput: audioInputSelect.selected
    property alias camera: videoSourceSelect.selectedCamera
    property alias screenCapture: videoSourceSelect.selectedScreenCapture
    property alias windowCapture: videoSourceSelect.selectedWindowCapture

    spacing: Style.interSpacing * Style.ratio

    // ========== Left Section: Input Controls ==========
    Column {
        id: inputControls
        spacing: Style.intraSpacing

        VideoSourceSelect { id: videoSourceSelect }
        AudioInputSelect { id: audioInputSelect }
    }

    // ========== Center Section: Record Button & Timer ==========
    Column {
        width: recordButton.width
        spacing: 6

        RecordButton {
            id: recordButton
            recording: recorder.recorderState === MediaRecorder.RecordingState
            onClicked: recording ? recorder.stop() : recorder.record()
        }

        // Recording Time Display
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: recordingTime.contentWidth + 20
            height: recordingTime.contentHeight + 8
            radius: Style.radiusSmall
            color: root.recorder.recorderState === MediaRecorder.RecordingState ?
                   "rgba(232, 17, 35, 0.1)" : "rgba(0, 0, 0, 0.04)"

            Text {
                id: recordingTime
                anchors.centerIn: parent
                font.pointSize: Style.fontSizeLarge
                font.weight: Font.DemiBold
                font.family: "Segoe UI, -apple-system, sans-serif"
                color: root.recorder.recorderState === MediaRecorder.RecordingState ?
                       Style.accent : Style.textSecondary
            }

            Behavior on color { ColorAnimation { duration: Style.animationNormal } }
        }
    }

    // ========== Right Section: Option Buttons ==========
    Column {
        id: optionButtons
        spacing: Style.intraSpacing

        // Captures List Button
        Button {
            id: capturesBtn
            leftPadding: 16
            rightPadding: 16
            topPadding: 8
            bottomPadding: 8
            height: Style.height + 4
            width: Style.widthMedium

            background: Rectangle {
                anchors.fill: parent
                radius: Style.radiusMedium

                gradient: capturesBtn.hovered || root.capturesVisible ? Gradient {
                    GradientStop { position: 0.0; color: Style.primaryHover }
                    GradientStop { position: 1.0; color: Style.primary }
                } : Gradient {
                    GradientStop { position: 0.0; color: Style.primaryLight }
                    GradientStop { position: 1.0; color: Style.primary }
                }

                border.color: root.capturesVisible ? Style.primaryDark : "transparent"
                border.width: root.capturesVisible ? 2 : 0

                Behavior on border.color { ColorAnimation { duration: Style.animationFast } }

                // Shadow
                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: parent.radius + 2
                        color: "transparent"
                        opacity: 0.12
                        color: "#000000"
                    }
                }

                Behavior on gradient { ColorAnimation { duration: Style.animationFast } }
            }

            contentItem: Text {
                text: "录制列表"
                font.pointSize: Style.fontSize
                font.weight: Font.Medium
                font.family: "Segoe UI, -apple-system, sans-serif"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            hoverEnabled: true
            onClicked: root.capturesVisible = !root.capturesVisible
        }

        // Settings Button
        Button {
            id: settingsBtn
            leftPadding: 16
            rightPadding: 16
            topPadding: 8
            bottomPadding: 8
            height: Style.height + 4
            width: Style.widthMedium

            background: Rectangle {
                anchors.fill: parent
                radius: Style.radiusMedium

                // Use subtle style for settings button
                color: settingsBtn.hovered || root.settingsVisible ?
                       Style.backgroundTertiary : Style.backgroundSecondary

                border.color: root.settingsVisible ? Style.primary : Style.borderDefault
                border.width: root.settingsVisible ? 1.5 : 1

                // Shadow for elevation
                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -1
                        radius: parent.radius + 1
                        color: "transparent"
                        opacity: 0.08
                        color: "#000000"
                    }
                }

                Behavior on color { ColorAnimation { duration: Style.animationFast } }
                Behavior on border.color { ColorAnimation { duration: Style.animationFast } }
            }

            contentItem: Text {
                text: "设置"
                font.pointSize: Style.fontSize
                font.weight: Font.Medium
                font.family: "Segoe UI, -apple-system, sans-serif"
                color: root.settingsVisible ? Style.primary : Style.textPrimary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Behavior on contentItem.color { ColorAnimation { duration: Style.animationFast } }

            hoverEnabled: true
            onClicked: settingsVisible = !settingsVisible
        }
    }

    // ========== Timer for Recording Duration ==========
    Timer {
        running: true
        interval: 100
        repeat: true
        onTriggered: {
            var m = Math.floor(recorder.duration / 60000)
            var ms = (recorder.duration / 1000 - m * 60).toFixed(1)
            recordingTime.text = `${m}:${ms.padStart(4, '0')}`
        }
    }
}
