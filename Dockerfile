FROM dockerqa/unzip:latest AS unzip

WORKDIR /extract
COPY server/bedrock-server.zip .
RUN unzip bedrock-server.zip
RUN rm bedrock-server.zip

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libcurl4
WORKDIR /opt/bds
COPY --from=unzip /extract .