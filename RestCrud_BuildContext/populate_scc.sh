#!/bin/bash
if [ "$VERBOSE" != "true" ]; then
  exec >/dev/null
fi

set -Eeox pipefail

echo $PWD

SCC_SIZE="30m"  # Default size of the SCC layer.
ITERATIONS=2    # Number of iterations to run to populate it.
WARM_ENDPOINT=true
WARM_ENDPOINT_URL=127.0.0.1:9090/fruits

SCC="-Xshareclasses:name=openj9_system_scc,cacheDir=/opt/java/.scc"
export OPENJ9_JAVA_OPTIONS="-XX:+OriginalJDK8HeapSizeCompatibilityMode -XX:+IProfileDuringStartupPhase $SCC"
export IBM_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS"
CREATE_LAYER="$OPENJ9_JAVA_OPTIONS,createLayer,groupAccess"
DESTROY_LAYER="$OPENJ9_JAVA_OPTIONS,destroy"
PRINT_LAYER_STATS="$OPENJ9_JAVA_OPTIONS,printTopLayerStats"

while getopts ":i:s:u:tdhwc" OPT
do
  case "$OPT" in
    i)
      ITERATIONS="$OPTARG"
      ;;
    s)
      [ "${OPTARG: -1}" == "m" ] || ( echo "Missing m suffix." && exit 1 )
      SCC_SIZE="$OPTARG"
      ;;
    w)
      WARM_ENDPOINT=true
      ;;
    c)
      WARM_ENDPOINT=false
      ;;
    u)
      WARM_ENDPOINT_URL="${OPTARG}"
      ;;
    h)
      echo \
"Usage: $0 [-i iterations] [-s size] [-w] [-c] [-u url]
  -i <iterations> Number of iterations to run to populate the SCC. (Default: $ITERATIONS)
  -s <size>       Size of the SCC in megabytes (m suffix required). (Default: $SCC_SIZE)
  -w              Use curl to warm an endpoint during SCC creation. (Default: $WARM_ENDPOINT)
  -c              Do not warm an endpoint during SCC creation.
  -u              The URL endpoint to warm during SCC creation. (Default: $WARM_ENDPOINT_URL)
"
      exit 1
      ;;
    \?)
      echo "Unrecognized option: $OPTARG" 1>&2
      exit 1
      ;;
    :)
      echo "Missing argument for option: $OPTARG" 1>&2
      exit 1
      ;;
  esac
done

OLD_UMASK=`umask`
umask 002 # 002 is required to provide group rw permission to the cache when `-Xshareclasses:groupAccess` options is used

# Explicity create a class cache layer for this image layer here rather than allowing
# `server start` to do it, which will lead to problems because multiple JVMs will be started.
java $CREATE_LAYER -Xscmx$SCC_SIZE -version


# Populate the newly created class cache layer.
for ((i=0; i<$ITERATIONS; i++))
do
  java -Dquarkus.datasource.jdbc.url=jdbc:postgresql://192.168.1.9:5432/rest-crud -Djava.net.preferIPv4Stack=true -Dquarkus.http.port=9090 -Dquarkus.http.host=0.0.0.0 -jar /deployments/quarkus-run.jar > /tmp/java.log 2>&1 &
  JAVA_PID=$!
  sleep 15 
  echo $JAVA_PID
  #nc -zv 127.0.0.1 9090 | cat /tmp/java.log
  if [ ${WARM_ENDPOINT} == true ]
  then
    output=$(curl --silent --show-error --fail --max-time 5 ${WARM_ENDPOINT_URL}  2>&1)
    for i in {1..100}; do curl --silent --show-error --fail --max-time 5 ${WARM_ENDPOINT_URL} ; echo ""; done
  fi
  sleep 1
  echo "Killing process $JAVA_PID"
  kill -9 $JAVA_PID
done

# restore umask
umask ${OLD_UMASK}

# Tell the user how full the final layer is.
FULL=`( java $PRINT_LAYER_STATS || true ) 2>&1 | awk '/^Cache is [0-9.]*% .*full/ {print substr($3, 1, length($3)-1)}'`
echo "SCC layer is $FULL% full."
