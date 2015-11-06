import VPlay 2.0
import QtQuick 2.0

EntityBase {
    entityId: 'testBlock'
    entityType: 'testBlock'
    property string color: 'blue'
    Rectangle {
        width: stepSize
        height: stepSize
        color: parent.color
    }
}


