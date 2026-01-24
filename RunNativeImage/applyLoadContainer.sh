docker run --rm -it --name wrk --net=host -e SUT_IP=localhost -e SUT_PORT=9090 -e THREADS=10 -e CONNECTIONS=10 -e DURATION=60 wrk
