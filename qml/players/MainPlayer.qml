import VPlay 2.0
import QtQuick 2.0
import "../common"

EntityBase {
    id: mainPlayer
    entityId: mainPlayer

    width: 25 //57
    height: 25 //192

    Rectangle {
        anchors.fill: parent
        color: 'purple'
    }

    /*
    // here you could use a SpriteSquenceVPlay to animate your player
    MultiResolutionImage {
        source: "../../assets/player/player.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*parent.playerScale
        height: parent.height*parent.playerScale
        z: 2000
    }
    */

}

