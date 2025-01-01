FROM ubuntu:noble

WORKDIR /minecraft

RUN mkdir /minecraft/plugins
RUN chown -R $(whoami):$(whoami) /minecraft

# Copy script
COPY run_server.sh /minecraft/run_server.sh
RUN chmod +x /minecraft/run_server.sh

# Install dependencies
RUN apt update -y ; apt upgrade -y ; apt autoremove -y
RUN apt install -y wget default-jre-headless expect net-tools

# Install paper server
RUN wget https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/66/downloads/paper-1.21.4-66.jar -O /minecraft/paper.jar
RUN echo eula=true > /minecraft/eula.txt

# Run server for first time
RUN /minecraft/run_server.sh

# Install plugins
RUN wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O /minecraft/plugins/geyser.jar
RUN wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O /minecraft/plugins/floodgate.jar

# Run server
RUN /minecraft/run_server.sh wl

# Update config
RUN echo auth-type: floodgate >> plugins/Geyser-Spigot/config.yml

# Expose ports
EXPOSE 19132/udp 19133/udp 25565/tcp

CMD ["sh", "-c", "java -Xms4G -Xmx4G -jar paper.jar --nogui"]