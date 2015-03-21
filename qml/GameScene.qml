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
    x: player.x > offsetBeforeScrollingStarts ? offsetBeforeScrollingStarts - player.x : 0

    PhysicsWorld {
      id: physicsWorld
      gravity: Qt.point(0,-25)
      debugDrawVisible: false // enable this for physics debugging
      z: 1000
    }

    // you could load your levels Dynamically with a Loader component here
    Level1 {
      id: level
    }

    Player {
      id: player
      x: 20
      y: 20
    }

  }
/*
  Timer {
    id: updateTimer
    // set this interval as high as possible to improve performance, but as low as needed so it still looks good
    interval: 60
    running: true
    repeat: true
    onTriggered: {
      var xAxis = controller.xAxis;
      // if the xAxis has a value != 0, we move the player, else we slow him down until he stops
      if(xAxis) {
        player.horizontalVelocity = xAxis*200;
      } else {
        if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= 1.5
        else player.horizontalVelocity = 0
      }
    }
  }
  */
}

