# quarkus-restcrud
Repo for building/running a simple restCrud app on top of Quarkus with OpenJ9 and InstantON
Based on https://github.com/jdmcclur/restCrud


## A. Building restCrud app on top of Quarkus
Requirements:
- The src directory
- mvnw script
- .mvn directory
- pom.quarkus.xml (change this to use another version of quarkus)
- Java17 on your path

Execute:
```
./mvnw -f pom.quarkus.xml clean package
```

## B. Building the native image of restCrud+Quarkus (in container)
Requirements:
- build.native.sh script
- Dockerfile.quarkus.native
- Java17 on your path

Execute:
```
./build.native.sh
```

## C. Building the postgres container
```
cd PostgresContext
./buildPostgres.sh
```

## D. Building the OpenJ9 restCrud container
```
cd RestCrud_BuildContext
./buildQuarkusJ9.sh
```
**Note: Read readme.txt for additional changes**


## E. Building the wrk container for load
```
cd WrkContext
./build_wrk.sh
```

## F. Building the JMeter container for load
```
cd JMeterContext
./build_jmeter.sh
```

## G. (Optional) Try OpenJ9 restCrud container with wrk
```
cd RunInContainer
./startPostgres.sh
./startQuarkus.sh
```
Wait a few seconds for Quarkus to start and then apply load
```
./applyLoadContainer.sh
```





