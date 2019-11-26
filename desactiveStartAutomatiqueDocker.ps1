#Requires -RunAsAdministrator

# Désactivation du démarrage automatique
Set-Service -NAME com.docker.service -StartupType Manual

# Suppression de Docker Desktop au démarrage
Remove-ItemProperty -path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -name "Docker Desktop"