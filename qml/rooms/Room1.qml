import VPlay 2.0
import QtQuick 2.0
import "../entities"
import "../common"

RoomBase {
    id: room1

    height: 360
    width: 1140

    //state machine this so player can enter from multiple points
    property point defaultPlayerPoint: Qt.point(200,120);
    property real defaultOffset: 0

    Component.onCompleted: {
        /*
        viewPort.anchors.top = undefined;
        viewPort.anchors.right = undefined;
        viewPort.anchors.bottom = gameScene.gameWindowAnchorItem.bottom;
        viewPort.anchors.left = gameScene.gameWindowAnchorItem.left;
        */
        viewPort.x = defaultOffset
        viewPort.anchors.bottom = gameScene.gameWindowAnchorItem.bottom;
    }

    MultiResolutionImage {
        source: "../../assets/background/bg_testing_tables.png"
    }

    Loader {
        id: glass
        x: 310
        y: 168
        source: "../entities/Hotspot1.qml"
    }

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
