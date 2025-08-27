import QtQuick
import Quickshell
import Quickshell.Io

import "../widgets/"

import Quickshell.Services.Mpris

Scope {
    Time { id: timeSource }
    
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            implicitHeight: 24
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 6
                left: 12
                right: 12
            }

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: "#11111B"

                ClockWidget {
                    anchors.centerIn: parent
                    time: timeSource.time
                }
            }
        }
    }
}
