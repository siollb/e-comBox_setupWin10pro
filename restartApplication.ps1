# Détection et configuration d'un éventuel proxy pour Docker

Start-Process -wait lanceScriptPS_configProxyDocker.bat


# Récupération et mise au bon format de l'adresse IP de l'hôte
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP dans le fichier ".env"
Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

@"
DOCKER_IP_LOCALHOST=127.0.0.1
DOCKER_IP_HOST=$docker_ip_host
"@ > .env

Set-Content .env -Encoding UTF8 -Value (Get-Content .env)

# Redémarrage de Portainer
docker-compose down
docker-compose up -d


# Redémarrage de l'application

docker rm -f e-combox
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 aporaf/e-combox:1.0