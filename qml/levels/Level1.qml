import VPlay 2.0
import QtQuick 2.0
import "../entities"
import "." as Levels

Levels.LevelBase {
    id: level

    // we need to specify the width to get correct debug draw for our physics
    // the PhysicsWorld component fills it's parent by default, which is the viewPort Item of the gameScene and this item uses the size of the level
    // NOTE: thy physics will also work without defining the width here, so no worries, you can ignore it untill you want to do some physics debugging
    width: 1140

    signal clicked()

    MultiResolutionImage {
        source: "../../assets/background/bg_testing_tables.png"
    }

    MouseArea {
        anchors.fill: level
        onClicked: {            
            firstPlayer.move(mouseX, mouseY)
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
            Qt.point(840, 241), // bottom right
            Qt.point(840, 236) // top right
        ]
    }

    Wall {
        id: rightWall
        vertices: [
            Qt.point(1135, 200), // top left
            Qt.point(1135, 365), // bottom left
            Qt.point(840, 360), // bottom right
            Qt.point(840, 200) // top right
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
