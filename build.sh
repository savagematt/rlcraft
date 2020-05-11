export DOCKER_BUILDKIT=1
mkdir -p data/world
docker build $1 --progress plain --tag rlcraft:latest .