
# Création d'un fichier de log

Write-host ""
Write-host "============================"
Write-host "Création d'un fichier de log"
Write-host "============================"
Write-host ""

Set-Location -Path $env:USERPROFILE
New-Item -Name "configEnvEcombox.log" -ItemType file -force
Write-host "Le fichier de log configEnvEcombox.log a été créé à la racine du dossier $env:USERPROFILE"


# Détection du proxy sur le système pour le configurer sur Docker

 Write-host ""
 Write-host "============================================"
 Write-host "Vérification d'un éventuel proxy pour Docker"
 Write-host "============================================"
 Write-host ""

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

    Write-host "" >> $env:USERPROFILE\configEnvEcombox.log
    Write-Host "le proxy est $adresseProxy et le noProxy est $noProxy" >> $env:USERPROFILE\configEnvEcombox.log
    Write-host "" >> $env:USERPROFILE\configEnvEcombox.log

    # Configuration de Git pour récupérer éventuellement un nouveau Portainer
    git config --global http.proxy $adresseProxy
    
     Write-host ""
     Write-Host "Le système a détecté que vous utilisez un proxy pour vous connecter à Internet, veillez à vérifier que ce dernier est correctement configuré au niveau de Docker avec les paramètres suivants :"
     Write-Host ""
     Write-Host "Adresse IP du proxy (avec le port utilisé) : $adresseProxy"
     Write-host "By Pass : $noProxy"
     Write-Host ""
     Read-Host "Appuyez sur la touche Entrée pour continuer"
     Write-host ""

}
  else {
   Write-host "Pas de proxy système" >> $env:USERPROFILE\configEnvEcombox.log
   Write-host ""
   Write-Host "Le système a détecté que vous n'utilisez pas de proxy pour vous connecter à Internet, vérifiez que cette fonctionnalité soit bien désactivée sur Docker." 
   Write-Host ""
   Read-Host "Appuyez sur la touche Entrée pour continuer"
   Write-host ""

   # Configuration de Git pour récupérer éventuellement un nouveau Portainer
   git config --global --unset http.proxy *>> $env:USERPROFILE\configEnvEcombox.log 
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
      Write-host "Réseau pour les sites utilisé : $NET_ECB" >> $env:USERPROFILE\configEnvEcombox.log
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
              Write-host "Suppression des conteneurs :" >> $env:USERPROFILE\configEnvEcombox.log
              Write-Host "Suppression des sites"
              Write-Host ""
              docker rm -f $(docker ps -a -q) 2>&1 $env:USERPROFILE\configEnvEcombox.log
              docker volume rm $(docker volume ls -qf dangling=true)
            }
              Write-host "Suppression du réseau actuel :" >> $env:USERPROFILE\configEnvEcombox.log
              Write-Host "Suppression du réseau actuel"
              Write-Host ""
              docker network rm bridge_e-combox 2>&1 $env:USERPROFILE\configEnvEcombox.log
           }
           Write-host "Création du réseau actuel $NET_ECB :" >> $env:USERPROFILE\configEnvEcombox.log          
           docker network create --subnet $NET_ECB bridge_e-combox *>> $env:USERPROFILE\configEnvEcombox.log
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
    write-host "" >> $env:USERPROFILE\configEnvEcombox.log
    Write-host "Portainer n'est pas installé, il faut l'installer." >> $env:USERPROFILE\configEnvEcombox.log
    write-host "" >> $env:USERPROFILE\configEnvEcombox.log
    git clone https://github.com/siollb/e-comBox_portainer.git *>> $env:USERPROFILE\configEnvEcombox.log
    Write-Host ""
    }
    else {
      # Arrêt de Portainer
      write-host "" >> $env:USERPROFILE\configEnvEcombox.log
      Write-host "Portainer est démarré, il faut le stopper et le supprimer pour le réinstaller."
      write-host "" >> $env:USERPROFILE\configEnvEcombox.log
      Set-Location -Path $env:USERPROFILE\e-comBox_portainer\
      docker-compose down -t 20 2>&1 $env:USERPROFILE\configEnvEcombox.log
      Write-Host ""
      Set-Location -Path $env:USERPROFILE\
      Remove-Item "e-comBox_portainer" -Recurse -Force    
      git clone https://github.com/siollb/e-comBox_portainer.git *>> $env:USERPROFILE\configEnvEcombox.log
      Write-Host "" >> $env:USERPROFILE\configEnvEcombox.log      
      } 

If ($? -eq $null) {
write-host ""
write-host "Success..."
write-host ""
}
    else {
       write-host ""
       write-host "Portainer n'a pas pu être téléchargé, consultez le fichier de log pour plus d'informations"
       Write-Host ""
    }




#Détection et configuration de l'adresse IP

 Write-host ""
 Write-host "====================================================================="
 Write-host "Vérification et éventuelle configuration d'une adresse IP pour Docker"
 Write-host "====================================================================="
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
      }

}

# Mise à jour de l'adresse IP dans le fichier ".env"

Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

New-Item -Name ".env" -ItemType file -force
@"
URL_UTILE=$docker_ip_host
"@ > .env

     Set-Content .env -Encoding ASCII -Value (Get-Content .env)

     Write-host ""      
     Write-host "Le système va maintenant configurer e-comBox avec l'adresse IP : $docker_ip_host et lancer l'application dans votre navigateur par défaut."
     Write-host "" 


# Démarrage de Portainer
   docker-compose up -d

# Téléchargement éventuel d'une nouvelle version de e-comBox et démarrage de l'application
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
   
Read-Host "Appuyez sur la touche Entrée pour lancer l'application."

Start-Process "C:\Program Files\e-comBox\e-comBox.url"
