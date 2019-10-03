#Requires -RunAsAdministrator

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

    Write-Host "le no proxy est $noProxy"
    
     Write-host ""
     Write-Host "Le système a détecté que vous utilisez un proxy pour vous connecter à Internet, veillez à vérifier que ce dernier est correctement configuré au niveau de Docker avec les paramètres suivants :"
     Write-Host ""
     Write-Host "Adresse IP du proxy (avec le port utilisé) : $adresseProxy"
     Write-host "By Pass : $noProxy"
     Write-Host ""
     Read-Host "Appuyez sur la touche Entrée pour continuer"

}
  else {
   Write-host ""
   Write-Host "Le système a détecté que vous n'utilisez pas de proxy pour vous connecter à Internet, vérifiez que cette fonctionnalité soit bien désactivée sur Docker." 
   Write-Host ""
   Read-Host "Appuyez sur la touche Entrée pour continuer"
   }




# Configuration du réseau pour l'application

 Write-host ""
 Write-host "=========================================="
 Write-host "Configuration du réseau pour l'application"
 Write-host "=========================================="
 Write-host ""

 Write-Host "L'application utilise le réseau 192.168.97.0/24 avec une passerelle de 192.168.97.1." 
 Write-Host "Vous pouvez changer ces paramètres si vous pensez qu'il peut y avoir un conflit d'adresses IP avec votre réseau existant et si vous savez ce que vous faites"
 Write-Host ""
 
 $accord=Read-Host "Veuillez confirmer que vous désirez modifier le réseau (répondre par oui pour confirmer ou par n'importe quel autre caractère pour maintenir le réseau actuel)"
     if ($accord -eq "oui") 
      {
      Read-Host "Saisissez le réseau sous la forme adresseIP/CIDR" $NET_ECB
      Read-Host "Saisissez l'adresse IP de la passerelle" $GW_ECB
      }
     else {
      $NET_ECB = "192.168.97.0/24"
      $GW_ECB = "192.168.97.1"
      }


 if ((docker network ls) | Select-String bridge_e-combox) {
   Write-host "    --> Le réseau existe, il faut le supprimer avant de le créer à nouveau." -Fore blue
   docker stop $(docker ps -q)
   docker network rm bridge_e-combox
   docker network create --subnet $NET_ECB --gateway=$GW_ECB bridge_e-combox
   }
else {
   Write-host "    --> Le réseau n'existe pas, il faut le créer." -Fore blue
   docker network create --subnet $NET_ECB --gateway=$GW_ECB bridge_e-combox
}

Write-Host "L'application utilise maintenant le réseau $NET_ECB avec une passerelle de $GW_ECB."

Read-Host "Appuyez sur la touche Entrée pour continuer"

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
 Write-host "Le système ne détecte aucune adresse IP valide pouvant être utilisée avec e-comBox. Vérifiez votre configuration IP et relancez le programme."
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

     $confirmation=Read-Host "Veuillez confirmer que vous désirez utiliser la nouvelle adresse IP $adresseIP pour rendre accessible vos sites dans e-comBox (répondre par oui pour confirmer ou par n'importe quel autre caractère pour maintenir l'adresse IP actuelle)."
     if ($confirmation -eq "oui") 
      {
      $docker_ip_host=$adresseIP

      Write-host ""
      Write-host "L'application e-comBox utilisera dorénavant l'adresse IP : $docker_ip_host."
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
     #sleep 5   
   }
      else {
       Write-host ""
       Write-Host "L'application e-comBox continuera à utiliser l'adresse ip $docker_ip_host."
      
       #sleep 5
     }
}

# Détection et configuration d'un éventuel proxy pour Git

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
    #Write-Host "l'adresse du proxy est $adresseProxy"
    git config --global http.proxy $adresseProxy
    }
    else {
      git config --global --unset http.proxy
      }


# Récupération de portainer

$Path="$env:USERPROFILE\e-comBox_portainer\"
$TestPath=Test-Path $Path

If ($TestPath -eq $False) {
    # Installation de Portainer sur Git
    Write-host "    --> Portainer n'est pas installé, il faut l'installer." -Fore Red
    git clone https://github.com/siollb/e-comBox_portainer.git 2>$null
    }
    else {
      # Arrêt de Portainer
      Write-host "    --> Portainer est démarré, il faut le stopper et le supprimer pour le réinstaller." -Fore blue
      Set-Location -Path $env:USERPROFILE\e-comBox_portainer\
      docker-compose down
      Set-Location -Path $env:USERPROFILE\
      Remove-Item "e-comBox_portainer" -Recurse    
      git clone https://github.com/siollb/e-comBox_portainer.git 2>$null       
      } 

# Démarrage de Portainer
   Set-Location -Path $env:USERPROFILE\e-comBox_portainer\
   docker-compose up --build -d

# Redémarrage de l'application
   docker rm -f e-combox
   docker pull aporaf/e-combox:1.0
   docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0
   Start-Process "C:\Program Files\e-comBox\e-comBox.url"

Read-Host "Appuyez sur la touche Entrée pour fermer ce programme"
