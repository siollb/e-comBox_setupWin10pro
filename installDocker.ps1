﻿# Téléchargement de l'exécutable

(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe', 'docker-installer.exe')

# Installation en mode silentieux avec les options par défaut
start-process -wait docker-installer.exe " install --quiet"

# Suppression de l'exécutable
rm docker-installer.exe

# Lancement de docker
start-process "$env:ProgramFiles\docker\Docker\Docker for Windows.exe"

write-host "Docker et docker-compose sont installés."


# Détection et configuration d'un éventuel proxy
Set-Location -Path C:\Users\$env:USERNAME\.docker\
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$settings = Get-ItemProperty -Path $reg

if ($settings.ProxyEnable -eq 1) {
$adresseProxy = $settings.ProxyServer
$noProxy = $settings.ProxyOverride
$noProxy = $noProxy.Replace(';',',')
new-item "config.json" –type file -force 
@"
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://$adresseProxy",
     "httpsProxy": "http://$adresseProxy",
     "noProxy": "$noProxy"
   }
 }
}
"@ > config.json
Set-Content config.json -Encoding UTF8 -Value (Get-Content config.json)
}
else {
new-item "config.json" –type file -force
}
