
 #Téléchargement d'une éventuelle nouvelle version de e-comBox et démarrage de l'application
   if (docker ps -a | grep e-combox){
     Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
     Write-Output "Suppression d'e-combox avec son volume :" >> $env:USERPROFILE\initialisationEcombox.log
     docker rm -f e-combox *>> $env:USERPROFILE\configEnvEcombox.log
     docker volume rm $(docker volume ls -qf dangling=true) *>> $env:USERPROFILE\initialisationEcombox.log
     Write-Output "" >> $env:USERPROFILE\configEnvEcombox.log
     Write-Output "Téléchargement et lancement d'e-combox :" >> $env:USERPROFILE\initialisationEcombox.log
      # Téléchargement d'e-comBox
     docker pull aporaf/e-combox:1.0 *>> $env:USERPROFILE\initialisationEcombox.log
     # Lancement d'e-comBox
     docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $env:USERPROFILE\initialisationEcombox.log
   }
    else {
       Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
       Write-Output "Pas d'application e-combox trouvée." >> $env:USERPROFILE\initialisationEcombox.log
       Write-Output "Téléchargement et lancement d'e-combox :" >> $env:USERPROFILE\initialisationEcombox.log
       # Téléchargement d'e-comBox
       docker pull aporaf/e-combox:1.0 *>> $env:USERPROFILE\initialisationEcombox.log
       # Lancement d'e-comBox
       docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $env:USERPROFILE\initialisationEcombox.log
    } 


# Lancement de l'URL
Start-Process "C:\Program Files\e-comBox\e-comBox.url" *>> $env:USERPROFILE\initialisationEcombox.log
