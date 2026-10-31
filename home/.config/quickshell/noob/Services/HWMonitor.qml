pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string thermalZone: "thermal_zone1"
    property string battery: "BAT0"
    property string networkInterface: "wlp3s0"
    property int updateSec: 2

    property real cpuUsage
    property int cpuTemperature
    property real memUsed
    property int powerCapacity
    property real downloadMBps

    FileView {
        id: cpuFile
        property real prevTotal
        property real prevIdle
        path: "/proc/stat"
        onLoaded: {
            // Like BTOP, iowait is considered idle
            const numbers = text().match(/\d+/g).slice(0, 7).map(Number);
            const total = numbers.reduce((a, b) => a + b);
            const idle = numbers[3] + numbers[4];
            const dTotal = total - prevTotal;
            const dIdle = idle - prevIdle;
            root.cpuUsage = ((dTotal - dIdle) / dTotal) * 100;
            prevTotal = total;
            prevIdle = idle;
        }
    }

    FileView {
        id: temperatureFile
        path: `/sys/class/thermal/${root.thermalZone}/temp`
        onLoaded: root.cpuTemperature = text() / 1000
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const numbers = text().match(/\d+/g);
            // (MemTotal - MemAvail) convert kB to GiB
            root.memUsed = (numbers[0] - numbers[2]) / 1048576;
        }
    }

    FileView {
        id: powerFile
        path: `/sys/class/power_supply/${root.battery}/capacity`
        onLoaded: root.powerCapacity = text()
    }

    FileView {
        id: netwFile
        property real prevBytes
        path: `/sys/class/net/${root.networkInterface}/statistics/rx_bytes`
        onLoaded: {
            const bytes = text();
            if (prevBytes > 0)
                // (current - previous) converted to MiB/s
                root.downloadMBps = (bytes - prevBytes) / 1048576 / root.updateSec;
            prevBytes = bytes;
        }
    }

    Timer {
        interval: root.updateSec * 1000
        running: true
        repeat: true
        onTriggered: {
            cpuFile.reload();
            temperatureFile.reload();
            memFile.reload();
            powerFile.reload();
            netwFile.reload();
        }
    }
}
