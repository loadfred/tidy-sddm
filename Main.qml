import QtQuick 6.7
import QtQuick.Controls.Fusion 6.7
import QtQuick.Effects 6.7

Pane {
  id: root
  padding: 0

  LayoutMirroring.enabled: config.boolValue("LayoutMirroring") || Qt.locale().textDirection == Qt.RightToLeft
  LayoutMirroring.childrenInherit: true

  property bool chooseUser: config.boolValue("ChooseUser") || false
  property bool militaryTime: config.boolValue("MilitaryTime") || false
  property bool disableTopHalfColor: config.boolValue("DisableTopHalfColor") || false
  property int itemWidth: itemHeight * 10
  property int itemHeight: font.pointSize * 5 / 2
  property int spacingSmall: itemHeight / 3
  property int spacingBig: spacingSmall * 2
  property string backgroundSource: config.stringValue("Background")
  property string icons: config.stringValue("Icons")
  property string paletteChoice: config.stringValue("Palette")

  property string pOrigin: paletteChoice.split("/")[0]

  property string pBase:
    config.stringValue(paletteChoice + "/Base") ||
    config.stringValue(pOrigin + "/Base")
  property string pHighlight:
    config.stringValue(paletteChoice + "/Highlight") ||
    config.stringValue(pOrigin + "/Highlight")
  property string pHighlightedText:
    config.stringValue(paletteChoice + "/HighlightedText") ||
    config.stringValue(pOrigin + "/HighlightedText")
  property string pShadow:
    config.stringValue(paletteChoice + "/Shadow") ||
    config.stringValue(pOrigin + "/Shadow")
  property string pText:
    config.stringValue(paletteChoice + "/Text") ||
    config.stringValue(pOrigin + "/Text")
  property string pWindow:
    config.stringValue(paletteChoice + "/Window") ||
    config.stringValue(pOrigin + "/Window")
  property string pWindowText:
    config.stringValue(paletteChoice + "/WindowText") ||
    config.stringValue(pOrigin + "/WindowText")

  palette {
    base: pBase || undefined
    highlight: pHighlight || undefined
    highlightedText: pHighlightedText || undefined
    shadow: pShadow || undefined
    text: pText || undefined
    window: pWindow || undefined
    windowText: pWindowText || undefined
    button: pWindow || undefined
    buttonText: pWindowText || undefined
    toolTipBase: pBase || undefined
    toolTipText: pText || undefined

    property color pTextColor: pText
    placeholderText: pText ? Qt.rgba(pTextColor.r, pTextColor.g, pTextColor.b, 0.5) : undefined
  }

  font {
    pointSize: parseFloat(config.stringValue("FontPointSize")) || 12
    family: config.stringValue("FontFamily") || "sans"
  }

  Connections {
    target: sddm

    function onLoginSucceeded() {
        backgroundImage.cursorShape = Qt.ArrowCursor
    }

    function onLoginFailed() {
        pw_entry.clear()
        pw_entry.enabled = true
        backgroundImage.cursorShape = Qt.ArrowCursor
        pw.anchors.horizontalCenterOffset = spacingBig
        animateFail.restart()
    }
  }

  FocusScope {
    // Background image and default mouse area
    id: backgroundImage
    anchors.fill: parent

    property alias status: image.status
    property alias cursorShape: mousearea.cursorShape

    Image {
      id: image
      anchors.fill: parent
      clip: true
      focus: true
      smooth: true
      source: backgroundSource
      fillMode: Image.PreserveAspectCrop
    }

    MouseArea {
      id: mousearea
      anchors.fill: parent
      onClicked: parent.focus = true
      cursorShape: Qt.ArrowCursor
    }
  }

  Rectangle {
    // Top half background color
    width: parent.width; height: parent.height / 2 - form.height / 2 + clock.height / 2
    visible: backgroundImage.status != 1 && !disableTopHalfColor
    color: palette.base
  }

  Rectangle {
    id: window
    anchors.centerIn: parent
    width: childrenRect.width; height: childrenRect.height
    color: backgroundImage.status == 1 ? palette.window : "transparent"
    radius: 3
    layer.enabled: backgroundImage.status == 1

    layer.effect: MultiEffect {
      source: window
      shadowEnabled: true
      shadowHorizontalOffset: LayoutMirroring.enabled ? -3 : 3
      shadowVerticalOffset: 3
      shadowColor: palette.shadow
    }

    Column {
      Rectangle {
        // Show the time
        id: clock
        width: form.width; height: childrenRect.height
        color: backgroundImage.status == 1 && !disableTopHalfColor ? palette.base : "transparent"
        topLeftRadius: window.topLeftRadius
        topRightRadius: window.topRightRadius

        Column {
          anchors.left: parent.left
          spacing: spacingSmall
          padding: spacing

          property date dateTime: new Date()

          Timer {
              interval: 60000; running: true; repeat: true;
              onTriggered: parent.dateTime = new Date()
          }

          Text {
            anchors.left: parent.left
            anchors.leftMargin: parent.padding
            font.pointSize: root.font.pointSize * 2
            font.family: root.font.family
            font.weight: 900
            color: disableTopHalfColor ? palette.windowText : palette.text
            text: Qt.formatTime(parent.dateTime, "h:mm" + (militaryTime ? "" : " a"))
          }

          Text {
            anchors.left: parent.left
            anchors.leftMargin: parent.padding
            font: root.font
            color: disableTopHalfColor ? palette.windowText : palette.text
            text: Qt.formatDate(parent.dateTime, "dddd, MMMM d")
          }
        }
      }

      Column {
        id: form
        spacing: spacingBig
        padding: spacingSmall
        bottomPadding: spacing

        Row {
          spacing: spacingSmall

          Rectangle {
            // User .face.icon
            id: faceIcon
            width: childrenRect.width; height: childrenRect.height
            color: palette.base
            layer.enabled: true

            layer.effect: MultiEffect {
              source: faceIcon
              shadowEnabled: true
              shadowHorizontalOffset: LayoutMirroring.enabled ? -3 : 3
              shadowVerticalOffset: 3
              shadowColor: palette.shadow
            }
            
            Image {
              width: itemWidth - itemHeight - spacingSmall; height: width
              fillMode: Image.PreserveAspectCrop
              clip: true
              smooth: true
              source: userModel.data(userModel.index(user_entry.currentIndex, 0), Qt.UserRole + 4)
            }
          }

          Column {
            // Power states
            spacing: spacingBig

            Button {
              width: height; height: itemHeight
              icon.color: palette.buttonText
              icon.name: icons ? "" : "system-shutdown-symbolic"
              icon.source: "icons/" + icons + "/system-shutdown-symbolic.svg"
              icon.width: width; icon.height: height
              onClicked: sddm.powerOff()

              ToolTip {
                visible: parent.hovered
                font: root.font
                palette: parent.palette
                delay: 1000
                timeout: 5000
                text: qsTr("Shutdown")
              }

              MouseArea { 
                anchors.fill: parent
                enabled: false
                cursorShape: Qt.PointingHandCursor
              }
            }

            Button {
              width: height; height: itemHeight
              icon.color: palette.buttonText
              icon.name: icons ? "" : "system-reboot-symbolic"
              icon.source: "icons/" + icons + "/system-reboot-symbolic.svg"
              icon.width: width; icon.height: height
              onClicked: sddm.reboot()

              ToolTip {
                visible: parent.hovered
                font: root.font
                palette: parent.palette
                delay: 1000
                timeout: 5000
                text: qsTr("Reboot")
              }

              MouseArea { 
                anchors.fill: parent
                enabled: false
                cursorShape: Qt.PointingHandCursor
              }
            }

            Button {
              width: height; height: itemHeight
              icon.color: palette.buttonText
              icon.name: icons ? "" : "system-suspend-symbolic"
              icon.source: "icons/" + icons + "/system-suspend-symbolic.svg"
              icon.width: width; icon.height: height
              onClicked: sddm.suspend()

              ToolTip {
                visible: parent.hovered
                font: root.font
                palette: parent.palette
                delay: 1000
                timeout: 5000
                text: qsTr("Suspend")
              }

              MouseArea { 
                anchors.fill: parent
                enabled: false
                cursorShape: Qt.PointingHandCursor
              }
            }
          }
        }

        Row {
          // User and session
          spacing: spacingSmall
          anchors.horizontalCenter: parent.horizontalCenter

          ComboBox {
            id: session
            width: itemWidth - itemHeight - parent.spacing; height: itemHeight
            visible: !swap_button.checked
            wheelEnabled: true
            model: sessionModel
            currentIndex: sessionModel.lastIndex
            textRole: "name"
            popup.font: root.font
            palette.window: root.palette.base

            ToolTip {
              visible: parent.hovered
              font: root.font
              palette: parent.palette
              delay: 1000
              timeout: 5000
              text: qsTr("Session")
            }

            MouseArea { 
              anchors.fill: parent
              enabled: false
              cursorShape: Qt.PointingHandCursor
            }
          }

          ComboBox {
            id: user_entry
            width: itemWidth - itemHeight - parent.spacing; height: itemHeight
            visible: swap_button.checked
            wheelEnabled: true
            model: userModel
            currentIndex: userModel.lastIndex
            textRole: "name"
            popup.font: root.font
            palette.window: root.palette.base

            ToolTip {
              visible: parent.hovered
              font: root.font
              palette: parent.palette
              delay: 1000
              timeout: 5000
              text: qsTr("User")
            }

            MouseArea { 
              anchors.fill: parent
              enabled: false
              cursorShape: Qt.PointingHandCursor
            }
          }

          Button {
            id: swap_button
            width: height; height: itemHeight
            icon.color: palette.buttonText
            icon.name: icons ? "" : "system-switch-user-symbolic"
            icon.source: "icons/" + icons + "/system-switch-user-symbolic.svg"
            icon.width: width; icon.height: height
            checkable: true
            checked: chooseUser
            onClicked: swap_button_tooltip.hide()

            ToolTip {
              id: swap_button_tooltip
              visible: parent.hovered
              font: root.font
              palette: parent.palette
              delay: 1000
              timeout: 5000
              text: parent.checked ? qsTr("Choose session") : qsTr("Choose user")
            }

            MouseArea { 
              anchors.fill: parent
              enabled: false
              cursorShape: Qt.PointingHandCursor
            }
          }
        }

        Column {
          // Password
          spacing: spacingSmall
          anchors.horizontalCenter: parent.horizontalCenter

          Row {
            id: pw
            spacing: parent.spacing
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on anchors.horizontalCenterOffset {
              SequentialAnimation {
                id: animateFail
                running: false
                NumberAnimation { from: spacingBig; to: -spacingBig; duration: 80 }
                NumberAnimation { from: -spacingBig; to: spacingBig;  duration: 80 }
                NumberAnimation { from: spacingBig; to: 0;  duration: 80 }
              }
            }

            TextField {
              id: pw_entry
              width: itemWidth - itemHeight -parent.spacing; height: itemHeight
              font: root.font
              placeholderText: qsTr("Password")
              color: enabled ? palette.text : Qt.rgba(palette.text.r, palette.text.g, palette.text.b, 0.5)

              property bool showText: pw_reveal.checked
              echoMode: showText ? TextField.Normal : TextField.Password

              onAccepted: {
                backgroundImage.cursorShape = Qt.BusyCursor
                enabled = false
                sddm.login(user_entry.currentText, pw_entry.text, session.currentIndex)
              }
            }

            Button {
              id: login_button
              width: height; height: itemHeight
              icon.color: palette.buttonText
              icon.name: icons ? "" : "go-next-symbolic"
              icon.source: "icons/" + icons + "/go-next-symbolic.svg"
              icon.width: width; icon.height: height

              onClicked: {
                backgroundImage.cursorShape = Qt.BusyCursor
                pw_entry.enabled = false
                sddm.login(user_entry.currentText, pw_entry.text, session.currentIndex)
              }

              ToolTip {
                visible: parent.hovered
                font: root.font
                palette: parent.palette
                delay: 1000
                timeout: 5000
                text: qsTr("Login")
              }

              MouseArea { 
                anchors.fill: parent
                enabled: false
                cursorShape: Qt.PointingHandCursor
              }
            }
          }

          AbstractButton {
            width: childrenRect.width; height: childrenRect.height
            onClicked: pw_reveal.toggle()
            activeFocusOnTab: false
            anchors.left: parent.left

            MouseArea { 
              anchors.fill: parent
              enabled: false
              cursorShape: Qt.PointingHandCursor
            }

            Row {
              // Show password
              spacing: parent.parent.spacing

              CheckBox {
                id: pw_reveal
                padding: 0
                spacing: 0

                MouseArea { 
                  anchors.fill: parent
                  enabled: false
                  cursorShape: Qt.PointingHandCursor
                }
              }

              Text {
                anchors.verticalCenter: pw_reveal.verticalCenter
                font: root.font
                color: palette.windowText
                text: qsTr("Show password")
              }
            }
          }
        }
      }
    }
  }

  Component.onCompleted: {
    pw_entry.forceActiveFocus()

    // Disable virtual keyboard
    Qt.inputMethod.visibleChanged.connect(function () {
        if (Qt.inputMethod.visible)
            Qt.inputMethod.hide()
    })
  }
}
