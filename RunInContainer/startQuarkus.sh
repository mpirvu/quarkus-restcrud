docker run --rm -it -e QUARKUS_DATASOURCE_JDBC_URL="jdbc:postgresql://localhost:5432/rest-crud" -m=256m --cpuset-cpus=1 --net=host --name=quarkus openj9_restcrud:J17
#podman run --rm -it -p 9090:9090 -e QUARKUS_DATASOURCE_JDBC_URL="jdbc:postgresql://192.168.1.9:5432/rest-crud" --net=host --name=quarkus temurin_restcrud:j17

