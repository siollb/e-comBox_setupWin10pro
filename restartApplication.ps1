﻿# Redémarrage de Portainer
Start-Process -wait lanceScriptPS_restartPortainer.bat

# Redémarrage de l'application
docker rm -f e-combox
docker volume rm $(docker volume ls -qf dangling=true)
docker pull aporaf/e-combox:1.0
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0


# Nettoyage des anciennes images si elles ne sont associées à aucun site
Write-host ""      
Write-host "Suppression des images si elles ne sont associées à aucun site"
Write-host ""
docker rmi $(docker images -q) 2>> $env:USERPROFILE\configEnvEcombox.log


# Suppression des éventuels images dangling
if (docker images -q -f dangling=true) {
   docker rmi $(docker images -q -f dangling=true) 2>> $env:USERPROFILE\configEnvEcombox.log
   }

# Lancement de l'application
Start-Process "C:\Program Files\e-comBox\e-comBox.url"