import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../entities"
import "../rooms"
import "../interface"

SceneBase {
    id: gameScene

    // the "logical size" - the scene content is auto-scaled to match the GameWindow size
    width: 480
    height: 320

    property string activeRoomId
    property variant activeRoom

    property string activePlayerId
    property variant activePlayer

    onActivePlayerIdChanged: {console.log(activePlayerId); storage.savePlayerId(activePlayerId);}
    onActiveRoomIdChanged: {console.log(activeRoomId); storage.saveRoomId(activeRoomId);}

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

          drag.target: room1
          drag.axis: Drag.XandYAxis
          //drag.axis: Drag.XAxis
          drag.minimumX: room1.dragMinX
          drag.maximumX: room1.dragMaxX
          drag.minimumY: room1.dragMinY
          drag.maximumY: room1.dragMaxY
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
        }
    }
}

