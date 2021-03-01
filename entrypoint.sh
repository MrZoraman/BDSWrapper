#!/bin/bash
set -m

cp --no-clobber server.properties.default server.properties

./app.sh &
pid=$!
trap '{ echo "stop" > input; wait $pid; }' SIGTERM
wait $pid
