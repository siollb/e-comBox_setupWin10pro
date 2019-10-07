# Détection et configuration d'un éventuel proxy pour Docker
Start-Process -wait lanceScriptPS_configProxyDocker.bat
Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

# Récupération et mise au bon format de l'adresse IP de l'hôte (l'adresse IP récupérée est associée à une passerelle par défaut)
#$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetIPConfiguration | Foreach IPv4DefaultGateway).ifIndex).IPv4Address  | Select-Object -first 1
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP dans le fichier ".env"


New-Item -Name ".env" -ItemType file -force *>> $env:USERPROFILE\initialisationEcombox.log
Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "le fichier .env a été créé"  >> $env:USERPROFILE\initialisationEcombox.log
Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log

@"
URL_UTILE=$docker_ip_host
"@ > .env

Set-Content .env -Encoding ASCII -Value (Get-Content .env)
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "le fichier .env a été mis à jour avec l'adresse IP $docker_ip_host" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log


# Création du réseau 192.168.97.0/24 utilisé par e-comBox

Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "Création du réseau des sites" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

if ((docker network ls) | Select-String bridge_e-combox) {
   Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
   Write-Output "Le réseau des sites existe déjà." >> $env:USERPROFILE\initialisationEcombox.log
   Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
   }
else {
   Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
   Write-Output "Le réseau des sites 192.168.97.0/24 n'existe pas, il faut le créer :" >> $env:USERPROFILE\initialisationEcombox.log
   Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
   docker network create --subnet 192.168.97.0/24 --gateway=192.168.97.1 bridge_e-combox *>> $env:USERPROFILE\initialisationEcombox.log
}


# Lancement de Portainer (qui écoute sur le port 8880)
# On peut y accèder avec l'URL : http://localhost:8880/portainer

Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "Lancement de Portainer :" >> $env:USERPROFILE\initialisationEcombox.log 
docker-compose up -d *>> $env:USERPROFILE\initialisationEcombox.log


If ($? -eq 0) {
write-host ""
write-host "Portainer est UP, on peut continuer."
write-host ""
}
    else {
       write-host ""
       write-host "Portainer n'a pas pu être lancé correctement, consultez le fichier de log pour plus d'informations"
       Write-Host ""
    }


# Si problème il faut lancer le restartDocker (non fait car nécessite d'être super utilisateur et je n'y arrive toujours pas)