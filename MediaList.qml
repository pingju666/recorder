// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Layouts

Item {
    id: root

    required property Playback playback

    property string mediaUrl

    function getFileName(url) {
        var path = url.toString()
        var lastSlash = path.lastIndexOf('/')
        if (lastSlash >= 0) {
            return path.substring(lastSlash + 1)
        }
        var lastBackslash = path.lastIndexOf('\\')
        if (lastBackslash >= 0) {
            return path.substring(lastBackslash + 1)
        }
        return path
    }

    function append() {
        if (mediaUrl !== "")
            mediaList.append({"url": root.mediaUrl, "fileName": getFileName(root.mediaUrl)})
        mediaUrl = ""
    }

    ListModel { id: mediaList }

    ListView {
        id: listView
        anchors.fill: parent
        model:  mediaList
        orientation: ListView.Horizontal
        spacing: Style.intraSpacing

        delegate: Frame {
            padding: Style.intraSpacing
            width: root.height
            height: root.height
            background: StyleRectangle { anchors.fill: parent }

            required property string url
            required property string fileName

            ColumnLayout {
                anchors.fill: parent
                Image {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    source: "qrc:/qt-project.org/imports/QtQuick/Controls/images/video-preview.png"
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }

                Text {
                    Layout.fillWidth: true
                    elide: Text.ElideLeft
                    text: fileName
                }
            }
            RoundButton {
                anchors.centerIn: parent
                width: 30
                height: 30
                text: "\u25B6";
                onClicked: { playback.playUrl(url) }
            }
        }
    }
}
