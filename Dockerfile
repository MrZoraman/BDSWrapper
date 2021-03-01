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
COPY entrypoint.sh app.sh server.properties.default bds.sh ./
RUN mkfifo input
EXPOSE 19132/udp
VOLUME [ "worlds", "server.properties" ]
ENTRYPOINT ["./entrypoint.sh"]