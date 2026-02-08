// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia

Column {
    id: root
    spacing: Style.intraSpacing

    required property var recorder

    Component.onCompleted: {
        if (appSettings.savePath !== "") {
            recorder.outputLocation = appSettings.savePath
        }
    }

    Text {
        text: "保存路径"
        color: palette.text
    }

    Row {
        spacing: Style.intraSpacing

        Item {
            width: Style.widthLong
            height: Style.height
            StyleRectangle { anchors.fill: parent }
            TextInput {
                id: pathInput
                anchors.fill: parent
                anchors.margins: 4
                anchors.bottom: parent.bottom
                font.pointSize: Style.fontSize
                clip: true
                text: appSettings.savePath
                readOnly: true
                color: palette.text
            }
        }

        Button {
            width: Style.widthMedium
            height: Style.height
            text: "浏览..."
            font.pointSize: Style.fontSize
            background: StyleRectangle { anchors.fill: parent }
            onClicked: folderDialog.open()
        }
    }

    FolderDialog {
        id: folderDialog
        title: "选择保存文件夹"
        currentFolder: appSettings.savePath
        onAccepted: {
            appSettings.savePath = selectedFolder
            recorder.outputLocation = selectedFolder
        }
    }
}
