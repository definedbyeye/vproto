import VPlay 2.0
import QtQuick 2.0

GameWindow {
  id: gameWindow

  // you get free licenseKeys as a V-Play customer or in your V-Play Trial
  // with a licenseKey, you get the best development experience:
  //  * No watermark shown
  //  * No license reminder every couple of minutes
  //  * No fading V-Play logo
  // you can generate one from http://v-play.net/license/trial, then enter it below:
  licenseKey: "2B76C38A127992D0AA2E4CE6BD373B22B9F0A86987E3BE24FAAE3B7796867D0D6014D693C5C5CE5D2D9DC3748D6EBCE08190EC4125893320504917B4D0E00B65991EDF5CD666D857D0383B6B8D8169FF568A0E87D7386C3AE021DFB58D41AF50A5528382E3FB64A3233BC9B5A88B6B12145BF5CB528BC95E31154B155CDC84A35091785533D48E776EDCC48D6BDAA31929AD5A83D6C038BF4B8E61756C1F5DC838C90AFD0678696F95FA635127175E364588AD859C959F1B3B004A7E03AB63B46F2E554A6FBA550287183E9B6FEDA7C62B2825528E574EFC7FFBA8F017E52D854C55452234273FFAA5A6ADFAC98C5F3288D7EE725868CF48A4B0D78628D498CAF1278D490BCD74D5B48D3C2FAA9D0E3103DAB22ADF2BB93CFAF8E6CA277BCCFD"

  activeScene: gameScene

  // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
  // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
  // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
  // this resolution is for iPhone 4 & iPhone 4S
  width: 960
  height: 640

  GameScene {
    id: gameScene
  }
}

