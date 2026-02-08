// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Window

Window {
    id: root
    visible: true
    title: "媒体录制器"
    width: Style.screenWidth
    height: Style.screenHeigth

    StyleRectangle {
        anchors.fill: parent
        Text {
            anchors.fill: parent
            anchors.margins: 20
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("此示例需要权限才能使用。\n"
                       + "请授予所有请求的权限并重新启动应用程序。")
        }
    }
}
