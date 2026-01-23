docker run --rm -it -e JPORT=9090 -e JHOST=localhost -e JTHREAD=10 -e JTHINKTIME=0 -e JDURATION=600 --net=host --name jmeter jmeter_simple:5.5
