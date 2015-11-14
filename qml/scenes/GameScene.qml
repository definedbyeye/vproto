import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../interactables"
import "../rooms"
import "../interface"

/* Collider Categories:
   Box.Category1 -- Player
   Box.Category2 -- Wall
   Box.Category3 -- Area
   Box.Category4 -- ActiveInventory
   Box.Category5 -- InteractiveHotspot
   Box.Category6 -- Obstruction (not a wall)
*/



SceneBase {
    id: gameScene

    // the "logical size" - the scene content is auto-scaled to match the GameWindow size    
    height: 320
    width: 480

    property string activeRoomId
    property variant activeRoom

    property string activePlayerId
    property variant activePlayer
    signal playerStopped;
    signal playerTargetReached;
    signal playerTargetOutOfReach;

    //TODO: clean these up with aliases or something
    property variant activePanel
    signal panelClosed;
    signal panelOpt1;
    signal panelOpt2;
    signal panelOpt3;
    signal panelOpt4;
    signal panelOpt5;
    signal panelOptCancel;

    onActivePlayerIdChanged: storage.savePlayerId(activePlayerId);
    onActiveRoomIdChanged: storage.saveRoomId(activeRoomId);

    // viewport contains the full room.  gamescene only shows part of it.
    // todo: flip the two names
    Item {
        id: viewPort

        property alias dragActiveInventory: activeInventoryCollider

        height: activeRoom ? activeRoom.height : gameScene.height;
        width: activeRoom ? activeRoom.width: gameScene.width;

        PhysicsWorld {
            id: physicsWorld
            gravity: Qt.point(0,0)
            debugDrawVisible: true // enable this for physics debugging
            z: 1000
        }

        //mouse layer captures clicks if no overlaying layers intercept first
        MouseArea {
            id: clickToMove
            anchors.fill: viewPort;
            propagateComposedEvents: true

            onReleased: {
                var start = Qt.point(player.x, player.y);
                var end = Qt.point(mouse.x,mouse.y);
                var waypoints = activeRoom.getWaypoints(start, end);
                player.move(waypoints, end);
            }
        }

        Player {
            id: player
            z: 200

            onTargetReached: storage.savePlayerPoint(Qt.point(target.x, target.y));
            onTargetOutOfReach: storage.savePlayerPoint(Qt.point(target.x, target.y));

            //onYChanged: updatePlayerScale();
            onXChanged: updateRoomOffset();
        }

        // load levels at runtime
        Loader {
            id: roomLoader
            source: ''
            property string fromAreaId: ''
            onLoaded: {
                activeRoom = item;
                activeRoom.loaded();
                //todo: replace with a "setplayer" function accounting for areaid
                player.x = activeRoom.defaultPlayerPoint.x;
                player.y = activeRoom.defaultPlayerPoint.y;
            }
        }
        Connections {
            // only connect if a level is loaded, to prevent errors
            target: activeRoom !== undefined ? activeRoom : null        
            onGoToRoomIdChanged: {
                setRoom(target.goToRoomId, target.fromAreaId);
                //updatePlayerScale();
            }
        }        

        // Pressing MouseArea.dragFromFrame inits this
        // collider with an inventory ID and starts dragging the
        // activeInventory.  On release, the dropped signal is
        // triggered here which maps to the interactable that we
        // collided with and triggers any 'useWith' handlers.
        BoxCollider {
          id: activeInventoryCollider
          width: 40
          height: 40

          bodyType: Body.Dynamic
          visible: false;
          categories: Box.Category4
          collidesWith: Box.Category5
          collisionTestingOnlyMode: true

          signal dropped;

          property string inventoryId: "colliderOnly"
          property var interactWith;

          fixture.onBeginContact: {
            interactWith = other.getBody().target;
            interactWith.useWithInventoryId = activeInventoryCollider.inventoryId;
            dropped.connect(interactWith.dropped);
          }

          fixture.onEndContact: {
            dropped.disconnect(interactWith.dropped);
            interactWith.useWithInventoryId = '';
          }

        }

    } // --- end of viewport -------------------

    ActiveInventoryFrame{
        id: activeInventoryFrame
    }

    InventoryPanel {
        id: inventoryPanel
    }

    Scripted {
        id: scripted
    }

    /* ------------- panel loader -------------- */
    Loader {
        id: panelLoader
        anchors.fill: parent
        onLoaded: {
            activePanel = item
        }
        onSourceChanged: {
            if(source === null) {
                activePanel = null;
            }
        }
    }
    Connections {
        target: activePanel !== undefined ? activePanel : null
        onPanelOpt1: panelOpt1();
        onPanelOpt2: panelOpt2();
        onPanelOpt3: panelOpt3();
        onPanelOpt4: panelOpt4();
        onPanelOpt5: panelOpt5();
        onPanelOptCancel: panelOptCancel();
        onClose: {panelLoader.source = ''; gameScene.panelClosed();}
    }   

    //inventory panel visual helper (on top of the panels for save/load controls later)
    Rectangle {
        id: inventoryPanelHelper
        color: "white"
        opacity: .2

        anchors.top: gameScene.top;
        anchors.left: gameScene.left;
        anchors.right: gameScene.right;

        height: 15;

        MouseArea {
            id: gameSceneUI
            anchors.fill: parent
            onReleased: inventoryPanel.show()
        }
    }

    Text {
        id: roomTitle

        anchors.top: gameScene.top;
        anchors.left: gameScene.left;

        text: activeRoomId

        z: 1005

    }

    //console log the mouse click for dev purposes
    MouseArea {
        id: logPoint
        anchors.fill: viewPort;
        propagateComposedEvents: true
        onPressed: mouse.accepted = false;
        onDoubleClicked: mouse.accepted = false;
        onReleased: mouse.accepted = false;
        onPositionChanged: mouse.accepted = false;
        onPressAndHold: mouse.accepted = false;
        onClicked: { console.log('POINT: ' + mouseX + ', ' + mouseY); mouse.accepted = false;}
    }

    function init() {
        var gameState = storage.getPlayerState();

        setPlayer(gameState.playerId);
        setRoom(gameState.roomId);

        initInventory();
    }

    function initInventory() {
        var inventoryItems = storage.getInventoryState();
        for(var i = 0; i < inventoryItems.length; i++){
            inventoryPanel.addInventory(inventoryItems[i].inventoryId, false); //TODO: extend to add state eg qty
        }
    }

    function setRoom(toRoomId, fromAreaId) {

        //allow new room to set the player's position based on the old room
        //TODO: fromInteractId
        //roomLoader.fromInteractId = activeRoomId;
        activeRoomId = toRoomId;
        roomLoader.fromAreaId = fromAreaId || '';
        roomLoader.source = "../rooms/" + activeRoomId.charAt(0).toUpperCase() + activeRoomId.slice(1) + '.qml';

    }

    function setPlayer(playerId) {

        activePlayerId = playerId;
        //playerLoader.source = "../players/" + activePlayerId.charAt(0).toUpperCase() + activePlayerId.slice(1) + '.qml';

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
        var playerX = mapFromItem(player).x;
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

}

