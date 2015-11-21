import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

Item {
    id: inventoryPanel

    width: screen.width
    height: screen.height

    x: 0
    y: 0 - height
    z: 1001

    property string descriptionText: ''    

    MouseArea {
        anchors.fill: parent
        onReleased: hide()
    }

    PropertyAnimation { id: showPanel; target: inventoryPanel; property: "y"; to: 0; duration: 700; easing.type: Easing.InOutCubic; }
    PropertyAnimation { id: hidePanel; target: inventoryPanel; property: "y"; to: 0-height; duration: 1500; easing.type: Easing.OutBack; }

    signal hide
    signal show

    onHide: {
        showPanel.running = false;
        hidePanel.running = true;
        inventoryPanel.descriptionText = '';
    }

    onShow: {
        hidePanel.running = false;
        showPanel.running = true;
    }

    //TODO: fix the background here so that it fills the screen and only the frame animates in

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

    //set save to false on initial load
    function addInventory(inventoryId, save) {
        save = (save !== false);
        var existingInv = inventoryManager.getEntityById(inventoryId);
        if(!existingInv) {
            var invItem = storage.getInventoryItem(inventoryId);

            inventoryManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("../common/InventoryBase.qml"), invItem);

            console.log('------- last added: '+inventoryManager.getLastAddedEntity().entityId);

            activeInventoryFrame.inventoryId = inventoryId;

            if(save){
                storage.saveState('inventory', inventoryId, '');
            }
        }
    }

    function removeInventory(inventoryId, save) {
        save = (save !== false);
        if(inventoryManager.removeEntityById(inventoryId) && save) {
            storage.removeState('inventory', inventoryId);
        }
        if(activeInventoryFrame.inventoryId === inventoryId){
            activeInventoryFrame.inventoryId = '';
        }
    }

}
