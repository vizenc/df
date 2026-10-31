pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property PwNodeAudio pwAudio: Pipewire.defaultAudioSink?.audio || null
    property real speakerVolume: pwAudio?.volume * 100 ?? 0
    property bool isMuted: pwAudio?.muted ?? false
}
