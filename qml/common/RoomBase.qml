import VPlay 2.0
import QtQuick 2.0

Item {
  id: roomBase  

  property real dragMinX: -(roomBase.width-gameScene.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: roomBase.height-gameScene.height

  property real defaultOffset: 0

  property point defaultPlayerPoint: Qt.point(0,0)
  property real minPerspective: .1
  property real maxPerspective: 1

  property string goToRoomId: ''
  property string fromAreaId: ''

  function placePlayer(player, fromAreaId) {
      player.x = defaultPlayerPoint.x;
      player.y = defaultPlayerPoint.y;
  }


  /*
  EntityBaseDraggable {
    id: activeInventory
    entityId: 'activeInventory'
    entityType: "block"

    x: 240
    y: 332

    width: 50
    height: 50

    signal dropped;
    property bool dragging: false

    property string vcolor: "brown"
    property string inventoryId: 'testInventory'

    selectionMouseArea.anchors.fill: visual           //required for EntityBaseDraggable
    dragOffset: Qt.point(0,-5)                        //offset while dragging


    // if drop accepted, animate item in frame back up and do not snap item back
    // if drop not accepted, animate empty frame back up and snap item back ?

    onEntityPressed: {dragging = true;}
    onEntityReleased: {dragging = false; dropped(); x=240; y=200;}

    // TODO: may not need to be a circle
    CircleCollider {
      id: collider
      categories: Box.Category4
      collidesWith: Box.Category5
      radius: visual.width/2
      anchors.top: visual
      anchors.left: visual
      collisionTestingOnlyMode: true
    }

    Rectangle {
      id: visual
      width: 50
      height: 50
      radius: width/2;
      anchors.centerIn: parent
      color: "brown"
    }

  }
  */


}

