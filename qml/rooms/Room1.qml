import VPlay 2.0
import QtQuick 2.0
import "../interactables"
import "../common"

RoomBase {
    id: room1

    height: 360
    width: 1140

    // TODO: allow player to enter from multiple points
    property point defaultPlayerPoint: Qt.point(200,300);
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
        id: glass1

        x: 310
        y: 170
        width: 32
        height: 48

        onTap: {inventoryPanel.addInventory("emptyGlass"); glass1.destroy();}

        onSwipeUp: {glassSprite.jumpTo("empty")}
        onSwipeDown: {if(glassSprite.spriteSequence.currentSprite !== "boil" && glassSprite.spriteSequence.currentSprite !== "freeze") glassSprite.jumpTo("full")}
        onSwipeRight: {if(glassSprite.spriteSequence.currentSprite !== "empty") glassSprite.jumpTo("boil")}
        onSwipeLeft: {if(glassSprite.spriteSequence.currentSprite !== "empty") glassSprite.jumpTo("freeze")}

        SpriteSequenceVPlay {
            id: glassSprite
            width: 32
            height: 48

            defaultSource: "../../assets/hotspot/sprite_glass.png"

            SpriteVPlay {
                name: "empty"
                frameWidth: 41
                frameHeight: 59
                //frameCount: 1
                startFrameColumn: 1
                //frameRate: 1
                //to: {"full":0, "empty":1}
            }
            SpriteVPlay {
                name: "full"
                frameWidth: 41
                frameHeight: 59
                //frameCount: 1
                startFrameColumn: 2
                //frameRate: 1
                //to: {"full":1}
            }
            SpriteVPlay {
                name: "boil"
                frameWidth: 41
                frameHeight: 59
                //frameCount: 1
                startFrameColumn: 3
                //frameRate: 1
                //to: {"boil":1}
            }
            SpriteVPlay {
                name: "freeze"
                startFrameColumn: 4
                frameWidth: 41
                frameHeight: 59
                //to: {"freeze":1}
            }

        }
    }

    InteractableBase {
        id: glass2

        x: 560
        y: 170
        width: 30
        height: 50

        onTap: {scripted.sequence = [
                    {name: 'getCloser', type: 'moveTo', x: 274, y: 270, events: [
                            {on: 'onPlayerReachedTarget', to: 'firstLook'},
                            {on: 'onPlayerStopped', to: 'firstLook'}
                        ]},
                    {name: 'firstLook', type: 'take',   inventoryId: 'emptyGlass', events: [
                            {on: 'onPanelOpt1', to: 'leaveIt'},
                            {on: 'onPanelOpt2', to: 'takeIt'}
                        ]},
                    {name: 'leaveIt',   type: 'message', message: 'Eh, I\'ll leave it alone for now.'},
                    {name: 'takeIt',    type: 'message', message: 'I pick it up and put it in my pocket.'}
                ]}

        SpriteSequenceVPlay {
            id: glassSprite2
            anchors.fill: parent

            defaultSource: "../../assets/hotspot/sprite_glass.png"

            SpriteVPlay {
                name: "empty"
                frameWidth: 41
                frameHeight: 59
                //frameCount: 1
                startFrameColumn: 1
                //frameRate: 1
                //to: {"full":0, "empty":1}
            }
            SpriteVPlay {
                name: "full"
                frameWidth: 41
                frameHeight: 59
                //frameCount: 1
                startFrameColumn: 2
                //frameRate: 1
                //to: {"full":1}
            }
            SpriteVPlay {
                name: "boil"
                frameWidth: 41
                frameHeight: 59
                //frameCount: 1
                startFrameColumn: 3
                //frameRate: 1
                //to: {"boil":1}
            }
            SpriteVPlay {
                name: "freeze"
                startFrameColumn: 4
                frameWidth: 41
                frameHeight: 59
                //to: {"freeze":1}
            }

        }

    }

    InteractableBase {
        areaVertices: [Qt.point(0,0), Qt.point(150, 0), Qt.point(100, 100), Qt.point(0, 200)]
        Rectangle {
            anchors.fill:parent
            opacity: .5
            color: "white"
        }
        onTap: {
            scripted.sequence = [{name: 'look', type: 'message', message: "... Bzzzzzt.... this is only a test."}]
        }
        onUseWith: {
            if(useWithInventoryId === "emptyGlass"){
                inventoryPanel.removeInventory("emptyGlass");
                scripted.sequence = [{name: 'look', type: 'message', message: "You drop the empty glass from a great height.<br>It SHATTERS to pieces below."}]
            }
        }
    }


    /*
    InteractableBase {
        x: 161
        y: 65
        width: 30
        height: 30               
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
    */

    /*
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
    */

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
            Qt.point(190, 255), // top left
            Qt.point(190, 260), // bottom left
            Qt.point(985, 260), // bottom right
            Qt.point(985, 255) // top right
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

    Wall {
        id: sampleObstruction
        vertices: [
            Qt.point(300, 300), // top left
            Qt.point(300, 350), // bottom left
            Qt.point(305, 350), // bottom right
            Qt.point(305, 300) // top right
        ]
    }

}
