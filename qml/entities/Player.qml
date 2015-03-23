import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 57
    height: 192

    // add some aliases for easier access to those properties from outside
    //property alias collider: collider
    //property alias horizontalVelocity: collider.linearVelocity.x

    // start with jumping state, because we let the player fall from the sky at start
    //state: "jumping"

    // here you could use a SpriteSquenceVPlay to animate your player
    MultiResolutionImage {
        source: "../../assets/player/player.png"
    }

    signal move(real moveToX, real moveToY)
    onMove: {
        if(!moveTo.running){
            moveTo.waypoints = [
                        {x:player.x, y:player.y},
                        {x:moveToX - player.width/2, y:moveToY - player.height}
                    ];
            moveTo.start();
        } else { moveTo.stop()}
    }

    PathMovement {
        id: moveTo
        velocity: 100
        rotationAnimationEnabled: false
        running: false
        /*
      waypoints: [
        {x:0, y:0},
        {x:500, y:250}
      ]
*/
        onPathCompleted: {
            console.debug("last waypoint reached");
        }
    }

    BoxCollider {
        height: 5
        anchors.left: player.left
        anchors.right: player.right
        anchors.bottom: player.bottom

        categories: Box.Category2
        collidesWith: Box.Category1 //walls

        collisionTestingOnlyMode: true // use Box2D only for collision detection, move the entity with the NumberAnimation above
        sensor : true
        fixture.onBeginContact: {
            console.log('player collided with a wall!')
            moveTo.stop()
        }
    }// BoxCollider

    /*
  function jump() {
    if(player.state == "walking") {
      // for the jump, we simplay apply an upward impulse to the collider
      collider.applyLinearImpulse(Qt.point(0,-420), collider.body.getWorldCenter())
    }
  }
  */

}

