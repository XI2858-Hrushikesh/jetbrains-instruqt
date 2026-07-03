#!/bin/bash
# Starts Xvfb + XFCE + x11vnc + noVNC inside the container.

export DISPLAY=:1
export HOME=/root
export USER=root
export XFCE_ALLOW_ROOT=1

# Start virtual framebuffer
Xvfb :1 -screen 0 1920x1080x24 >/dev/null 2>&1 &
sleep 3

# Start XFCE desktop
startxfce4 >/dev/null 2>&1 &
sleep 5

# Start x11vnc
x11vnc -display :1 -forever -nopw -listen 127.0.0.1 -rfbport 5900 -quiet >/dev/null 2>&1 &
sleep 2

# Find noVNC web root
NOVNC_WEB=""
for candidate in /usr/share/novnc /usr/share/novnc/web /opt/novnc; do
    if [ -f "${candidate}/vnc.html" ] || [ -f "${candidate}/index.html" ]; then
        NOVNC_WEB="$candidate"
        break
    fi
done

# Start websocket proxy on port 8080
if [ -n "$NOVNC_WEB" ]; then
    python3 -m websockify --web="$NOVNC_WEB" 8080 127.0.0.1:5900 >/dev/null 2>&1 &
    echo "noVNC started with web root: $NOVNC_WEB"
else
    # Fallback: plain websockify without web files
    python3 -m websockify 8080 127.0.0.1:5900 >/dev/null 2>&1 &
    echo "websockify started (no web root found)"
fi

# Launch IntelliJ IDEA with the task_tracker project
IDEA_BIN=$(ls /opt/idea-IC-*/bin/idea.sh 2>/dev/null | head -1)
if [ -n "$IDEA_BIN" ]; then
    "$IDEA_BIN" /workspace/task_tracker >/dev/null 2>&1 &
    echo "IntelliJ IDEA launched."
else
    echo "WARNING: IntelliJ IDEA binary not found." >&2
fi

echo "Environment ready. noVNC on port 8080."

# Keep container alive
tail -f /dev/null
