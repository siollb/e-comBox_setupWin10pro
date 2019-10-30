
# Création d'un fichier de log et écriture de la date

Write-host ""
Write-host "============================"
Write-host "Création d'un fichier de log"
Write-host "============================"
Write-host ""

$pathlog="$env:USERPROFILE\.docker\logEcombox"

Set-Location -Path $env:USERPROFILE
New-Item -Path "$pathlog\configEnvEcombox.log" -ItemType file -force
write-host ""
Write-host "Le fichier de log configEnvEcombox.log a été créé à la racine du dossier $pathlog."
Write-host "$(Get-Date) - Configuration de l'environnement"

Write-Output "==========================================================================================" >> $pathlog\configEnvEcombox.log
Write-Output "$(Get-Date) -  Vérification et configuration de l'environnement" >> $pathlog\configEnvEcombox.log
Write-Output "==========================================================================================" >> $pathlog\configEnvEcombox.log
Write-Output "" >> $pathlog\configEnvEcombox.log

# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

Write-host ""
Write-host "================================"
Write-host "Vérification de l'état de Docker"
Write-host "================================"
Write-host ""

Write-Output "Vérification du bon fonctionnement de Docker" >> $pathlog\configEnvEcombox.log
Write-Output "" >> $pathlog\configEnvEcombox.log

docker info *>> $pathlog\configEnvEcombox.log
Write-Output "" >> $pathlog\configEnvEcombox.log

$info_docker = (docker info)

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré" >> $pathlog\configEnvEcombox.log 
     Write-Output "" >> $pathlog\configEnvEcombox.log
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
         Write-Output "Docker est démarré" >> $pathlog\configEnvEcombox.log
         Write-Output "" >> $pathlog\configEnvEcombox.log
         Write-host "Docker est démarré, on peut continuer..."
         Write-host ""
    }       
       

# Détection du proxy système

Write-host ""
Write-host "============================================"
Write-host "Vérification d'un éventuel proxy pour Docker"
Write-host "============================================"
Write-host ""

Write-Output "Détection du proxy système" >> $pathlog\configEnvEcombox.log 
Write-Output "" >> $pathlog\configEnvEcombox.log

$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

$settings = Get-ItemProperty -Path $reg
$adresseProxy = $settings.ProxyServer
$proxyEnable = $settings.ProxyEnable


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

    Write-Output "" >> $pathlog\configEnvEcombox.log
    Write-Output "le proxy est $adresseProxy et le noProxy est $noProxy" >> $pathlog\configEnvEcombox.log
    Write-Output "" >> $pathlog\configEnvEcombox.log

    # Configuration de Git pour récupérer éventuellement un nouveau Portainer
    git config --global http.proxy $adresseProxy *>> $pathlog\configEnvEcombox.log
    
     Write-host ""
     Write-Host "Le système a détecté que vous utilisez un proxy pour vous connecter à Internet, veillez à vérifier que ce dernier est correctement configuré au niveau de Docker avec les paramètres suivants :"
     Write-Host ""
     Write-Host "Adresse IP du proxy (avec le port utilisé) : $adresseProxy"
     Write-host "By Pass : $noProxy"
     Write-Host ""
     Read-Host "Appuyez sur la touche Entrée pour continuer"
     Write-host ""

     # Configuration de Docker
     new-item "config.json" –type file -force *>> $pathlog\configEnvEcombox.log
@"
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "$adresseProxy",
     "httpsProxy": "$adresseProxy",
     "noProxy": "$noProxy"
   }
 }
}
"@ > config.json

Set-Content config.json -Encoding ASCII -Value (Get-Content config.json) *>> $pathlog\configEnvEcombox.log

}
  else {
   write-Output ""
   Write-Output "Pas de proxy système." >> $pathlog\configEnvEcombox.log
   Write-Output ""
   Write-Host "Le système a détecté que vous n'utilisez pas de proxy pour vous connecter à Internet, vérifiez que cette fonctionnalité soit bien désactivée sur Docker." 
   Write-Host ""
   Read-Host "Appuyez sur la touche Entrée pour continuer"
   Write-host ""

   # Configuration de Git
   git config --global --unset http.proxy *>> $pathlog\configEnvEcombox.log
   
   #Configuration de Docker
   remove-item "config.json" *>> $pathlog\initialisationEcombox.log 
   }

   
# Configuration du réseau pour l'application

 Write-host ""
 Write-host "=========================================="
 Write-host "Configuration du réseau pour l'application"
 Write-host "=========================================="
 Write-host ""


 Write-Host "L'application utilise par défaut le réseau 192.168.97.0/24." 
 Write-host ""

 if ((docker network ls) | Select-String bridge_e-combox) {
      $NET_ECB = docker network inspect --format='{{range .IPAM.Config}}{{.Subnet}}{{end}}' bridge_e-combox
      #$GW_ECB = docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge_e-combox
      if ($NET_ECB -ne "192.168.97.0/24") {
      Write-Host "Vous avez déjà changé ce réseau pour le réseau $NET_ECB"
      Write-Output "Réseau pour les sites utilisé : $NET_ECB" >> $pathlog\configEnvEcombox.log
      Write-Host ""
      }
  }

 Write-Host "Vous pouvez changer ce paramètre si vous pensez, par exemple, qu'il peut y avoir un conflit d'adresses IP avec votre réseau existant et si vous savez ce que vous faites."
 Write-host ""
 Write-Host "ATTENTION, LES ANCIENS SITES DOIVENT ETRE ET SERONT AUTOMATIQUEMENT SUPPRIMES."
 Write-Host ""

 $confirmReseau=Read-Host "Veuillez confirmer que vous désirez modifier le réseau et SUPPRIMER les anciens sites s'il en existe (répondre par oui pour confirmer ou par n'importe quel autre caractère pour maintenir le réseau actuel)"
 Write-host ""
   if ($confirmReseau -eq "oui") 
     {
        $NET_ECB=Read-Host "Saisissez le réseau sous la forme adresseIP/CIDR"
        #$GW_ECB=Read-Host "Saisissez l'adresse IP de la passerelle" 
          if ((docker network ls) | Select-String bridge_e-combox) {
            if (docker ps -a -q) {
              Write-Output "Suppression des conteneurs :" >> $pathlog\configEnvEcombox.log
              Write-Host "Suppression des sites"
              Write-Host ""
              docker rm -f $(docker ps -a -q) *>> $pathlog\configEnvEcombox.log
              docker volume rm $(docker volume ls -qf dangling=true) *>> $pathlog\configEnvEcombox.log
            }
              Write-Output "Suppression du réseau actuel :" >> $pathlog\configEnvEcombox.log
              Write-Host "Suppression du réseau actuel"
              Write-Host ""
              docker network rm bridge_e-combox *>> $pathlog\configEnvEcombox.log
              write-Output ""
           }
           Write-Output "Création du réseau actuel $NET_ECB :" >> $pathlog\configEnvEcombox.log          
           docker network create --subnet $NET_ECB bridge_e-combox *>> $pathlog\configEnvEcombox.log
           write-Output ""
           Write-Host ""
           Write-Host "L'application utilise maintenant le réseau $NET_ECB."
           Write-Host ""
      }  


#Read-Host "Appuyez sur la touche Entrée pour continuer"


# Récupération de portainer

write-host ""
write-host "Le re-initialisation continue avec la configuration de Portainer..."
write-host ""

$Path="$env:USERPROFILE\e-comBox_portainer\"
$TestPath=Test-Path $Path

If ($TestPath -eq $False) {
    # Installation de Portainer sur Git
    write-Output "" >> $pathlog\configEnvEcombox.log
    Write-Output "Portainer n'est pas installé, il faut l'installer." >> $pathlog\configEnvEcombox.log
    write-Output "" >> $pathlog\configEnvEcombox.log
    git clone https://github.com/siollb/e-comBox_portainer.git *>> $pathlog\configEnvEcombox.log
    #Write-Host ""
    }
    else {
      # Arrêt et suppression de Portainer
      write-Output "" >> $pathlog\configEnvEcombox.log
      Write-Output "Portainer est démarré, il faut le stopper et le supprimer pour le réinstaller." >> $pathlog\configEnvEcombox.log
      write-Output "" >> $pathlog\configEnvEcombox.log
      Set-Location -Path $env:USERPROFILE\e-comBox_portainer\
      docker-compose down *>> $pathlog\configEnvEcombox.log
      Write-Output "" >> $pathlog\configEnvEcombox.log
      Set-Location -Path $env:USERPROFILE\
      Remove-Item "e-comBox_portainer" -Recurse -Force *>> $pathlog\configEnvEcombox.log
      Write-Output "" >> $pathlog\configEnvEcombox.log   
      git clone https://github.com/siollb/e-comBox_portainer.git *>> $pathlog\configEnvEcombox.log
      #Write-Host "" >> $pathlog\configEnvEcombox.log      
      } 

If ($? -eq 0) {
  write-host ""
  write-host "Success... Portainer a été téléchargé."
  write-host ""
  write-Output "" >> $pathlog\configEnvEcombox.log
  write-Output "Success... Portainer a été téléchargé." >> $pathlog\configEnvEcombox.log
  write-Output "" >> $pathlog\configEnvEcombox.log

}
    else {
       write-host ""
       write-host "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations."
       Write-Host ""
       write-Output "" >> $pathlog\configEnvEcombox.log
       write-Output "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations." >> $pathlog\configEnvEcombox.log
       write-Output "" >> $pathlog\configEnvEcombox.log
    }           



#Détection et configuration de l'adresse IP

Write-host ""
Write-host "============================================================="
Write-host "Vérification et configuration d'une adresse IP pour les sites"
Write-host "============================================================="
Write-host ""

# Récupération et mise au bon format de l'adresse IP de l'hôte utilisé par e-comBox
$docker_ip_host = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex (Get-NetIPConfiguration | Foreach IPv4DefaultGateway).ifIndex).IPAddress  | Select-Object -first 1
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Récupération des adresses IP d'une interface physique même si elles ne sont pas associées à une passerelle par défaut
$adressesIPvalides = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$adressesIPvalides = "$adressesIPvalides"
$adressesIPvalides = $adressesIPvalides.Trim()

if ($adressesIPvalides -eq $null) {
 write-host ""
 Write-host "Le système ne détecte aucune adresse IP accessible à distance pouvant être utilisée avec e-comBox. L'application sera configuré avec l'adresse 127.0.0.1 qui n'est accessible que de la machine elle-même. Si ce n'est pas ce que vous voulez, vérifiez votre configuration IP et relancez le programme."
 Write-Host ""
 write-Output "" >> $pathlog\configEnvEcombox.log
 Write-Output "Le système ne détecte aucune adresse IP accessible à distance pouvant être utilisée avec e-comBox. L'application sera configuré avec l'adresse 127.0.0.1 qui n'est accessible que de la machine elle-même. Si ce n'est pas ce que vous voulez, vérifiez votre configuration IP et relancez le programme." >> $pathlog\configEnvEcombox.log
 Write-Output "" >> $pathlog\configEnvEcombox.log
 Read-Host "Appuyez sur la touche Entrée pour fermer ce programme"
 }


If ($docker_ip_host -eq $adressesIPvalides) {
 write-host ""
 Write-host "Le système a détecté que vous utilisez cette adresse IP : $docker_ip_host et que vous ne disposez pas d'autres adresses IP valides susceptibles d'être configurées avec e-comBox."
 Write-Host ""
 #Read-Host "Appuyez sur la touche Entrée pour fermer ce programme"
 }
 else {
  Write-host ""
  Write-host "Le système a détecté que vous utilisez cette adresse IP : $docker_ip_host et que vous disposez des adresses IP valides suivantes :"
  write-host ""

  # Récupération des adresses IP pour formatage dans menu
     $adressesIPformat = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPAddress 
     $menu = @{}
     for ($i=1;$i -le $adressesIPformat.count; $i++) 
       {
       Write-Host "$i. $($adressesIPformat[$i-1].Trim())" 
       $menu.Add($i,($adressesIPformat[$i-1]))
       }

     Write-host ""
     [int]$num = Read-Host "Saisissez le numéro correspondant à l'adresse IP que vous voulez utiliser pour e-comBox"
     Write-host "" 

     $adresseIP = $menu.Item($num) 

     Write-host ""

     $confirmIP=Read-Host "Veuillez confirmer que vous désirez utiliser l'adresse IP $adresseIP pour rendre accessible vos sites dans e-comBox (répondre par oui pour confirmer ou par n'importe quel autre caractère pour maintenir l'adresse IP actuelle)."
     if ($confirmIP -eq "oui") 
      {
      $docker_ip_host=$adresseIP

      Write-host ""
      Write-host "L'application e-comBox utilisera dorénavant l'adresse IP : $docker_ip_host."
      Write-Output "" >> $pathlog\configEnvEcombox.log
      Write-Output "L'application e-comBox utilisera dorénavant l'adresse IP : $docker_ip_host." >> $pathlog\configEnvEcombox.log
      }

}

# Mise à jour de l'adresse IP dans le fichier ".env" préalablement créé

Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

New-Item -Name ".env" -ItemType file -force *>> $pathlog\configEnvEcombox.log

@"
URL_UTILE=$docker_ip_host
"@ > .env

     Set-Content .env -Encoding ASCII -Value (Get-Content .env) *>> $pathlog\configEnvEcombox.log

     Write-host ""      
     Write-host "Le système va maintenant configurer e-comBox avec l'adresse IP : $docker_ip_host et lancer l'application dans votre navigateur par défaut."
     Write-host "" 


# Démarrage de Portainer
   docker-compose up --build --force-recreate -d *>> $pathlog\configEnvEcombox.log

# Téléchargement éventuel d'une nouvelle version de e-comBox et démarrage de l'application
   if ((docker ps -a |  Select-String e-combox)) {
     Write-Output "" >> $pathlog\configEnvEcombox.log
     Write-Output "Suppression d'e-combox avec son volume :" >> $pathlog\configEnvEcombox.log
     docker rm -f e-combox *>> $pathlog\configEnvEcombox.log
     docker volume rm $(docker volume ls -qf dangling=true) *>> $pathlog\configEnvEcombox.log
     Write-Output "" >> $pathlog\configEnvEcombox.log
     Write-Output "Téléchargement et lancement d'e-combox :" >> $pathlog\configEnvEcombox.log
     docker pull aporaf/e-combox:1.0 *>> $pathlog\configEnvEcombox.log
     docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $pathlog\configEnvEcombox.log
     Write-host "Téléchargement d'e-combox après suppression FAIT"
   }
    else {
       Write-Output "" >> $pathlog\configEnvEcombox.log
       Write-Output "Pas d'application e-combox trouvée." >> $pathlog\configEnvEcombox.log
       Write-Output "Téléchargement et lancement d'e-combox :" >> $pathlog\configEnvEcombox.log
       docker pull aporaf/e-combox:1.0 *>> $pathlog\configEnvEcombox.log
       docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $pathlog\configEnvEcombox.log
       Write-host "Téléchargement d'e-combox FAIT"
    } 

# Nettoyage des anciennes images si elles ne sont associées à aucun site
if (docker image ls -q) {
  Write-host ""      
  Write-host "Suppression des images qui ne sont associées à aucun site."
  Write-host ""
  Write-Output "" >> $pathlog\configEnvEcombox.log     
  Write-Output "Suppression des images qui ne sont associées à aucun site :" >> $pathlog\configEnvEcombox.log
  docker image rm -f $(docker image ls -q) *>> $pathlog\configEnvEcombox.log
}
  else {
       Write-host ""
       Write-host "Aucune image non associée à un site à supprimer."
       Write-host ""
       Write-Output "" >> $pathlog\configEnvEcombox.log     
       Write-Output "Aucune image non associée à un site à supprimer." >> $pathlog\configEnvEcombox.log
       Write-Output "" >> $pathlog\configEnvEcombox.log
  }

Read-Host "Appuyez sur la touche Entrée pour lancer l'application"

Start-Process "C:\Program Files\e-comBox\e-comBox.url"
write-Output "" >> $pathlog\configEnvEcombox.log
Write-Output "L'application a été lancée dans le navigateur le $(Get-Date)." >> $pathlog\configEnvEcombox.log
