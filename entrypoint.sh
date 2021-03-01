#!/bin/bash
set -m

# trap '{ echo "I want to stop" || true; exit 0; }' SIGTERM

cat > input &
pid=$!
./bedrock_server < input && kill -2 $pid &
fg %1 > /dev/null
