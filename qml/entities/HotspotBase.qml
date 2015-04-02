import VPlay 2.0
import QtQuick 2.4

EntityBase {
    entityType: "hotspot"

    property int hotspotId: 0
    property int inventoryId: 0

    signal swipeUp()
    signal swipeDown()
    signal swipeLeft()
    signal swipeRight()
    signal clicked()
    signal doubleClicked()

    //MultiResolutionImage {
    //    source: "../../assets/hotspot/sprite_glass.png"
    //}

    //SpriteSequenceVPlay {
    //    defaultSource: ""
    //}

    MouseArea {
        anchors.fill: parent
        onReleased: triggerSwipe(parent, mouse)
        onClicked: parent.clicked()
        onDoubleClicked: parent.doubleClicked()
    }

    //only triggers a swipe if the mouse has traveled > 20
    function triggerSwipe (target, mouse) {
        var tw = 20
        var th = 20
        var x = mouse.x - tw;
        var y = - (mouse.y  - th);

        if(Math.abs(y) > Math.abs(x) && Math.abs(y) > (th+1)) {
            if(y > 0) {
                target.swipeUp()
            } else {
                target.swipeDown()
            }
        } else if(Math.abs(x) > Math.abs(y) && Math.abs(x) > (tw+1)) {
            if(x > 0) {
                target.swipeRight()
            } else {
                target.swipeLeft()
            }
        }
    }

}
