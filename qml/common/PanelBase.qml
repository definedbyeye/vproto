import VPlay 2.0
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "../common"

Item {
    id: panel

    anchors.fill: parent

    signal panelOpt1
    signal panelOpt2
    signal panelOpt3
    signal panelOpt4
    signal panelOpt5
    signal close

    Rectangle {
        anchors.fill: parent
        color: "#000";
        opacity: .2;
    }

    MouseArea {
        anchors.fill: parent
        onReleased: {
            closePanel();
        }
    }

    function closePanel() {
        close();        
    }

}
