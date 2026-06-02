// 版权所有 (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: root
    width: outerDiameter
    height: outerDiameter

    required property bool recording

    property int outerRadius: Style.recordButtonOuterRadius
    property int innerRadius: Style.recordButtonInnerRadius
    property real outerDiameter: outerRadius * 2
    property real innerDiameter: innerRadius * 2

    signal clicked

    // ========== 悬停状态 ==========
    property bool hovered: false

    // ========== 脉冲动画（录制时） ==========
    SequentialAnimation on pulseScale {
        running: root.recording
        loops: Animation.Infinite
        NumberAnimation {
            from: 1.0; to: 1.15
            duration: Style.animationPulse
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            from: 1.15; to: 1.0
            duration: Style.animationPulse
            easing.type: Easing.InQuad
        }
    }

    property real pulseScale: 1.0

    // ========== 外圈（背景） ==========
    Rectangle {
        id: outerRing
        anchors.centerIn: parent
        width: outerDiameter
        height: outerDiameter
        radius: outerRadius

        // 渐变背景
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.lighter(Style.backgroundCard, 1.05) }
            GradientStop { position: 1.0; color: Style.backgroundSecondary }
        }

        // 细边框
        border.color: root.hovered ? Style.primaryLight : Style.borderDefault
        border.width: root.recording ? 2 : 1.5

        // 阴影效果
        layer.enabled: true

        Behavior on border.color { ColorAnimation { duration: Style.animationNormal } }
        Behavior on border.width { NumberAnimation { duration: Style.animationFast } }
    }

    // ========== 脉冲圈（录制时可见） ==========
    Rectangle {
        id: pulseRing
        anchors.centerIn: parent
        width: outerDiameter * pulseScale
        height: outerDiameter * pulseScale
        radius: width / 2

        visible: root.recording
        opacity: 0.3 * (1.0 - (pulseScale - 1.0) * 4) // 扩大时淡出
        color: "transparent"
        border.color: Style.accent
        border.width: 3

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    // ========== 内圈（可点击部分） ==========
    Rectangle {
        id: innerButton
        anchors.centerIn: parent
        width: recording ? innerDiameter - 14 : innerDiameter
        height: recording ? innerDiameter - 14 : innerDiameter
        radius: recording ? 6 : (width / 2)

        // 录制状态：红色方块，空闲状态：带渐变的红色圆圈
        gradient: !recording ? Gradient {
            GradientStop { position: 0.0; color: Style.accentLight }
            GradientStop { position: 0.5; color: Style.accent }
            GradientStop { position: 1.0; color: Style.accentDark }
        } : null

        color: recording ? Style.accent : "transparent"

        // 悬停或录制时的发光效果
        layer.enabled: root.hovered || root.recording
        layer.effect: Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                radius: parent.radius + 4
                color: "transparent"
                opacity: root.recording ? 0.5 : 0.3
                // 发光颜色
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Style.accentGlow
                }
            }
        }

        // 形状变化的平滑过渡
        Behavior on width { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutBack } }
        Behavior on height { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutBack } }
        Behavior on radius { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutBack } }

        // 按下时的缩放动画
        scale: mouseArea.pressed ? 0.92 : (root.hovered ? 1.05 : 1.0)
        Behavior on scale { NumberAnimation { duration: Style.animationFast; easing.type: Easing.OutBack } }

        // ========== 按钮内的图标/指示器 ==========
        Text {
            anchors.centerIn: parent
            visible: !root.recording
            text: "\u25CF" // 圆形字符
            font.pixelSize: parent.width * 0.45
            color: "white"
            opacity: 0.9
        }

        Text {
            anchors.centerIn: parent
            visible: root.recording
            text: "\u25A0" // 方块字符（停止符号）
            font.pixelSize: parent.width * 0.35
            color: "white"
            opacity: 0.95
        }

        // ========== 鼠标交互区域 ==========
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovered = true
            onExited: root.hovered = false
            onClicked: root.clicked()
            
            ToolTip.visible: mouseArea.containsMouse
            ToolTip.text: root.recording ? "点击停止录制" : "点击开始录制"
            ToolTip.delay: 300
        }
    }

    // ========== 状态指示点（录制时） ==========
    Rectangle {
        id: statusDot
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.bottom
            topMargin: 8
        }
        width: 8
        height: 8
        radius: 4
        visible: root.recording
        color: Style.accent

        // 录制时的闪烁动画
        SequentialAnimation on opacity {
            running: root.recording
            loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 0.3; duration: 600; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 0.3; to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
        }
    }
}
