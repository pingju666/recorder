// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia

pragma ComponentBehavior: Bound

ColumnLayout {
    id: root
    required property MediaRecorder recorder

    Text {
        text: "元数据设置"
        color: palette.text
    }

    ListModel { id: metaDataModel }

    Connections {
        target: root.recorder
        function onMetaDataChanged() {
            metaDataModel.clear()
            for (var key of root.recorder.metaData.keys()) {
                if (recorder.metaData.stringValue(key))
                    metaDataModel.append(
                                { text: recorder.metaData.metaDataKeyToString(key)
                                , value: key })
            }
        }
    }

    Row {
        id: metaDataAdd
        spacing: Style.intraSpacing
        ComboBox {
            id: metaDataType
            width: Style.widthMedium
            height: Style.height
            font.pointSize: Style.fontSize
            model: ListModel {
                ListElement { text: "标题"; value: MediaMetaData.Title }
                ListElement { text: "作者"; value: MediaMetaData.Author }
                ListElement { text: "评论"; value: MediaMetaData.Comment }
                ListElement { text: "描述"; value: MediaMetaData.Description }
                ListElement { text: "流派"; value: MediaMetaData.Genre }
                ListElement { text: "出版商"; value: MediaMetaData.Publisher }
                ListElement { text: "版权"; value: MediaMetaData.Copyright }
                ListElement { text: "日期"; value: MediaMetaData.Date }
                ListElement { text: "网址"; value: MediaMetaData.Url }
                ListElement { text: "媒体类型"; value: MediaMetaData.MediaType }
                ListElement { text: "专辑标题"; value: MediaMetaData.AlbumTitle }
                ListElement { text: "专辑艺术家"; value: MediaMetaData.AlbumArtist }
                ListElement { text: "贡献艺术家"; value: MediaMetaData.ContributingArtist }
                ListElement { text: "作曲家"; value: MediaMetaData.Composer }
                ListElement { text: "主演"; value: MediaMetaData.LeadPerformer }
            }
            textRole: "text"
            valueRole: "value"
            background: StyleRectangle { anchors.fill: parent; width: metaDataType.width }
        }
        Item {
            width: Style.widthMedium
            height: Style.height
            StyleRectangle { anchors.fill: parent }
            TextInput {
                id: textInput
                anchors.fill: parent
                anchors.bottom: parent.bottom
                anchors.margins: 4
                font.pointSize: Style.fontSize
                clip: true
                onAccepted: {
                    root.recorder.metaData.insert(metaDataType.currentValue, text)
                    recorder.metaDataChanged()
                    text = ""
                    textInput.deselect()
                }
            }
        }
        Button {
            width: Style.widthShort
            height: Style.height
            text: "添加"
            font.pointSize: Style.fontSize

            background: StyleRectangle { anchors.fill: parent }
            onClicked: textInput.accepted()
        }
    }

    ListView {
        id: listView
        Layout.fillHeight: true
        Layout.minimumWidth: metaDataAdd.width
        spacing: Style.intraSpacing
        clip: true
        model: metaDataModel

        delegate: Row {
            id: r
            height: Style.height
            spacing: Style.intraSpacing

            required property string text
            required property string value

            Text {
                width: Style.widthShort
                height: Style.height
                text: r.text
                font.pointSize: Style.fontSize

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
            Item {
                width: Style.widthMedium
                height: Style.height

                StyleRectangle { anchors.fill: parent }
                TextInput {
                    anchors.fill: parent
                    anchors.margins: 4
                    anchors.bottom: parent.bottom
                    font.pointSize: Style.fontSize
                    clip: true
                    text: root.recorder.metaData.stringValue(r.value)
                    onAccepted: root.recorder.metaData.insert(r.value, text)

                }
            }
            Button {
                width: Style.widthShort
                height: Style.height
                text: "删除"
                font.pointSize: Style.fontSize
                background: StyleRectangle { anchors.fill: parent }
                onClicked: { root.recorder.metaData.remove(r.value); recorder.metaDataChanged() }
            }
        }
    }
}
