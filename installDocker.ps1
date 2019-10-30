#Requires -RunAsAdministrator
# Téléchargement de l'exécutable

(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe', 'docker-installer.exe')

# Installation en mode silentieux avec les options par défaut
start-process -wait docker-installer.exe " install --quiet"

# Lancement de docker (le lancement se fait au redémarrage de la machine)
#Start-Process "C:\Program Files\Docker\Docker\Docker for Windows.exe"

# Suppression de l'exécutable
rm docker-installer.exe

# Ajout du dossier qui va accueillir les logs
If (-not (Test-Path "$env:USERPROFILE\.docker")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.docker" }
New-Item -Path "$env:USERPROFILE\.docker\logEcombox" -ItemType Directory -force

