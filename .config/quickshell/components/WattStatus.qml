pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	property string wattExecutable: "/usr/local/bin/watt"

	property bool serviceActive: false
	property bool wattInfoValid: false
	property bool infoRequestPending: false
	property bool serviceRequestPending: false

	property string wattGovernor: ""
	property string wattTurbo: ""
	property string wattEpp: ""
	property string wattEpb: ""
	property string wattTemperature: ""
	property string wattPowerStatus: ""

	property string fallbackGovernor: ""
	property string fallbackTurbo: ""
	property string fallbackEpp: ""

	property string lastError: ""
	property double lastInfoUpdate: 0

	readonly property bool usingFallback: !wattInfoValid

	readonly property string governor: {
		const fromWatt = wattInfoValid && wattGovernor !== "" ? wattGovernor : "";
		if (fromWatt !== "")
			return fromWatt;
		return fallbackGovernor !== "" ? fallbackGovernor : "Unknown";
	}

	readonly property string turboStatus: {
		const fromWatt = wattInfoValid && wattTurbo !== "" ? wattTurbo : "";
		if (fromWatt !== "")
			return fromWatt;
		return fallbackTurbo !== "" ? fallbackTurbo : "Unknown";
	}

	readonly property string energyPreference: {
		const fromWatt = wattInfoValid && wattEpp !== "" ? wattEpp : "";
		if (fromWatt !== "")
			return fromWatt;
		return fallbackEpp;
	}

	readonly property string energyBias: wattInfoValid ? wattEpb : ""

	readonly property string powerStatus: wattInfoValid ? (wattPowerStatus || "") : ""

	readonly property string profileLabel: {
		const status = powerStatus.toLowerCase();
		if (status.includes("ac"))
			return "Charger";
		if (status.includes("battery"))
			return "Battery";
		return "";
	}

	readonly property string temperature: wattInfoValid ? wattTemperature : ""

	readonly property bool infoStale: lastInfoUpdate > 0 && (Date.now() - lastInfoUpdate) > 30000

	readonly property string statusMessage: {
		if (lastError !== "")
			return lastError;
		if (infoStale)
			return "Watt data stale";
		if (usingFallback)
			return "Using fallback sysfs data";
		return "";
	}

	Component.onCompleted: {
		infoTimer.start();
		serviceTimer.start();
		loadFallbackValues();
	}

	property list<QtObject> helpers: [
		Timer {
			id: infoTimer
			interval: 8000
			repeat: true
			triggeredOnStart: true
			onTriggered: root.requestInfo()
		},

		Timer {
			id: serviceTimer
			interval: 30000
			repeat: true
			triggeredOnStart: true
			onTriggered: root.requestServiceStatus()
		},

		Timer {
			id: fallbackReloadTimer
			interval: 10000
			repeat: true
			running: root.usingFallback
			onTriggered: loadFallbackValues()
		},

		Process {
			id: wattInfoProcess
			command: [root.wattExecutable, "info"]
			stdout: StdioCollector {
				id: wattInfoStdout
				waitForEnd: true
				onStreamFinished: root.handleInfoOutput(text)
			}
			stderr: StdioCollector {
				id: wattInfoStderr
				waitForEnd: true
			}

			onRunningChanged: {
				if (!running && root.infoRequestPending) {
					root.infoRequestPending = false;
					wattInfoRestartTimer.start();
				}
			}

			onExited: function(exitCode, exitStatus) {
				if (exitStatus !== 0 || exitCode !== 0) {
					root.lastError = wattInfoStderr.text !== "" ? wattInfoStderr.text.trim() : "Failed to query Watt (exit code " + exitCode + ")";
					root.wattInfoValid = false;
					root.loadFallbackValues();
				}
			}
		},

		Timer {
			id: wattInfoRestartTimer
			interval: 200
			onTriggered: root.requestInfo()
		},

		Process {
			id: wattServiceProcess
			command: ["systemctl", "is-active", "--quiet", "watt"]
			stderr: StdioCollector {
				id: wattServiceStderr
				waitForEnd: true
			}

			onRunningChanged: {
				if (!running && root.serviceRequestPending) {
					root.serviceRequestPending = false;
					serviceRestartTimer.start();
				}
			}

			onExited: function(exitCode) {
				root.serviceActive = exitCode === 0;
			}
		},

		Timer {
			id: serviceRestartTimer
			interval: 200
			onTriggered: root.requestServiceStatus()
		},

		Process {
			id: fallbackGovernorProcess
			command: ["cat", "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"]
			stdout: StdioCollector {
				waitForEnd: true
				onStreamFinished: root.fallbackGovernor = text.trim()
			}
			stderr: StdioCollector {
				waitForEnd: true
			}
			onExited: function(exitCode) {
				if (exitCode !== 0)
					root.fallbackGovernor = "";
			}
		},

		Process {
			id: fallbackTurboProcess
			command: ["cat", "/sys/devices/system/cpu/cpufreq/boost"]
			stdout: StdioCollector {
				waitForEnd: true
				onStreamFinished: {
					const trimmed = text.trim().toLowerCase();
					if (trimmed === "1")
						root.fallbackTurbo = "Enabled";
					else if (trimmed === "0")
						root.fallbackTurbo = "Disabled";
					else
						root.fallbackTurbo = text.trim();
				}
			}
			stderr: StdioCollector {
				waitForEnd: true
			}
			onExited: function(exitCode) {
				if (exitCode !== 0)
					root.fallbackTurbo = "";
			}
		},

		Process {
			id: fallbackEppProcess
			command: ["cat", "/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference"]
			stdout: StdioCollector {
				waitForEnd: true
				onStreamFinished: root.fallbackEpp = text.trim()
			}
			stderr: StdioCollector {
				waitForEnd: true
			}
			onExited: function(exitCode) {
				if (exitCode !== 0)
					root.fallbackEpp = "";
			}
		}
	]

	function requestInfo() {
		if (wattInfoProcess.running) {
			root.infoRequestPending = true;
			return;
		}
		root.infoRequestPending = false;
		root.lastError = "";
		wattInfoProcess.running = true;
	}

	function requestServiceStatus() {
		if (wattServiceProcess.running) {
			root.serviceRequestPending = true;
			return;
		}
		root.serviceRequestPending = false;
		wattServiceProcess.running = true;
	}

	function handleInfoOutput(output) {
		if (!output || output.trim() === "") {
			root.wattInfoValid = false;
			root.lastError = "No data from watt info";
			root.loadFallbackValues();
			return;
		}

		const lines = output.split(/\r?\n/);
		let governor = "";
		let turbo = "";
		let epp = "";
		let epb = "";
		let temperature = "";
		let powerStatus = "";

		for (let i = 0; i < lines.length; ++i) {
			const line = lines[i].trim();
			if (line === "")
				continue;

			if (line.startsWith("Current Governor:")) {
				governor = line.slice("Current Governor:".length).trim();
			} else if (line.startsWith("Turbo Status:")) {
				turbo = line.slice("Turbo Status:".length).trim();
			} else if (line.startsWith("EPP:")) {
				epp = line.slice("EPP:".length).trim();
			} else if (line.startsWith("EPB:")) {
				epb = line.slice("EPB:".length).trim();
			} else if (line.startsWith("CPU Temperature:")) {
				temperature = line.slice("CPU Temperature:".length).trim();
			} else if (powerStatus === "" && line.startsWith("Power Status:")) {
				powerStatus = line.slice("Power Status:".length).trim();
			}
		}

		if (governor === "" && turbo === "" && powerStatus === "") {
			root.wattInfoValid = false;
			root.lastError = "Unexpected watt info format";
			root.loadFallbackValues();
			return;
		}

		root.wattGovernor = governor;
		root.wattTurbo = turbo;
		root.wattEpp = epp;
		root.wattEpb = epb;
		root.wattTemperature = temperature;
		root.wattPowerStatus = powerStatus;
		root.wattInfoValid = true;
		root.lastError = "";
		root.lastInfoUpdate = Date.now();
	}

	function loadFallbackValues() {
		runFallbackProcess(fallbackGovernorProcess);
		runFallbackProcess(fallbackTurboProcess);
		runFallbackProcess(fallbackEppProcess);
	}

	function runFallbackProcess(proc) {
		if (!proc.running)
			proc.running = true;
	}
}
