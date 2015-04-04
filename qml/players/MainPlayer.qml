import VPlay 2.0
import QtQuick 2.0
import "../common"

PlayerBase {
    id: mainPlayer
    entityId: mainPlayer

    width: 57
    height: 192


    // here you could use a SpriteSquenceVPlay to animate your player
    MultiResolutionImage {
        source: "../../assets/player/player.png"
        z: 2000
    }

}

