import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

PanelBase {
    id: messagePanel

    property string message: 'default text';

    anchors.fill: parent

    Rectangle {
        id: dialogFrame
        color: "#cccccc"

        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.verticalCenter;
        anchors.bottom: parent.bottom;
        anchors.margins: 40

        ScrollViewVPlay {
            id: scrollView
            anchors.fill: parent
            anchors.margins: 10

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

}
