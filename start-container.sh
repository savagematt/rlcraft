CONTAINER_ID="$(./container-id.sh)"

if [ -z "$CONTAINER_ID" ]
then
  ./start-new-container.sh
else
  docker start -ai --mount 'target=/media/Backups,type=bind,source=Backups' "$CONTAINER_ID"
fi
