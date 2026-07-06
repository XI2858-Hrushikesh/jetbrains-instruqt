#!/bin/bash
# Starts KasmVNC (Xvnc + XFCE + built-in HTTPS websocket proxy) inside the
# container, then launches IntelliJ IDEA against the sample project.

set -uo pipefail

# Block external DNS resolution entirely. Confirmed live: with normal DNS in
# place, IntelliJ's main window failed to appear for several minutes while
# idea-startup.log repeatedly logged "AIPromoWindowAdvisor - Verdict
# calculation took too long" every ~43s on the dot -- a fixed interval like
# that, recurring across independent runs, matches a network call that's
# silently dropped (no response, no rejection) rather than actively refused,
# so the client just sits until its own internal timeout expires. Forcing
# sun.net.client.default*Timeout (an earlier attempt) had no effect, meaning
# whatever HTTP client IntelliJ uses here ignores that JDK property. This
# track has no legitimate need for external DNS at all (git, pytest, and the
# IDE itself are all local) -- with no nameservers configured, any such
# lookup fails in milliseconds instead of hanging.
echo "nameserver 127.0.0.1" > /etc/resolv.conf

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

vncserver :1 \
    -depth    24 \
    -geometry 1920x1080 \
    -localhost no

# Authenticated probe — KasmVNC blacklists a source IP after repeated
# unauthenticated requests, and an unauthenticated readiness loop like this
# one trips that blacklist against 127.0.0.1 within seconds, permanently
# breaking every later check from inside the container for this session.
MAX_WAIT=60
WAITED=0
until curl -s --max-time 5 --insecure -u root:instruqt "https://localhost:8080" -o /dev/null 2>/dev/null; do
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
