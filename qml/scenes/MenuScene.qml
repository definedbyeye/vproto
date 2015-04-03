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

  // the "logo"
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
}
