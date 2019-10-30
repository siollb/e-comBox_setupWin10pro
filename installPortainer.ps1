# Gestion des logs
$pathlog="$env:USERPROFILE\.docker\logEcombox"

Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "======================================" >> $pathlog\initialisationEcombox.log
Write-Output "Installation et démarrage de Portainer" >> $pathlog\initialisationEcombox.log
Write-Output "======================================" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log

write-host ""
Write-host "Vérification du bon fonctionnement de Docker"
write-host ""

Write-Output "" >> $pathlog\initialisationEcombox.log
Write-Output "Vérification du bon fonctionnement de Docker" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log


# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

docker info *>> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log

$info_docker = (docker info)
Write-Host $info_docker

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré" >> $pathlog\initialisationEcombox.log 
     Write-Output "" >> $pathlog\initialisationEcombox.log
     Write-host "Docker ne semble pas démarré, Si vous venez d'allumer votre ordinateur, c'est normal. Merci d'attendre avant de continuer."
     write-host ""
     write-host "Si la situation ne vous parait pas normal, fermez la fenêtre et lancer le raccourci 'Redémarrer Docker'."
     write-host "Lorsque Docker est démarré, voous pourrez relancer de nouveau le raccourci 'Vérifier et configurer l'environnement'."
     write-host ""
     $confirmStart=Read-Host "Saisissez oui pour fermer la fenêtre ou sur n'importe quel touche pour continuer"
     if ($confirmStart -eq "oui") {
     exit          
     }
        else {
            Write-Output "L'utilisateur a continué le processus d'initialisation" >> $pathlog\initialisationEcombox.log 
            Write-Output "" >> $pathlog\initialisationEcombox.log
        }
}
     else {
         Write-Output "Docker est démarré" >> $pathlog\initialisationEcombox.log
         Write-Output "" >> $pathlog\initialisationEcombox.log
         Write-host "Docker est démarré, on peut continuer..."
         Write-host ""
    }       
       
       

# Détection et configuration d'un éventuel proxy pour Git

Write-Output "Détection du proxy système" >> $pathlog\initialisationEcombox.log 
Write-Output "" >> $pathlog\initialisationEcombox.log

Set-Location -Path $env:USERPROFILE

$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$settings = Get-ItemProperty -Path $reg

if ($settings.ProxyEnable -eq 1) {
    $adresseProxy = $settings.ProxyServer
    if ($adresseProxy -ilike "*=*")
        {
            $adresseProxy = $adresseProxy -replace "=","://" -split(';') | Select-Object -First 1
        }

        else
        {
            $adresseProxy = "http://" + $adresseProxy
        }
    $noProxy = $settings.ProxyOverride
    if ($noProxy)
       { 
             $noProxy = $noProxy.Replace(';',',')
       }
       else
       {     
             $noProxy = "localhost"
       }
    Write-Output "" >> $pathlog\initialisationEcombox.log
    Write-Output "le proxy est $adresseProxy et le noProxy est $noProxy" >> $pathlog\initialisationEcombox.log
    Write-Output "" >> $pathlog\initialisationEcombox.log
    
    # Configuration de Git
    git config --global http.proxy $adresseProxy *>> $pathlog\initialisationEcombox.log
    }
    else {
      write-Output "" >> $pathlog\initialisationEcombox.log
      Write-Output "Pas de proxy système." >> $pathlog\initialisationEcombox.log
      Write-Output "" >> $pathlog\initialisationEcombox.log     
      # Configuration de Git
      git config --global --unset http.proxy *>> $pathlog\initialisationEcombox.log
      }


# Récupération de portainer 

$Path="$env:USERPROFILE\e-comBox_portainer\"
$TestPath=Test-Path $Path

If ($TestPath -eq $False) {
    # Récupération de Portainer sur Git
    Write-host ""
    Write-host "    --> Portainer n'existe pas."
    Write-host ""
    Write-Output ""  >> $pathlog\initialisationEcombox.log
    Write-Output "Téléchargement de Portainer" >> $pathlog\initialisationEcombox.log
    git clone https://github.com/siollb/e-comBox_portainer.git *>> $pathlog\initialisationEcombox.log
    }
    else {
      # Suppression de portainer et installation d'un éventuel nouveau Portainer
      Write-host ""
      Write-host "    --> Portainer est démarré, il faut le supprimer pour le réinstaller."
      Write-host ""
      Write-Output ""  >> $pathlog\initialisationEcombox.log
      Write-Output "    --> Portainer est installé, il faut le supprimer pour le réinstaller."  >> $pathlog\initialisationEcombox.log
      Write-Output ""  >> $pathlog\initialisationEcombox.log    
      #docker-compose down *>> $pathlog\initialisationEcombox.log
      Remove-Item "$env:USERPROFILE\e-comBox_portainer" -Recurse -Force *>> $pathlog\initialisationEcombox.log
      Write-Output "" >> $pathlog\initialisationEcombox.log
      Write-Output "Téléchargement de Portainer" >> $pathlog\initialisationEcombox.log
      git clone https://github.com/siollb/e-comBox_portainer.git *>> $pathlog\initialisationEcombox.log 
    }

      
If ($? -eq 0) {
  write-host ""
  write-host "Succès... Portainer a été téléchargé."
  write-host ""
  write-Output "" >> $pathlog\initialisationEcombox.log
  write-Output "Succès... Portainer a été téléchargé." >> $pathlog\initialisationEcombox.log
  write-Output "" >> $pathlog\initialisationEcombox.log

}
    else {
       write-host ""
       write-host "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations."
       Write-Host ""
       write-Output "" >> $pathlog\initialisationEcombox.log
       write-Output "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations." >> $pathlog\initialisationEcombox.log
       write-Output "" >> $pathlog\initialisationEcombox.log
    }           