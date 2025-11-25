import QtQuick
import Calculator 1.0

TextButton {
    Fonts { id: fonts }
    Theme { id: theme }
    id: root
    normalColor: theme.theme1_2
    pressedColor:  theme.theme1_add_2
    normalTextColor: theme.theme1_6
    pressedTextColor: theme.theme1_6
    textFont: fonts.button
}
