#!/bin/bash
cd $JMETER_HOME

echo jmeter -n -t simple_waittime.jmx -j /output/restcrud.stats -JHOST=$JHOST  -JPORT=$JPORT -JTHREAD=$JTHREAD -JDURATION=$JDURATION -JRAMP=$JRAMP -JTHINKTIME=$JTHINKTIME
exec jmeter -n -t simple_waittime.jmx -j /output/restcrud.stats -JHOST=$JHOST  -JPORT=$JPORT -JTHREAD=$JTHREAD -JDURATION=$JDURATION -JRAMP=$JRAMP -JTHINKTIME=$JTHINKTIME


