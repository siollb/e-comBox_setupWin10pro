#Requires -RunAsAdministrator
# Téléchargement de l'exécutable

(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe', 'docker-installer.exe')