#!/bin/bash
trap '{ ./stop_server.sh || true; exit 0; }' SIGTERM

screen -d -m -S server /bin/bash -c "LD_LIBRARY_PATH=. ./bedrock_server"

while true
do
    echo "testing..."
    sleep 1
done