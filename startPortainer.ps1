# Détection et configuration d'un éventuel proxy pour Docker
Start-Process -wait lanceScriptPS_configProxyDocker.bat


# Récupération et mise au bon format de l'adresse IP de l'hôte
#$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetIPConfiguration | Foreach IPv4DefaultGateway).ifIndex).IPv4Address
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP dans le fichier ".env"
Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

@"
DOCKER_IP_LOCALHOST=127.0.0.1
DOCKER_IP_HOST=$docker_ip_host
"@ > .env

Set-Content .env -Encoding ASCII -Value (Get-Content .env)

# Lancement de Portainer (qui écoute sur le port 8880)
# On peut y accèder avec l'URL : http://localhost:8880/portainer

docker-compose up -d