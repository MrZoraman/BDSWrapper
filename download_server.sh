# Code from https://github.com/TheRemote/MinecraftBedrockServer/blob/master/start.sh
wget -O version.html https://minecraft.net/en-us/download/server/bedrock/
DownloadURL=$(grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' version.html)
wget -O "bedrock-server.zip" "$DownloadURL"