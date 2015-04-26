import QtQuick 2.0
import VPlay 2.0
import "../common"
import "../interface"

//activeInventoryFrame
Rectangle {
    id: activeInventoryFrame

    property string inventoryId;

    x: gameScene.width/2 - 25
    y: gameScene.height - 50

    width: 50;
    height: 50

    color: "pink"
    opacity: .6
    radius: width*0.5

    Rectangle {
        id: activeInventory
        width: 50
        height: 50
        radius: 25
        color: "blue"
        Drag.active: dragFromFrame.drag.active

        x: 0
        y: 0

        property bool dragging: false

        states: [
            State {
                when: activeInventory.dragging
                PropertyChanges {target: activeInventory; color: "green"}
            }

        ]
    }

    MouseArea {
        id: dragFromFrame
        anchors.fill: parent

        Component.onCompleted: reset()

        onPressed: {
            viewPort.dragActiveInventory.visible = true;
            activeInventory.dragging = true;
        }
        onReleased: {
            activeInventory.dragging = false;
            viewPort.dragActiveInventory.dropped();
            viewPort.dragActiveInventory.visible = false;
            reset();
        }
        onPositionChanged: follow(mouse);


        function follow(mouse){
            activeInventory.x = mouse.x - activeInventory.width/2;
            activeInventory.y = mouse.y - activeInventory.height/2;

            var drag = viewPort.dragActiveInventory;
            var vp = mapToItem(viewPort, activeInventory.x, activeInventory.y);
            drag.x = vp.x + 5;
            drag.y = vp.y + activeInventory.height - 5;
        }

        function reset() {
            activeInventory.x = 0;
            activeInventory.y = 0;

            var drag = viewPort.dragActiveInventory;
            var vp = mapToItem(viewPort, 5, 5);
            drag.x = vp.x;
            drag.y = vp.y + activeInventory.height - 5;

        }
    }
}

