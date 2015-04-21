import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

PanelBase {
    id: dialogPanel


    //state for image and description?  click to advance state, or auto-advance speed (per settings)
    /*{
        message: optional,  //simple look
        orientation: 'topLeft',

        characterImage: '' //character dialog
        options: [{
             text: '',
             toTopic: dialogIndex,
        }]
    }*/
    property var dialog: []
    property int activeDialog: '';

    //properties
    property string orientation: 'topLeft'
    property string title: '';    
    property string message: ''

    property string imageSource: '';
    property int imageHeight: 0;
    property int imageWidth: 0;

    //autoAdvance

    Rectangle {
        id: dialogFrame
        color: "#cccccc"

        anchors.left: parent.left;
        anchors.leftMargin: 40;
        anchors.right: parent.right;
        anchors.rightMargin: 40;
        anchors.top: parent.verticalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 40

        //only used for dialogs and inventory, optional for messages
        Rectangle {
            id: imageFrame

            width: imageWidth ? Math.min(imageWidth+10, 100) : 0;
            height: imageHeight ? Math.min(imageHeight+10, 200) : 0;
            color: "#ccc";

            x: - 10
            y: -imageFrame.height/3;

            MultiResolutionImage {
                source: imageSource;
                width: imageWidth;
                height: imageHeight;
                anchors.centerIn: parent
            }
        }

        Text {
            text: title
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
    }


    function next(){
        setDialog(activeDialog + 1);
    }

    function prev() {
        setDialog(activeDialog - 1);
    }


    /*{
        orientation: 'topLeft',

        inventoryId: optional,  //inventory panel

        characterImage: '' //character dialog
        message: optional,
        options: [{
             text: '',
             toIndex: dialogIndex,
        }]
    }*/

    function setDialog(index){
        var d = dialog[index];
        if(activeDialog !== index && d) {
            activeDialog = index;

            orientation = d.orientation || d;

            message = d.message || message;

            if(d.characterImage) {
                imageSource = d.characterImage;
                imageWidth = 100;
                imageHeight = 200;
            }

            if(options && options.length){

            }


        }
    }

}
