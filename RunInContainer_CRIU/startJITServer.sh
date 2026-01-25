# Start a an instance of the quarkus image which will operate in jitserver mode
# Providing the "-XX:+JITServerLogConnections" option instruct jitserver to display
# a message every time a new client connects to it.
# This can be viewed with `docker logs jitserver`
docker run --rm -d --net=host -e _JAVA_OPTIONS="-XX:+JITServerLogConnections" --name=jitserver openj9_restcrud:J17 jitserver
