import QtQuick
import Calculator 1.0

TextButton {
    Fonts { id: fonts }
    Theme { id: theme }
    id: root
    normalColor: theme.theme1_4
    pressedColor:  theme.theme1_3
    normalTextColor: theme.theme1_1
    pressedTextColor: theme.theme1_6
    textFont: fonts.button
    onClicked: Calculator.append(value)
}
