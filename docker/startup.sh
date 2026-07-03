#!/bin/bash
# Starts KasmVNC, XFCE desktop, and IntelliJ IDEA inside the container.

DISPLAY_NUM=1
export DISPLAY=:${DISPLAY_NUM}
export HOME=/root
export USER=root
export XFCE_ALLOW_ROOT=1

# Write KasmVNC config (plain HTTP — Instruqt handles external TLS)
mkdir -p /root/.vnc
cat > /root/.vnc/kasmvnc.yaml <<'KASMCONF'
logging:
  log_writer_name: all
  log_dest: logfile
  level: 30
desktop:
  allow_resize: false
  size:
    width: 1920
    height: 1080
network:
  interface: 0.0.0.0
  websocket_port: 8080
  use_ssl: false
auth:
  require_password: false
KASMCONF

# Create a passwd file to prevent interactive password prompt
mkdir -p /root/.vnc
printf "password\npassword\n\n" | vncpasswd 2>/dev/null || true
chmod 600 /root/.vnc/passwd 2>/dev/null || true

# Start KasmVNC server
vncserver :${DISPLAY_NUM} \
    -geometry 1920x1080 \
    -depth 24 \
    -SecurityTypes None \
    --I-know-what-I-am-doing \
    2>/tmp/vncserver.log || true

echo "vncserver started (exit: $?)"

# Wait for X display
for i in $(seq 1 30); do
    if xdpyinfo -display :${DISPLAY_NUM} >/dev/null 2>&1; then
        echo "X display :${DISPLAY_NUM} is ready."
        break
    fi
    sleep 1
done

# Start XFCE desktop
startxfce4 &
sleep 5

# Disable XFCE screensaver and power management
xfconf-query -c xfce4-screensaver -p /screensaver/enabled -s false 2>/dev/null || true
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0 2>/dev/null || true

# Launch IntelliJ IDEA with the task_tracker project
IDEA_BIN=$(ls /opt/idea-IC-*/bin/idea.sh 2>/dev/null | head -1)
if [ -n "$IDEA_BIN" ]; then
    "$IDEA_BIN" /workspace/task_tracker &
    echo "IntelliJ IDEA launched."
else
    echo "WARNING: IntelliJ IDEA binary not found." >&2
fi

echo "Environment ready. KasmVNC on port 8080."

# Keep container alive
tail -f /dev/null
