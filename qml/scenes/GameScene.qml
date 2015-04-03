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

  property string activeRoomFileName
  property variant activeRoom
  property string activePlayerFileName
  property variant activePlayer

  function load() {
      setRoom(storage.roomId);
      setPlayer(storage.playerId);
      activePlayer.x = storage.playerX;
      activePlayer.y = storage.playerY;
  }

  // set the name of the current level, this will cause the Loader to load the corresponding level
  function setRoom(roomId) {
    var roomFile = roomId.charAt(0).toUpperCase() + roomId.slice(1) + '.qml';
    activeRoomFileName = roomFile
  }

  function setPlayer(playerId) {
    var playerFile = playerId.charAt(0).toUpperCase() + playerId.slice(1) + '.qml';
    activePlayerFileName = playerFile
  }

  Item {
      id: viewPort
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
      anchors.fill: room

      property real pressedY: 0
      onPressed: {
          pressedY = mouseY + (gameScene.height - room.height);
      }
      onReleased: {
          if(pressedY < 10 && (mouseY + (gameScene.height - room.height)) > 15) {
              inventoryPanel.show = true
              //inventory.y = inventory.y < 0 ? 50 : 0-height
//              mouse.accepted = true
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
    id: room
    source: activeRoomFileName != "" ? "../rooms/" + activeRoomFileName : ""
    onLoaded: {
      activeRoom = item
        viewPort.height = activeRoom.height;
        viewPort.width = activeRoom.width;
        viewPort.anchors.bottom = gameScene.gameWindowAnchorItem.bottom
        viewPort.anchors.left = gameScene.gameWindowAnchorItem.left

    }
  }

  // we connect the gameScene to the loaded level
  Connections {
      // only connect if a level is loaded, to prevent errors
      target: activeRoom !== undefined ? activeRoom : null
  }

  Loader {
      id: player
      source: activePlayerFileName != "" ? "../players/" + activePlayerFileName : ""
      onLoaded: {
        activePlayer = item
      }
  }

  Connections {
      target: activePlayer !== undefined ? activePlayer : null
  }
}
}

