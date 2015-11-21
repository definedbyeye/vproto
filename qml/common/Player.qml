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

    function move(waypoints, end) {
        path.stop();
        target = end;
        path.waypoints = waypoints;
        path.start();
    }

    Rectangle {
        width: 10
        height: 10
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

    /*
        Behavior on y {
            SmoothedAnimation {
                easing.type: Easing.bezierCurve
                duration: 100
            }
        }

        Behavior on x {
            SmoothedAnimation {
                easing.type: Easing.bezierCurve
                duration: 100
            }
        }
*/
}

