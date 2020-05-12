CONTAINER_ID="$(./container-id.sh)"

if [ -z "$CONTAINER_ID" ]
then
  ./start-new-container.sh
else
  docker start \
    -ai \
    --mount target=/media/Data,type=bind,source="$(pwd)"/data \
    "$CONTAINER_ID"
fi
