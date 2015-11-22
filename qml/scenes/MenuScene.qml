import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: menuScene

    height: 320
    width: 480

    signal newGamePressed
    signal continueGamePressed
    signal creditsPressed

    MultiResolutionImage {
        source: "../../assets/background/bg_loading_screen.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    // the game name
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30
        font.pixelSize: 30
        color: "#e9e9e9"
        text: "My Prototype Game"
    }

    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10

        MenuButton {
            text: "New Game"
            onClicked: newGamePressed()
        }
        MenuButton {
            text: "Continue Game"
            onClicked: continueGamePressed()
        }
        MenuButton {
            text: "Road Map"
            onClicked: creditsPressed()
        }

    }

    onNewGamePressed: {
        storage.newGame();
        gameWindow.state = "game";
        gameScene.init();
    }
    onContinueGamePressed: {
        //TODO: should continue the game with the most recent timestamp
        storage.loadGame();
        gameWindow.state = "game"
        gameScene.init();
    }

    onCreditsPressed: {
        gameWindow.state = "credits"
    }

    onBackButtonPressed: {
        nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
    }

    // listen to the return value of the MessageBox
    Connections {
        target: nativeUtils
        onMessageBoxFinished: {
            if(accepted)
                Qt.quit()
        }
    }
}
