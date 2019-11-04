# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts"

Write-host ""
Write-host "    --> Réinstallation et redémarrage de Portainer"
Write-host ""
Write-Output ""  >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "    --> Réinstallation et redémarrage de Portainer. Voir détail des logs dans initialisationEcombox.log"  >> $pathlog\reinitialiseEnvEcombox.log
Write-Output ""  >> $pathlog\reinitialiseEnvEcombox.log

Write-Output "--------------------------------------------------------------------------------------------" >> $pathlog\initialisationEcombox.log
Write-Output "    --> Une réinitialisation de l'environnement a été lancée le $(Get-Date)."  >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log

Start-Process "$pathscripts\lanceScriptPS_installPortainer.bat" -wait -NoNewWindow 
Start-Process "$pathscripts\lanceScriptPS_startPortainer.bat" -wait -NoNewWindow 

Write-Output "--------------------------------------------------------------------------------------------" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output ""  >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Fin de la réinitialisation de Portainer du $(Get-Date)."  >> $pathlog\reinitialiseEnvEcombox.log
Write-Output ""  >> $pathlog\reinitialiseEnvEcombox.log
