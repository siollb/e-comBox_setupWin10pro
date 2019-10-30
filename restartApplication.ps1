# Gestion des logs
$pathlog="$env:USERPROFILE\.docker\logEcombox"

Write-host ""
Write-host "================================================================================="
Write-host "$(Get-Date) - Réinitialisation de l'environnement"
Write-host "================================================================================="
Write-host ""

Write-Output "=======================================================================" > $pathlog\reinitialiseEnvEcombox.log
Write-Output "$(Get-Date) - Réinitialisation de l'environnement" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "=======================================================================" >> $pathlog\reinitialiseEnvEcombox.log

# Reinitialisation de Portainer
write-host ""
Write-host "Réinitialisation de Portainer"
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Réinitialisation de Portainer" >> $pathlog\reinitialiseEnvEcombox.log
Start-Process -wait -NoNewWindow "lanceScriptPS_restartPortainer.bat"

# Réinitialisation de l'application
write-host ""
Write-host "Réinitialisation de l'application"
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Réinitialisation de l'application" >> $pathlog\reinitialiseEnvEcombox.log
docker rm -f e-combox *>> $pathlog\reinitialiseEnvEcombox.log
docker volume rm $(docker volume ls -qf dangling=true) *>> $pathlog\reinitialiseEnvEcombox.log
docker pull aporaf/e-combox:1.0 *>> $pathlog\reinitialiseEnvEcombox.log
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $pathlog\reinitialiseEnvEcombox.log


# Nettoyage des anciennes images si elles ne sont associées à aucun site
Write-host ""      
Write-host "Suppression des images si elles ne sont associées à aucun site"
Write-host ""
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Suppression des images si elles ne sont associées à aucun site" >> $pathlog\reinitialiseEnvEcombox.log
docker rmi $(docker images -q) *>> $pathlog\reinitialiseEnvEcombox.log

# Suppression des éventuelles images dangling
if (docker images -q -f dangling=true) {
   docker rmi $(docker images -q -f dangling=true) *>> $pathlog\reinitialiseEnvEcombox.log
   }

# Lancement de l'application
Start-Process "C:\Program Files\e-comBox\e-comBox.url"
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "L'application a été lancée dans le navigateur le $(Get-Date)." >> $pathlog\reinitialiseEnvEcombox.log

