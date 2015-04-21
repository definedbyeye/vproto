import QtQuick 2.0
import VPlay 2.0
import QtQuick.LocalStorage 2.0

Item {
    id: storage

    //TODO: error handling

    property int quickSaveId: 1
    property bool dbInit: false

    //opens db and ensures all tables are created
    function openDb() {
        var db = LocalStorage.openDatabaseSync("ProtoStorage", "1.0", "Proto Game Storage", 1000000);
        if(!dbInit) {
            createTables(db);
            preloadInventoryItems(db)
            storage.dbInit = true;
        }
        return db;
    }

    function createTables(db) {
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS SaveStates(name TEXT, playerId TEXT, roomId TEXT, x REAL, y REAL, created INTEGER, updated INTEGER)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS InteractStates(saveId INTEGER, interactId TEXT, state TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS InventoryStates(saveId INTEGER, inventoryId TEXT, state TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS EventStates(saveId INTEGER, eventId TEXT, state TEXT)');

            tx.executeSql('CREATE TABLE IF NOT EXISTS InventoryItems(inventoryId TEXT, name TEXT, description TEXT)');
        });
    }

    function preloadInventoryItems(db) {
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT ROWID FROM InventoryItems');
            if(result.rows.length !== 1) {
                console.log('--- inventoryId count did not = 3: '+result.rows.length);
                var inventoryItems = [
                        {inventoryId: 'emptyGlass', name: 'Empty Glass', description: 'This glass is empty.'},
                        {inventoryId: 'fullGlass', name: 'Glass of Water', description: 'This glass is half full.'},
                        {inventoryId: 'scissors', name: 'Scissors', description: 'Sharp blue scissors.'}
                        ];
                tx.executeSql('DELETE FROM InventoryItems');

                var qry = 'INSERT INTO InventoryItems SELECT "'+
                        inventoryItems[0].inventoryId+'" as inventoryId, "'+
                        inventoryItems[0].name+'" as name, "'+
                        inventoryItems[0].description+'" as description ';
                for(var i = 1; i < inventoryItems.length; i++) {
                    qry += ' UNION SELECT "'+
                            inventoryItems[i].inventoryId+'", "'+
                            inventoryItems[i].name+'", "'+
                            inventoryItems[i].description+'"'
                }
                tx.executeSql(qry);
            }
        });
    }

    function getInventoryItem(inventoryId) {
        var inv = false;
        var db = openDb();
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM InventoryItems WHERE inventoryId = "'+inventoryId+'"');                       
            inv = result.rows.item(0);
        });
        return inv;
    }

    function savePlayerId(pId) {
        var db = openDb();
        db.transaction(function(tx) {
            var qry = 'UPDATE SaveStates SET playerId = "'+pId+'" WHERE ROWID = '+storage.quickSaveId;
           tx.executeSql(qry);
        });
    }

    function saveRoomId(rId) {
        var db = openDb();
        db.transaction(function(tx) {
            var qry = 'UPDATE SaveStates SET roomId = "'+rId+'" WHERE ROWID = '+storage.quickSaveId;
           tx.executeSql(qry);
        });
    }

    function savePlayerPoint(point) {
        var db = openDb();
        db.transaction(function(tx) {
            var qry = 'UPDATE SaveStates SET x = '+point.x+', y = '+point.y+' WHERE ROWID = '+storage.quickSaveId;
           tx.executeSql(qry);
        });
    }

    function getPlayerState(db) {
        var saveState = false;
        db = db || openDb();
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM SaveStates WHERE ROWID = ' + storage.quickSaveId);
            if(result.rows.length) {
                saveState = result.rows.item(0);
            }
        });
        return saveState;
    }

    function saveState (entity, id, state, db) {
        db = db || openDb();
        var tableName = entity.charAt(0).toUpperCase() + entity.slice(1) + 'States';
        db.transaction(function(tx) {                        
            var result = tx.executeSql('SELECT *, rowid FROM '+tableName+' WHERE saveId = '+storage.quickSaveId+' AND '+entity+'Id = "'+id+'"');
            if(result.rows.length) {            
                tx.executeSql('UPDATE '+tableName+' SET saveId='+storage.quickSaveId+', '+entity+'Id="'+id+'", state="'+state+'" WHERE ROWID='+result.rows.item(0).rowid);
            } else {
                tx.executeSql('INSERT INTO '+tableName+' VALUES (?, ?, ?)', [storage.quickSaveId, id, state]);
            }
        });
    }

    function loadState (entity, id, state, db) {
        db = db || openDb();
        var tableName = entity.charAt(0).toUpperCase() + entity.slice(1) + 'States';
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM '+tableName+' WHERE saveId = '+storage.quickSaveId+' AND '+entity+'Id = '+id);
            if(result.rows.length){
                return result.rows.item(0).state;
            }
        });
        return false;
    }

    //newGame resets quickSave
    //TODO: warning that all progress will be lost
    function newGame(db) {
        db = db || openDb();

        deleteSave(storage.quickSaveId, db);

        db.transaction(function(tx) {
            tx.executeSql('INSERT INTO SaveStates (ROWID, name, playerId, roomId, x, y, created, updated) VALUES (?,?,?,?,?,?,?,?)', [
                              storage.quickSaveId,
                              "Quick Save",
                              'mainPlayer',
                              'room1',
                              200,
                              120,
                              Date.parse(Date()),
                              Date.parse(Date())
                          ]);
        });    

    }

    function continueGame(db) {
        db = db || openDb()
    }

    //loadGame loads a copy into the quickSave
    //TODO: warning that all progress will be lost
    //TODO: loadgame should not be available under certain conditions....
    function loadGame(id, db) {
        id = id || storage.quickSaveId;
        db = db || openDb()

        //check that quicksave exists, else create new game
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM SaveStates WHERE ROWID = '+storage.quickSaveId);
            if(result.rows.length < 1){
                newGame(db);
            }
        });

        //default inventory
        storage.saveState('inventory', 'emptyGlass', '', db);
        storage.saveState('inventory', 'fullGlass', '', db);
        storage.saveState('inventory', 'scissors', '', db);
    }

    //returns a collection of inventory ID's and states that are currently in the player's inventory
    function getInventoryState(db){
        var invItems = [];
        db = db || openDb();
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM InventoryStates WHERE saveId = ' + storage.quickSaveId);
            if(result.rows.length) {
                for(var i=0; i < result.rows.length; i++){
                    invItems.push(result.rows.item(i))
                }
            }
        });
        return invItems;

    }

    //saveGame makes a copy out of the quickSave
    function saveGame(id, db) {
        id = id || 0;
        copySaveStates(storage.quickSaveId, id, db)
    }

    function deleteSave(saveId, db) {
        db = db || openDb();
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM SaveStates WHERE ROWID = ' + saveId);
            tx.executeSql('DELETE FROM InteractStates WHERE saveId = ' + saveId);
            tx.executeSql('DELETE FROM InventoryStates WHERE saveId = ' + saveId);
            tx.executeSql('DELETE FROM EventStates WHERE saveId = ' + saveId);
        });
    }

    function copySaveStates(fromId, toId, db) {
        db = db || openDb();
        var result, i, qry;

        db.transaction(function(tx) {

            if(!toId){
                result = tx.executeSql('SELECT * FROM SaveStates WHERE saveId = ' + fromId);
                if(result.rows.length){
                    tx.executeSql('INSERT INTO SaveStates VALUES (?,?,?,?,?,?,?,?)',
                                  result.rows.item(0),
                                  function(tx, results){
                                      toId = results.insertId;
                                  });
                } else {
                    return false;
                }
            }

            result = tx.executeSql('SELECT * FROM InteractStates WHERE saveId = ' + fromId);
            if(result.rows.length){
                qry = 'INSERT INTO InteractStates SELECT "'+result.rows.item(0).interactId+'" as interactId, "'+result.rows.item(0).state+'" as state';
                for(i = 1; i < result.rows.length; i++) {
                    qry += ' UNION SELECT "'+result.rows.item(i).interactId+'", "'+result.rows.item(i).state+'"';
                }
                tx.executeSql(qry);
            }

            result = tx.executeSql('SELECT * FROM InventoryStates WHERE saveId = ' + fromId);
            if(result.rows.length){
                qry = 'INSERT INTO InventoryStates SELECT "'+result.rows.item(0).inventoryId+'" as inventoryId, "'+result.rows.item(0).state+'" as state';
                for(i = 1; i < result.rows.length; i++) {
                    qry += ' UNION SELECT "'+result.rows.item(i).inventoryId+'", "'+result.rows.item(i).state+'"';
                }
                tx.executeSql(qry);
            }

            result = tx.executeSql('SELECT * FROM EventStates WHERE saveId = ' + fromId);
            if(result.rows.length){
                qry = 'INSERT INTO EventStates SELECT "'+result.rows.item(0).eventId+'" as eventId, "'+result.rows.item(0).state+'" as state';
                for(i = 1; i < result.rows.length; i++) {
                    qry += ' UNION SELECT "'+result.rows.item(i).eventId+'", "'+result.rows.item(i).state+'"';
                }
                tx.executeSql(qry);
            }

        });

    }

}
