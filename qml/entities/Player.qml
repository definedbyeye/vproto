import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 57
    height: 192

    property string direction: ""
    property int speed: 150

    function isTargetReached() {
        var pX = player.x + player.width/2
        var pY = player.y + player.height - 5
        var toX = moveToPointHelper.targetPoint.x
        var toY = moveToPointHelper.targetPoint.y

        if((player.direction == "NW" && pX <= toX && pY <= toY)
         || (player.direction == "NE" && pX > toX && pY <= toY)
         || (player.direction == "SE" && pX > toX && pY > toY)
         || (player.direction == "SW" && pX <= toX && pY > toY)) {
            playerCollider.linearVelocity = Qt.point(0,0)
        }
    }

    function isTargetCloseEnough() {
        var pX = player.x + player.width/2
        var pY = player.y + player.height - 5
        var toX = moveToPointHelper.targetPoint.x
        var toY = moveToPointHelper.targetPoint.y

        if((player.direction[0] == "N" && pY <= toY)
         || (player.direction[0] == "S" && pY < toY)
         || (player.direction[1] == "E" && pX > toX)
         || (player.direction[1] == "W" && pX <= toX)) {
            playerCollider.linearVelocity = Qt.point(0,0)
        }
    }

    onXChanged: isTargetReached()
    onYChanged: isTargetReached()

    // start with jumping state, because we let the player fall from the sky at start
    //state: "jumping"

    // here you could use a SpriteSquenceVPlay to animate your player
    MultiResolutionImage {
        source: "../../assets/player/player.png"
    }

    signal move(real toX, real toY)
    onMove: {
        var fromX = player.x + player.width/2
        var fromY = player.y + player.height - 5
        var diffX = toX - fromX
        var diffY = toY - fromY
        var speed = Math.abs(player.speed/Math.sqrt((diffX*diffX) + (diffY*diffY)))

        moveToPointHelper.targetPoint = Qt.point(toX, toY)
        playerCollider.linearVelocity = Qt.point(0,0)
        playerCollider.linearVelocity = Qt.point(diffX*speed, diffY*speed)

        if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y <= 0) {player.direction = "NW"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y <= 0) {player.direction = "NE"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y > 0) {player.direction = "SE"}
        else if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y > 0) {player.direction = "SW"}
    }

    MoveToPointHelper {
        id: moveToPointHelper
    }

    BoxCollider {
        id: playerCollider

        height: 5
        anchors.left: player.left
        anchors.right: player.right
        anchors.bottom: player.bottom

        bodyType: Body.Dynamic

        //categories: Box.Category2
        //collidesWith: Box.Category1 //walls

        collisionTestingOnlyMode: false

        fixture.onBeginContact: {
            playerCollider.linearVelocity = Qt.point(0,0)
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

