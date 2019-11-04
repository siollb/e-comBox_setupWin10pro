# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts"

Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "=============================================================" >> $pathlog\initialisationEcombox.log
Write-Output "Installation et lancement dans un navigateur de l'application" >> $pathlog\initialisationEcombox.log
Write-Output "=============================================================" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log
 
 #Téléchargement d'une éventuelle nouvelle version de e-comBox et démarrage de l'application
   if ((docker ps -a |  Select-String e-combox)) {
     Write-Output "" >> $pathlog\initialisationEcombox.log
     Write-Output "Suppression d'e-combox avec son volume :" >> $pathlog\initialisationEcombox.log
     docker rm -f e-combox *>> $pathlog\initialisationEcombox.log
     docker volume rm $(docker volume ls -qf dangling=true) *>> $pathlog\initialisationEcombox.log
     Write-Output "" >> $pathlog\initialisationEcombox.log
     Write-Output "Téléchargement et lancement d'e-combox :" >> $pathlog\initialisationEcombox.log
      # Téléchargement d'e-comBox
     docker pull aporaf/e-combox:1.0 *>> $pathlog\initialisationEcombox.log
     # Lancement d'e-comBox
     docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $pathlog\initialisationEcombox.log
     Write-host "Téléchargement d'e-combox après suppression FAIT"
   }
    else {
       Write-Output "" >> $pathlog\initialisationEcombox.log
       Write-Output "Pas d'application e-combox trouvée." >> $pathlog\initialisationEcombox.log
       Write-Output "Téléchargement et lancement d'e-combox :" >> $pathlog\initialisationEcombox.log
       # Téléchargement d'e-comBox
       docker pull aporaf/e-combox:1.0 *>> $pathlog\initialisationEcombox.log
       # Lancement d'e-comBox
       docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $pathlog\initialisationEcombox.log
       Write-host "Téléchargement d'e-combox FAIT"
     } 

# Lancement de l'URL
Start-Process "C:\Program Files\e-comBox\e-comBox.url" *>> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "L'application e-comBox a été lancée dans le navigateur." >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log
