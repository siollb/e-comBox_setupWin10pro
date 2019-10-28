Write-host ""
Write-host "    --> Réinstallation et redémarrage de Portainer"
Write-host ""
Write-Output ""  >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "    --> Réinstallation et redémarrage de Portainer. Voir détail des logs dans initialisationEcombox.log"  >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output ""  >> $env:USERPROFILE\reinitialiseEnvEcombox.log

Write-Output "--------------------------------------------------------------------------------------------" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "    --> Une réinitialisation de l'environnement a été lancée le $(Get-Date)."  >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

Start-Process -wait -NoNewWindow "lanceScriptPS_installPortainer.bat"
Start-Process -wait -NoNewWindow "lanceScriptPS_startPortainer.bat"

Write-Output "--------------------------------------------------------------------------------------------" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output ""  >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "Fin de la réinitialisation de Portainer du $(Get-Date)."  >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output ""  >> $env:USERPROFILE\reinitialiseEnvEcombox.log
