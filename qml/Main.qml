import QtQuick
import QtQuick.Controls 2.15
import Calculator 1.0

//основное окно
Window {
    Theme { id: appTheme }
    Fonts { id: fonts }

    id: window
    width: 360
    height: 640
    visible: true
    title: "Calculator"
    color: appTheme.theme1_1

    // Обработка сигналов с новым синтаксисом
    Connections {
        target: Calculator

        function onDisplayChanged() {
            console.log("Мат выражение: ", Calculator.getMathExpr())
            calcs.text = Calculator.getMathExpr()
        }

        function onErrorHappened() {
            console.log("Ошибка")
            res.text = "Ошибка"
        }

        function onResultChanged() {
            console.log("Результат: ", Calculator.getRes())
            res.text = Calculator.getRes()
        }

        function onSecretMenu() {
            console.log("Секретное меню")
            var component = Qt.createComponent("SecretWindow.qml")
            if (component.status === Component.Ready) {
                var secretWindow = component.createObject(component)
                secretWindow.show()
            } else {
                console.error("Ошибка создания окна:", component.errorString())
            }
        }
    }

    Image {
        width: parent.width
        height: 25
        source: "qrc:/qt/qml/Calculator/images/status.png"
        anchors.top: parent.top
        fillMode: Image.PreserveAspectFit
    }
    property string secretCode: ""
    // Таймер для отслеживания долгого нажатия
    Timer {
        id: longPressTimer
        interval: 4000 // 4 секунды
        onTriggered: {
            secretInputTimer.start()
            console.log("Долгое нажатие зафиксировано, вводите комбинацию...")
            Calculator.setSecretMode(true);
        }
    }

    // Таймер для ввода комбинации (5 секунд)
    Timer {
        id: secretInputTimer
        interval: 5000 // 5 секунд
        onTriggered: {
            console.log("Время для ввода комбинации истекло")
            Calculator.setSecretMode(false);
        }
    }

    //окно с вводом
    Rectangle {
        id: toprect
        width: 360
        height: 156
        visible: true
        color: appTheme.theme1_3
        anchors.top: parent.top
        anchors.topMargin: 24
        bottomLeftRadius: 16
        bottomRightRadius: 16
        topLeftRadius: 0
        topRightRadius: 0

        //МАТ ВЫРАЖЕНИЕ - ВЕРХНИЙ TextArea
        TextArea {
            id: calcs
            width: 281
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 39
            anchors.right: parent.right
            anchors.rightMargin: 39

            visible: true
            color: appTheme.theme1_6
            font: fonts.body2
            horizontalAlignment: TextEdit.AlignRight
            verticalAlignment: TextEdit.AlignBottom
            text: Calculator.getMathExpr()
            wrapMode: TextArea.Wrap
            readOnly: true
            background: Rectangle {
                color: "transparent"
            }
        }

        //РЕЗУЛЬТАТ
        Text {
            id: res
            width: 280
            height: 60
            anchors.top: calcs.bottom
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 39
            anchors.right: parent.right
            anchors.rightMargin: 39

            color: appTheme.theme1_6
            font: fonts.body1
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            text: Calculator.getRes()
            wrapMode: Text.WrapAnywhere
            elide: Text.ElideNone

            // Автоматическое уменьшение шрифта
            onTextChanged: {
                var textLength = text.length;
                if (textLength > 25) {
                    font.pixelSize = 14;
                } else if (textLength > 20) {
                    font.pixelSize = 16;
                } else if (textLength > 15) {
                    font.pixelSize = 18;
                } else {
                    font.pixelSize = fonts.body1.pixelSize;
                }

                // Принудительный перенос для очень длинных чисел
                if (textLength > 30) {
                    wrapMode = Text.WrapAnywhere;
                }
            }

            // Принудительный рефлоу текста
            onWidthChanged: {
                if (text.length > 15) {
                    doLayout();
                }
            }
        }
    }

    //окно кнопок
    Rectangle {
        id: bottomrect
        width: 360
        height: 616
        visible: true
        anchors.top: toprect.bottom
        anchors.bottom: parent.bottom
        color: appTheme.theme1_1
        anchors.bottomMargin: 0

        Grid {
            id: panel
            width: 312
            height: 396
            opacity: 1
            x: 30
            y: 40
            verticalItemAlignment: Grid.AlignTop
            columns: 4
            spacing: 20

            //СКОБКИ
            OperationButton {
                value: "()"
                onClicked: {
                    var text = calcs.text
                    var openCount = (text.match(/\(/g) || []).length
                    var closeCount = (text.match(/\)/g) || []).length
                    if(openCount <= closeCount)
                        Calculator.addBracket("(")
                    else
                        Calculator.addBracket(")")
                }
            }
            OperationButton {
                value: "+/-"
                onClicked: Calculator.changeSign()
            }
            OperationButton {
                value: "%"
                onClicked: Calculator.calcPercent()
            }
            OperationButton {
                value: "/"
                onClicked: Calculator.setOper("/")
            }
            NumberButton{ value: "7" }
            NumberButton{ value: "8" }
            NumberButton{ value: "9" }
            OperationButton {
                value: "*"
                onClicked: Calculator.setOper("*")
            }
            NumberButton{ value: "4" }
            NumberButton{ value: "5" }
            NumberButton{ value: "6" }
            OperationButton {
                value: "-"
                onClicked: Calculator.setOper("-")
            }
            NumberButton{ value: "1" }
            NumberButton{ value: "2" }
            NumberButton{ value: "3" }
            OperationButton {
                value: "+"
                onClicked: Calculator.setOper("+")
            }

            //СБРОС
            TextButton {
                value: "C"
                textFont: fonts.body2
                normalColor: appTheme.theme1_5
                normalTextColor: appTheme.theme1_6
                pressedColor: appTheme.theme1_5_opacity50
                pressedTextColor: appTheme.theme1_6
                onClicked: Calculator.clear()
            }
            NumberButton{ value: "0" }
            OperationButton{
                value: "."
                onClicked: Calculator.addDecimal()
            }
            OperationButton {
                value: "="
                onClicked: Calculator.calcul()
                onPressed: longPressTimer.start()
                onReleased: if (longPressTimer.running) longPressTimer.stop()
                onCanceled: if (longPressTimer.running) longPressTimer.stop()
            }
        }
    }
}
