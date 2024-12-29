FROM ubuntu:noble

WORKDIR /minecraft

RUN apt update -y ; apt upgrade -y ; apt autoremove -y
RUN apt install -y curl unzip wget

RUN DOWNLOAD_URL=$(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https.*/bin-linux/.*.zip') && \
    echo DOWNLOAD_URL=$DOWNLOAD_URL && \
    wget -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" $DOWNLOAD_URL -O bedrock-server.zip && \
    unzip bedrock-server.zip && \
    rm bedrock-server.zip

RUN chown -R $(whoami):$(whoami) /minecraft

EXPOSE 19132 19133

COPY .env /minecraft/.env
SHELL ["/bin/bash", "-c"] 
RUN source /minecraft/.env && \
    echo $ALLOW_LIST > /minecraft/allowlist.json && \
    echo $SERVER_NAME >> /minecraft/server.properties && \
    echo level-seed=suMpnjaLPn >> /minecraft/server.properties

CMD ["sh", "-c", "LD_LIBRARY_PATH=/minecraft /minecraft/bedrock_server"]