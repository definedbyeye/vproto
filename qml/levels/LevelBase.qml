import VPlay 2.0
import QtQuick 2.0

Item {
  id: levelBase

  property real dragMinX: -(levelBase.width-gameScene.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: levelBase.height-gameScene.height
}

