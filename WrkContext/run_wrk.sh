#!/bin/bash
set -x
wrk -t ${THREADS} -d ${DURATION} -c ${CONNECTIONS} http://${SUT_IP}:${SUT_PORT}/fruits "$@"

