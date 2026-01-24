docker run --rm -it --name wrk --net host -e SUT_IP=localhost -e SUT_PORT=9090 -e THREADS=100 -e CONNECTIONS=100 -e DURATION=60  wrk
#docker run --rm -it --name wrk --net myNetwork --ip 192.168.200.60 -e SUT_IP=192.168.200.20 -e SUT_PORT=9090 -e THREADS=100 -e CONNECTIONS=100 -e DURATION=60  wrk
