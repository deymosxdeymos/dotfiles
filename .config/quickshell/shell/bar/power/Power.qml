import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets
import qs
import qs.bar
import qs.components
import "../../../components" as AppComponents

BarWidgetInner {
	id: root
	required property var bar;
	readonly property var wattStatus: AppComponents.WattStatus;

	readonly property var displayDevice: {
		const device = UPower.displayDevice;
		return device !== undefined ? device : null;
	}
	readonly property int chargeState: displayDevice ? displayDevice.state : UPowerDeviceState.Unknown
	readonly property bool isCharging: chargeState == UPowerDeviceState.Charging;
	readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge;
	readonly property real percentage: displayDevice ? displayDevice.percentage : 0
	readonly property bool isLow: percentage <= 0.20 && displayDevice !== null

	readonly property var upowerDevices: {
		const devices = UPower.devices;
		return devices && devices.values ? devices.values : [];
	}
	readonly property UPowerDevice batteryDevice: {
		const list = upowerDevices;
		for (let i = 0; i < list.length; ++i) {
			const device = list[i];
			if (device && device.isLaptopBattery) return device;
		}
		return null;
	}

	function statusStr() {
		return root.isPluggedIn ? `Plugged in, ${root.isCharging ? "Charging" : "Not Charging"}`
		                        : "Discharging";
	}

	property bool showMenu: false;

	implicitHeight: width
	color: isLow ? "#45ff6060" : ShellGlobals.colors.widget

	BarButton {
		id: button
		anchors.fill: parent
		baseMargin: 5
		fillWindowWidth: true
		acceptedButtons: Qt.RightButton
		directScale: true
		showPressed: root.showMenu

		onPressed: {
			root.showMenu = !root.showMenu
		}

		BatteryIcon {
			device: root.displayDevice
			visible: root.displayDevice !== null
		}

		IconImage {
			visible: root.displayDevice === null
			source: "root:icons/battery-empty.svg"
			implicitSize: 24
			anchors.centerIn: parent
		}
	}

	property TooltipItem tooltip: TooltipItem {
		id: tooltip
		tooltip: bar.tooltip
		owner: root
		show: button.containsMouse

		Loader {
			active: tooltip.visible

			sourceComponent: Label {
				text: {
					const status = root.statusStr();

					const percentage = Math.round(root.percentage * 100);

					let str = `${percentage}% - ${status}`;
					return str;
				}
			}
		}
	}

	property TooltipItem rightclickMenu: TooltipItem {
		id: rightclickMenu
		tooltip: bar.tooltip
		owner: root

		isMenu: true
		show: root.showMenu
		onClose: root.showMenu = false

		Loader {
			active: rightclickMenu.visible
			sourceComponent: ColumnLayout {
				spacing: 10

				FontMetrics { id: fm }

				component SmallLabel: Label {
					font.pointSize: fm.font.pointSize * 0.8
					color: "#d0eeffff"
				}
			
				RowLayout {
					IconImage {
						source: "root:icons/gauge.svg"
						implicitSize: 32
					}

					ColumnLayout {
						spacing: 0
						Label { text: "Power Status" }

						ColumnLayout {
							Layout.fillWidth: true
							spacing: 2

							SmallLabel {
								text: {
									const profile = root.wattStatus.profileLabel;
									if (profile && profile !== "") return `Profile: ${profile}`;
									return `Profile: ${root.isPluggedIn ? "Charger" : "Battery"}`;
								}
							}

							SmallLabel { text: `Governor: ${root.wattStatus.governor}` }

							SmallLabel {
								text: `Turbo: ${root.wattStatus.turboStatus}`
								color: root.wattStatus.turboStatus.toLowerCase().startsWith("enabled") ? "#d0eeffff" : "#ffd480"
							}

							SmallLabel {
								visible: root.wattStatus.energyPreference !== ""
								text: `EPP: ${root.wattStatus.energyPreference}`
							}

							SmallLabel {
								visible: root.wattStatus.energyBias !== ""
								text: `EPB: ${root.wattStatus.energyBias}`
							}

							SmallLabel {
								visible: root.wattStatus.temperature !== ""
								text: `CPU Temp: ${root.wattStatus.temperature}`
							}

							SmallLabel {
								text: root.wattStatus.serviceActive ? "Watt service: active" : "Watt service: inactive"
								color: root.wattStatus.serviceActive ? "#d0eeffff" : "#ff8080"
							}

							SmallLabel {
								visible: root.wattStatus.usingFallback
								text: "Using fallback sysfs data"
								color: "#ffb347"
							}

							SmallLabel {
								visible: root.wattStatus.statusMessage !== "" && !root.wattStatus.usingFallback
								text: root.wattStatus.statusMessage
								color: "#ffb347"
							}
						}
					}
				}

				RowLayout {
					IconImage {
						Layout.alignment: Qt.AlignTop
						source: "root:icons/battery-empty.svg"
						implicitSize: 32
					}

					ColumnLayout {
						spacing: 0

						RowLayout {
							Label { text: "Battery" }
							Item { Layout.fillWidth: true }
							Label {
								text: `${root.statusStr()} -`
								color: "#d0eeffff"
							}
							Label { text: `${Math.round(root.percentage * 100)}%` }
						}

						ProgressBar {
							Layout.topMargin: 5
							Layout.bottomMargin: 5
							Layout.fillWidth: true
							value: {
								const device = root.displayDevice;
								return device ? device.percentage : 0;
							}
						}

						RowLayout {
							visible: root.displayDevice && remainingTimeLbl.text !== ""

							SmallLabel { text: "Time remaining" }
							Item { Layout.fillWidth: true }

				     	SmallLabel {
								id: remainingTimeLbl
				     		text: {
				     			const device = root.displayDevice;
				     			if (!device) return "";
				     			const time = device.timeToEmpty || device.timeToFull;

									if (time === 0) return "";
									const minutes = Math.floor(time / 60).toString().padStart(2, '0');
									return `${minutes} minutes`
				     		}
				     	}
						}

						RowLayout {
							visible: root.batteryDevice && root.batteryDevice.healthSupported
							SmallLabel { text: "Health" }
							Item { Layout.fillWidth: true }

				     	SmallLabel {
							text: {
								const device = root.batteryDevice;
								const health = device ? (device.healthPercentage ?? 0) : 0;
								return `${Math.floor(health)}%`;
							}
				     	}
						}
					}
				}

				Repeater {
					model: ScriptModel {
						// external devices
						values: root.upowerDevices.filter(device => !device.powerSupply)
					}

			   	RowLayout {
						required property UPowerDevice modelData;

			   		IconImage {
			   			Layout.alignment: Qt.AlignTop
			   			source: {
								switch (modelData.type) {
								case UPowerDeviceType.Headset: return "root:icons/headset.svg";
								}
								return Quickshell.iconPath(modelData.iconName)
							}
			   			implicitSize: 32
			   		}

			   		ColumnLayout {
			   			spacing: 0

			   			RowLayout {
			   				Label { text: modelData.model }
			   				Item { Layout.fillWidth: true }
			   				Label { text: `${Math.round(modelData.percentage * 100)}%` }
			   			}

			   			ProgressBar {
			   				Layout.topMargin: 5
			   				Layout.bottomMargin: 5
			   				Layout.fillWidth: true
			   				value: modelData.percentage
			   			}

			   			RowLayout {
			   				visible: modelData.healthSupported
			   				SmallLabel { text: "Health" }
			   				Item { Layout.fillWidth: true }

			   	     	SmallLabel {
			   	     		text: `${Math.floor(modelData.healthPercentage)}%`
			   	     	}
			   			}
			   		}
			   	}
				}
			}
		}
	}
}
