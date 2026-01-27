# Usage: ./applyLoadContainer.sh [--wrk]
# If --wrk is provided, use wrk load generator, otherwise use jmeter

if [ "$1" = "--wrk" ]; then
    docker run --rm -it --name wrk --net=host -e SUT_IP=localhost -e SUT_PORT=9090 -e THREADS=10 -e CONNECTIONS=10 -e DURATION=60 wrk
else
    docker run --rm -it --name jmeter --net=host -e JHOST=localhost -e JPORT=9090 -e JTHREAD=10 -e JDURATION=60 jmeter_simple:5.5
fi
