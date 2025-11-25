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

                onClicked: {
                    secretWindow.close()
                }
            }
        }
    }

    onClosing: {
        // Освобождаем ресурсы при закрытии
        destroy()
    }
}
