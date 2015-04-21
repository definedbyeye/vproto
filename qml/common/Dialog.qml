import VPlay 2.0
import QtQuick 2.4
import "../common"
import "../interface"


//{inventoryId, vertices or x/y/width/height}
//Take: tap area, show dismissable message panel
InteractableBase {
    id: lookInteractable

    property var activePanel: null;

    property var dialog: [];

    //char1, left, image, message
    //char2, right, image, message
    //char1, left, 3 options

    /*{
        characterImage: '' //character dialog
        message: '',
        orientation: 'topLeft',
        options: [{
             text: '',
             toTopic: dialogIndex,
        }]
    }*/

    states: [
        State {
            name: "name"
            PropertyChanges {
                target: object

            }
        }
    ]


    onTap: {
        panelManager.createItemFromUrl(Qt.resolvedUrl("../interface/Dialog.qml"));
        //TODO: need states
        activePanel = panelManager.getLastAddedEntity();
    }

    Connections {
        target: activePanel !== undefined ? activePanel : null
        onClose: {
            //panel removes itself after signaling close
        }
    }

}
