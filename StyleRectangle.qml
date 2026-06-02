// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick

Rectangle {
    id: root

    // ========== Properties ==========
    property bool hovered: false
    property bool pressed: false
    property color baseColor: Style.surfaceElevated
    property color borderColor: Style.borderDefault
    property real borderWidth: 1
    property int cornerRadius: Style.radiusMedium
    property bool useGradient: false
    property color gradientTop: Style.buttonGradientStart
    property color gradientBottom: Style.buttonGradientEnd
    property real targetOpacity: 0.95

    // ========== Appearance ==========
    opacity: pressed ? 0.9 : (hovered ? 1.0 : targetOpacity)
    radius: cornerRadius
    border.color: pressed ? Style.primaryHover : (hovered ? Style.borderHover : borderColor)
    border.width: borderWidth

    // ========== Gradient ==========
    gradient: useGradient ? Gradient {
        GradientStop { position: 0.0; color: pressed ? Qt.darker(gradientBottom, 1.1) : gradientTop }
        GradientStop { position: 1.0; color: pressed ? Qt.darker(gradientBottom, 1.2) : gradientBottom }
    } : null

    // Default solid color when not using gradient
    color: !useGradient ? (pressed ? Qt.darker(baseColor, 1.05) :
                            hovered ? Qt.lighter(baseColor, 1.02) :
                            baseColor) : "transparent"

    // ========== Shadow Layer ==========
    layer.enabled: true
    layer.effect: Item {
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: "transparent"

            // Drop shadow effect using multiple rectangles
            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: parent.radius + 2
                color: "transparent"
                z: -1

                // Soft shadow
                opacity: 0.15
                color: "#000000"
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -1
                radius: parent.radius + 1
                color: "transparent"
                z: -1

                // Tighter shadow for depth
                opacity: 0.08
                color: "#000000"
            }
        }
    }

    // ========== Smooth Transitions ==========
    Behavior on opacity { NumberAnimation { duration: Style.animationFast; easing.type: Easing.OutCubic } }
    Behavior on border.color { ColorAnimation { duration: Style.animationFast } }
    Behavior on color { ColorAnimation { duration: Style.animationFast } }
}
