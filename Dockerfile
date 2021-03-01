FROM alpine:latest AS download
WORKDIR /download
# Code from https://github.com/TheRemote/MinecraftBedrockServer/blob/master/start.sh
RUN wget -O version.html https://minecraft.net/en-us/download/server/bedrock/ && \
    DownloadURL=$(grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' version.html) && \
    wget -O "bedrock-server.zip" "$DownloadURL"

FROM alpine:latest AS extract
WORKDIR /extract
COPY --from=download download/bedrock-server.zip .
RUN unzip bedrock-server.zip
RUN rm bedrock-server.zip

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libcurl4 screen expect
WORKDIR /opt/bds
COPY --from=extract /extract .
COPY entrypoint.sh ./
RUN mkfifo input output
ENTRYPOINT ["./entrypoint.sh"]