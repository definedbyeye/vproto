import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

PanelBase {
    id: inspectPanel

    property string inventoryId;

    onInventoryIdChanged: {
        var inventoryItem = storage.getInventoryItem(inventoryId);
        if(inventoryItem){
            name = inventoryItem.name
            message = inventoryItem.description
        }
    }

    Rectangle {
        id: messageFrame
        color: "#cccccc"

        anchors.left: parent.left;
        anchors.leftMargin: 40;
        anchors.right: parent.right;
        anchors.rightMargin: 40;
        anchors.top: parent.verticalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 40

        Rectangle {
            id: imageFrame

            width: 70;
            height: 70;
            color: "#ccc";

            x: - 10
            y: -imageFrame.height/3;

            MultiResolutionImage {
                source: inventoryId ? "../../assets/inventory/"+inventoryId+".png" : '';
                width: 60;
                height: 60;
                anchors.centerIn: parent
            }
        }

        Text {
            text: name
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: imageFrame.width + 5
            anchors.topMargin: 5
        }


        ScrollViewVPlay {
            id: scrollView
            anchors.fill: parent
            anchors.topMargin: title ? 25 : 10
            anchors.leftMargin: imageFrame.width + 5
            anchors.rightMargin: 10
            anchors.bottomMargin: 10

            flickableItem.interactive: true
            frameVisible: true
            flickableItem.flickableDirection: Flickable.VerticalFlick

            Text {
                text: message
                anchors.top: parent.top
                anchors.left: parent.left
                color: '#000'
            }

        }

        Button {
            y: 90
            x: 30
            text: "Leave it"
            onClicked: panelOpt1()
        }

        Button {
            y: 90
            x: 150
            text: "Take it"            
            onClicked: {inventoryPanel.addInventory(inventoryId); panelOpt2();}
        }

    }

}
