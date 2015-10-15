import VPlay 2.0
import QtQuick 2.0
import "../interface"

EntityBase {
    entityId: inventoryId
    entityType: 'inventory'

    height: 60
    width: 60

    property string inventoryId: ''
    property string name: ''
    property string description: ''

    MultiResolutionImage {
        source: '../../assets/inventory/dropShadow.png';
        width: 48
        height: 7
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MultiResolutionImage {
        source: '../../assets/inventory/'+inventoryId+'.png';
        anchors.centerIn: parent
        width: 50;
        height: 50;
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        //onPressed: inventoryPanel.descriptionText = description;
        onPressed: {activeInventoryFrame.inventoryId = inventoryId; inventoryPanel.hide()}
        onEntered: inventoryPanel.descriptionText = description;
    }
}




