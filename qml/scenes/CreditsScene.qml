import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id:creditsScene

    height: 320
    width: 480

    anchors.centerIn: parent.gameWindowAnchorItem

    onBackButtonPressed: {
        gameWindow.state = "menu";
    }

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#1161b0"
    }

    Text {
        anchors.top: gameWindowAnchorItem.top
        anchors.left: gameWindowAnchorItem.left
        anchors.margins: 10
        text: "Roadmap"
        font.pixelSize: 18
        color: "white"
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: backButtonPressed()
    }



    // roadmap
    ScrollViewVPlay {
        anchors.fill: gameWindowAnchorItem
        anchors.margins: 20
        anchors.topMargin: 50
        anchors.rightMargin: 80
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        Text {
        color: "white"
        font.pixelSize: 9

        text: "
            <h3>Features To Do</h3
            <ol>
                <li>---- \"Look\" + dialog</li>
                <li>---- \"Use\" + dialog</li>
                <li>---- Pick up item flow (move, dialog, leave/take, grab+stow)</li>
                <li>---- Active item gui</li>
                <li>---- Use item on interact area</li>
                <li>Save Game library</li>
                <li>Conversation dialogs + profile shots (in progress)</li>
                <li>---- Parallax backgrounds</li>
                <li>Background sound effects with sound toggle icon</li>
                <li>Use inventory on other inventory?</li>
                <li>Swap character</li>
                <li>Sprite character animations</li>
                <li>Closeup shot of interactive area</li>
            </ol>

            <h3>UI</h3>
            <ol>
                <li>Tap to interact</li>
                <li>Long tap to look</li>
                <li>Press and hold to open context menu (or swipe to shortcut)</li>
                <li>Context ring opens after a spell is learned.  Spells on top, look/interact on bottom</li>
            </ol>

            <ol>
                <li>Water (affects liquids): make solid, move/boil, make gas</li>
                <li>Fire (affects heat, light): diminish, move/refract, burn/light</li>
                <li>Air: calm, move/levitate, raise wind</li>
                <li>Earth: ?, move, ?</li>
                <li>Two levels, second unlocked later in the game as an extra ring around the context menu.</li>
            </ol>
"

    }
    }
}
