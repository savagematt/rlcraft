# syntax = docker/dockerfile:experimental

FROM ubuntu:18.04

# Install packages

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    unzip \
    screen \
    curl

# ...rsyslog does not seem to be included in the base image
RUN apt-get update && apt-get install --reinstall -y \
    rsyslog

# ...and neither is cron
RUN apt-get update && apt-get install -y \
    cron

# Unpack RLCraft zip

RUN mkdir -p /usr/bin/rlcraft

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Provided,type=bind,source=provided \
    /media/Install/uncompress-rlcraft.sh /usr/bin/rlcraft

# Make rlcraft game rules more fun (players spawn within walking distance, no pvp, don't lose their inventory, etc.)

RUN --mount=target=/media/Install,type=bind,source=install \
    /media/Install/customise-rlcraft.sh /usr/bin/rlcraft

RUN --mount=target=/media/Config,type=bind,source=Config \
    ln -s /media/Config/server.properties /usr/bin/rlcraft/server.properties

# Install Forge over unpacked RLCraft gubbins

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Provided,type=bind,source=provided \
    /media/Install/install-forge.sh /usr/bin/rlcraft

# Configure whitelist cron job

COPY install/whitelist.sh /usr/bin/rlcraft

COPY install/whitelist.cron /etc/cron.d/whitelist.cron

RUN chmod 0644 /etc/cron.d/whitelist.cron

RUN crontab /etc/cron.d/whitelist.cron

RUN --mount=target=/media/Config,type=bind,source=Config \
    /usr/bin/rlcraft/whitelist.sh

# Install run-forge.sh

COPY install/run-forge.sh /usr/bin/rlcraft

# Automatically accept EULA

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Config,type=bind,source=Config \
    /media/Install/fix-eula.sh /usr/bin/rlcraft

# Configure backup cron job

COPY install/backup.sh /usr/bin/rlcraft

COPY install/backup.cron /etc/cron.d/backup.cron

RUN chmod 0644 /etc/cron.d/backup.cron

RUN crontab /etc/cron.d/backup.cron

# Configure upstart job

COPY install/run-keep-alive.sh /usr/bin/rlcraft

# Install Mods

COPY provided/mods/* /usr/bin/rlcraft/mods/

# Expose minecraft port

EXPOSE 25565

ENTRYPOINT ["screen", "-S", "rlcraft", "/usr/bin/rlcraft/run-keep-alive.sh"]
