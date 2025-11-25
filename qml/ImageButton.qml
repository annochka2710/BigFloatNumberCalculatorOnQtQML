import QtQuick
//не использую, думала иконки так добавлять как кнопки
Rectangle {
    id: root
    width: 60
    height: width
    radius: width / 2
    color: mouseArea.pressed ? "#F7E425" : "#0889A6"

    property string imageSource: ""
    property string value: ""

    property real iconWidth: width * 0.8
    property real iconHeight: height * 0.8
    property bool iconFillParent: false

    signal clicked(string value)
    //normal #B0D1D8
    //clicked #04BFAD

    Image {
        anchors.centerIn: parent
        source: root.imageSource
        width: iconFillParent ? parent.width : iconWidth
        height: iconFillParent ? parent.height : iconHeight
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked(root.value)
    }
}
