#!/bin/bash
# Starts KasmVNC, XFCE desktop, and IntelliJ IDEA inside the container.

set -e

DISPLAY_NUM=1
export DISPLAY=:${DISPLAY_NUM}
export HOME=/root
export USER=root

# Generate self-signed SSL cert if not present
if [ ! -f /etc/ssl/private/kasmvnc.key ]; then
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout /etc/ssl/private/kasmvnc.key \
        -out /etc/ssl/certs/kasmvnc.crt \
        -subj "/CN=localhost" 2>/dev/null
fi

# Write KasmVNC config
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
  use_ssl: true
  ssl_certificate: /etc/ssl/certs/kasmvnc.crt
  ssl_key: /etc/ssl/private/kasmvnc.key
auth:
  require_password: false
KASMCONF

# Set a dummy VNC password (required by vncpasswd even if auth disabled)
echo -e "password\npassword\n" | vncpasswd -f > /root/.vnc/passwd 2>/dev/null || true
chmod 600 /root/.vnc/passwd

# Start KasmVNC server
vncserver :${DISPLAY_NUM} \
    -geometry 1920x1080 \
    -depth 24 \
    -SecurityTypes None \
    --I-know-what-I-am-doing \
    2>/tmp/vncserver.log || true

# Wait for X display
for i in $(seq 1 20); do
    if xdpyinfo -display :${DISPLAY_NUM} >/dev/null 2>&1; then
        echo "X display :${DISPLAY_NUM} is ready."
        break
    fi
    sleep 1
done

# Start XFCE desktop
startxfce4 &
sleep 4

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
