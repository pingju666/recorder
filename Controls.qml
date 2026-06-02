// 版权所有 (C) 2021 The Qt Company Ltd.
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

    // ========== 左侧区域：输入控制 ==========
    Column {
        id: inputControls
        spacing: Style.intraSpacing

        VideoSourceSelect { id: videoSourceSelect }
        AudioInputSelect { id: audioInputSelect }
    }

    // ========== 中间区域：录制按钮和计时器 ==========
    Column {
        width: recordButton.width
        spacing: 6

        RecordButton {
            id: recordButton
            recording: recorder.recorderState === MediaRecorder.RecordingState
            onClicked: recording ? recorder.stop() : recorder.record()
        }

        // 录制时间显示
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
                font.family: "Microsoft YaHei UI, Segoe UI, sans-serif"
                color: root.recorder.recorderState === MediaRecorder.RecordingState ?
                       Style.accent : Style.textSecondary
            }

            Behavior on color { ColorAnimation { duration: Style.animationNormal } }
        }
    }

    // ========== 右侧区域：选项按钮 ==========
    Column {
        id: optionButtons
        spacing: Style.intraSpacing

        // 录制列表按钮
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

                gradient: Gradient {
                    GradientStop { position: 0.0; color: capturesBtn.hovered || root.capturesVisible ? Style.primaryHover : Style.primaryLight }
                    GradientStop { position: 1.0; color: Style.primary }
                }

                border.color: root.capturesVisible ? Style.primaryDark : "transparent"
                border.width: root.capturesVisible ? 2 : 0

                Behavior on border.color { ColorAnimation { duration: Style.animationFast } }

                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: parent.radius + 2
                        color: "#000000"
                        opacity: 0.12
                    }
                }

                Behavior on opacity { NumberAnimation { duration: Style.animationFast } }
            }

            contentItem: Text {
                text: "录制列表"
                font.pointSize: Style.fontSize
                font.weight: Font.Medium
                font.family: "Microsoft YaHei UI, Segoe UI, sans-serif"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            hoverEnabled: true
            ToolTip.visible: capturesBtn.hovered
            ToolTip.text: "查看已录制的视频列表"
            ToolTip.delay: 500

            onClicked: root.capturesVisible = !root.capturesVisible
        }

        // 设置按钮
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

                color: settingsBtn.hovered || root.settingsVisible ?
                       Style.backgroundTertiary : Style.backgroundSecondary

                border.color: root.settingsVisible ? Style.primary : Style.borderDefault
                border.width: root.settingsVisible ? 1.5 : 1

                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -1
                        radius: parent.radius + 1
                        color: "#000000"
                        opacity: 0.08
                    }
                }

                Behavior on color { ColorAnimation { duration: Style.animationFast } }
                Behavior on border.color { ColorAnimation { duration: Style.animationFast } }
            }

            contentItem: Text {
                text: "设置"
                font.pointSize: Style.fontSize
                font.weight: Font.Medium
                font.family: "Microsoft YaHei UI, Segoe UI, sans-serif"
                color: root.settingsVisible ? Style.primary : Style.textPrimary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Behavior on contentItem.color { ColorAnimation { duration: Style.animationFast } }

            hoverEnabled: true
            ToolTip.visible: settingsBtn.hovered
            ToolTip.text: "打开编码器和元数据设置"
            ToolTip.delay: 500

            onClicked: settingsVisible = !settingsVisible
        }
    }

    // ========== 录制时长计时器 ==========
    Timer {
        running: true
        interval: 100
        repeat: true
        onTriggered: {
            var totalSeconds = Math.floor(recorder.duration / 1000)
            var minutes = Math.floor(totalSeconds / 60)
            var seconds = totalSeconds % 60
            var centiseconds = Math.floor((recorder.duration % 1000) / 10)
            
            var timeText = String(minutes).padStart(2, '0') + ":" +
                          String(seconds).padStart(2, '0') + "." +
                          String(centiseconds).padStart(2, '0')
            recordingTime.text = timeText
        }
    }
}
