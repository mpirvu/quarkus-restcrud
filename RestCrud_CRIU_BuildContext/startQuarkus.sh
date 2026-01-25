#!/bin/bash

# Check if the directory "cr" exists
if [ -d "cr" ]; then
    echo "Executing dumb-init"
    exec dumb-init --rewrite 15:2 -- "/deployments/restore.sh"
else
    echo "start checkpoint run"
    for i in {1..500}; do ./pidplus.sh; done
    mkdir cr
    # To enable JITServer one must add -XX:+UseJITServer to the Java command line. Assumes JITServer is on the same network as the application.
    # Check if USE_JITSERVER is set to true and add the option via _JAVA_OPTIONS
    if [ "$USE_JITSERVER" = "true" ]; then
        echo "Enabling JIT Server"
        export _JAVA_OPTIONS="${_JAVA_OPTIONS} -XX:+UseJITServer"
    fi
    $JAVA_HOME/bin/java -Dquarkus.thread-pool.max-threads=8 -Dquarkus.thread-pool.core-threads=8 -Dquarkus.datasource.jdbc.url=jdbc:postgresql://localhost:5432/rest-crud -Dhttp.keepalive=true -Dhttp.maxConnections=100 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Xmx128m -Dquarkus.http.host=0.0.0.0 -XX:CRaCCheckpointTo=cr -Dquarkus.http.port=9090 -Dopenj9.internal.criu.unprivilegedMode=true $JAVA_OPTS -jar /deployments/quarkus-run.jar 1>out 2>err </dev/null &
    echo "sleeping for 10 seconds"
    sleep 10
    echo "Exercising the endpoint"
    for i in {1..100}; do curl -s -w ''%{http_code}'' http://localhost:9090/fruits ; echo ""; done
    echo "sleeping for 10 seconds to allow compilations to quiesce"
    sleep 10
    echo "Calling jcmd to generate the checkpoint"
    $JAVA_HOME/bin/jcmd /deployments/quarkus-run.jar JDK.checkpoint
    echo "Showing output from the java command line"
    cat out
    cat err
    echo "sleeping for 5 seconds"
    sleep 5
    echo "end checkpoint run"
fi

