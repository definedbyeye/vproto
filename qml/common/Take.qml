import VPlay 2.0
import QtQuick 2.4
import "../common"
import "../interface"


//{inventoryId, vertices or x/y/width/height}
//Take: tap area, show dismissable message panel
InteractableBase {
    id: takeInteractable

    property string inventoryId: '';

    signal takeIt()
    signal leaveIt()

    onTakeIt: {
        inventoryPanel.addInventory(inventoryId);
    }

    onTap: {
        panelLoader.source = "../interface/InspectPanel.qml";
        activePanel.inventoryId = inventoryId;
    }

    Connections {
        target: activePanel !== undefined ? activePanel : null
        onTakeIt: {
            console.log('take it!');
            takeInteractable.takeIt();
            activePanel.closePanel();
        }
        onLeaveIt: {
            console.log('leave it!');
            activePanel.closePanel();
        }
        onClose: {
            //panel removes itself after signaling close
        }
    }

}
