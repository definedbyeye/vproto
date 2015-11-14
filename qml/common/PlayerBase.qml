import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: playerBase
    entityType: "player"

    property string direction: ""
    property int speed: 150
    property real mediaScale: 1

    property int colliderX: x + width/2
    property int colliderY: y + height - 1

    property var targetPoint: null;
    property var waypoints: [];
    property var movingToPoint: null;

    signal waypointReached
    signal targetReached
    signal targetOutOfReach

    function placePlayer(point) {
        x = point.x-(width/2);
        y = point.y = height + 1;
    }

    function movePlayer(waypoints, targetPoint) {
        cancelMovement();
        playerBase.targetPoint = targetPoint;
        playerBase.waypoints = waypoints;
    }

    onWaypointsChanged: {
        if(waypoints.length) {
            move(waypoints[0]);
        }
    }

    onWaypointReached: {

        playerCollider.linearVelocity = Qt.point(0,0);

        //did we just complete the last waypoint?
        if(waypoints.length-1 === 0){
            if(waypoints[0] === targetPoint){
                targetReached();
            } else {
                targetOutOfReach();
            }

        //otherwise, update waypoints to move to the next waypoint
        } else {
            waypoints = waypoints.slice(1);
        }

    }

    onTargetReached: {
        console.log('TARGET REACHED');
        cancelMovement();
    }

    onTargetOutOfReach: {
        console.log('TARGET OUT OF REACH');
        cancelMovement();
    }

    function isWaypointReached() {
        var toX = movingToPoint.x+5;
        var toY = movingToPoint.y+5;

        var diffX = movingToPoint.x - colliderX;
        var diffY = movingToPoint.y - colliderY;

        //is the player already standing near the point?
        if(Math.abs(diffY) < 5 && Math.abs(diffX) < 5){
            playerCollider.linearVelocity = Qt.point(0,0);
            waypointReached();
            return;
        }

        /*
        // since the user may have overshot the point due to signal lags,
        // use this catch-all check vs a simple diff check
        if((direction === "NW" && colliderX <= toX && colliderY <= toY)
         || (direction === "NE" && colliderX > toX && colliderY <= toY)
         || (direction === "SE" && colliderX > toX && colliderY > toY)
         || (direction === "SW" && colliderX <= toX && colliderY > toY)) {
            playerCollider.linearVelocity = Qt.point(0,0);
            waypointReached();
        }
        */
    }

    //todo: throttle this?
    onXChanged: {
            if(movingToPoint){
                isWaypointReached()
            }
        }
    onYChanged: {
            if(movingToPoint){
                isWaypointReached()
            }
        }

    function move() {
        movingToPoint = waypoints[0];

        var diffX = movingToPoint.x - colliderX;
        var diffY = movingToPoint.y - colliderY;

        //is the player already standing near the point?
        if(Math.abs(diffY) < 2 && Math.abs(diffX) < 2){
            waypointReached();
            return;
        }

        var newSpeed = Math.abs(speed/Math.sqrt((diffX*diffX) + (diffY*diffY)))

        playerCollider.linearVelocity = Qt.point(diffX*newSpeed, diffY*newSpeed)

        /*
        // set movement direction (four-point for now)
        if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y <= 0) {direction = "NW"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y <= 0) {direction = "NE"}
        else if(playerCollider.linearVelocity.x > 0 && playerCollider.linearVelocity.y > 0) {direction = "SE"}
        else if(playerCollider.linearVelocity.x <= 0 && playerCollider.linearVelocity.y > 0) {direction = "SW"}
        */
    }

    function cancelMovement() {
        playerCollider.linearVelocity = Qt.point(0,0);
        waypoints = [];
        movingToPoint = null;
        targetPoint = null;
    }

    BoxCollider {
        id: playerCollider

        height: 1
        width: 1
        anchors.horizontalCenter: playerBase.horizontalCenter
        anchors.bottom: playerBase.bottom

        bodyType: Body.Dynamic

        collisionTestingOnlyMode: false

        //safety check to ensure player doesn't step into an obstacle
        fixture.onBeginContact: {
            playerCollider.linearVelocity = Qt.point(0,0);
            console.log('Player ran into an obstacle.  Ouch! at '+x + ',' + y);
            //targetReached();
        }
    }

}

