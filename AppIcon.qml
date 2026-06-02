// AppIcon.qml - 应用程序图标组件
import QtQuick

Item {
    id: root
    property real iconSize: 48
    width: iconSize
    height: iconSize

    // 图标背景（带渐变效果）
    Rectangle {
        id: iconBg
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: width * 0.22

        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.primaryLight }
            GradientStop { position: 0.5; color: Style.primary }
            GradientStop { position: 1.0; color: Style.primaryDark }
        }

        // 细边框
        border.color: "rgba(255, 255, 255, 0.2)"
        border.width: 1

        // 阴影效果
        layer.enabled: true
    }

    // 相机图标（简化的矢量表示）
    Canvas {
        id: canvas
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.55

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // 绘制相机机身（白色）
            ctx.fillStyle = "#FFFFFF"
            ctx.globalAlpha = 0.95

            // 主机身矩形（带圆角）
            var bodyW = width * 0.7
            var bodyH = height * 0.55
            var bodyX = (width - bodyW) / 2
            var bodyY = height * 0.15

            ctx.beginPath()
            ctx.roundRect(bodyX, bodyY, bodyW, bodyH, 4)
            ctx.fill()

            // 镜头外圈
            ctx.strokeStyle = "#FFFFFF"
            ctx.lineWidth = 3
            ctx.beginPath()
            ctx.arc(width / 2, bodyY + bodyH * 0.55, bodyH * 0.4, 0, Math.PI * 2)
            ctx.stroke()

            // 镜头内圈
            ctx.fillStyle = Style.primaryDark
            ctx.beginPath()
            ctx.arc(width / 2, bodyY + bodyH * 0.55, bodyH * 0.25, 0, Math.PI * 2)
            ctx.fill()

            // 镜头中心高光
            ctx.fillStyle = "rgba(255, 255, 255, 0.6)"
            ctx.beginPath()
            ctx.arc(width / 2 - 2, bodyY + bodyH * 0.5, bodyH * 0.08, 0, Math.PI * 2)
            ctx.fill()

            // 取景器（顶部）
            ctx.fillStyle = Style.primaryDark
            var vfW = bodyW * 0.35
            var vfH = bodyH * 0.12
            ctx.beginPath()
            ctx.roundRect((width - vfW) / 2, bodyY - vfH * 0.3, vfW, vfH, 2)
            ctx.fill()

            // 镜头筒（右侧）
            ctx.fillStyle = "#FFFFFF"
            ctx.beginPath()
            ctx.moveTo(bodyX + bodyW, bodyY + bodyH * 0.15)
            ctx.lineTo(bodyX + bodyW + bodyW * 0.25, bodyY)
            ctx.lineTo(bodyX + bodyW + bodyW * 0.25, bodyY + bodyH)
            ctx.lineTo(bodyX + bodyW, bodyY + bodyH * 0.85)
            ctx.closePath()
            ctx.fill()
        }
    }

    // 录制指示点（图标底部）
    Rectangle {
        id: recordDot
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * 0.12
        }
        width: parent.width * 0.22
        height: width
        radius: width / 2

        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.accentLight }
            GradientStop { position: 1.0; color: Style.accent }
        }

        // 内部白色圆圈
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
            radius: width / 2
            color: "#FFFFFF"
        }

        // 脉冲动画以引起注意
        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 1.1; duration: 1000; easing.type: Easing.OutQuad }
            NumberAnimation { from: 1.1; to: 1.0; duration: 1000; easing.type: Easing.InQuad }
        }

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 0.7; duration: 1000 }
            NumberAnimation { from: 0.7; to: 1.0; duration: 1000 }
        }
    }
}
