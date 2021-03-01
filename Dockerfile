FROM alpine:3.13.2 AS download
WORKDIR /download
# Code from https://github.com/TheRemote/MinecraftBedrockServer/blob/master/start.sh
RUN wget -O version.html https://minecraft.net/en-us/download/server/bedrock/ && \
    DownloadURL=$(grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' version.html) && \
    wget -O "bedrock-server.zip" "$DownloadURL"

FROM alpine:3.13.2 AS extract
WORKDIR /extract
COPY --from=download download/bedrock-server.zip .
RUN unzip bedrock-server.zip
RUN rm bedrock-server.zip

FROM ubuntu:20.04
RUN apt-get update && apt-get install -y libcurl4
WORKDIR /opt/bds
COPY --from=extract /extract .
COPY entrypoint.sh app.sh server.properties bds.sh ./
RUN mkfifo input
EXPOSE 19132/udp
ENV \
    BDS_SERVER_NAME="Dedicated Server" \
    BDS_GAMEMODE="survival" \
    BDS_DIFFICULTY="easy" \
    BDS_ALLOW_CHEATS="false" \
    BDS_MAX_PLAYERS="10" \
    BDS_ONLINE_MODE="true" \
    BDS_WHITE_LIST="false" \
    BDS_VIEW_DISTANCE="32" \
    BDS_TICK_DISTANCE="4" \
    BDS_PLAYER_IDLE_TIMEOUT="30" \
    BDS_MAX_THREADS="8" \
    BDS_LEVEL_NAME="Bedrock level" \
    BDS_LEVEL_SEED="" \
    BDS_DEFAULT_PLAYER_PERMISSION_LEVEL="member" \
    BDS_TEXTUREPACK_REQUIRED="false" \
    BDS_CONTENT_LOG_FILE_ENABLED="False" \
    BDS_COMPRESSION_THRESHOLD="1" \
    BDS_SERVER_AUTHORITATIVE_MOVEMENT="server-auth" \
    BDS_PLAYER_MOVEMENT_SCORE_THRESHOLD="20" \
    BDS_PLAYER_MOVEMENT_DISTANCE_THRESHOLD="0.3" \
    BDS_PLAYER_MOVEMENT_DURATION_THRESHOLD_IN_MS="500" \
    BDS_CORRECT_PLAYER_MOVEMENT="false"
ENTRYPOINT ["./entrypoint.sh"]