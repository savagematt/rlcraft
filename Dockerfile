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

# Install Forge over unpacked RLCraft gubbins

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Provided,type=bind,source=provided \
    /media/Install/install-forge.sh /usr/bin/rlcraft

# Copy over run scripts

COPY run/* /usr/bin/rlcraft

# Automatically accept EULA

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Data,type=bind,source=data \
    /media/Install/fix-eula.sh /usr/bin/rlcraft

# Make rlcraft game rules more fun (players spawn within walking distance, no pvp, don't lose their inventory, etc.)

RUN --mount=target=/media/Install,type=bind,source=install \
    /media/Install/customise-rlcraft.sh /usr/bin/rlcraft

COPY install/server.properties /usr/bin/rlcraft/server.properties

# Configure cron jobs

COPY install/rlcraft-cron /etc/cron.d/rlcraft-cron
RUN crontab /etc/cron.d/rlcraft-cron

# Install Mods

COPY provided/mods/* /usr/bin/rlcraft/mods/
COPY provided/resourcepacks/* /usr/bin/rlcraft/resourcepacks/

# Expose minecraft port

EXPOSE 25565

# Expose DynMap port

EXPOSE 8123

# backup.sh requires a screen session named rlcraft

CMD screen -S rlcraft /usr/bin/rlcraft/run-keep-alive.sh