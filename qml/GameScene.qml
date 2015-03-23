import VPlay 2.0
import QtQuick 2.0
import "entities"
import "levels"

Scene {
  id: gameScene
  // the "logical size" - the scene content is auto-scaled to match the GameWindow size
  width: 480
  height: 320

  property int offsetBeforeScrollingStarts: 0

  EntityManager {
    id: entityManager
  }

  // the whole screen is filled with an incredibly beautiful blue ...
  Rectangle {
    anchors.fill: gameScene.gameWindowAnchorItem
    color: "#74d6f7"
  }

  // this is the moving item containing the level and player
  Item {
    id: viewPort
    height: level.height
    width: level.width
    anchors.bottom: gameScene.gameWindowAnchorItem.bottom
    anchors.left: gameScene.gameWindowAnchorItem.left
    x: firstPlayer.x > offsetBeforeScrollingStarts ? offsetBeforeScrollingStarts - firstPlayer.x : 0

    PhysicsWorld {
      id: physicsWorld
      gravity: Qt.point(0,-25)
      debugDrawVisible: true // enable this for physics debugging
      z: 1000
    }

    // you could load your levels Dynamically with a Loader component here
    Level1 {
      id: level
    }

    Player {
      id: firstPlayer      
      x: 50
      y: 160
      //x: 0
      //y: 0
    }

    Hotspot {
      id: glass
      x: 310
      y: 160
    }
  }
}

