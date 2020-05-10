CONTAINER_ID="$(./container-id.sh)"
if [ -z "$CONTAINER_ID" ]
then
  exit 0
fi

echo "Removing rlcraft container $CONTAINER_ID"

docker container rm --force "$CONTAINER_ID"