#!/bin/bash
set -m

./app.sh &
pid=$!
trap '{ echo "stop" > input; wait $pid; }' SIGTERM
wait $pid
