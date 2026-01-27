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

## F. Building the jmeter container for load
```
cd JMeterContext
./build_jmeter.sh
```

## G. Testing restCrud native image with jmeter or wrk
```
cd RunNativeImage
./startPostgres.sh
./startQuarkus.sh
```
In another window execute:
```
./applyLoadContainer.sh [--wrk]
```

## H. Testing OpenJ9 restCrud container with jmeter or wrk
```
cd RunInContainer
./startPostgres.sh
./startQuarkus.sh
```
Wait a few seconds for Quarkus to start and then apply load in another window:
```
./applyLoadContainer.sh [--wrk]
```

Note: if you want to allow the JVM to use JITServer (Semeru Cloud Compiler) functionality,
start the JITServer container prior to starting the Quarkus container:
```
./startJITServer.sh
```
This will use the image `openj9_restcrud:J17` created at step D as a jitserver.
Then, start the app with:
```
./startQuarkus-jitserver.sh
```
After the Quarkus container is started, you can check that it connected to JITServer by
executing: `docker logs jitserver`.


## I. Building the OpenJ9 restCrud container with CRIU (InstantON) support
```
cd RestCrud_CRIU_BuildContext
./buildJ9-criu.sh
```
Note: if you want to allow the JVM to use JITServer (Semeru Cloud Compiler) functionality, use:
```
./buildJ9-criu.sh --jitserver
```

## J. Testing OpenJ9-CRIU restCrud container
```
cd RunInContainer_CRIU
./startPostgres.sh
./startQuarkus.sh
```
In another window execute
```
./applyLoadContainer.sh [--wrk]
./stopQuarkus.sh
```
Note: if you want to allow the JVM to use JITServer (Semeru Cloud Compiler) functionality,
start the JITServer container prior to starting the Quarkus container.
```
./startJITServer.sh
```
This will use the image `openj9_restcrud:J17` created at step D as a jitserver.
Then, start the app with:
```
./startQuarkus-jitserver.sh
```
After the Quarkus container is started, you can check that it connected to JITServer by
executing: `docker logs jitserver`.

## K. Automation though python script
The script `runQuarkusCrudContainer.py` can run several iterations of the test.
```
python3 runQuarkusCrudContainer.py numIterations
```

The script can be customized by change the variables at the top of the script.
The most important ones are the image to run and the arguments to provide to the JVM in that image.





