import VPlay 2.0
import QtQuick 2.0
import "../interactables"
import "../common"

RoomBase {
    id: room1

    height: 360
    width: 1140

    // TODO: allow player to enter from multiple points
    property point defaultPlayerPoint: Qt.point(200,120);
    property real defaultOffset: 0

    Component.onCompleted: {
        viewPort.x = defaultOffset
        viewPort.anchors.bottom = gameScene.gameWindowAnchorItem.bottom;
    }

    // background
    MultiResolutionImage {        
        source: "../../assets/background/bg_testing_tables.png"
    }

    // interaction areas
    // currently loads 1 per qml
    /*
    Loader {
        id: glass
        x: 310
        y: 168
        source: "../interactables/Interact1.qml"
    }
    */

    Look {
        areaVertices: [Qt.point(0,0), Qt.point(150, 0), Qt.point(100, 100), Qt.point(0, 200)]
        message: "This is only a test... bzzzzzp...."
    }

    Take {
        inventoryId: 'emptyGlass'
        x: 310
        y: 168
        width: 32
        height: 48
        boxColor: '#cc0011'
    }



    //Action Sequence
    //Item {

   // inventoryManager.createItemFromUrlWithProperties(
     //           Qt.resolvedUrl("../common/InventoryBase.qml"), invItem);

        //ex: throw something out the window

        //drop inventory on interactable
        //move to point
        //stub animation
        //message
    //}



    // transition areas
    Area {
        id: leftArea
        vertices: [
            Qt.point(240, 236), // top left
            Qt.point(-5, 365), // bottom left
            Qt.point(50, 360), // bottom right
            Qt.point(245, 236) // top right
        ]

        onEntered: {
            goToRoomId = 'room2'
            fromAreaId= 'leftArea'
        }
    }


    // walkable area boundaries
    Wall {
        id: leftWall
        vertices: [
            Qt.point(240, 236), // top left
            Qt.point(-5, 365), // bottom left
            Qt.point(0, 360), // bottom right
            Qt.point(245, 236) // top right
        ]
    }

    Wall {
        id: topWall
        vertices: [
            Qt.point(238, 236), // top left
            Qt.point(238, 241), // bottom left
            Qt.point(905, 241), // bottom right
            Qt.point(905, 236) // top right
        ]
    }

    Wall {
        id: rightWall
        vertices: [
            Qt.point(890, 235), // top left
            Qt.point(1150, 365), // bottom left
            Qt.point(1155, 365), // bottom right
            Qt.point(895, 235) // top right
        ]
    }

    Wall {
        id: bottomWall
        vertices: [
            Qt.point(-5, 355), // top left
            Qt.point(-5, 360), // bottom left
            Qt.point(1145, 360), // bottom right
            Qt.point(1145, 355) // top right
        ]
    }
}
