import VPlay 2.0
import QtQuick 2.4
import "." as Hotspots

Hotspots.HotspotBase {

    hotspotId: 1
    inventoryId: 1

    width: 41
    height: 59

    onSwipeUp: {sprite.jumpTo("empty")}
    onSwipeDown: {if(sprite.spriteSequence.currentSprite !== "boil" && sprite.spriteSequence.currentSprite !== "freeze") sprite.jumpTo("full")}
    onSwipeRight: {if(sprite.spriteSequence.currentSprite !== "empty") sprite.jumpTo("boil")}
    onSwipeLeft: {if(sprite.spriteSequence.currentSprite !== "empty") sprite.jumpTo("freeze")}

    onDoubleClicked: inventory.addInventory(1)

    SpriteSequenceVPlay {
        id: sprite

        defaultSource: "../../assets/hotspot/sprite_glass.png"

        SpriteVPlay {
            name: "empty"
            frameWidth: 41
            frameHeight: 59
            frameCount: 1
            startFrameColumn: 1
            frameRate: 1
            // optionally provide a name to which animation it should be changed after this is finished
            //to: "whirl"
            // if there is no target with to with goalSprite, it wouldnt work! thus a weight of 0 must be set
            to: {"full":0, "empty":1}
        }
        SpriteVPlay {
            name: "full"
            frameWidth: 41
            frameHeight: 59
            frameCount: 1
            startFrameColumn: 2
            // this tests if another sprite source is displayed, by not using the default spriteSheetSource property
            //source: "squatanBlue.png"
            frameRate: 1
            // after a while, with 10% probability, switch to die animation
            //to: {"die":0.1, "whirl":0.9}
            to: {"full":1}
        }
        SpriteVPlay {
            name: "boil"
            frameWidth: 41
            frameHeight: 59
            frameCount: 1
            startFrameColumn: 3
            frameRate: 1
            // returns to walking animation after a single jump animation (100% weight moving to walk)
            to: {"boil":1}
        }
        SpriteVPlay {
            name: "freeze"
            startFrameColumn: 4
            frameWidth: 41
            frameHeight: 59
            // frameCount is set to 1 by default
            to: {"freeze":1}
        }

    }

}
