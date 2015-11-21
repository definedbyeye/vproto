import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: playerSkin

    x: roomPanel.playerThing.x-(width/2)
    y: roomPanel.playerThing.y-(height)

    height: 192
    width: 57

    property double playerScale: 1

    MultiResolutionImage {
        id: playerImage
        source: "../../assets/player/player.png"
        anchors.bottom: parent.bottom
        //anchors.verticalCenter: parent.anchors.verticalCenter

        //x: -1 * width/2
        //y: -1 * height

        height: parent.height
        width: parent.width
    }

    onYChanged: updatePlayerScale();

    function updatePlayerScale(){
        if(screen.activeRoom){
            var minP = screen.activeRoom.minPerspective;
            var maxP = screen.activeRoom.maxPerspective;
            var position = (y+height) / screen.activeRoom.height;
            playerScale = ((maxP - minP) * position) + minP;
        }
    }

}

