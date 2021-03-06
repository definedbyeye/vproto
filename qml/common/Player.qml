import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    x: 150
    y: 150
    width: 1
    height: 1

    property int speed: 150
    property string direction: ""

    property var target: null;
    property var waypoints: [];

    signal waypointReached
    signal targetReached
    signal targetOutOfReach

    signal stop
    signal collision

    onStop: path.stop();

    function move(waypoints, end) {
        path.stop();
        target = end;
        path.waypoints = waypoints;
        path.start();
    }

    Rectangle {
        anchors.fill: parent;
        color: "red"
    }

    PathMovement {
        id: path
          velocity: 100
          rotationAnimationEnabled: false

          onWaypointReached: {
              player.waypointReached();
              //todo: return direction
          }

          onPathCompleted: {
              console.log('Path completed');
              if(player.x === target.x && player.y === target.y){
                  targetReached();
              } else {
                  targetOutOfReach();
              }
          }
      }

    BoxCollider {
        id: playerCollider

        anchors.fill: parent
        bodyType: Body.Dynamic
        collisionTestingOnlyMode: true

        categories: Box.Category1   // player
        collidesWith: Box.Category3 // area

        fixture.onBeginContact: {
            player.collision();
        }
    }
}

