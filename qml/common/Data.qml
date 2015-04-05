import QtQuick 2.0
import VPlay 2.0
import QtQuick.LocalStorage 2.0

Item {
    id: storage

    //TODO: error handling

    property int quickSaveId: 1
    property bool dbInit: false

    property string playerId: ""
    property string roomId: ""    
    property point playerPoint: Qt.point(0,0)

    //opens db and ensures all tables are created
    function openDb() {
        var db = LocalStorage.openDatabaseSync("ProtoStorage", "1.0", "Proto Game Storage", 1000000);
        if(!dbInit) {
            createTables(db);            
            storage.dbInit = true;
        }
        return db;
    }

    function createTables(db) {
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS SaveStates(name TEXT, playerId TEXT, roomId TEXT, x REAL, y REAL, created INTEGER, updated INTEGER)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS HotspotStates(saveId INTEGER, hotspotId TEXT, state TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS InventoryStates(saveId INTEGER, inventoryId TEXT, state TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS EventStates(saveId INTEGER, eventId TEXT, state TEXT)');
        });
    }

    function savePlayerState(db) {
        db = db || openDb();
        db.transaction(function(tx) {
            var qry = 'UPDATE SaveStates SET playerId = "'+storage.playerId+'", roomId = "'+storage.roomId+'", x = '+storage.playerPoint.x+', y = '+storage.playerPoint.y+' WHERE ROWID = '+storage.quickSaveId;
           tx.executeSql(qry);
        });
    }

    function savePlayerId(pId) {
        storage.playerId = pId
        savePlayerState();
    }

    function saveRoomId(rId) {
        storage.roomId = rId
        savePlayerState();
    }

    function savePlayerPoint(point) {
        storage.playerPoint = point;
        savePlayerState();
    }

    function loadPlayerState(db) {
        db = db || openDb();
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM SaveStates WHERE ROWID = ' + storage.quickSaveId);
            if(result.rows.length) {
                storage.roomId = result.rows.item(0).roomId;
                storage.playerId = result.rows.item(0).playerId;
                storage.playerPoint = Qt.point(result.rows.item(0).x, result.rows.item(0).y);
            }
        });        
    }

    function saveState (entity, id, state, db) {
        db = db || openDb();
        var tableName = entity.charAt(0).toUpperCase() + entity.slice(1) + 'States';
        db.transaction(function(tx) {            
            var result = tx.executeSql('SELECT * FROM '+tableName+' WHERE saveId = '+storage.quickSaveId+' AND '+entity+'Id = '+id);
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

        //defaults
        storage.roomId = 'room1';
        storage.playerId = 'mainPlayer';
        storage.playerPoint = Qt.point(200, 120);

        db.transaction(function(tx) {
            tx.executeSql('INSERT INTO SaveStates (ROWID, name, playerId, roomId, x, y, created, updated) VALUES (?,?,?,?,?,?,?,?)', [
                              storage.quickSaveId,
                              "Quick Save",
                              storage.playerId,
                              storage.roomId,
                              storage.playerPoint.x,
                              storage.playerPoint.y,
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

        //if(id !== quickSaveId) {
        //    deleteSave(quickSaveId, db);
        //    copySaveStates(id, quickSaveId, db);
        //    loadPlayerState(quickSaveId, db);
        //}
        loadPlayerState(db);
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
