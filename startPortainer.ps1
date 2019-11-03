# Gestion des logs
$pathlog="$env:USERPROFILE\.docker\logEcombox"

# Détection et configuration d'un éventuel proxy pour Docker
Start-Process -wait -NoNewWindow "lanceScriptPS_configProxyDocker.bat"
Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

# Récupération et mise au bon format de l'adresse IP de l'hôte (l'adresse IP récupérée est associée à une passerelle par défaut)
#$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetIPConfiguration | Foreach IPv4DefaultGateway).ifIndex).IPv4Address  | Select-Object -first 1
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP dans le fichier ".env"


New-Item -Name ".env" -ItemType file -force *>> $pathlog\initialisationEcombox.log
Write-Output ""  >> $pathlog\initialisationEcombox.log
Write-Output "le fichier .env a été créé"  >> $pathlog\initialisationEcombox.log
Write-Output ""  >> $pathlog\initialisationEcombox.log

@"
URL_UTILE=$docker_ip_host
"@ > .env

Set-Content .env -Encoding ASCII -Value (Get-Content .env)
Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "le fichier .env a été mis à jour avec l'adresse IP $docker_ip_host" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log


# Création éventuelle du réseau 192.168.97.0/24 utilisé par e-comBox

Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "Création du réseau des sites" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log

if ((docker network ls) | Select-String bridge_e-combox) {
   Write-Output "" >> $pathlog\initialisationEcombox.log
   Write-Output "Le réseau des sites existe déjà." >> $pathlog\initialisationEcombox.log
   Write-Output "" >> $pathlog\initialisationEcombox.log
   }
else {
   Write-Output "" >> $pathlog\initialisationEcombox.log
   Write-Output "Le réseau des sites 192.168.97.0/24 n'existe pas, il faut le créer :" >> $pathlog\initialisationEcombox.log
   Write-Output "" >> $pathlog\initialisationEcombox.log
   docker network create --subnet 192.168.97.0/24 --gateway=192.168.97.1 bridge_e-combox *>> $pathlog\initialisationEcombox.log
}


# Lancement de Portainer (qui écoute sur le port 8880)
# On peut y accèder avec l'URL : http://localhost:8880/portainer

Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "Lancement de Portainer :" >> $pathlog\initialisationEcombox.log 
docker-compose up --build --force-recreate -t 20 -d *>> $pathlog\initialisationEcombox.log

# La vérification se fait au niveau du script "initialisatioApplication"
