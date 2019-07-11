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
    Write-Host "l'adresse du proxy est $adresseProxy"
    git config --global http.proxy $adresseProxy
    }
    else {
      git config --global --unset http.proxy
      }


# Récupération de portainer 

git clone https://github.com/siollb/e-comBox_portainer.git 2>$null

