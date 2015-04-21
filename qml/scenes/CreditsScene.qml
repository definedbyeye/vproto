import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id:creditsScene

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#1161b0"
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: creditsScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: creditsScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: backButtonPressed()
    }

    // roadmap
    Text {
        color: "white"
        anchors.centerIn: parent
        font.pixelSize: 10
        text: "
            <h3>Features To Do</h3
            <ol>
                <li>\"Look\" + dialog</li>
                <li>\"Use\" + dialog</li>
                <li>Pick up item flow (move, dialog, leave/take, grab+stow)</li>
                <li>Active item gui</li>
                <li>Use item on interact area</li>
                <li>Save Game library</li>
                <li>Conversation dialogs + profile shots</li>
                <li>Parallax backgrounds</li>
                <li>Background sound effects with sound toggle icon</li>
                <li>Use inventory on other inventory?</li>
                <li>Swap character</li>
                <li>Sprite character animations</li>
                <li>Closeup shot of interactive area</li>
                <li></li>
            </ol>

            <h3>Prototype Game To Do</h3
            <ol>
                <li>Rope physics?</li>
                <li>Untie rope (use interact area)</li>
                <li>Cut rope (use inventory on interact area)</li>
                <li>item 4</li>
            </ol>
"

    }
}
