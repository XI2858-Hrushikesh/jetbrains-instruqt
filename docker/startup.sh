#!/bin/bash
# Starts KasmVNC (Xvnc + XFCE + built-in HTTPS websocket proxy) inside the
# container, then launches IntelliJ IDEA against the sample project.

set -uo pipefail

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

vncserver :1 \
    -depth    24 \
    -geometry 1920x1080 \
    -localhost no

MAX_WAIT=60
WAITED=0
until curl -s --max-time 5 --insecure "https://localhost:8080" -o /dev/null 2>/dev/null; do
    if [ "${WAITED}" -ge "${MAX_WAIT}" ]; then
        echo "ERROR: KasmVNC did not come up on :8080 within ${MAX_WAIT}s" >&2
        cat /root/.vnc/*.log 2>/dev/null | tail -30
        exit 1
    fi
    sleep 2
    WAITED=$((WAITED + 2))
done
echo "KasmVNC is up on :8080"

# Launch IntelliJ IDEA with the task_tracker project
export DISPLAY=:1
IDEA_BIN=/opt/intellij-idea/bin/idea
if [ -x "$IDEA_BIN" ]; then
    nohup "$IDEA_BIN" nosplash /workspace/task_tracker >/tmp/idea-startup.log 2>&1 &
    echo "IntelliJ IDEA launched."
else
    echo "WARNING: IntelliJ IDEA binary not found at $IDEA_BIN." >&2
fi

echo "Environment ready. KasmVNC on port 8080."

# Keep container alive
tail -f /dev/null
