
# Build the base restCrud container with CRIU
# Usage: ./buildJ9-criu.sh [--jitserver]

# Check if --jitserver parameter is provided
JITSERVER_ARG=""
IMAGE_TAG_SUFFIX=""
if [ "$1" = "--jitserver" ]; then
    JITSERVER_ARG="--build-arg USE_JITSERVER=true "
    IMAGE_TAG_SUFFIX="-jitserver"
    echo "Building with JIT Server enabled"
fi

# Start the postgres DB container on host network
docker run -d --rm --name postgres --net host restcrud-db
# Build the base restCrud container with CRIU
docker build ${JITSERVER_ARG} --network=host --progress=plain --no-cache -f Dockerfile_restcrud_openj9_criu -t start-quarkus-image .
# Launch the base restCrud container
docker run --name checkpointrun --privileged --cpus=1.0 -m=256m --net host start-quarkus-image
docker commit checkpointrun restorerun-crud-256-1cpu-8threads:J17${IMAGE_TAG_SUFFIX}

docker rm checkpointrun
docker stop postgres


