#!/bin/bash
screen -S server -X stuff "stop^M"

while true
do
    screen -list | grep -q "server"
    if [ $? -eq 1 ]
    then
        break
    fi
    sleep 1
done
