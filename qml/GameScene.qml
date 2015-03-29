import VPlay 2.0
import QtQuick 2.0
import "entities"
import "levels"
import "interface"

Scene {
  id: gameScene
  // the "logical size" - the scene content is auto-scaled to match the GameWindow size
  width: 480
  height: 320

  property int offsetBeforeScrollingStarts: 0

  EntityManager {
    id: entityManager

    dynamicCreationEntityList: []
  }

  // the whole screen is filled with an incredibly beautiful blue ...
  Rectangle {
    anchors.fill: gameScene.gameWindowAnchorItem
    color: "#74d6f7"
  }

  Inventory {
      id: inventory

      width: gameScene.width - 100
      height: gameScene.height - 100
  }


  MouseArea {
      id: gameMouseArea
      anchors.fill: viewPort

      property real pressedY: 0
      onPressed: {
          pressedY = mouseY + (gameScene.height - viewPort.height);
      }
      onReleased: {
          if(pressedY < 10 && (mouseY + (gameScene.height - viewPort.height)) > 15) {
              inventory.show = true
              //inventory.y = inventory.y < 0 ? 50 : 0-height
//              mouse.accepted = true
          } else {
              firstPlayer.move(mouseX, mouseY)
          }
      }

      /*
      property bool dragActive: drag.active

      drag.target: level1
      drag.axis: Drag.XandYAxis
      //drag.axis: Drag.XAxis
      drag.minimumX: level1.dragMinX
      drag.maximumX: level1.dragMaxX
      drag.minimumY: level1.dragMinY
      drag.maximumY: level1.dragMaxY
      */
  }

  // this is the moving item containing the level and player
  Item {
    id: viewPort
    height: level1.height
    width: level1.width
    anchors.bottom: gameScene.gameWindowAnchorItem.bottom
    anchors.left: gameScene.gameWindowAnchorItem.left    

    PhysicsWorld {
      id: physicsWorld
      gravity: Qt.point(0,0)
      debugDrawVisible: true // enable this for physics debugging
      z: 1000
    }

    // you could load your levels Dynamically with a Loader component here
    Level1 {
      id: level1

      Hotspot {
        id: glass
        x: 310
        y: 160
      }
    }    

    Player {
      id: firstPlayer
      x: 200
      y: 120
    }
  }
}

