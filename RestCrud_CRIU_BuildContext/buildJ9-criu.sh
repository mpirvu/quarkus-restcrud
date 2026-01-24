
# Build the base restCrud container with CRIU


# Start the postgres DB container on host network
docker run -d --rm --name postgres --net host restcrud-db
# Build the base restCrud container with CRIU
docker build --network=host --progress=plain --no-cache -f Dockerfile_restcrud_openj9_criu -t start-quarkus-image .
# Launch the base restCrud container
docker run --name checkpointrun --privileged --cpus=1.0 -m=256m --net host start-quarkus-image
docker commit checkpointrun restorerun-crud-256-1cpu-8threads:J17
#docker commit checkpointrun restorerun-crud-256-1cpu-8threads-jitserver:J17

docker rm checkpointrun
docker stop postgres


