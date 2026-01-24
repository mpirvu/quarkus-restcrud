#podman run --rm -it -p 9090:9090 --net myNetwork --ip 192.168.200.20 --name=quarkus localhost/openj9_restcrud:j17
docker run -it --rm --name quarkus -m=256m --cpus=1.0 --privileged --net host restorerun-crud-256-1cpu-8threads:J17
