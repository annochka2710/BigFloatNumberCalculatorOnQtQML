import QtQuick 2.15

QtObject {
    readonly property string fontFamily: "Open Sans"

    //Open Sans Semibold 50/60 0.5px
    readonly property font body1: Qt.font({
        family: fontFamily,
        weight: Font.DemiBold,
        pixelSize: 50,
        letterSpacing: 0.5,
        lineHeight: 1.2 // 60/50 = 1.2
    })
    //Open Sans Semibold 20/30 0.5px
    readonly property font body2: Qt.font({
        family: fontFamily,
        weight: Font.DemiBold,
        pixelSize: 20,
        letterSpacing: 0.5,
        lineHeight: 1.5
    })
    //Open Sans Semibold 24/30 1px
    readonly property font button: Qt.font({
        family: fontFamily,
        weight: Font.DemiBold,
        pixelSize: 24,
        letterSpacing: 1.0,
        lineHeight: 1.25
    })
}
