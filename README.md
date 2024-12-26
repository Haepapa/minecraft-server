# minecraft-server

## bedrock container

`docker build -t minecraft-server .`<br>
`docker run -d --publish 19132:19132 --publish 19133:19133 --name minecraft-server minecraft-server`<br>
`docker logs -f minecraft-server`<br>
