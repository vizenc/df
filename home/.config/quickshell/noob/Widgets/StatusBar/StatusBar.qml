pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Bluetooth
import qs.Common
import qs.Services

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: window
        required property ShellScreen modelData
        screen: modelData

        WlrLayershell.namespace: "noob-statusbar"
        BackgroundEffect.blurRegion: Region {
            Region {
                item: wsGroup.background
                radius: wsGroup.background.radius
            }
            Region {
                item: winGroup.background
                radius: winGroup.background.radius
            }
            Region {
                item: trayLoader.item?.background ?? null
                radius: trayLoader.item?.background.radius ?? 0
            }
            Region {
                item: hwGroup.background
                radius: hwGroup.background.radius
            }
            Region {
                item: controlGroup.background
                radius: controlGroup.background.radius
            }
            Region {
                item: clockGroup.background
                radius: clockGroup.background.radius
            }
        }
        color: "transparent"
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: container.implicitHeight

        Control {
            id: container
            anchors.fill: parent
            topPadding: 8
            horizontalPadding: 8
            contentItem: RowLayout {
                spacing: 8

                WmWorkspaces {
                    id: wsGroup
                    activeIcon: "󰮯"
                    defaultIcon: "•"
                    activeColor: Theme.yellow
                }

                Group {
                    id: winGroup
                    Layout.preferredHeight: hwGroup.height
                    verticalPadding: 0
                    Module {
                        format: `<font color="${Theme.blue}">󰊠</font> ${WMan.winTitle}`
                        Layout.maximumWidth: 420
                        elide: Text.ElideRight
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Tray {
                    id: trayLoader
                    Layout.preferredHeight: hwGroup.height
                    iconSize: 16
                    parentWindow: window
                }

                Group {
                    id: hwGroup
                    Module {
                        format: `<font color="${Theme.blue}">󰍛</font> ${HWMonitor.cpuUsage.toFixed(0)}%`
                        onClickCmd: "foot -T 'Task Manager' btop"
                    }
                    Module {
                        format: `<font color="${Theme.red}"></font> ${HWMonitor.cpuTemperature}C`
                        onClickCmd: "foot -T 'Task Manager' btop"
                    }
                    Module {
                        format: `<font color="${Theme.magenta}">󰘚</font> ${HWMonitor.memUsed.toFixed(1)}G`
                        onClickCmd: "foot -T 'Task Manager' btop"
                    }
                }

                Group {
                    id: controlGroup
                    Module {
                        format: `<font color="${Theme.green}"></font> ${HWMonitor.powerCapacity}%`
                        onClickCmd: "foot -T 'Battery Details' sh -c 'cat /sys/class/power_supply/BAT*/uevent; read'"
                    }
                    Module {
                        format: `<font color="${Theme.cyan}">󰤨</font> ${HWMonitor.downloadMBps.toFixed(1)}M`
                        onClickCmd: "foot -T 'Network Manager' nmtui"
                    }
                    Module {
                        format: `<font color="${Theme.blue}"></font> ${Bluetooth.defaultAdapter?.state == "1" ? "On" : "Off"}`
                        onClickCmd: "foot -T 'Bluetooth Manager' bluetui"
                    }
                    Module {
                        format: `<font color="${Theme.red}">${Audio.isMuted ? "󰖁" : "󰕾"}</font> ${Audio.speakerVolume.toFixed(0)}%`
                        onClickCmd: "foot -T 'Audio Manager' wiremix"
                    }
                }

                Group {
                    id: clockGroup
                    Module {
                        format: `<font color="${Theme.yellow}">󰥔</font> ${Time.dateTime}`
                        onClickCmd: "foot -T 'Calendar' sh -c 'cal --year; read'"
                    }
                }
            }
        }
    }
}
