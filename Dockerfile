# syntax = docker/dockerfile:experimental

FROM ubuntu:18.04

# Install packages

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    unzip \
    screen

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

COPY install/server.properties /usr/bin/rlcraft

# Install Forge over unpacked RLCraft gubbins

RUN --mount=target=/media/Install,type=bind,source=install \
    --mount=target=/media/Provided,type=bind,source=provided \
    /media/Install/install-forge.sh /usr/bin/rlcraft


# Automatically accept EULA

COPY install/run-forge.sh /usr/bin/rlcraft

RUN --mount=target=/media/Install,type=bind,source=install \
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

ENTRYPOINT ["/usr/bin/rlcraft/run-keep-alive.sh"]
