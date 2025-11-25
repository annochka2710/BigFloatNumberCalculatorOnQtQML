import QtQuick
import Calculator 1.0

Rectangle {
    Fonts { id: fonts }
    id: root
    width: 60
    height: width
    radius: width / 2
    color: normalColor

    property string value: ""
    property color normalTextColor: "#000000"
    property color pressedTextColor: "#000000"
    property font textFont: fonts.button
    property color normalColor: "#B0D1D8"
    property color pressedColor: "#B0D1D8"
    signal clicked(string value)
    signal pressed()
    signal released()
    signal canceled()

    //Open Sans Semibold 24/30 1px
    Text{
        id: rootText
        anchors.centerIn: parent
        text: root.value
        color: root.normalTextColor
        font: root.textFont
        lineHeightMode: Text.FixedHeight //между строками       
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked(root.value)
        onPressed: {
            root.color = root.pressedColor
            rootText.color = root.pressedTextColor
            root.pressed()
        }
        onReleased: {
            root.color = root.normalColor
            rootText.color = root.normalTextColor
            root.released()
        }
        onCanceled: {
            root.color = root.normalColor
            rootText.color = root.normalTextColor
            root.canceled()
        }
    }
}
