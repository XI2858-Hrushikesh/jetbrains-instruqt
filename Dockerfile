# JetBrains IntelliJ IDEA Community + KasmVNC for Instruqt workshop
# Build: docker build -t hrushikeshkanade/jetbrains-instruqt:latest .
# Push:  docker push hrushikeshkanade/jetbrains-instruqt:latest

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG IDEA_VERSION=2024.1.7
ARG KASM_VERSION=1.3.1

ENV HOME=/root
ENV USER=root
ENV DISPLAY=:1

# Base packages + desktop + Java + Python
RUN apt-get update && apt-get install -y \
    curl wget git sudo openssl \
    python3 python3-pip \
    openjdk-17-jdk \
    xfce4 xfce4-terminal \
    dbus-x11 x11-utils \
    xfonts-base \
    libgbm1 libxkbcommon0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install KasmVNC (Ubuntu 22.04 / jammy)
RUN wget -q \
    "https://github.com/kasmtech/KasmVNC/releases/download/v${KASM_VERSION}/kasmvncserver_jammy_${KASM_VERSION}_amd64.deb" \
    -O /tmp/kasmvnc.deb && \
    apt-get update && apt-get install -y /tmp/kasmvnc.deb && \
    rm /tmp/kasmvnc.deb && \
    rm -rf /var/lib/apt/lists/*

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

# Copy startup script
COPY docker/startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 8080

CMD ["/startup.sh"]
