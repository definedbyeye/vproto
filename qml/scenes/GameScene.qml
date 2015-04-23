import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../interactables"
import "../rooms"
import "../interface"

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
    signal playerReachedTarget;

    property variant activePanel
    signal panelClosed;


    onActivePlayerIdChanged: storage.savePlayerId(activePlayerId);
    onActiveRoomIdChanged: storage.saveRoomId(activeRoomId);

    function init() {
        var gameState = storage.getPlayerState();

        setPlayer(gameState.playerId);
        setRoom(gameState.roomId);
        activePlayer.x = gameState.x;
        activePlayer.y = gameState.y;

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


    // contains the full room.  gamescene only shows part of this.
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

        MouseArea {
            id: clickToMove
            anchors.fill: viewPort;

            property real pressedY: 0
            propagateComposedEvents: true

            onPressed: {
                pressedY = mouseY + (gameScene.height - activeRoom.height);
            }
            onReleased: {                
                activePlayer.moveTo(mouseX, mouseY)
            }

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
                playerStopped();
                storage.savePlayerPoint(Qt.point(target.x, target.y));
            }
            onTargetReached: {
                playerReachedTarget();
            }
            onYChanged: updatePlayerScale();
            onXChanged: updateRoomOffset();
        }
    }

    InventoryPanel {
        id: inventoryPanel
    }

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
        onClose: {panelClosed(); panelLoader.source = '';}
    }

    EntityBase {
        id: scriptedSequence
        property var sequence

        onSequenceChanged: loadStates()

        function loadStates() {
            var states = '';
            var state = '';
            var s;

console.log('----------- loading states');

            for(var i = 0; i < sequence.length; i++){
                s = sequence[i];

                state = 'State {';
                state += 'name: "'+s.name+'"; '

                switch(s.type){
                    case 'moveTo':
                        state += 'StateChangeScript { script: activePlayer.moveTo('+s.x+','+s.y+')} ';
                        state += 'PropertyChanges { target: gameScene; ';

                        if(s.change && s.change.length){
                            for(var j = 0; j < s.change.length; j++){
                                state += s.change[j].on + ': sampleScript.state = "'+s.change[j].to+'"; ';
                            }
                        }
                        state += '} ';
                        break;
                    case 'look':
                        //TODO: escape single quotes
                        state += 'StateChangeScript { script: {
                            panelLoader.source = "../interface/MessagePanel.qml";
                            activePanel.message = "'+s.message+'";
                        }} ';
                        state += 'PropertyChanges { target: gameScene; ';

                        if(s.change && s.change.length){
                            for(var j = 0; j < s.change.length; j++){
                                state += s.change[j].on + ': sampleScript.state = "'+s.change[j].to+'"; ';
                            }
                        }
                        state += '} ';

                        break;
                }

                state += '}';
                if(i < sequence.length-1)
                    state += ',';
                states += state;
            }

            states = 'import QtQuick 2.0; import VPlay 2.0; EntityBase { id: sampleScript
                onStateChanged: {console.log("-- state changed to "+state)}
                state: "'+sequence[0].name+'"; states: ['+states+'] }';
            console.log(states);
            Qt.createQmlObject(states, scriptedSequence);
        }
    }


    //inventory panel visual helper
    Rectangle {
        color: "white"
        opacity: .2

        anchors.top: gameScene.top;
        anchors.left: gameScene.left;
        anchors.right: gameScene.right;

        height: 15;

        MouseArea {
            id: gameSceneUI
            anchors.fill: parent
            onReleased: inventoryPanel.show = true
        }
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

}

