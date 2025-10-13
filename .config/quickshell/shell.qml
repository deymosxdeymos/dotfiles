//@ pragma ShellId shell
//@ pragma IconTheme breeze-dark

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "screenshot" as Screenshot
import "bar" as Bar
import "lock" as Lock
import "notifications" as Notifs
import "launcher" as Launcher
import "background"

ShellRoot {
	Component.onCompleted: [Lock.Controller, Launcher.Controller.init()]

	Process {
		command: ["mkdir", "-p", ShellGlobals.rtpath]
		running: true
	}

	LazyLoader {
		id: screenshot
		loading: true

		Screenshot.Controller {
		}
	}

	Connections {
		target: ShellIpc

		function onScreenshot() {
			screenshot.item.shooting = true;
		}
	}

	Notifs.NotificationOverlay {
		screen: {
			const screens = Quickshell.screens;
			if (!screens || screens.length === 0 || screens.length === undefined) {
				return null;
			}
			for (let i = 0; i < screens.length; ++i) {
				const info = screens[i];
				if (info && info.name === "DP-1") {
					return info;
				}
			}
			return screens[0];
		}
	}

	Variants {
		model: Quickshell.screens

		Scope {
			property var modelData
			property var screenInfo: modelData ?? null

			Bar.Bar {
				screen: screenInfo
			}

			PanelWindow {
				id: window

				screen: screenInfo

				exclusionMode: ExclusionMode.Ignore
				WlrLayershell.layer: WlrLayer.Background
				WlrLayershell.namespace: "shell:background"

				anchors {
					top: true
					bottom: true
					left: true
					right: true
				}

				BackgroundImage {
					anchors.fill: parent
					screen: window.screen
				}
			}
		}
	}
}
