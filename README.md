# minecraft-server

## bedrock container

`docker build -t minecraft-server .`<br>
`docker run -d --publish 19132:19132 --publish 19133:19133 --name minecraft-server minecraft-server`<br>
`docker logs -f minecraft-server`<br>

### WSL network setup - PowerShell Admin

`netsh interface portproxy add v4tov4 listenport=19132 listenaddress=0.0.0.0 connectport=19132 connectaddress=<WSL IP Address>`<br>
`netsh interface portproxy add v4tov4 listenport=19133 listenaddress=0.0.0.0 connectport=19133 connectaddress=<WSL IP Address>`<br>
`New-NetFirewallRule -DisplayName "WSL2 Port Bridge" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 19132,19133`<br>
`netsh interface portproxy show v4tov4`<br>
