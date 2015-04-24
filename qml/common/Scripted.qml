import QtQuick 2.0
import VPlay 2.0

EntityBase {

    property var sequence
    onSequenceChanged: loadStates()

    function loadStates() {
        var states = '';
        var state = '';
        var s;

        for(var i = 0; i < sequence.length; i++){
            s = sequence[i];

            state = 'State {';
            state += 'name: "'+s.name+'"; '

            switch(s.type){
                case 'moveTo':
                    state += 'StateChangeScript { script: activePlayer.moveTo('+s.x+','+s.y+')} ';
                    state += 'PropertyChanges { target: gameScene; ';
                    state += parseEvents(s.events);                    
                    state += '} ';                    
                    break;
                case 'message':
                    //TODO: escape single quotes
                    state += 'StateChangeScript { script: {
                        panelLoader.source = "../interface/MessagePanel.qml";
                        activePanel.message = "'+s.message+'";
                    }} ';
                    state += 'PropertyChanges { target: gameScene; ';
                    state += parseEvents(s.events);                    
                    state += '} ';
                    break;
                case 'take':
                    state += 'StateChangeScript { script: {
                        panelLoader.source = "../interface/TakePanel.qml";
                        activePanel.inventoryId = "'+s.inventoryId+'";
                    }} ';
                    state += 'PropertyChanges { target: gameScene; ';
                    state += parseEvents(s.events);
                    state += '} ';
                    break;
                case 'dialog':
                    state += 'StateChangeScript { script: {
                        panelLoader.source = "../interface/DialogPanel.qml";
                        activePanel.message = "'+s.message+'";
                        activePanel.orientation = "'+s.orientation+'";
                        activePanel.profile = "'+s.profile+'"; '
                        +parseDialogOpts(s.events)+'
                    }} ';
                    state += 'PropertyChanges { target: gameScene; ';
                    state += parseEvents(s.events);                    
                    state += '} ';                    
                    break;
                case 'addInventory':
                    break;
            }

            state += '}';
            if(i < sequence.length-1)
                state += ',';
            states += state;
        }

        states = 'import QtQuick 2.0; Item { id: thisScript
            onStateChanged: {console.log("-- state changed to "+state)}
            state: "'+sequence[0].name+'"; states: ['+states+'] }';
        Qt.createQmlObject(states, scripted);
    }

    function parseEvents(changeEvents){
        var e = '';
        if(changeEvents && changeEvents.length){
            for(var j = 0; j < changeEvents.length; j++){
                e += changeEvents[j].on + ': thisScript.state = "'+changeEvents[j].to+'"; ';
            }
        }        
        return e;
    }

    function parseDialogOpts(changeEvents){
        var opts = '';
        if(changeEvents && changeEvents.length){
            for(var j = 0; j < changeEvents.length; j++){
                if(changeEvents[j].on === 'onPanelOptCancel') {
                    opts += 'activePanel.optCancelMessage = "'+(changeEvents[j].message || '')+'";';
                } else {
                    opts += 'activePanel.opt'+(j+1)+'Message = "'+(changeEvents[j].message || '')+'";';
                }
            }
        }
        return opts;
    }
}
