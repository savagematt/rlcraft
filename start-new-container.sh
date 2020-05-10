./rm-container.sh

mkdir -p Backups
export DOCKER_BUILDKIT=1

# -d, --detach                         Run container in background and print container ID
# -i, --interactive                    Keep STDIN open even if not attached
# -t, --tty                            Allocate a pseudo-TTY

docker run \
  -ti \
  --publish 25565:25565 \
  --mount target=/media/Backups,type=bind,source="$(pwd)"/Backups \
  --mount target=/media/Config,type=bind,source="$(pwd)"/Config \
  --name rlcraft \
  rlcraft:latest