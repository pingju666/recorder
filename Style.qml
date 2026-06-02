// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma Singleton
import QtQuick

QtObject {
    // ========== Platform Detection ==========
    function isMobile() {
        return Qt.platform.os === "android" || Qt.platform.os === "ios";
    }

    function calculateRatio(windowWidth, windowHeight) {
        var refWidth = 800.;
        Style.ratio = windowWidth / refWidth;
    }

    // ========== Responsive Scaling ==========
    property real ratio: 1

    property real screenWidth: isMobile() ? 400 : 900
    property real screenHeigth: isMobile() ? 900 : 650

    // ========== Dimensions ==========
    property real height: 32
    property real widthTiny: 44 * ratio
    property real widthShort: 88 * ratio
    property real widthMedium: 170 * ratio
    property real widthLong: 240 * ratio
    property real valueWidth: 70 * ratio
    property real intraSpacing: 8
    property real interSpacing: 16
    property real fontSize: 12
    property real fontSizeLarge: 14
    property real fontSizeSmall: 10

    // ========== Border Radius ==========
    property int radiusSmall: 4
    property int radiusMedium: 8
    property int radiusLarge: 12
    property int radiusXLarge: 16
    property int radiusRound: 25

    // ========== Fluent Design Color Palette ==========
    // Primary Colors (Blue)
    property color primary: "#0078D4"
    property color primaryLight: "#60CDFF"
    property color primaryDark: "#005A9E"
    property color primaryHover: "#1B86D9"
    property color primaryPressed: "#006ABF"

    // Accent Color (for recording)
    property color accent: "#E81123"
    property color accentLight: "#FF4D5A"
    property color accentDark: "#C3000E"
    property color accentGlow: "#FF6B75"

    // Success/Stop Color
    property color success: "#107C10"
    property color successLight: "#28A128"

    // Background Colors
    property color backgroundPrimary: "#FAFAFA"
    property color backgroundSecondary: "#F3F3F3"
    property color backgroundTertiary: "#EDEDED"
    property color backgroundCard: "#FFFFFF"
    property color backgroundOverlay: "rgba(0, 0, 0, 0.4)"

    // Surface Colors (for elevated elements)
    property color surfacePrimary: "#FFFFFF"
    property color surfaceSecondary: "#F9F9F9"
    property color surfaceElevated: "#FFFFFF"

    // Text Colors
    property color textPrimary: "#1A1A1A"
    property color textSecondary: "#5C5C5C"
    property color textTertiary: "#8A8A8A"
    property color textDisabled: "#A0A0A0"
    property color textOnPrimary: "#FFFFFF"
    property color textOnAccent: "#FFFFFF"

    // Border Colors
    property color borderDefault: "#E0E0E0"
    property color borderHover: "#C0C0C0"
    property color borderFocus: "#0078D4"
    property color borderSubtle: "#F0F0F0"

    // Shadow & Elevation
    property string shadowSmall: "0 1px 3px rgba(0, 0, 0, 0.08)"
    property string shadowMedium: "0 4px 12px rgba(0, 0, 0, 0.12)"
    property string shadowLarge: "0 8px 24px rgba(0, 0, 0, 0.16)"
    property string shadowGlow: "0 0 20px rgba(232, 17, 35, 0.4)"

    // Gradient Definitions (as color arrays for QML)
    property color gradientStart: "#667eea"
    property color gradientEnd: "#764ba2"

    property color buttonGradientStart: "#0078D4"
    property color buttonGradientEnd: "#005A9E"

    property color recordingGradientStart: "#E81123"
    property color recordingGradientEnd: "#C3000E"

    // Control Panel Specific
    property color controlPanelBg: "rgba(250, 250, 250, 0.92)"
    property color controlPanelBorder: "rgba(255, 255, 255, 0.5)"
    property int controlPanelRadius: 16

    // Media List Panel
    property color mediaListBg: "rgba(248, 248, 248, 0.95)"
    property int mediaListRadius: 12

    // Animation Durations
    property int animationFast: 100
    property int animationNormal: 200
    property int animationSlow: 400
    property int animationPulse: 1000

    // Opacity Levels
    property real opacityDisabled: 0.45
    property real opacitySubtle: 0.7
    property real opacityFull: 1.0

    // Recording Button Specific
    property int recordButtonOuterRadius: height + 8
    property int recordButtonInnerRadius: height - 2
    property int recordButtonPulseSize: height + 30
}
