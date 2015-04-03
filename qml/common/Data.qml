import QtQuick 2.0
import VPlay 2.0
import QtQuick.LocalStorage 2.0

Item {

    //TODO: error handling

    property int quickSaveId: 1
    property bool dbInit: false

    property string playerId: ""
    property string roomId: ""
    property int playerX: 0
    property int playerY: 0

    //opens db and ensures all tables are created
    function openDb() {
        var db = LocalStorage.openDatabaseSync("ProtoStorage", "1.0", "Proto Game Storage", 1000000);
        if(!dbInit) {
            createTables(db);
            newGame(db);
        }
        return db;
    }

    function createTables(db) {
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS SaveStates(name TEXT, playerId TEXT, roomId TEXT, x INTEGER, y INTEGER, created INTEGER, updated INTEGER)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS HotspotStates(saveId INTEGER, hotspotId TEXT, state TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS InventoryStates(saveId INTEGER, inventoryId TEXT, state TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS EventStates(saveId INTEGER, eventId TEXT, state TEXT)');
        });
    }

    function savePlayerState(db) {
        db = db || openDb();
        db.transaction(function(tx) {
           tx.executeSql('UPDATE SaveStates SET playerId = "'+playerId+'", roomId = "'+roomId+'", x = '+playerX+', y = '+playerY+' WHERE ROWID = '+quickSaveId);
        });
    }

    function loadPlayerState(db) {
        db = db || openDb();
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM SaveStates WHERE ROWID = ' + quickSaveId);
            if(result.rows.length) {
                roomId = result.rows(0).roomId;
                playerId = result.rows(0).playerId;
                playerX = result.rows(0).playerX;
                playerY = result.rows(0).playerY;
            }
        });
    }

    function saveState (entity, id, state, db) {
        db = db || openDb();
        var tableName = entity.charAt(0).toUpperCase() + entity.slice(1) + 'States';
        db.transaction(function(tx) {            
            var result = tx.executeSql('SELECT * FROM '+tableName+' WHERE saveId = '+quickSaveId+' AND '+entity+'Id = '+id);
            if(result.rows.length) {
                tx.executeSql('UPDATE '+tableName+' SET saveId='+quickSaveId+', '+entity+'Id="'+id+'", state="'+state+'" WHERE ROWID='+result.rows.item(0).rowid);
            } else {
                tx.executeSql('INSERT INTO '+tableName+' VALUES (?, ?, ?)', [quickSaveId, id, state]);
            }
        });
    }

    function loadState (entity, id, state, db) {
        db = db || openDb();
        var tableName = entity.charAt(0).toUpperCase() + entity.slice(1) + 'States';
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM '+tableName+' WHERE saveId = '+quickSaveId+' AND '+entity+'Id = '+id);            
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
        var now = new Date('now');

        deleteSave(quickSaveId, db);

        roomId = 'room1';
        playerId = 'mainPlayer';
        playerX = 200;
        playerY = 120;

        db.transaction(function(tx) {
            tx.executeSql('INSERT INTO SaveStates (ROWID, name, playerId, roomId, x, y, created, updated) VALUES (?,?,?,?,?,?,?,?)', [
                              quickSaveId,
                              "Quick Save",
                              playerId,
                              roomId,
                              playerX,
                              playerY,
                              now.getMilliseconds(),
                              now.getMilliseconds()
                          ]);
        });
    }

    function continueGame(db) {
        db = db || openDb()
    }

    //loadGame loads a copy into the quickSave
    //TODO: warning that all progress will be lost
    function loadGame(id, db) {
        db = db || openDb()
        if(id !== quickSaveId) {
            deleteSave(quickSaveId, db);
            copySaveStates(id, quickSaveId, db);
            loadPlayerState(quickSaveId, db);
        }
    }

    //saveGame makes a copy out of the quickSave
    function saveGame(id, db) {
        id = id || 0;
        copySaveStates(quickSaveId, id, db)
    }

    function deleteSave(saveId, db) {
        db = db || openDb();
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM SaveStates WHERE ROWID = ' + saveId);
            tx.executeSql('DELETE FROM HotspotStates WHERE saveId = ' + saveId);
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

            result = tx.executeSql('SELECT * FROM HotspotStates WHERE saveId = ' + fromId);
            if(result.rows.length){
                qry = 'INSERT INTO HotspotStates SELECT "'+result.rows.item(0).hotspotId+'" as hotspotId, "'+result.rows.item(0).state+'" as state';
                for(i = 1; i < result.rows.length; i++) {
                    qry += ' UNION SELECT "'+result.rows.item(i).hotspotId+'", "'+result.rows.item(i).state+'"';
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
