import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: secretWindow
    title: "Секретное меню"
    width: 300
    height: 200
    modality: Qt.ApplicationModal // Делает окно модальным

    Rectangle {
        anchors.fill: parent
        color: "lightyellow"

        Column {
            anchors.centerIn: parent
            spacing: 30

            Text {
                text: "Секретное меню"
                font.pixelSize: 24
                font.bold: true
                color: "red"
            }

            TextButton {
                value: "Закрыть"
                normalColor: "#FF6B6B"
                pressedColor: "#FF5252"
                normalTextColor: "white"
                pressedTextColor: "white"

                width: 100
                height: 100
                radius: 50

                onClicked: {
                    secretWindow.close()
                }

                textFont: Qt.font({
                        family: fonts.button.family,
                        pointSize: fonts.button.pointSize * 0.8
                    })
            }
        }
    }

    onClosing: {
        // Освобождаем ресурсы при закрытии
        destroy()
    }
}
