#!/bin/bash
# Starts Xvfb + XFCE + x11vnc + noVNC inside the container.

export DISPLAY=:1
export HOME=/root
export USER=root
export XFCE_ALLOW_ROOT=1

# Start virtual framebuffer
Xvfb :1 -screen 0 1920x1080x24 >/dev/null 2>&1 &
sleep 2

# Start XFCE desktop
startxfce4 >/dev/null 2>&1 &
sleep 4

# Start x11vnc (no password, localhost only)
x11vnc -display :1 -forever -nopw -listen 127.0.0.1 -rfbport 5900 -quiet >/dev/null 2>&1 &
sleep 1

# Start noVNC websocket proxy on port 8080
websockify --web=/usr/share/novnc 8080 127.0.0.1:5900 >/dev/null 2>&1 &

echo "Environment ready. noVNC on port 8080."

# Launch IntelliJ IDEA with the task_tracker project
IDEA_BIN=$(ls /opt/idea-IC-*/bin/idea.sh 2>/dev/null | head -1)
if [ -n "$IDEA_BIN" ]; then
    "$IDEA_BIN" /workspace/task_tracker &
    echo "IntelliJ IDEA launched."
else
    echo "WARNING: IntelliJ IDEA binary not found." >&2
fi

# Keep container alive
tail -f /dev/null
