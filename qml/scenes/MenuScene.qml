import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: menuScene

    signal newGamePressed
    signal continueGamePressed
    signal creditsPressed

    MultiResolutionImage {
        source: "../../assets/background/bg_loading_screen.jpg"
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
            text: "Credits"
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

    onBackButtonPressed: {
        nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
    }

    // listen to the return value of the MessageBox
    Connections {
        target: nativeUtils
        onMessageBoxFinished: {
            // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
            if(accepted && window.activeScene === menuScene)
                Qt.quit()
        }
    }
}
