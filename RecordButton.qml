// Copyright (C) 2021 The Qt Company Ltd.
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

    // ========== Hover State ==========
    property bool hovered: false

    // ========== Pulse Animation (when recording) ==========
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

    // ========== Outer Ring (Background) ==========
    Rectangle {
        id: outerRing
        anchors.centerIn: parent
        width: outerDiameter
        height: outerDiameter
        radius: outerRadius

        // Gradient background
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.lighter(Style.backgroundCard, 1.05) }
            GradientStop { position: 1.0; color: Style.backgroundSecondary }
        }

        // Subtle border
        border.color: root.hovered ? Style.primaryLight : Style.borderDefault
        border.width: root.recording ? 2 : 1.5

        // Shadow effect
        layer.enabled: true

        Behavior on border.color { ColorAnimation { duration: Style.animationNormal } }
        Behavior on border.width { NumberAnimation { duration: Style.animationFast } }
    }

    // ========== Pulse Ring (visible when recording) ==========
    Rectangle {
        id: pulseRing
        anchors.centerIn: parent
        width: outerDiameter * pulseScale
        height: outerDiameter * pulseScale
        radius: width / 2

        visible: root.recording
        opacity: 0.3 * (1.0 - (pulseScale - 1.0) * 4) // Fade out as it expands
        color: "transparent"
        border.color: Style.accent
        border.width: 3

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    // ========== Inner Button (the clickable part) ==========
    Rectangle {
        id: innerButton
        anchors.centerIn: parent
        width: recording ? innerDiameter - 14 : innerDiameter
        height: recording ? innerDiameter - 14 : innerDiameter
        radius: recording ? 6 : (width / 2)

        // Recording state: red square, Idle state: red circle with gradient
        gradient: !recording ? Gradient {
            GradientStop { position: 0.0; color: Style.accentLight }
            GradientStop { position: 0.5; color: Style.accent }
            GradientStop { position: 1.0; color: Style.accentDark }
        } : null

        color: recording ? Style.accent : "transparent"

        // Glow effect when hovering or recording
        layer.enabled: root.hovered || root.recording
        layer.effect: Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                radius: parent.radius + 4
                color: "transparent"
                opacity: root.recording ? 0.5 : 0.3
                // Glow color
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Style.accentGlow
                }
            }
        }

        // Smooth transitions for shape change
        Behavior on width { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutBack } }
        Behavior on height { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutBack } }
        Behavior on radius { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutBack } }

        // Scale animation on press
        scale: mouseArea.pressed ? 0.92 : (root.hovered ? 1.05 : 1.0)
        Behavior on scale { NumberAnimation { duration: Style.animationFast; easing.type: Easing.OutBack } }

        // ========== Icon/Indicator inside button ==========
        Text {
            anchors.centerIn: parent
            visible: !root.recording
            text: "\u25CF" // Circle character
            font.pixelSize: parent.width * 0.45
            color: "white"
            opacity: 0.9
        }

        Text {
            anchors.centerIn: parent
            visible: root.recording
            text: "\u25A0" // Square character (stop)
            font.pixelSize: parent.width * 0.35
            color: "white"
            opacity: 0.95
        }

        // ========== Mouse Interaction Area ==========
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovered = true
            onExited: root.hovered = false
            onClicked: root.clicked()
        }
    }

    // ========== Status Indicator Dot (when recording) ==========
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

        // Blinking animation when recording
        SequentialAnimation on opacity {
            running: root.recording
            loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 0.3; duration: 600; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 0.3; to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
        }
    }
}
