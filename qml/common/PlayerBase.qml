import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: playerBase
    entityType: "player"

    property string direction: ""
    property int speed: 150
    property real mediaScale: 1

    property int colliderX: x + width/2
    property int colliderY: y + height - 5

    property var moveToPoint: null;
    property var waypoints: [];

    signal waypointReached
    signal targetReached
    signal targetIsClose
    signal moveStopped

    function placePlayer(point) {
        x = point.x-(width/2);
        y = point.y = height + 5;
    }

    onWaypointsChanged: {
        //console.log('onWaypointsChanged, update movetopoint to: '+waypoints[0]);
        if(waypoints.length) {
            moveToPoint = waypoints[0];
            move();
        }
    }

    /*
    onMoveToPointChanged: {        
        if(moveToPoint != null){
            console.log('onMoveTOPointChanged: from '+colliderX+','+colliderY+' to '+moveToPoint.x+','+moveToPoint.y);
            move();
        }
    }
    */

    onWaypointReached: {
        //console.log('onWaypointREached: waypoints length ' + waypoints.length);
        waypoints.shift();
        if(waypoints.length === 0){
            console.log('REACHED END OF PATH');
            targetReached();
        } else {
            moveToPoint = waypoints[0];
            move();
        }
    }

    function isWaypointReached() {
        var toX = moveToPoint.x
        var toY = moveToPoint.y

        if((direction === "NW" && colliderX <= toX && colliderY <= toY)
         || (direction === "NE" && colliderX > toX && colliderY <= toY)
         || (direction === "SE" && colliderX > toX && colliderY > toY)
         || (direction === "SW" && colliderX <= toX && colliderY > toY)) {
            playerCollider.linearVelocity = Qt.point(0,0);
            //console.log('STOP');
            waypointReached();
        }
    }

    onTargetReached: {
        moveToPoint = null;
    }

    //todo: throttle this?
    onXChanged: {
            if(moveToPoint){
                isWaypointReached()
            }
        }
    onYChanged: {
            if(moveToPoint){
                isWaypointReached()
            }
        }

    function move() {


        var diffX = moveToPoint.x - colliderX
        var diffY = moveToPoint.y - colliderY

        //console.log('moving... '+colliderX+','+colliderY+' to '+moveToPoint.x+','+moveToPoint.y);

        //is the player already standing on the point?
        if(Math.abs(diffY) < 2 && Math.abs(diffX) < 2){
            waypointReached();
            return;
        }

        var newSpeed = Math.abs(speed/Math.sqrt((diffX*diffX) + (diffY*diffY)))

        playerCollider.linearVelocity = Qt.point(diffX*newSpeed, diffY*newSpeed)

        if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y <= 0) {direction = "NW"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y <= 0) {direction = "NE"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y > 0) {direction = "SE"}
        else if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y > 0) {direction = "SW"}
    }

    BoxCollider {
        id: playerCollider

        height: 1
        width: 10
        anchors.horizontalCenter: playerBase.horizontalCenter
        anchors.bottom: playerBase.bottom

        bodyType: Body.Dynamic

        collisionTestingOnlyMode: false

        fixture.onBeginContact: {
            playerCollider.linearVelocity = Qt.point(0,0);
            moveStopped();
        }
    }

}

