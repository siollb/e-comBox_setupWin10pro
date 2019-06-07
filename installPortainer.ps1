# Récupération de portainer
Set-Location -Path C:\Users\$env:USERNAME

git clone https://github.com/siollb/e-comBox_portainer.git 2>$null

# Récupération et mise au bon format de l'adresse IP de l'hôte
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP dans le fichier ".env"
Set-Location -Path C:\Users\$env:USERNAME\e-comBox_portainer\

@"
DOCKER_IP_TOUT=0.0.0.0
DOCKER_IP_HOST=$docker_ip_host
"@ > .env

Set-Content .env -Encoding UTF8 -Value (Get-Content .env)

# Lancement de Portainer (qui écoute sur le port 8000)
# On peut y accèder avec l'URL : http://localhost/portainer:8000
docker-compose up -d

