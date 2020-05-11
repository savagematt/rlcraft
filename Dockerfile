# syntax = docker/dockerfile:experimental

FROM ubuntu:18.04

# Install packages

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    unzip \
    screen \
    curl

# rsyslog is required to allow cron to output to /var/log/syslog
# and it needs some fixing to work in docker
# https://stackoverflow.com/questions/56609182/openthread-environment-docker-rsyslogd-imklog-cannot-open-kernel-log-proc-km
RUN apt-get update && apt-get install --reinstall -y \
    rsyslog

RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

# Install cron for backup and whitelist
# ...which needs https://askubuntu.com/questions/9382/how-can-i-configure-a-service-to-run-at-startup
RUN apt-get update && apt-get install -y \
    cron

# Unpack RLCraft zip

RUN mkdir -p /usr/bin/rlcraft

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Provided,type=bind,source=provided \
    /media/Install/uncompress-rlcraft.sh /usr/bin/rlcraft

# Save world state to host filesystem

RUN --mount=target=/media/Data,type=bind,source=data \
    ln -s /media/Data/world /usr/bin/rlcraft/world

# Make rlcraft game rules more fun (players spawn within walking distance, no pvp, don't lose their inventory, etc.)

RUN --mount=target=/media/Install,type=bind,source=install \
    /media/Install/customise-rlcraft.sh /usr/bin/rlcraft

RUN --mount=target=/media/Config,type=bind,source=config \
    ln -s /media/Config/server.properties /usr/bin/rlcraft/server.properties

# Install Forge over unpacked RLCraft gubbins

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Provided,type=bind,source=provided \
    /media/Install/install-forge.sh /usr/bin/rlcraft

# Configure whitelist cron job

COPY install/whitelist.sh /usr/bin/rlcraft

RUN --mount=target=/media/Config,type=bind,source=config \
    /usr/bin/rlcraft/whitelist.sh

# Install run-forge.sh

COPY install/run-forge.sh /usr/bin/rlcraft

# Automatically accept EULA

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Config,type=bind,source=config \
    /media/Install/fix-eula.sh /usr/bin/rlcraft

# Configure backup cron job

COPY install/backup.sh /usr/bin/rlcraft
COPY install/backup-cron.sh /usr/bin/rlcraft

# Configure backup cron job

COPY install/rlcraft-cron /etc/cron.d/rlcraft-cron
RUN crontab /etc/cron.d/rlcraft-cron

# Configure upstart job

COPY install/run-keep-alive.sh /usr/bin/rlcraft

# Install Mods

COPY provided/mods/* /usr/bin/rlcraft/mods/

# Expose minecraft port

EXPOSE 25565

ENTRYPOINT screen -S rlcraft /usr/bin/rlcraft/run-keep-alive.sh