# JetBrains IntelliJ IDEA Community + KasmVNC for Instruqt workshop
# Build: docker build -t hrushikeshkanade/jetbrains-instruqt:latest .
# Push:  docker push hrushikeshkanade/jetbrains-instruqt:latest

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG IDEA_VERSION=2024.1.7

ENV HOME=/root
ENV USER=root
ENV DISPLAY=:1

# Enable universe repo (needed for x11vnc) and install packages
RUN echo "deb http://archive.ubuntu.com/ubuntu jammy universe" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    curl wget git sudo \
    python3 python3-pip \
    openjdk-17-jdk \
    xfce4 xfce4-terminal \
    dbus-x11 x11-utils x11-xserver-utils \
    xvfb x11vnc \
    novnc \
    xfonts-base \
    ca-certificates \
    xdotool wmctrl \
    && rm -rf /var/lib/apt/lists/*

# Install websockify via pip (more reliable than apt package)
RUN pip3 install --quiet websockify

# Install IntelliJ IDEA Community
RUN wget -q \
    "https://download.jetbrains.com/idea/ideaIC-${IDEA_VERSION}.tar.gz" \
    -O /tmp/idea.tar.gz && \
    tar -xzf /tmp/idea.tar.gz -C /opt/ && \
    rm /tmp/idea.tar.gz

# Install Python deps for the sample project
RUN pip3 install --quiet pytest

# Copy sample project
COPY docker/task_tracker /workspace/task_tracker

# Initialise git repo so Challenge 3 commit step works
RUN cd /workspace/task_tracker && \
    git config --global user.email "learner@instruqt.com" && \
    git config --global user.name "Learner" && \
    git init && \
    git add . && \
    git commit -m "Initial commit: task_tracker project"

# Pre-accept JetBrains license, disable data sharing, trust /workspace
RUN mkdir -p /root/.config/JetBrains/IdeaIC2024.1 && \
    printf '[accepted]\neua=1.0\n' > /root/.config/JetBrains/IdeaIC2024.1/accepted_eua && \
    mkdir -p /root/.local/share/JetBrains/consentOptions && \
    echo "rsch:1.1:0:$(date +%s%3N)" > /root/.local/share/JetBrains/consentOptions/accepted && \
    mkdir -p /root/.config/JetBrains/IdeaIC2024.1/options && \
    printf '<?xml version="1.0" encoding="UTF-8"?>\n<application>\n  <component name="TrustDialogState">\n    <option name="approvedPaths">\n      <set>\n        <option value="/workspace" />\n      </set>\n    </option>\n  </component>\n</application>\n' \
        > /root/.config/JetBrains/IdeaIC2024.1/options/ide.trust.project.xml

# Copy startup script
COPY docker/startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 8080

CMD ["/startup.sh"]
