#!/bin/bash
set -m

sed -i "s/{{BDS_SERVER_NAME}}/$BDS_SERVER_NAME/" server.properties
sed -i "s/{{BDS_GAMEMODE}}/$BDS_GAMEMODE/" server.properties
sed -i "s/{{BDS_DIFFICULTY}}/$BDS_DIFFICULTY/" server.properties
sed -i "s/{{BDS_ALLOW_CHEATS}}/$BDS_ALLOW_CHEATS/" server.properties
sed -i "s/{{BDS_MAX_PLAYERS}}/$BDS_MAX_PLAYERS/" server.properties
sed -i "s/{{BDS_ONLINE_MODE}}/$BDS_ONLINE_MODE/" server.properties
sed -i "s/{{BDS_WHITE_LIST}}/$BDS_WHITE_LIST/" server.properties
sed -i "s/{{BDS_VIEW_DISTANCE}}/$BDS_VIEW_DISTANCE/" server.properties
sed -i "s/{{BDS_TICK_DISTANCE}}/$BDS_TICK_DISTANCE/" server.properties
sed -i "s/{{BDS_PLAYER_IDLE_TIMEOUT}}/$BDS_PLAYER_IDLE_TIMEOUT/" server.properties
sed -i "s/{{BDS_MAX_THREADS}}/$BDS_MAX_THREADS/" server.properties
sed -i "s/{{BDS_LEVEL_NAME}}/$BDS_LEVEL_NAME/" server.properties
sed -i "s/{{BDS_LEVEL_SEED}}/$BDS_LEVEL_SEED/" server.properties
sed -i "s/{{BDS_DEFAULT_PLAYER_PERMISSION_LEVEL}}/$BDS_DEFAULT_PLAYER_PERMISSION_LEVEL/" server.properties
sed -i "s/{{BDS_TEXTUREPACK_REQUIRED}}/$BDS_TEXTUREPACK_REQUIRED/" server.properties
sed -i "s/{{BDS_CONTENT_LOG_FILE_ENABLED}}/$BDS_CONTENT_LOG_FILE_ENABLED/" server.properties
sed -i "s/{{BDS_COMPRESSION_THRESHOLD}}/$BDS_COMPRESSION_THRESHOLD/" server.properties
sed -i "s/{{BDS_SERVER_AUTHORITATIVE_MOVEMENT}}/$BDS_SERVER_AUTHORITATIVE_MOVEMENT/" server.properties
sed -i "s/{{BDS_PLAYER_MOVEMENT_SCORE_THRESHOLD}}/$BDS_PLAYER_MOVEMENT_SCORE_THRESHOLD/" server.properties
sed -i "s/{{BDS_PLAYER_MOVEMENT_DISTANCE_THRESHOLD}}/$BDS_PLAYER_MOVEMENT_DISTANCE_THRESHOLD/" server.properties
sed -i "s/{{BDS_PLAYER_MOVEMENT_DURATION_THRESHOLD_IN_MS}}/$BDS_PLAYER_MOVEMENT_DURATION_THRESHOLD_IN_MS/" server.properties
sed -i "s/{{BDS_CORRECT_PLAYER_MOVEMENT}}/$BDS_CORRECT_PLAYER_MOVEMENT/" server.properties

./app.sh &
pid=$!
trap '{ echo "stop" > input; wait $pid; }' SIGTERM
wait $pid
