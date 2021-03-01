#!/bin/bash
set -m

trap '{ echo "I want to stop" || true; exit 0; }' SIGTERM

# unbuffer -p ./bedrock_server
# unbuffer -p bash -c 'LD_LIBRARY_PATH=. ./bedrock_server'
# ./bedrock_server
# id=$!

# sleep 5
# echo "stop^M" > /proc/$id/fd/0

# while true
# do
#     echo $id
#     sleep 1
# done

# cat < output &
# ./bedrock_server < input &
cat > input &
pid=$!
./bedrock_server < input && kill -2 $pid &
jobs -l
# echo "disowned."
# disown %2
# ./test.sh $pid &
fg %1 > /dev/null


# cat | ./test.sh
# echo "hello!"
# sleep 5
# echo "there!"
# cat > input &
# pid=$!




# fg %2

# while true
# do
#     echo "testing..."
#     sleep 1
# done