#Requires -RunAsAdministrator
# Téléchargement de l'exécutable

(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe', 'docker-installer.exe')

# Installation en mode silentieux avec les options par défaut
start-process -wait docker-installer.exe " install --quiet"

# Suppression de l'exécutable
rm docker-installer.exe

# Lancement de docker
Start-Process "C:\Program Files\Docker\Docker\Docker for Windows.exe"
#start-process "$env:ProgramFiles\Docker\Docker\Docker for Windows.exe"

# write-host "Docker et docker-compose sont installés."
Start-Sleep -Seconds 120