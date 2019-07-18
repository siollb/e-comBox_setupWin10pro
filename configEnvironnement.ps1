# Détection du proxy sur le système

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
     $noProxy = $noProxy.Replace(';',',')
    
     Write-host ""
     Write-Host "Le système a détecté que vous utilisiez un proxy pour vous connecter à Internet, veillez à vérifier que ce dernier est correctement configuré au niveau de Docker avec les paramètres suivants :"
     Write-Host " Adresse IP du proxy (avec le port utilisé) : $adresseProxy"
     Write-Host ""
     Write-host "By Pass : $noProxy"
}
  else {
   Write-host ""
   Write-Host "Le système a détecté que vous n'utilisiez pas de proxy pour vous connecter à Internet, vérifiez que cette fonctionnalité soit bien désactivée sur Docker" 
   Write-Host ""
   }




#Détection et configuration de l'adresse IP

 Write-host ""
 Write-host "====================================================================="
 Write-host "Vérification et éventuelle configuration d'une adresse IP pour Docker"
 Write-host "====================================================================="
 Write-host ""

# Récupération et mise au bon format de l'adresse IP de l'hôte
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetIPConfiguration | Foreach IPv4DefaultGateway).ifIndex).IPv4Address
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

Write-host "Le système a détecté que vous utilisiez cette adresse IP : $docker_ip_host"
Write-host ""
$changement=Read-Host "Voulez-vous changer l'adresse IP pour e-comBox ? : (répondre par oui pour changer l'adresse IP ou par tout autre caractère si vous ne voulez par opérer de changement au niveau de l'adresse IP)"

if ($changement -eq "oui") {
 Write-host ""
 $adresseIP=Read-Host "Saisissez une adresse IP valide :"
 $confirmation=Read-Host "Veuillez confirmer (yes) que vous désirez utiliser la nouvelle adresse IP $adresseIP pour rendre accessible vos sites dans e-comBox :"
 if ($confirmation -eq "yes") {
 $docker_ip_host=$adresseIP
 Write-host ""
 Write-host "L'application e-comBox utilisera dorénavant la nouvelle adresse IP : $docker_ip_host"
 }
 else {
 Write-host ""
 Write-Host "L'application e-comBox continuera à utiliser l'adresse ip $docker_ip_host"
 }
}

 # Mise à jour de l'adresse IP dans le fichier ".env"
$Path="$env:USERPROFILE\e-comBox_portainer\"
Write-Host "le chemin est $Path"

@"
DOCKER_IP_LOCALHOST=127.0.0.1
DOCKER_IP_HOST=$docker_ip_host
"@ > $Path\.env

Set-Content $Path\.env -Encoding ASCII -Value (Get-Content $Path\.env)

Write-host ""
Write-host "Le système va maintenant configurer e-comBox avec l'adresse IP : $docker_ip_host et lancer l'application dans votre navigateur par défaut"
Write-host ""


Start-Process -wait lanceScriptPS_restartApplication.bat

