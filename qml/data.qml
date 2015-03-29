import QtQuick 2.0
import VPlay 2.0

Item {

    function init(){
        inventoryLookup.loadInventory()
        gameState.loadGame(1)
    }

    function loadInventory() {
        inventoryLookup.setValue(1, {id: 1, name: "Water Glass", description: "An empty glass"})
    }

    function getInventory(id) {
        return inventoryLookup.getValue(1)
    }

    function saveGame() {
        gameState.playerX = firstPlayer.x
        gameState.playerY = firstPlayer.y
        gameState.inventory = "" //stub
        saveGames.setValue(gameState.id, gameState);
    }

    function loadGame(id) {
        gameState.state = saveGames.getValue(id)
    }

    Storage {
        id: inventoryLookup
    }

    Storage {
        id: saveGames
    }

    Item {
        id: gameState
        property int id: 1
        property int room: 1
        property string shortName: "Sample Save"
        property real playerX: 0
        property real playerY: 0
        property string inventory: ""
    }

}


/*
save game id, name, screencap
    room id
    player id, x, y
    inventory [id's, states]
    story event states
*/
