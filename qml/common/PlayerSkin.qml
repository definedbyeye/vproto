import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: playerSkin

    x: gameScene.playerThing.x-(width/2)
    y: gameScene.playerThing.y-(height)

    height: 192
    width: 57

    property double mediaScale: 1

    onMediaScaleChanged: {//console.log('media scale: '+mediaScale);
    }

    MultiResolutionImage {
        id: playerImage
        source: "../../assets/player/player.png"
        anchors.bottom: parent.bottom
        //anchors.verticalCenter: parent.anchors.verticalCenter

        //x: -1 * width/2
        //y: -1 * height

        height: parent.height*(mediaScale)
        width: parent.width*(mediaScale)
    }

    onYChanged: updatePlayerScale();

    function updatePlayerScale(){
        if(gameScene.activeRoom){
            var minP = gameScene.activeRoom.minPerspective;
            var maxP = gameScene.activeRoom.maxPerspective;
            var position = (y+height) / gameScene.activeRoom.height;
            mediaScale = ((maxP - minP) * position) + minP;
        }
    }

}

