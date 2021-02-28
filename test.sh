#!/bin/bash
trap '{ echo "sigterm received!" || true; exit 0; }' SIGTERM

while true
do
    echo "testing..."
    sleep 1
done