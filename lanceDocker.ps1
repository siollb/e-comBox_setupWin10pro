#Requires -RunAsAdministrator
# Ce script n'est plus utilisé par l'appli e-comBox car il a été fait
# le choix du premier lancement de Docker au redémarrage de la machine 

# Lancement de docker
Start-Process "C:\Program Files\Docker\Docker\Docker for Windows.exe"

# Attente pendant le lancement de Docker
Start-Sleep -Seconds 120