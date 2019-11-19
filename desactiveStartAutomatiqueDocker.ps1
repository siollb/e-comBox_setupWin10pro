#Requires -RunAsAdministrator

# Désactivation du démarrage automatique
Set-Service -NAME com.docker.service -StartupType Manual