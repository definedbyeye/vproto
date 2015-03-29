import VPlay 2.0
import QtQuick 2.4

Rectangle {

    width: 5
    height: 5
    color: "blue";

    property int id: 0
    property string name: ""
    property string description: ""

    Text {
        text: parent.name
    }

}

