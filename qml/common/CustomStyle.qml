import VPlay 2.0
import QtQuick 2.0
import QtQuick.Controls.Styles 1.1

Item {
  property alias buttonStyle:buttonStyleComponent
  property alias switchStyle:switchStyleComponent
  property alias sliderStyle:sliderStyleComponent
  property alias textFieldStyle:textFieldStyleComponent
  property alias scrollViewStyle:scrollViewStyleComponent
  property alias itemEditorStyle:itemEditorStyle
  property color windowBackgroundColor: "#212126"
  property color elementBackgroundColor: "#2c2b2a"
  property color elementForegroundColor: "#413d3c"
  property color elementHighlightColor: Qt.lighter("#468bb7", 1.2)
  property color elementNormalColor: Qt.darker("#468bb7", 1.4)
  property color buttonTextColor: "white"
  property int buttonTextPixelSize: 12
  property color switchTextColor: "white"
  property int switchTextPixelSize: 11
  property color textFieldTextColor: "white"
  property color textFieldPlaceholderTextColor: "grey"
  property int textFieldTextPixelSize: 14
  property color itemEditorLabelTextColor: "white"
  property int itemEditorLabelTextPixelSize: 11
  property alias itemEditorLabel: itemEditorLabel

  // Button Style
  Component {
    id: buttonStyleComponent
    ButtonStyle {
      id: buttonStyle
      background: Rectangle {
        id: buttonBackground
        implicitHeight: 30
        color: control.pressed ? elementBackgroundColor : elementForegroundColor
        radius: height/4
        Rectangle {
          anchors.fill: parent
          anchors.margins: 1
          color: "transparent"
          border.color: control.hovered ? elementHighlightColor : elementNormalColor
          radius: height/4
        }
      }
      label:  Item {
        implicitWidth: buttonText.implicitWidth
        implicitHeight: buttonText.implicitHeight
        baselineOffset: buttonText.y + buttonText.baselineOffset
        Text {
          id: buttonText
          text: control.text
          anchors.centerIn: parent
          color: buttonTextColor
          font.pixelSize: buttonTextPixelSize
          // causes bad fonts and other problems http://qt-project.org/forums/viewthread/22158
          //renderType: Text.NativeRendering
          renderType: Text.QtRendering
        }
      }
    }
  }


  // Switch Style
  Component {
    id: switchStyleComponent
    SwitchStyle {
      groove: Rectangle {
        implicitHeight: 25
        implicitWidth: 76
        radius: height/4
        Rectangle {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.bottom: parent.bottom
          width: parent.width/2 - 1
          height: 10
          anchors.margins: 1
          radius: height/4

          color: control.checked ? elementHighlightColor : elementBackgroundColor
          Behavior on color {ColorAnimation {}}
          Text {
            font.pixelSize: switchTextPixelSize
            color: switchTextColor
            anchors.centerIn: parent
            text: "ON"
          }
        }
        Item {
          width: parent.width/2
          height: parent.height
          anchors.right: parent.right
          Text {
            font.pixelSize: switchTextPixelSize
            color: switchTextColor
            anchors.centerIn: parent
            text: "OFF"
          }
        }
        Behavior on color {ColorAnimation {}}
        color: control.checked ? elementHighlightColor : elementBackgroundColor
        border.color: elementForegroundColor
        border.width: 1
      }
      handle: Rectangle {
        width: parent.parent.width/2
        height: control.height
        radius: height/4
        color: control.pressed ? elementBackgroundColor : elementForegroundColor
        Rectangle {
          anchors.fill: parent
          anchors.margins: 1
          color: "transparent"
          antialiasing: true
          border.color: control.checked ? elementHighlightColor : elementNormalColor
          radius: height/4
        }
      }
    }
  }


  // Slider Style
  Component {
    id: sliderStyleComponent
    SliderStyle {
      handle: Rectangle {
        width: 30
        height: 30
        radius: height
        color: control.pressed ? elementBackgroundColor : elementForegroundColor
        Rectangle {
          anchors.fill: parent
          anchors.margins: 1
          color: "transparent"
          antialiasing: true
          border.color: control.hovered ? elementHighlightColor : elementNormalColor
          radius: height/2
        }
      }

      groove: Item {
        implicitHeight: 50
        implicitWidth: 400
        Rectangle {
          height: 8
          width: parent.width
          anchors.verticalCenter: parent.verticalCenter
          color: elementBackgroundColor
          opacity: 0.8
          Rectangle {
            antialiasing: true
            radius: 1
            color: elementHighlightColor
            height: parent.height
            width: styleData.handlePosition
          }
        }
      }
    }
  }


  // TextField Style
  Component {
    id: textFieldStyleComponent
    TextFieldStyle {
      renderType: Text.QtRendering
      textColor: textFieldTextColor
      font.pixelSize: textFieldTextPixelSize
      placeholderTextColor: textFieldPlaceholderTextColor
      background: Rectangle {
        implicitWidth: Math.round(control.__contentHeight * 8)
        implicitHeight: Math.max(25, Math.round(control.__contentHeight * 1.2))
        color: control.pressed ? elementBackgroundColor : elementForegroundColor
        radius: height/4

        Rectangle {
          anchors.fill: parent
          anchors.margins: 1
          color: "transparent"
          border.color: (control.hovered || control.activeFocus) ? elementHighlightColor : elementNormalColor
          radius: height/4
        }
      }
    }
  }

  // ScrollView Style
  Component {
    id: scrollViewStyleComponent
    ScrollViewStyle {
      transientScrollBars: true
      handle: Item {
        implicitWidth: 7
        implicitHeight: 13
        Rectangle {
          color: elementBackgroundColor
          anchors.fill: parent
          anchors.topMargin: 3
          anchors.leftMargin: 2
          anchors.rightMargin: 2
          anchors.bottomMargin: 3
          radius: height/4
          Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            color: "transparent"
            antialiasing: true
            border.color: elementHighlightColor
            radius: height/4
          }
        }
      }
      scrollBarBackground: Item {
        implicitWidth: 7
        implicitHeight: 13
      }
    }
  }

  // ItemEditor Style
  ItemEditorStyle {
    id: itemEditorStyle
    contentDelegateBackground: Rectangle {
      color: windowBackgroundColor
      anchors.fill: parent
      radius: 2
    }
    contentDelegateTypeList: Rectangle {
      color: windowBackgroundColor
      anchors.fill: parent
      radius: 2
    }
    label: Text {
      id: itemEditorLabel
      color: itemEditorLabelTextColor
      font.pixelSize: itemEditorLabelTextPixelSize
    }
  }
}
