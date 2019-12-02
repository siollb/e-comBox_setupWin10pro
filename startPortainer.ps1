# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts\"

# Détection et configuration d'un éventuel proxy pour Docker
Set-Location $pathscripts
Start-Process -wait -NoNewWindow "lanceScriptPS_configProxyDocker.bat"

Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

# Récupération et mise au bon format de l'adresse IP de l'hôte (l'adresse IP récupérée est associée à une passerelle par défaut)
#$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetIPConfiguration | Foreach IPv4DefaultGateway).ifIndex).IPv4Address  | Select-Object -first 1
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP dans le fichier ".env"


New-Item -Name ".env" -ItemType file -force *>> $pathlog\initialisationEcombox.log

If ($? -eq 0) {
  $allProcesses = Get-Process
  foreach ($process in $allProcesses) { 
    $process.Modules | where {$_.FileName -eq "$env:USERPROFILE\e-comBox_portainer\.env"} | Stop-Process -Force -ErrorAction SilentlyContinue
  }
Remove-Item ".env"  *>> $pathlog\initialisationEcombox.log
New-Item -Path ".env" -ItemType file -force  *>> $pathlog\initialisationEcombox.log
}

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
#docker-compose up --build --force-recreate -t 20 -d *>> $pathlog\initialisationEcombox.log
#docker-compose down *>> $pathlog\initialisationEcombox.log
If (docker ps -a --filter "name=portainer-app") {
   docker rm -f portainer-app *>> $pathlog\initialisationEcombox.logg
   }
If (docker ps -a --filter "name=portainer-proxy") {
   docker rm -f portainer-proxy *>> $pathlog\initialisationEcombox.log
   }
If (docker ps -a --format '{{.Names}}' |  Select-String portainer-proxy) {
   docker rm -f $(docker ps -a --format '{{.Names}}' |  Select-String portainer-proxy)  *>> $pathlog\initialisationEcombox.log
   }
docker-compose up --build -d *>> $pathlog\initialisationEcombox.log


    # On vérifie de nouveau

if ((docker ps |  Select-String portainer-proxy)) {
    write-host ""
    write-host "Portainer est UP, on peut continuer."
    write-host ""
    write-Output "" >> $pathlog\initialisationEcombox.log
    write-Output "Portainer est UP, on peut continuer" >> $pathlog\initialisationEcombox.log
    write-Output "" >> $pathlog\initialisationEcombox.log
    }
      else {
            write-host ""
            write-host "Toutes les tentatives pour démarrer Portainer ont échoué, consultez le fichier de log pour plus d'informations"
            Write-Host ""
            Write-Output "" >> $pathlog\initialisationEcombox.log
            Write-Output "Toutes les tentatives pour démarrer Portainer ont échoué" >> $pathlog\initialisationEcombox.log
            # Ce n'est pas la peine de continuer
            Read-Host "Appuyez sur la touche Entrée pour arrêter le processus"
            Write-host ""
            exit
            }

Set-Location $pathscripts
