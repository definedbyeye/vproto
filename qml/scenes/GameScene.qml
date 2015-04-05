import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../entities"
import "../rooms"
import "../interface"

SceneBase {
    id: gameScene

    // the "logical size" - the scene content is auto-scaled to match the GameWindow size


    property string activeRoomId
    property variant activeRoom

    property string activePlayerId
    property variant activePlayer

    onActivePlayerIdChanged: storage.savePlayerId(activePlayerId);
    onActiveRoomIdChanged: storage.saveRoomId(activeRoomId);

    function init() {
        setPlayer(storage.playerId);
        setRoom(storage.roomId);

        activePlayer.x = storage.playerPoint.x;
        activePlayer.y = storage.playerPoint.y;
    }

    function setRoom(toRoomId, fromAreaId) {

        //allow new room to set the player's position based on the old room
        //TODO: fromHotspotId
        //roomLoader.fromHotspotId = activeRoomId;
        activeRoomId = toRoomId;
        roomLoader.fromAreaId = fromAreaId || '';
        roomLoader.source = "../rooms/" + activeRoomId.charAt(0).toUpperCase() + activeRoomId.slice(1) + '.qml';

    }

    function setPlayer(playerId) {

        activePlayerId = playerId;
        playerLoader.source = "../players/" + activePlayerId.charAt(0).toUpperCase() + activePlayerId.slice(1) + '.qml';

    }


    //NOTE: does not actually change player item dimensions - that screws with too many calculations atm
    function updatePlayerScale(){
        var minP = activeRoom.minPerspective;
        var maxP = activeRoom.maxPerspective;
        var position = (activePlayer.y+activePlayer.height) / activeRoom.height;
        activePlayer.mediaScale = ((maxP - minP) * position) + minP;
    }

    //TODO: save static numbers
    function updateRoomOffset() {
        //if player is in the right half of the screen && there is more of the room to show to the right....
        var midPoint = gameScene.width/2;
        var playerX = mapFromItem(activePlayer).x;
        if(playerX > midPoint){
            if(viewPort.x > -(viewPort.width - gameScene.width)){
                viewPort.x -= playerX - midPoint;
            }
        } else {
            if(viewPort.x < 0){
                viewPort.x -= playerX - midPoint;
            }

        }
    }

    Text {
        id: roomTitle

        anchors.top: gameScene.top;
        anchors.left: gameScene.left;

        text: activeRoomId

        z: 1005

    }

    Item {
        id: viewPort

        height: activeRoom ? activeRoom.height : gameScene.height;
        width: activeRoom ? activeRoom.width: gameScene.width;

        PhysicsWorld {
            id: physicsWorld
            gravity: Qt.point(0,0)
            debugDrawVisible: true // enable this for physics debugging
            z: 1000
        }

        InventoryPanel {
            id: inventoryPanel
            width: gameScene.width - 100
            height: gameScene.height - 100
        }

        MouseArea {
            id: gameMouseArea
            anchors.fill: viewPort;

            property real pressedY: 0

            onPressed: {
                pressedY = mouseY + (gameScene.height - activeRoom.height);
            }
            onReleased: {
                if(pressedY < 10 && (mouseY + (gameScene.height - activeRoom.height)) > 15) {
                    inventoryPanel.show = true
                } else {
                    activePlayer.move(mouseX, mouseY)
                }
            }

            /*
          property bool dragActive: drag.active
          drag.target: activeRoom
          drag.axis: Drag.XandYAxis
          //drag.axis: Drag.XAxis
          drag.minimumX: activeRoom.dragMinX
          drag.maximumX: activeRoom.dragMaxX
          drag.minimumY: activeRoom.dragMinY
          drag.maximumY: activeRoom.dragMaxY
          */

        }




        // load levels at runtime
        Loader {
            id: roomLoader
            source: ''

            property string fromAreaId: ''

            onLoaded: {
                activeRoom = item;
                activeRoom.placePlayer(activePlayer, fromAreaId);
            }
        }

        // we connect the gameScene to the loaded level
        Connections {
            // only connect if a level is loaded, to prevent errors
            target: activeRoom !== undefined ? activeRoom : null
            onGoToRoomIdChanged: {
                setRoom(target.goToRoomId, target.fromAreaId);
                updatePlayerScale();
            }
        }

        Loader {
            id: playerLoader
            source: ''
            onLoaded: {
                activePlayer = item
            }
        }

        Connections {
            target: activePlayer !== undefined ? activePlayer : null
            onMoveStopped: {
                storage.savePlayerPoint(Qt.point(target.x, target.y));
            }
            onYChanged: updatePlayerScale();
            onXChanged: updateRoomOffset();
        }
    }
}

