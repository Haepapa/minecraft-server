# minecraft-server

## bedrock container

`docker build -t minecraft-server .`<br>
`docker volume create minecraft_worlds`<br>
`docker run -d -v minecraft_worlds:/minecraft/worlds --network=host --name minecraft-server minecraft-server`<br>
`docker logs -f minecraft-server`<br>

### WSL network setup - PowerShell Admin

`netsh interface portproxy add v4tov4 listenport=19132 listenaddress=0.0.0.0 connectport=19132 connectaddress=<WSL IP Address>`<br>
`netsh interface portproxy add v4tov4 listenport=19133 listenaddress=0.0.0.0 connectport=19133 connectaddress=<WSL IP Address>`<br>
`New-NetFirewallRule -DisplayName "WSL2 Port Bridge" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 19132,19133`<br>
`netsh interface portproxy show v4tov4`<br>
