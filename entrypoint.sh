#!/bin/bash
set -m

trap '{ echo "I have been hammered!"; }' SIGKILL

./app.sh &
pid=$!
trap '{ echo "I am not stopping"; echo "stop" > input; wait $pid; }' SIGTERM
wait $pid
