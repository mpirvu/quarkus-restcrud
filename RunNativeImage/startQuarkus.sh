docker run --rm -it -p 9090:9090 -e QUARKUS_DATASOURCE_JDBC_URL="jdbc:postgresql://localhost:5432/rest-crud" --cpus=1.0 --net=host --name=quarkus restcrud-native 

