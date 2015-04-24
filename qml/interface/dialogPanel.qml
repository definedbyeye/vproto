import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

PanelBase {
    id: dialogPanel

    //properties
    onOrientationChanged: console.log('--- new orientation: '+orientation);
    onProfileChanged: console.log('--- new profile: '+profile);

    //TODO: autoAdvance

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

        Rectangle {
            Component.onCompleted: console.log('width height: '+width+' '+height);
            id: imageFrame

            width: 100;
            height: 200;
            //color: "lightgreen";

            x: orientation === 'left' ? -10 : 300
            y: -imageFrame.height/3;


            MultiResolutionImage {
                source: profile ? '../../assets/player/'+profile+'.png' : ''
                width: 23;
                height: 50;
                anchors.top: imageFrame.top
                anchors.left: imageFrame.left
            }

        }

        Text {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: imageFrame.width + 5
            anchors.topMargin: 5
        }


        ScrollViewVPlay {
            id: scrollView
            anchors.fill: parent
            anchors.topMargin: name ? 25 : 10
            anchors.leftMargin: orientation === 'left' ? imageFrame.width + 5 : 10
            anchors.rightMargin: orientation !== 'left' ? imageFrame.width + 5 : 10
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
            id: opt1
            x: 0
            y: 90
            visible: (!!opt1Message)
            text: opt1Message
            onClicked: {activePanel.close(); panelOpt1()}
        }

        Button {
            id: opt2
            x: 50
            y: 90
            visible: (!!opt2Message)
            text: opt2Message
            onClicked: {activePanel.close(); panelOpt2()}
        }

        Button {
            id: opt3
            x: 100
            y: 90
            visible: (!!opt3Message)
            text: opt3Message
            onClicked: {activePanel.close(); panelOpt3()}
        }

        Button {
            id: opt4
            visible: (!!opt4Message)
            text: opt4Message
            onClicked: {activePanel.close(); panelOpt4()}
        }

        Button {
            x: 150
            y: 90
            id: opt5
            visible: (!!opt5Message)
            text: opt5Message
            onClicked: {activePanel.close(); panelOpt5()}
        }

        Button {
            id: optCancel
            x: 200
            y: 90
            visible: (!!optCancelMessage)
            text: optCancelMessage
            onClicked: {activePanel.close(); panelOptCancel()}
        }


    }


    function next(){
        setDialog(activeDialog + 1);
    }

    function prev() {
        setDialog(activeDialog - 1);
    }
}
