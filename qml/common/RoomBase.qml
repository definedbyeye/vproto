import VPlay 2.0
import QtQuick 2.0

Item {
  id: roomBase  

  property real dragMinX: -(roomBase.width-gameScene.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: roomBase.height-gameScene.height

  property point defaultPlayerPoint: Qt.point(0,0)
  property real minPerspective: .2
  property real maxPerspective: .9

  property string goToRoomId: ''
  property string fromAreaId: ''

  function placePlayer(player, fromAreaId) {
      player.x = defaultPlayerPoint.x;
      player.y = defaultPlayerPoint.y;
  }

}

