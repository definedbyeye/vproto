import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 57
    height: 192

    //origin at 0,0
    property string direction: "none"

    function isTargetReached() {
        var pX = player.x + player.width/2
        var pY = player.y + player.height - 5
        var toX = moveToPointHelper.targetPoint.x
        var toY = moveToPointHelper.targetPoint.y
        console.log('x: ' + pX + ' to ' + toX)
        console.log('y: ' + pY + ' to ' + toY)
        //if(playerX > toX && playerY > toY) {playerCollider.linearVelocity = Qt.point(0,0)}
        if((player.direction == "NW" && pX <= toX && pY <= toY)
         || (player.direction == "NE" && pX > toX && pY <= toY)
         || (player.direction == "SE" && pX > toX && pY > toY)
         || (player.direction == "SW" && pX <= toX && pY > toY)) {
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

    function gcd(a,b) { return (!b)?a:gcd(b,a%b); }


    signal move(real toX, real toY)
    onMove: {
        var fromX = player.x + player.width/2
        var fromY = player.y + player.height - 5

        //console.log(fromX + ', ' + fromY + ' to ' + toX + ', ' + toY + ' = ' + toX-fromX + ', ' + toY-fromY)
        console.log((toX-fromX) + ', ' + (toY-fromY))

        moveToPointHelper.targetPoint = Qt.point(toX, toY)
        playerCollider.linearVelocity = Qt.point(0,0)
        var diffX = Math.floor(toX - fromX)
        var diffY = Math.floor(toY - fromY)
        var divBy = Math.abs(diffX - diffY)
        //console.log('div: ' + divBy)

        //closer, but not quite right - need a more consistent speed
        playerCollider.linearVelocity = Qt.point((diffX/divBy)*100, (diffY/divBy))

        if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y <= 0) {player.direction = "NW"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y <= 0) {player.direction = "NE"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y > 0) {player.direction = "SE"}
        else if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y > 0) {player.direction = "SW"}
    }

    MoveToPointHelper {
        id: moveToPointHelper
        // the targetPoint gets set from MouseArea
        onTargetReached: {console.log('target reached'); playerCollider.linearVelocity = Qt.point(0,0);}
        //stopForwardMovementAtDifferentDirections: true
    }

    BoxCollider {
        id: playerCollider

        height: 5
        anchors.left: player.left
        anchors.right: player.right
        anchors.bottom: player.bottom

        bodyType: Body.Dynamic

        //anchors.fill: parent

        //categories: Box.Category2
        //collidesWith: Box.Category1 //walls

        collisionTestingOnlyMode: false // use Box2D only for collision detection, move the entity with the NumberAnimation above
        //sensor : true
        fixture.onBeginContact: {
            console.log('player collided with a wall!');
            //moveToPointHelper.targetPoint = Qt.point(playerCollider.body.x, playerCollider.body.y)
            playerCollider.linearVelocity = Qt.point(0,0)
            //moveTo.stop()
        }

        // rotate left and right
        //torque: moveToPointHelper.outputXAxis*300

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

