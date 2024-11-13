import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Vehicle
import QGroundControl.Controls
import QGroundControl.FactSystem
import QGroundControl.FactControls
import QGroundControl.Palette
import QGroundControl.FlightMap

Rectangle {
    id:         _root
    height:     childrenRect.y + childrenRect.height + _margin
    width:      availableWidth
    color:      qgcPal.windowShadeDark
    radius:     _radius

    property bool   transectAreaDefinitionComplete: true
    property string transectAreaDefinitionHelp:     _internalError
    property string transectValuesHeaderName:       _internalError
    property var    transectValuesComponent:        undefined
    property var    presetsTransectValuesComponent: undefined

    readonly property string _internalError: "Internal Error"

    property var    _missionItem:               missionItem
    property real   _margin:                    ScreenTools.defaultFontPixelWidth / 2
    property real   _fieldWidth:                ScreenTools.defaultFontPixelWidth * 10.5
    property var    _vehicle:                   QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle
    property real   _cameraMinTriggerInterval:  _missionItem.cameraCalc.minTriggerInterval.rawValue
    property string _doneAdjusting:             qsTr("Done")
    property bool   _presetsAvailable:          _missionItem.presetNames.length !== 0

    function polygonCaptureStarted() {
        _missionItem.clearPolygon()
    }

    function polygonCaptureFinished(coordinates) {
        for (var i=0; i<coordinates.length; i++) {
            _missionItem.addPolygonCoordinate(coordinates[i])
        }
    }

    function polygonAdjustVertex(vertexIndex, vertexCoordinate) {
        _missionItem.adjustPolygonCoordinate(vertexIndex, vertexCoordinate)
    }

    function polygonAdjustStarted() { }
    function polygonAdjustFinished() { }

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    ColumnLayout {
        id:                 editorColumn
        anchors.margins:    _margin
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.right:      parent.right

        QGCLabel {
            id:                     transectAreaDefinitionCompleteLabel
            Layout.fillWidth:       true
            wrapMode:               Text.WordWrap
            horizontalAlignment:    Text.AlignHCenter
            text:                   transectAreaDefinitionHelp
            visible:                !transectAreaDefinitionComplete || _missionItem.wizardMode
        }

        ColumnLayout {
            Layout.fillWidth:   true
            spacing:            _margin
            visible:            transectAreaDefinitionComplete && !_missionItem.wizardMode

            // Grid tab
            ColumnLayout {
                Layout.fillWidth:   true
                spacing:            _margin
                visible:            tabBar.currentIndex === 0

                SectionHeader {
                    id:                 transectValuesHeader
                    Layout.fillWidth:   true
                    text:               transectValuesHeaderName
                }

                Loader {
                    Layout.fillWidth:   true
                    visible:            transectValuesHeader.checked
                    sourceComponent:    transectValuesComponent

                    property bool forPresets: false
                }

                QGCButton {
                    Layout.alignment:   Qt.AlignHCenter
                    text:               qsTr("Rotate Entry Point")
                    onClicked:          _missionItem.rotateEntryPoint()
                    visible:            transectValuesHeader.checked
                }

            } // Grid Column

        } // Top level  Column
    }
}
