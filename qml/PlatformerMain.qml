import VPlay 2.0
import QtQuick 2.0
import "." as Root

GameWindow {
  id: gameWindow

  licenseKey: "2B76C38A127992D0AA2E4CE6BD373B22B9F0A86987E3BE24FAAE3B7796867D0D6014D693C5C5CE5D2D9DC3748D6EBCE08190EC4125893320504917B4D0E00B65991EDF5CD666D857D0383B6B8D8169FF568A0E87D7386C3AE021DFB58D41AF50A5528382E3FB64A3233BC9B5A88B6B12145BF5CB528BC95E31154B155CDC84A35091785533D48E776EDCC48D6BDAA31929AD5A83D6C038BF4B8E61756C1F5DC838C90AFD0678696F95FA635127175E364588AD859C959F1B3B004A7E03AB63B46F2E554A6FBA550287183E9B6FEDA7C62B2825528E574EFC7FFBA8F017E52D854C55452234273FFAA5A6ADFAC98C5F3288D7EE725868CF48A4B0D78628D498CAF1278D490BCD74D5B48D3C2FAA9D0E3103DAB22ADF2BB93CFAF8E6CA277BCCFD"

  width: 960
  height: 640

  activeScene: gameScene
  GameScene {
    id: gameScene

    Root.Data {
        id: storage
        Component.onCompleted: init()
    }
  }

  /*
    // this property holds how often the game was started
    property int numberGameStarts

    Component.onCompleted: {

      // this code reads the numberGameStarts value from the database

      // getValue() returns undefined, if no setting for this key is found, so when this is the first start of the app
      var tempNumberGameStarts = settings.getValue("numberGameStarts")
      if(!tempNumberGameStarts) {
          settings.setValue("numberGameStarts", 0)
          tempNumberGameStarts = 0
      }

      numberGameStarts = tempNumberGameStarts
    }
*/
  /*

  Storage {
      id: inventoryLookup

      Component.onCompleted: {
          inventoryLookup.setValue(1, {id: 1, name: "Water Glass", description: "An empty glass"})
      }
  }
  */

  function triggerSwipe (target, mouse) {
      var tw = target.width/2
      var th = target.height/2
      var x = mouse.x - tw;
      var y = - (mouse.y  - th);

      if(Math.abs(y) > Math.abs(x) && Math.abs(y) > (th+1)) {
          if(y > 0) {
              target.swipeUp()
          } else {
              target.swipeDown()
          }
      } else if(Math.abs(x) > Math.abs(y) && Math.abs(x) > (tw+1)) {
          if(x > 0) {
              target.swipeRight()
          } else {
              target.swipeLeft()
          }
      }
  }

}

