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
  licenseKey: "11321DEC4CFDBB409754E6853080B6613F6181A623C4DD866D224A1D225A28587A195D257268F9EB0897F63B41B858B3693C23A68374F95D894245A65799C973E3BF10455CEDA765D44EBA6ACF538CA763C0455C18F4FBE5F11BADFA0386DC53101B932BAEFC2A6879E11EA5E3C48FD6CD985B948FC517964E71EA5F2E311797FD963E65127719EF059176B012F69D96E39BD7F86A68EE4BE92E20FF9248DAAFB66CEDB9300E00C88B65B2ED625AB4D4B86B9ABD29A949135738058017B96CF60889E9E954E82D3BCCB1A83D0D285FD5376349C72C02E4713A7C26D4C650E19DF27BA6A11E7AE4419CF3BCB0F447820BA3ABC66A527AE6693D2761AF06A5DF163A7AC3E415696E5CEB7D2B345F2C4FA888938E5775051FD40E430C2A1D0E019E"

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

