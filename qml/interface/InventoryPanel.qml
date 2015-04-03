import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

Rectangle {
    id: inventoryPanel

    function addInventory(id) {
        var invItem = storage.getInventory(id);
        if(invItem) {
            inventoryManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("InventoryItem.qml"), invItem)
        }
    }
    color: "#cccccc"
    x: 50
    y: 0 - height
    z: 1001

    EntityManager {
      id: inventoryManager
      entityContainer: inventoryGrid
      dynamicCreationEntityList: []
    }

    Button {
        property int count: 1;
        anchors.right: inventoryPanel.right
        text: "Add Inventory"
        onClicked: {
            console.log('clicked');
            inventoryManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("InventoryItem.qml"),
                        {"color": "green", "entityId": "i"+count, "text": count, "width": "50"}
                        )
            count++
        }
        z: 2000
    }

    PropertyAnimation { id: showPanel; target: inventoryPanel; property: "y"; to: 50; duration: 700; easing.type: Easing.InOutCubic; }
    PropertyAnimation { id: hidePanel; target: inventoryPanel; property: "y"; to: 0-height; duration: 1500; easing.type: Easing.OutBack; }

    property bool show: false

    onShowChanged: {
        if(show) {
            hidePanel.running = false;
            showPanel.running = true;
        } else {
            showPanel.running = false;
            hidePanel.running = true;
        }
    }

    MouseArea {
        anchors.fill: inventoryPanel

        property point pressed: Qt.point(0,0)

        onPressed: {pressed = Qt.point(mouse.x, mouse.y)}
        onReleased: {
            if(Math.abs(mouse.y-pressed.y) > 10){
                show = false
            }
        }
    }

    Text {
        text: "Inventory Window"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10
    }

    ScrollViewVPlay {
        anchors.fill: parent
        anchors.topMargin: 30
        anchors.leftMargin: 20
        anchors.rightMargin: 60
        anchors.bottomMargin: 20

        flickableItem.interactive: true
        frameVisible: true
        flickableItem.flickableDirection: Flickable.VerticalFlick

        GridLayout {
            id: inventoryGrid
            columns: 4
            width: 300
            height: 300
        }
    }

}
