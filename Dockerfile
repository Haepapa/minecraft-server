FROM ubuntu:noble

WORKDIR /minecraft

RUN apt update -y ; apt upgrade -y ; apt autoremove -y
RUN apt install -y curl unzip wget

RUN wget -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-1.21.51.02.zip -O bedrock-server.zip && \
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