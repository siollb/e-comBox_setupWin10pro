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
 Read-Host "Appuyez sur la touche Entrée pour fermer ce programme"
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

     $confirmation=Read-Host "Veuillez confirmer que vous désirez utiliser la nouvelle adresse IP $adresseIP pour rendre accessible vos sites dans e-comBox (répondre par oui pour confirmer ou par n'importe quel autre caractère pour maintenir l'adresse IP actuelle)"
     if ($confirmation -eq "oui") 
      {
      $docker_ip_host=$adresseIP

      Write-host ""
      Write-host "L'application e-comBox utilisera dorénavant l'adresse IP : $docker_ip_host."
       # Mise à jour de l'adresse IP dans le fichier ".env"
      Set-Location -Path $env:USERPROFILE\e-comBox_portainer\

@"
URL_UTILE=$docker_ip_host
"@ > .env

     Set-Content .env -Encoding ASCII -Value (Get-Content .env)

     Write-host ""
     Write-host "Le système va maintenant configurer e-comBox avec l'adresse IP : $docker_ip_host et lancer l'application dans votre navigateur par défaut."
     Write-host ""
     sleep 5

   # Redémarrage de Portainer
   Set-Location -Path $env:USERPROFILE\e-comBox_portainer\
   docker-compose down
   docker-compose up -d

   # Redémarrage de l'application
   docker rm -f e-combox
   docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 aporaf/e-combox:1.0
   Start-Process "C:\Program Files\e-comBox\e-comBox.url"
   
   }
      else {
       Write-host ""
       Write-Host "L'application e-comBox continuera à utiliser l'adresse ip $docker_ip_host."
       sleep 5
     }
  #}
}