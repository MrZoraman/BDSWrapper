#!/bin/bash
set -m

trap '{ echo "I have been hammered!"; }' SIGKILL
trap '{ echo "I am not stopping"; echo "stop" > input; sleep 5; }' SIGTERM

./app.sh &
pid=$!
echo $pid
wait $pid
