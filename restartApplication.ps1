# Création d'un fichier de log et écriture de la date

Write-host ""
Write-host "================================================================================="
Write-host "$(Get-Date) - Réinitialisation de l'environnement"
Write-host "================================================================================="
Write-host ""

Write-Output "=======================================================================" > $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "$(Get-Date) - Réinitialisation de l'environnement" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "=======================================================================" >> $env:USERPROFILE\reinitialiseEnvEcombox.log

# Reinitialisation de Portainer
write-host ""
Write-host "Réinitialisation de Portainer"
write-Output "" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "Réinitialisation de Portainer" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Start-Process -wait -NoNewWindow "lanceScriptPS_restartPortainer.bat"

# Réinitialisation de l'application
write-host ""
Write-host "Réinitialisation de l'application"
write-Output "" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "Réinitialisation de l'application" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
docker rm -f e-combox *>> $env:USERPROFILE\reinitialiseEnvEcombox.log
docker volume rm $(docker volume ls -qf dangling=true) *>> $env:USERPROFILE\reinitialiseEnvEcombox.log
docker pull aporaf/e-combox:1.0 *>> $env:USERPROFILE\reinitialiseEnvEcombox.log
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $env:USERPROFILE\reinitialiseEnvEcombox.log


# Nettoyage des anciennes images si elles ne sont associées à aucun site
Write-host ""      
Write-host "Suppression des images si elles ne sont associées à aucun site"
Write-host ""
write-Output "" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "Suppression des images si elles ne sont associées à aucun site" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
docker rmi $(docker images -q) *>> $env:USERPROFILE\reinitialiseEnvEcombox.log

# Suppression des éventuelles images dangling
if (docker images -q -f dangling=true) {
   docker rmi $(docker images -q -f dangling=true) *>> $env:USERPROFILE\reinitialiseEnvEcombox.log
   }

# Lancement de l'application
Start-Process "C:\Program Files\e-comBox\e-comBox.url"
write-Output "" >> $env:USERPROFILE\reinitialiseEnvEcombox.log
Write-Output "L'application a été lancée dans le navigateur le $(Get-Date)." >> $env:USERPROFILE\reinitialiseEnvEcombox.log

