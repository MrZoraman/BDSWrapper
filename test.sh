#!/bin/bash
# trap '{ echo "sigterm received!" || true; exit 0; }' SIGTERM

# exec 9<> ${input}

# while IFS= read -r line; do
#     echo "I got input" $line
#     printf $line "\n"
#     echo $line > input
#     if [ "${line,,}" = "stop" ]; then
#         echo "killing everything!"
#         pkill -9 cat
#         break
#     fi
# done

./bedrock_server < input # > output
kill -9 $1
# echo "aaa"
# echo -e "I am done!\n" > input
# echo "killing everything!"
# pkill -9 cat