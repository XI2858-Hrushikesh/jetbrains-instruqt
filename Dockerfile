# syntax=docker/dockerfile:1
# JetBrains IntelliJ IDEA + KasmVNC for Instruqt workshop
# Build: docker build -t hrushikeshkanade/jetbrains-instruqt:latest .
# Push:  docker push hrushikeshkanade/jetbrains-instruqt:latest

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG IDEA_VERSION=2025.3
ARG KASMVNC_VERSION=1.4.0

ENV HOME=/root
ENV USER=root
ENV DISPLAY=:1

# ─── System packages ──────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    curl wget git sudo \
    python3 python3-pip python3-pytest \
    openjdk-21-jre-headless \
    xfce4 xfce4-terminal dbus-x11 \
    x11-utils x11-xserver-utils \
    xfonts-base ca-certificates openssl \
    xdotool wmctrl \
    && rm -rf /var/lib/apt/lists/*

# ─── Install IntelliJ IDEA 2025.3 Unified ─────────────────────────────────────
# Streamed directly into tar (no temp file), fixed extraction path avoids
# guessing the versioned directory name the tarball unpacks to.
RUN mkdir -p /opt/intellij-idea && \
    wget -qO- "https://download.jetbrains.com/idea/ideaIU-${IDEA_VERSION}.tar.gz" \
        | tar -xz -C /opt/intellij-idea --strip-components=1 && \
    ln -sf /opt/intellij-idea/bin/idea /usr/local/bin/idea

# ─── Install KasmVNC (jammy build — matches ubuntu:22.04 base) ────────────────
RUN KASMVNC_DEB="kasmvncserver_jammy_${KASMVNC_VERSION}_amd64.deb" && \
    wget -q -O "/tmp/${KASMVNC_DEB}" \
        "https://github.com/kasmtech/KasmVNC/releases/download/v${KASMVNC_VERSION}/${KASMVNC_DEB}" && \
    apt-get update && apt-get install -y "/tmp/${KASMVNC_DEB}" && \
    rm -f "/tmp/${KASMVNC_DEB}" && rm -rf /var/lib/apt/lists/* && \
    usermod -aG ssl-cert root

# select-de.sh prompts interactively even when xstartup already exists —
# replace with a no-op, our own xstartup (written at runtime) starts XFCE4.
RUN printf '#!/bin/bash\nexit 0\n' > /usr/lib/kasmvncserver/select-de.sh && \
    chmod +x /usr/lib/kasmvncserver/select-de.sh

# Copy sample project
COPY docker/task_tracker /workspace/task_tracker

# Initialise git repo so Challenge 3 commit step works
RUN cd /workspace/task_tracker && \
    git config --global user.email "learner@instruqt.com" && \
    git config --global user.name "Learner" && \
    git init && \
    git add . && \
    git commit -m "Initial commit: task_tracker project"

# Pre-accept JetBrains license, disable data sharing, trust /workspace.
# track_scripts/setup-workstation rewrites these with fresh timestamps at
# container start — this bake-in is just a safety net for local `docker run`
# testing without the Instruqt lifecycle.
#
# Two independent EULA/privacy bypasses are layered here because IntelliJ has
# checked EULA acceptance through more than one mechanism across versions:
# the legacy accepted_eua properties file, and (since ~2024.2) a Java
# Preferences entry under privacy_policy. Setting both means this survives
# a future IDE version bump without silently regressing into a manual
# click-through — the TrustedPaths bypass below (trust-dialog suppression)
# is not something the reference JetBrains-provided config covers, so keep
# it even though it isn't part of that layered pair.
RUN mkdir -p /root/.config/JetBrains/IntelliJIdea2025.3/options && \
    printf '[accepted]\neua=1.0\n' > /root/.config/JetBrains/IntelliJIdea2025.3/accepted_eua && \
    mkdir -p /root/.local/share/JetBrains/consentOptions && \
    echo "rsch:1.1:0:$(date +%s%3N)" > /root/.local/share/JetBrains/consentOptions/accepted && \
    mkdir -p /root/.java/.userPrefs/jetbrains/privacy_policy && \
    printf '<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n<!DOCTYPE map SYSTEM "http://java.sun.com/dtd/preferences.dtd">\n<map MAP_XML_VERSION="1.0">\n  <entry key="accepted_version" value="1.1"/>\n  <entry key="eap_accepted_version" value="1.1"/>\n</map>\n' \
        > /root/.java/.userPrefs/jetbrains/privacy_policy/prefs.xml && \
    printf '<?xml version="1.0" encoding="UTF-8"?>\n<application>\n  <component name="TrustedPaths">\n    <option name="TRUSTED_PATHS">\n      <list>\n        <option value="/workspace" />\n      </list>\n    </option>\n  </component>\n</application>\n' \
        > /root/.config/JetBrains/IntelliJIdea2025.3/options/trusted-paths.xml && \
    printf '<application>\n  <component name="GeneralSettings">\n    <option name="showTipsOnStartup" value="false" />\n    <option name="confirmOpenNewProject2" value="OPEN" />\n    <option name="reopenLastProject" value="true" />\n  </component>\n  <component name="PropertiesComponent">\n    <property name="ide.firstStartup" value="false" />\n    <property name="jb.privacy.accepted" value="true" />\n    <property name="idea.initially.ask.config" value="false" />\n  </component>\n</application>\n' \
        > /root/.config/JetBrains/IntelliJIdea2025.3/options/other.xml

# ─── KasmVNC configuration ─────────────────────────────────────────────────────
RUN mkdir -p /root/.vnc /etc/ssl/kasmvnc /etc/kasmvnc && \
    printf 'instruqt\ninstruqt\n' | vncpasswd -u root -w && \
    openssl req -x509 -nodes -newkey rsa:2048 \
        -keyout /etc/ssl/kasmvnc/vnc.key \
        -out    /etc/ssl/kasmvnc/vnc.crt \
        -days   3650 \
        -subj   "/CN=instruqt-workstation/O=Instruqt/C=US" 2>/dev/null && \
    chmod 600 /etc/ssl/kasmvnc/vnc.key

RUN cat > /etc/kasmvnc/kasmvnc.yaml << 'KASMCFG'
network:
  protocol: http
  interface: 0.0.0.0
  websocket_port: 8080
  use_ipv4: true
  use_ipv6: false
  ssl:
    pem_certificate: /etc/ssl/kasmvnc/vnc.crt
    pem_key: /etc/ssl/kasmvnc/vnc.key
desktop:
  resolution:
    width: 1920
    height: 1080
  allow_resize: false
  pixel_depth: 24
KASMCFG

RUN cat > /root/.vnc/xstartup << 'XSTARTUP'
#!/bin/bash
export XDG_SESSION_TYPE=x11
unset DBUS_SESSION_BUS_ADDRESS
eval "$(dbus-launch --sh-syntax)"
exec startxfce4
XSTARTUP
RUN chmod +x /root/.vnc/xstartup

# JVM options — headroom for IDEA 2025.3's larger JBR runtime, and disable
# JCEF's sandbox (chrome-sandbox requires root:root 4755, which breaks under
# the root user this container runs as — see JetBrains bug IJPL-59368).
RUN printf -- "-Xms512m\n-Xmx3072m\n-Dide.firstLaunch=false\n-Dide.slow.operations.assertion=false\n-Dsun.awt.disablegrab=true\n-Dide.browser.jcef.sandbox.enable=false\n" \
    > /root/.config/JetBrains/IntelliJIdea2025.3/idea64.vmoptions

# Disable codeWithMe (EDT crash in containers) and AI Assistant — this track
# is built entirely around IntelliJ's own tooling, not AI features.
RUN printf "com.jetbrains.codeWithMe\ncom.intellij.ml.llm\n" \
    > /root/.config/JetBrains/IntelliJIdea2025.3/disabled_plugins.txt

# Copy startup script
COPY docker/startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 8080

CMD ["/startup.sh"]
