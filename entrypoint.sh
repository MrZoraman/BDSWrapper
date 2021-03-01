#!/bin/bash
set -m

write_prop()
{
    prop_name=$1
    echo "$1: ${!prop_name}"
    sed -i "s/{{${prop_name}}}/${!prop_name}/" server.properties
}

write_prop BDS_SERVER_NAME
write_prop BDS_GAMEMODE
write_prop BDS_DIFFICULTY
write_prop BDS_ALLOW_CHEATS
write_prop BDS_MAX_PLAYERS
write_prop BDS_ONLINE_MODE
write_prop BDS_WHITE_LIST
write_prop BDS_VIEW_DISTANCE
write_prop BDS_TICK_DISTANCE
write_prop BDS_PLAYER_IDLE_TIMEOUT
write_prop BDS_MAX_THREADS
write_prop BDS_LEVEL_NAME
write_prop BDS_LEVEL_SEED
write_prop BDS_DEFAULT_PLAYER_PERMISSION_LEVEL
write_prop BDS_TEXTUREPACK_REQUIRED
write_prop BDS_CONTENT_LOG_FILE_ENABLED
write_prop BDS_COMPRESSION_THRESHOLD
write_prop BDS_SERVER_AUTHORITATIVE_MOVEMENT
write_prop BDS_PLAYER_MOVEMENT_SCORE_THRESHOLD
write_prop BDS_PLAYER_MOVEMENT_DISTANCE_THRESHOLD
write_prop BDS_PLAYER_MOVEMENT_DURATION_THRESHOLD_IN_MS
write_prop BDS_CORRECT_PLAYER_MOVEMENT

./app.sh &
pid=$!
trap '{ echo "stop" > input; wait $pid; }' SIGTERM
wait $pid
