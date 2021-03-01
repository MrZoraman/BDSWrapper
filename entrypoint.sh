#!/bin/bash
set -m

sed -i "s/{{BDS_DIFFICULTY}}/$BDS_DIFFICULTY/" server.properties


# ./app.sh &
# pid=$!
# trap '{ echo "stop" > input; wait $pid; }' SIGTERM
# wait $pid
