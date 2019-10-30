# Gestion des logs

If (-not (Test-Path "$env:USERPROFILE\.docker\logEcombox")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.docker\logEcombox" }

$pathlog="$env:USERPROFILE\.docker\logEcombox"


# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

# Création d'un fichier de log et écriture de la date

Write-host ""
Write-host "============================"
Write-host "Création d'un fichier de log"
Write-host "============================"
Write-host ""

 
New-Item -Path "$pathlog\initialisationEcombox.log" -ItemType file -force
write-host ""
Write-host "Le fichier de log configEnvEcombox.log a été créé à la racine du dossier $pathlog."


Write-Output "============================================================================" >> $pathlog\initialisationEcombox.log
Write-Output "$(Get-Date) - Initialisation de l'application" >> $pathlog\initialisationEcombox.log
Write-Output "============================================================================" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log
Write-host "$(Get-Date) - Initialisation de l'application"
write-host ""

#Start-Process -wait lanceScriptPS_installPortainer.bat 
#Start-Process -wait lanceScriptPS_startPortainer.bat
#Start-Process -wait lanceScriptPS_startApplication.bat

Start-Process -wait -NoNewWindow "lanceScriptPS_installPortainer.bat"
Write-Output "Fin du processus d'install de Portainer." >> $pathlog\initialisationEcombox.log
Start-Process -wait -NoNewWindow "lanceScriptPS_startPortainer.bat"
Write-Output "Fin du processus de démarrage de Portainer." >> $pathlog\initialisationEcombox.log
Start-Process -wait -NoNewWindow "lanceScriptPS_startApplication.bat"
Write-Output "Fin processus du démarrage et du lancement de l'application." >> $pathlog\initialisationEcombox.log
