import QtQuick 2.0

Item {
  id: levelBase
  signal clicked()

  property real dragMinX: -(levelBase.width-gameScene.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: levelBase.height-gameScene.height

  MouseArea {
      anchors.fill: level
      onClicked: {
          firstPlayer.move(mouseX, mouseY)
      }

      drag.target: parent
      drag.axis: Drag.XandYAxis
      //drag.axis: Drag.XAxis
      drag.minimumX: dragMinX
      drag.maximumX: dragMaxX
      drag.minimumY: dragMinY
      drag.maximumY: dragMaxY
  }

}

