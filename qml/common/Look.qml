import VPlay 2.0
import QtQuick 2.4
import "../common"
import "../interface"


//{inventoryId, vertices or x/y/width/height}
//Take: tap area, show dismissable message panel
InteractableBase {
    id: lookInteractable

    property string message: '';

    onTap: {
        panelLoader.source = "../interface/MessagePanel.qml";
        activePanel.message = message;
    }

}
