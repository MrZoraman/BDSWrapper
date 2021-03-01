#!/bin/bash
set -m

cat > input &
pid=$!
./bedrock_server < input && kill -2 $pid &
fg %1 > /dev/null
