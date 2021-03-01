#!/bin/bash
set -m

cat > input &
pid=$!
LD_LIBRARY_PATH=. ./bedrock_server < input && kill -2 $pid &
fg %1 > /dev/null
