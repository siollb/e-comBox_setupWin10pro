# Les logs sont dans $env:USERPROFILE\initialisationEcombox.log

Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "======================================" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "Installation et démarrage de Portainer" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "======================================" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

write-host ""
Write-host "Vérification du bon fonctionnement de Docker"
write-host ""

Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "Vérification du bon fonctionnement de Docker" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log


# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

docker info *>> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

$info_docker = (docker info)
Write-Host $info_docker

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré" >> $env:USERPROFILE\initialisationEcombox.log 
     Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
     Write-host "Docker ne semble pas démarré, merci d'attendre le redémarrage avant de continuer."
     #write-host "Si la situation ne vous parait pas normal, le système peut tenter un redémarrage de Docker."
     $confirmStart=Read-Host "Saisissez oui pour confirmer le redémarrage de Docker par le système ou sur n'importe quel touche pour continuer"
     #if ($confirmStart -eq "oui") {
        #Start-Process -wait C:\Users\daniel\e-comBox_setupWin10pro\lanceScriptPS_restartDocker.bat *>> $env:USERPROFILE\initialisationEcombox.log

     #}
        #else {
            #Write-Output "L'utilisateur a continué le processus d'initialisation" >> $env:USERPROFILE\initialisationEcombox.log 
            #Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
        #}
}
     else {
         Write-Output "Docker est démarré" >> $env:USERPROFILE\initialisationEcombox.log
         Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
         Write-host "Docker est démarré, on peut continuer..."
         Write-host ""
    }       
       
       

# Détection et configuration d'un éventuel proxy pour Git

Write-Output "Détection du proxy système" >> $env:USERPROFILE\initialisationEcombox.log 
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

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
    Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
    Write-Output "le proxy est $adresseProxy et le noProxy est $noProxy" >> $env:USERPROFILE\initialisationEcombox.log
    Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
    
    # Configuration de Git
    git config --global http.proxy $adresseProxy *>> $env:USERPROFILE\initialisationEcombox.log
    }
    else {
      write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
      Write-Output "Pas de proxy système." >> $env:USERPROFILE\initialisationEcombox.log
      Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log     
      # Configuration de Git
      git config --global --unset http.proxy *>> $env:USERPROFILE\initialisationEcombox.log
      }


# Récupération de portainer 

$Path="$env:USERPROFILE\e-comBox_portainer\"
$TestPath=Test-Path $Path

If ($TestPath -eq $False) {
    # Récupération de Portainer sur Git
    Write-host ""
    Write-host "    --> Portainer n'existe pas."
    Write-host ""
    Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log
    Write-Output "Téléchargement de Portainer" >> $env:USERPROFILE\initialisationEcombox.log
    git clone https://github.com/siollb/e-comBox_portainer.git *>> $env:USERPROFILE\initialisationEcombox.log
    }
    else {
      # Suppression de portainer et installation d'un éventuel nouveau Portainer
      Write-host ""
      Write-host "    --> Portainer est démarré, il faut le supprimer pour le réinstaller."
      Write-host ""
      Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log
      Write-Output "    --> Portainer est installé, il faut le supprimer pour le réinstaller."  >> $env:USERPROFILE\initialisationEcombox.log
      Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log    
      #docker-compose down *>> $env:USERPROFILE\initialisationEcombox.log
      Remove-Item "$env:USERPROFILE\e-comBox_portainer" -Recurse -Force *>> $env:USERPROFILE\initialisationEcombox.log
      Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
      Write-Output "Téléchargement de Portainer" >> $env:USERPROFILE\initialisationEcombox.log
      git clone https://github.com/siollb/e-comBox_portainer.git *>> $env:USERPROFILE\initialisationEcombox.log 
    }

      
If ($? -eq 0) {
  write-host ""
  write-host "Success... Portainer a été téléchargé."
  write-host ""
  write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
  write-Output "Success... Portainer a été téléchargé." >> $env:USERPROFILE\initialisationEcombox.log
  write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

}
    else {
       write-host ""
       write-host "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations."
       Write-Host ""
       write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
       write-Output "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations." >> $env:USERPROFILE\initialisationEcombox.log
       write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
    }           