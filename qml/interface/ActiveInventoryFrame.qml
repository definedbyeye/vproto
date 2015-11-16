import QtQuick 2.0
import VPlay 2.0
import "../common"
import "../interface"

//tap - open inventory
//tap item to select
//close inventory



//activeInventoryFrame
Item {
    id: activeInventoryFrame

    property string inventoryId;

    //bottom middle
    //TODO: test top right
    //x: gameScene.width/2 - 25
    //y: gameScene.height - 50
    x: inventoryId ? gameScene.width - 50 : -60
    y: inventoryId ? 0 : -60

    width: 50;
    height: 50

    Rectangle {
        id: frameBackground
        anchors.centerIn: parent
        width: 75
        height: 75
        opacity: .9
        color: "tan"
        border.width: 2
        border.color: "#555"
        radius: width*.5
    }

    Item {
        id: activeInventory
        width: 50
        height: 50
        Drag.active: dragFromFrame.drag.active

        x: 0
        y: 0

        property bool dragging: false

        MultiResolutionImage {
            source: inventoryId ? "../../assets/inventory/"+inventoryId+".png" : '';
            anchors.fill: activeInventory;
        }

        states: [
            State {
                when: activeInventory.dragging
                PropertyChanges {target: frameBackground; opacity: .4}
            }
        ]
    }

    MouseArea {
        id: dragFromFrame
        anchors.fill: parent

        Component.onCompleted: reset()

        onClicked: {
           inventoryPanel.show();
        }

        onPressed: {
            roomScene.dragActiveInventory.inventoryId = inventoryId;
            roomScene.dragActiveInventory.visible = true;
            activeInventory.dragging = true;
        }
        onReleased: {
            activeInventory.dragging = false;
            roomScene.dragActiveInventory.dropped();
            roomScene.dragActiveInventory.visible = false;
            reset();
        }
        onPositionChanged: follow(mouse);


        function follow(mouse){
            activeInventory.x = mouse.x - activeInventory.width/2;
            activeInventory.y = mouse.y - activeInventory.height/2;

            var drag = roomScene.dragActiveInventory;
            var vp = mapToItem(roomScene, activeInventory.x, activeInventory.y);
            drag.x = vp.x + 5;
            drag.y = vp.y + activeInventory.height - 5;
        }

        function reset() {
            activeInventory.x = 0;
            activeInventory.y = 0;

            var drag = roomScene.dragActiveInventory;
            var vp = mapToItem(roomScene, 5, 5);
            drag.x = vp.x;
            drag.y = vp.y + activeInventory.height - 5;

        }
    }
}

