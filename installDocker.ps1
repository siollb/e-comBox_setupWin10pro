#Requires -RunAsAdministrator

# Installation en mode silentieux avec les options par défaut
start-process -wait docker-installer.exe " install --quiet"

# Suppression de l'exécutable
rm docker-installer.exe

