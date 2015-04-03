import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: playerBase
    entityType: "player"

    property string direction: ""
    property int speed: 150

    function isTargetReached() {
        var pX = playerBase.x + playerBase.width/2
        var pY = playerBase.y + playerBase.height - 5
        var toX = moveToPointHelper.targetPoint.x
        var toY = moveToPointHelper.targetPoint.y

        if((playerBase.direction == "NW" && pX <= toX && pY <= toY)
         || (playerBase.direction == "NE" && pX > toX && pY <= toY)
         || (playerBase.direction == "SE" && pX > toX && pY > toY)
         || (playerBase.direction == "SW" && pX <= toX && pY > toY)) {
            playerCollider.linearVelocity = Qt.point(0,0)
        }
    }

    function isTargetCloseEnough() {
        var pX = playerBase.x + playerBase.width/2
        var pY = playerBase.y + playerBase.height - 5
        var toX = moveToPointHelper.targetPoint.x
        var toY = moveToPointHelper.targetPoint.y

        if((playerBase.direction[0] == "N" && pY <= toY)
         || (playerBase.direction[0] == "S" && pY < toY)
         || (playerBase.direction[1] == "E" && pX > toX)
         || (playerBase.direction[1] == "W" && pX <= toX)) {
            playerCollider.linearVelocity = Qt.point(0,0)
        }
    }

    onXChanged: isTargetReached()
    onYChanged: isTargetReached()

    signal move(real toX, real toY)
    onMove: {
        console.log('---------- move: '+toX+', '+toY+' player: '+playerBase.x+', '+playerBase.y);
        var fromX = playerBase.x + playerBase.width/2
        var fromY = playerBase.y + playerBase.height - 5
        var diffX = toX - fromX
        var diffY = toY - fromY
        var speed = Math.abs(playerBase.speed/Math.sqrt((diffX*diffX) + (diffY*diffY)))

        moveToPointHelper.targetPoint = Qt.point(toX, toY)
        playerCollider.linearVelocity = Qt.point(0,0)
        playerCollider.linearVelocity = Qt.point(diffX*speed, diffY*speed)

        if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y <= 0) {playerBase.direction = "NW"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y <= 0) {playerBase.direction = "NE"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y > 0) {playerBase.direction = "SE"}
        else if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y > 0) {playerBase.direction = "SW"}
    }

    MoveToPointHelper {
        id: moveToPointHelper
    }

    BoxCollider {
        id: playerCollider

        height: 5
        anchors.left: playerBase.left
        anchors.right: playerBase.right
        anchors.bottom: playerBase.bottom

        bodyType: Body.Dynamic

        //categories: Box.Category2
        //collidesWith: Box.Category1 //walls

        collisionTestingOnlyMode: false

        fixture.onBeginContact: {
            playerCollider.linearVelocity = Qt.point(0,0)
        }
    }

}

