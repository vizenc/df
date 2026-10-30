pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
    id: root

    readonly property string winTitle: ToplevelManager.activeToplevel?.title || "Quickshell"

    // Workspaces cached from niri's EventStream (niri's own object shape).
    property var workspaces: []

    function goToWorkspace(n: int): void {
        if (!reqSocket.connected)
            return;
        // Our index is 0-based, niri's is 1-based.
        const message = {
            Action: {
                FocusWorkspace: {
                    reference: {
                        Index: n + 1
                    }
                }
            }
        };
        reqSocket.write(JSON.stringify(message) + "\n");
        reqSocket.flush();
    }

    // Actions + replies. Kept separate from the event socket so replies
    // don't get mixed with broadcast events.
    Socket {
        id: reqSocket
        path: Quickshell.env("NIRI_SOCKET") || ""
        connected: path !== ""
        parser: SplitParser {
            onRead: line => {
                const reply = JSON.parse(line);
                if (reply.Err)
                    console.warn("niri:", reply.Err);
            }
        }
    }

    // Second connection, subscribed to niri's event stream.
    Socket {
        path: reqSocket.path
        connected: path !== ""
        onConnectedChanged: {
            // Must subscribe explicitly, otherwise no events arrive.
            if (connected) {
                write('"EventStream"\n');
                flush();
            }
        }
        parser: SplitParser {
            onRead: line => {
                const ev = JSON.parse(line);
                if (ev.WorkspacesChanged) {
                    // Full replacement; sort by idx for stable order.
                    root.workspaces = ev.WorkspacesChanged.workspaces.sort((a, b) => a.idx - b.idx);
                } else if (ev.WorkspaceActivated) {
                    // Event carries no output, so look it up. Only one workspace
                    // per output can be active, so deactivate siblings.
                    const activation = ev.WorkspaceActivated;
                    const output = root.workspaces.find(w => w.id === activation.id)?.output;
                    root.workspaces = root.workspaces.map(w => Object.assign({}, w, {
                            is_active: w.output === output ? w.id === activation.id : w.is_active,
                            is_focused: activation.focused ? w.id === activation.id : w.is_focused
                        }));
                } else if (ev.WorkspaceUrgencyChanged) {
                    const urgencyChange = ev.WorkspaceUrgencyChanged;
                    root.workspaces = root.workspaces.map(w => w.id === urgencyChange.id ? Object.assign({}, w, {
                            is_urgent: urgencyChange.urgent
                        }) : w);
                }
            }
        }
    }
}
