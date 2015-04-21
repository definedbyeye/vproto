import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

Item {
    id: inventoryPanel

    width: gameScene.width
    height: gameScene.height

    x: 0
    y: 0 - height
    z: 1001

    property string descriptionText: ''

    //set save to false on initial load
    function addInventory(inventoryId, save) {
        save = (save !== false);
        var existingInv = inventoryManager.getEntityById(inventoryId);
        if(!existingInv) {
            var invItem = storage.getInventoryItem(inventoryId);
            inventoryManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("../common/InventoryBase.qml"), invItem);
            if(save){                
                storage.saveState('inventory', inventoryId, '');
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onReleased: {
            show = false
        }
    }

    PropertyAnimation { id: showPanel; target: inventoryPanel; property: "y"; to: 0; duration: 700; easing.type: Easing.InOutCubic; }
    PropertyAnimation { id: hidePanel; target: inventoryPanel; property: "y"; to: 0-height; duration: 1500; easing.type: Easing.OutBack; }

    property bool show: false

    onShowChanged: {
        if(show) {
            hidePanel.running = false;
            showPanel.running = true;
        } else {
            showPanel.running = false;
            hidePanel.running = true;
            inventoryPanel.descriptionText = '';
        }
    }

    Rectangle {
        color: "#cccccc"
        anchors.centerIn: parent
        width: parent.width - 100
        height: parent.height - 100

        EntityManager {
            id: inventoryManager
            entityContainer: inventoryGrid
            dynamicCreationEntityList: []
        }

        Text {
            text: "Inventory Window"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.topMargin: 10
        }

        Text {
            id: description
            text: inventoryPanel.descriptionText
            height: 20
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
        }

        ScrollViewVPlay {
            id: scrollView
            anchors.fill: parent
            anchors.topMargin: 30
            anchors.leftMargin: 20
            anchors.rightMargin: 100
            anchors.bottomMargin: 40

            flickableItem.interactive: true
            frameVisible: true
            flickableItem.flickableDirection: Flickable.VerticalFlick                    

            GridLayout {
                id: inventoryGrid                                
                width: scrollView.width-10
            }
        }
    }

}
