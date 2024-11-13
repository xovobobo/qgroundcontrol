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

CustomTransectStyleComplexItemEditor {
    transectAreaDefinitionComplete: missionItem.surveyAreaPolygon.isValid
    transectAreaDefinitionHelp:     qsTr("Use the Polygon Tools to create the polygon which outlines your survey area.")
    transectValuesHeaderName:       qsTr("Transects")
    transectValuesComponent:        _transectValuesComponent
    presetsTransectValuesComponent: _transectValuesComponent

    // The following properties must be available up the hierarchy chain
    //  property real   availableWidth    ///< Width for control
    //  property var    missionItem       ///< Mission Item for editor

    property real   _margin:        ScreenTools.defaultFontPixelWidth / 2
    property var    _missionItem:   missionItem

    Component {
        id: _transectValuesComponent

        GridLayout {
            Layout.fillWidth:   true
            columnSpacing:      _margin
            rowSpacing:         _margin
            columns:            2


            QGCLabel {
                text:       qsTr("Resolution")
                visible:    !forPresets
            }
            FactTextField {
                Layout.fillWidth:   true
                fact:               missionItem.resolution
                visible:            !forPresets
            }

            QGCLabel { text: qsTr("Radius") }
            FactTextField {
                fact:                   missionItem.radius
                Layout.fillWidth:       true
                onUpdated:              radiusSlider.value = missionItem.radius.value
            }
            QGCSlider {
                id:                     radiusSlider
                from:                   0
                to:                     10000
                stepSize:               0.1
                tickmarksEnabled:       false
                Layout.fillWidth:       true
                Layout.columnSpan:      2
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 1.5
                onValueChanged:         missionItem.radius.value = value
                Component.onCompleted:  value = missionItem.radius.value
                live: true
            }

            QGCLabel { text: qsTr("Dist btw spirals") }
            FactTextField {
                fact:                   missionItem.distanceBetweenSpirals
                Layout.fillWidth:       true
                onUpdated:              distanceBetweenSpiralsSlider.value = missionItem.distanceBetweenSpirals.value
            }
            QGCSlider {
                id:                     distanceBetweenSpiralsSlider
                from:                   0
                to:                     10000
                stepSize:               0.1
                tickmarksEnabled:       false
                Layout.fillWidth:       true
                Layout.columnSpan:      2
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 1.5
                onValueChanged:         missionItem.distanceBetweenSpirals.value = value
                Component.onCompleted:  value = missionItem.distanceBetweenSpirals.value
                live: true
            }
        }
    }

    KMLOrSHPFileDialog {
        id:             kmlOrSHPLoadDialog
        title:          qsTr("Select Polygon File")

        onAcceptedForLoad: (file) => {
            missionItem.surveyAreaPolygon.loadKMLOrSHPFile(file)
            missionItem.resetState = false
            //editorMap.mapFitFunctions.fitMapViewportTomissionItems()
            close()
        }
    }
}
