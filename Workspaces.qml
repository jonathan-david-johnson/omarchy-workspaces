import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "jdj.workspaces"

  property bool legendOpen: false

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function sortedMonitors() {
    var values = Hyprland.monitors.values.slice()
    values.sort(function(left, right) {
      var leftName = String(left.name || "")
      var rightName = String(right.name || "")
      return leftName < rightName ? -1 : (leftName > rightName ? 1 : 0)
    })
    return values
  }

  function monitorIndex(monitor) {
    if (!monitor) return -1
    var name = String(monitor.name || "")
    var values = root.sortedMonitors()
    for (var i = 0; i < values.length; i++) {
      if (String(values[i].name || "") === name) return i
    }
    return -1
  }

  // Use theme palette roles rather than fixed monitor colors. Sorting connector
  // names keeps each output's marker consistent across all workspace buttons.
  function monitorColor(monitor) {
    var index = root.monitorIndex(monitor)
    if (index < 0) return Color.muted
    return index === 0 ? Color.accent : Color.muted
  }

  function monitorLabel(monitor) {
    if (!monitor) return "Unassigned"
    var name = String(monitor.name || "Monitor")
    var lowerName = name.toLowerCase()
    if (lowerName.indexOf("edp") === 0) return "Laptop (" + name + ")"
    return "External (" + name + ")"
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  function close() {
    legendOpen = false
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length + 1
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property var assignedMonitor: workspace ? workspace.monitor : null
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData
        readonly property bool assigned: assignedMonitor !== null

        bar: root.bar
        text: focused ? "\uDB85\uDCFB" : (modelData === 10 ? "0" : String(modelData))
        tooltipText: assigned ? "Workspace " + modelData + " · " + root.monitorLabel(assignedMonitor) : "Workspace " + modelData
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }

        Rectangle {
          z: -1
          visible: assigned
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom
          anchors.bottomMargin: Style.space(4)
          width: Style.space(12)
          height: Style.spaceReal(1.5)
          radius: height / 2
          color: Util.alpha(root.monitorColor(assignedMonitor), 0.58)
        }
      }
    }

    WidgetButton {
      id: legendButton

      bar: root.bar
      text: root.legendOpen ? "⌄" : "›"
      tooltipText: root.legendOpen ? "Hide monitor key" : "Show monitor key"
      useActiveColor: false
      foreground: Util.alpha(root.foreground, 0.72)
      horizontalMargin: 0
      verticalPadding: 6
      fixedWidth: root.vertical ? root.barSize : Style.space(14)
      fixedHeight: root.barSize
      onPressed: function() { root.legendOpen = !root.legendOpen }
    }
  }

  PopupCard {
    id: legendPopup
    anchorItem: legendButton
    owner: root
    bar: root.bar
    open: root.legendOpen
    contentWidth: legendPopup.fittedContentWidth(Style.space(204))
    contentHeight: legendPopup.fittedContentHeight(Style.space(25) + root.sortedMonitors().length * Style.space(22))

    Column {
      id: legendColumn
      anchors.fill: parent
      spacing: Style.space(4)

      Text {
        text: "Workspace monitor key"
        color: Color.popups.text
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.body
        font.bold: true
      }

      Repeater {
        model: root.sortedMonitors()

        Item {
          required property var modelData
          required property int index

          width: legendColumn.width
          height: Style.space(20)

          Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: Style.space(12)
            height: Style.spaceReal(1.5)
            radius: height / 2
            color: Util.alpha(root.monitorColor(modelData), 0.68)
          }

          Text {
            anchors.left: parent.left
            anchors.leftMargin: Style.space(20)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: root.monitorLabel(modelData)
            color: Color.popups.text
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.body
            elide: Text.ElideRight
          }
        }
      }
    }
  }
}
