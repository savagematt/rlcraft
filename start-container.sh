CONTAINER_ID="$(./container-id.sh)"

if [ -z "$CONTAINER_ID" ]
then
  ./start-new-container.sh
else
  docker start \
    -ai \
    "$CONTAINER_ID"
fi
