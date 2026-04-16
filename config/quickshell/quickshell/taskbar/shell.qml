import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "#1a1b26"

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    Item {
        // CPU Usage Process
        Process {
            id: cpuProc
            command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"]
            stdout: StdioCollector { onStreamFinished: cpuText.text = "󰻠 " + Math.round(this.text.trim()) + "%" }
        }
        
        // RAM Usage Process
        Process {
            id: ramProc
            command: ["sh", "-c", "free -h | awk '/^Mem:/ {print $3}'"]
            stdout: StdioCollector { onStreamFinished: ramText.text = "󰍛 " + this.text.trim() }
        }

        // Network Checker Process
        Process {
            id: netProc
            command: ["sh", "-c", "nmcli -t -f STATE general | grep -q 'connected' && echo 'up' || echo 'down'"]
            stdout: StdioCollector { onStreamFinished: netIndicator.color = this.text.trim() === "up" ? "#06d179" : "#f7768e" }
        }

        // Warp Checker Process
        Process {
            id: warpProc
            command: ["sh", "-c", "warp-cli status | grep -q 'Connected' && echo 'up' || echo 'down'"]
            stdout: StdioCollector { onStreamFinished: warpIndicator.color = this.text.trim() === "up" ? "#06d179" : "#f7768e" }
        }

        Timer {
            interval: 2000 // Update every 2 seconds
            running: true
            repeat: true
            onTriggered: {
                clockText.text = Qt.formatDateTime(new Date(), "dd MMMM (dddd), hh:mm")
                cpuProc.running = true
                ramProc.running = true
                netProc.running = true
                warpProc.running = true
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5 
        spacing: 12

         Rectangle {
            width: 20
            height: 20
            color: "transparent" 
            radius: 4

            Text {
                anchors.centerIn: parent
                text: "⏻"
                color: "#e3cd07"
                font.pixelSize: 16
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    Quickshell.execDetached(["sh", "-c", "wlogout --protocol layer-shell"])
                }
            }
        }

        Row {
            spacing: 8
            Repeater {
                model: 9

                Text {
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    text: index + 1
                    color: isActive ? "#06d179" : (ws ? "#ffffff" : "#444b6a")
                    font { pixelSize: 16; bold: false }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }
                }
            }
        }


        Item { Layout.fillWidth: true }

        Text {
            id: clockText
            Layout.alignment: Qt.AlignCenter
            text: Qt.formatDateTime(new Date(), "dd MMMM (dddd), hh:mm")
            color: "#c0caf5"
            font.pixelSize: 16
        }

        Item { Layout.fillWidth: true }

        // ==========================================
        // RIGHT SIDE: Stats, Toggles, Audio, Tray
        // ==========================================
        Row {
            Layout.alignment: Qt.AlignRight
            spacing: 15

            // --- CPU & RAM ---
            Row {
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    id: cpuText
                    text: "󰻠 --%"
                    color: "#7aa2f7"
                    font.pixelSize: 16
                }
                Text {
                    id: ramText
                    text: "󰍛 --"
                    color: "#bb9af7"
                    font.pixelSize: 16
                }
            }

            // --- (Network & Warp) ---
            Row {
                spacing: 12
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    id: netIndicator
                    width: 16
                    height: 16
                    radius: 8
                    color: "#444b6a" 
                }
                Rectangle {
                    id: warpIndicator
                    width: 16
                    height: 16
                    radius: 8
                    color: "#444b6a"
                }
            }

            // --- Orbit ---
            Rectangle {
                width: 20
                height: 14
                color: "transparent"
                radius: 5
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "🌐" 
                    font.pixelSize: 16
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["sh", "-c", "orbit toggle top-right"])
                }
            }

            // --- Audio (Volume & Mic) && Pavucontrol ---
            Row {
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter

                // Sink (Speakers)
                Text {
                    property var node: Pipewire.defaultAudioSink
                    text: "󰕾 " + (node && node.audio ? Math.round(node.audio.volume * 100) + "%" : "Muted")
                    color: "#9ece6a"
                    font.pixelSize: 13
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["pavucontrol"])
                    }
                }

                // Source (Microphone)
                Text {
                    property var node: Pipewire.defaultAudioSource
                    text: "󰍬 " + (node && node.audio ? Math.round(node.audio.volume * 100) + "%" : "Muted")
                    color: "#f7768e"
                    font.pixelSize: 13

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["pavucontrol"])
                    }
                }
            }

            // --- System Tray ---
            Row {
                spacing: 6
                anchors.verticalCenter: parent.verticalCenter
                
                Repeater {
                    model: SystemTray.items
                    
                    Image {
                        source: modelData.icon
                        sourceSize.width: 16
                        sourceSize.height: 16
                        width: 16
                        height: 16
                        anchors.verticalCenter: parent.verticalCenter
                        
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) {
                                    modelData.activate()
                                } else if (mouse.button === Qt.RightButton) {
                                    modelData.contextMenu()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

     Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        
        // Set your custom thickness here
        height: 2 
        
        // Set your custom border color here (e.g., a nice blue/purple accent)
        color: "#7aa2f7" 
    }
}
