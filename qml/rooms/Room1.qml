import VPlay 2.0
import QtQuick 2.0
import "../interactables"
import "../common"

RoomBase {
    id: room1

    height: 360
    width: 1140

    // TODO: allow player to enter from multiple points
    property point defaultPlayerPoint: Qt.point(200,120);
    property real defaultOffset: 0

    Component.onCompleted: {
        viewPort.x = defaultOffset
        viewPort.anchors.bottom = gameScene.gameWindowAnchorItem.bottom;
    }

    // background
    MultiResolutionImage {        
        source: "../../assets/background/bg_testing_tables.png"
    }

    // interaction areas

    InteractableBase {
        areaVertices: [Qt.point(0,0), Qt.point(150, 0), Qt.point(100, 100), Qt.point(0, 200)]
        onTap: {
            scripted.sequence = [{name: 'look', type: 'message', message: "... Bzzzzzt.... this is only a test."}]
        }
        onUseWith: {
            if(useWithInventoryId === "emptyGlass"){
                scripted.sequence = [{name: 'look', type: 'message', message: "You drop the empty glass from a great height.<br>It SHATTERS to pieces below."}]
            }
        }
    }


    InteractableBase {
        x: 161
        y: 65
        width: 30
        height: 30
        helperColor: "lightblue"        
        onTap: {scripted.sequence = [
                    {name: 'd1', type: 'dialog', orientation: 'left',  profile: 'player', message: 'Hello!', events: [{on: 'onPanelClosed', to: 'd2'}]},
                    {name: 'd2', type: 'dialog', orientation: 'right', profile: 'player', message: 'Who, me?', events: [{on: 'onPanelClosed', to: 'd3'}]},
                    {name: 'd3', type: 'dialog', orientation: 'left',  profile: 'player', message: 'I think I\'m talking to myself...', events: [{on: 'onPanelClosed', to: 'd4'}]},
                    {name: 'd4', type: 'dialog', orientation: 'right', profile: 'player', message: 'I\'ll respond with...', events: [
                            {on: 'onPanelOpt1', message: 'Really?', to: 'd3'},
                            {on: 'onPanelOpt2', message: 'Really really?', to: 'd5'},
                            {on: 'onPanelOptCancel', message: 'Forget it.'},
                        ]},
                    {name: 'd5', type: 'dialog', orientation: 'left', profile: 'player', message: 'Its confirmed. I\'m talking to myself.'}
                ]}
    }



    InteractableBase {
        x: 315
        y: 161
        width: 30
        height: 50
        helperColor: "pink"
        onTap: {scripted.sequence = [
                    {name: 'getCloser', type: 'moveTo', x: 274, y: 270, events: [{on: 'onPlayerReachedTarget', to: 'firstLook'}]},
                    {name: 'firstLook', type: 'take',   inventoryId: 'emptyGlass', events: [{on: 'onPanelOpt1', to: 'leaveIt'}, {on: 'onPanelOpt2', to: 'takeIt'}]},
                    {name: 'leaveIt',   type: 'message', message: 'Eh, I\'ll leave it alone for now.'},
                    {name: 'takeIt',    type: 'message', message: 'I pick it up and put it in my pocket.'}
                ]}
    }


    Rectangle {
        x: 400
        y: 300
        width: 50
        height: 50
        color: "lightblue"
        MouseArea {
            anchors.fill: parent
            onClicked: {scripted.sequence = [
                            {name: 'getCloser', events: [{on: 'onPlayerReachedTarget', to: 'firstLook'}],  type: 'moveTo', x: 346, y: 337},
                            {name: 'firstLook', events: [{on: 'onPanelClosed', to: 'moveAway'}],           type: 'message',   message: 'It looks big.'},
                            {name: 'moveAway',  events: [{on: 'onPlayerReachedTarget', to: 'secondLook'}], type: 'moveTo', x: 330, y: 287},
                            {name: 'secondLook', type: 'message', message: 'Now it looks small.'}
                        ]}

        }
    }

    // transition areas
    Area {
        id: leftArea
        vertices: [
            Qt.point(240, 236), // top left
            Qt.point(-5, 365), // bottom left
            Qt.point(50, 360), // bottom right
            Qt.point(245, 236) // top right
        ]

        onEntered: {
            goToRoomId = 'room2'
            fromAreaId= 'leftArea'
        }
    }


    // walkable area boundaries
    Wall {
        id: leftWall
        vertices: [
            Qt.point(240, 236), // top left
            Qt.point(-5, 365), // bottom left
            Qt.point(0, 360), // bottom right
            Qt.point(245, 236) // top right
        ]
    }

    Wall {
        id: topWall
        vertices: [
            Qt.point(238, 236), // top left
            Qt.point(238, 241), // bottom left
            Qt.point(905, 241), // bottom right
            Qt.point(905, 236) // top right
        ]
    }

    Wall {
        id: rightWall
        vertices: [
            Qt.point(890, 235), // top left
            Qt.point(1150, 365), // bottom left
            Qt.point(1155, 365), // bottom right
            Qt.point(895, 235) // top right
        ]
    }

    Wall {
        id: bottomWall
        vertices: [
            Qt.point(-5, 355), // top left
            Qt.point(-5, 360), // bottom left
            Qt.point(1145, 360), // bottom right
            Qt.point(1145, 355) // top right
        ]
    }

}
