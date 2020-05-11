CONTAINER_ID="$(./container-id.sh)"

if [ -z "$CONTAINER_ID" ]
then
  ./start-new-container.sh
else
  docker start \
    -ai \
    --mount target=/media/Data,type=bind,source="$(pwd)"/data \
    --mount target=/media/Config,type=bind,source="$(pwd)"/config \
    "$CONTAINER_ID"
fi
