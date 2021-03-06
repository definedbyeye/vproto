import VPlay 2.0
import QtQuick 2.0
import "../interactables"
import "../common"

RoomBase {
    id: room2

    height: 360
    width: 1140

    property alias playerSkin: playerSkin

    //define all entrance points
    property var entrances: {'default': Qt.point(200,300), 'right':Qt.point(900,300)}
    property point defaultOffset: Qt.point(-(room2.width - screen.width), 0);

    property real minPerspective: .1
    property real maxPerspective: 1

    PlayerSkin {
        id: playerSkin
        z: 50
    }

    MultiResolutionImage {
        source: "../../assets/background/bg_testing_tables.png"
    }

    Loader {
        id: glass
        x: 310
        y: 160
        source: "../interactables/Interact1.qml"
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
