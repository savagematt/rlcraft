CONTAINER_ID="$(./container-id.sh)"

if [ -z "$CONTAINER_ID" ]
then
  ./start-new-container.sh
else
  docker start \
    -ai \
    --mount target=/media/Backups,type=bind,source="$(pwd)"/Backups \
    --mount target=/media/Config,type=bind,source="$(pwd)"/Config \
    "$CONTAINER_ID"
fi
