import VPlay 2.0
import QtQuick 2.0
import "../common"

PlayerBase {
    id: mainPlayer
    entityId: mainPlayer

    width: 5 //57
    height: 5 //192


    // here you could use a SpriteSquenceVPlay to animate your player
    MultiResolutionImage {
        source: "../../assets/player/player.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*parent.mediaScale
        height: parent.height*parent.mediaScale
        z: 2000
    }

}

