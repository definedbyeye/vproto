import VPlay 2.0
import QtQuick 2.0

Item {
  id: roomBase

  property real dragMinX: -(roomBase.width-gameScene.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: roomBase.height-gameScene.height
}

