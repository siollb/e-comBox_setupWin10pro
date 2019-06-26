# Téléchargement de l'exécutable

(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe', 'docker-installer.exe')

# Installation en mode silentieux avec les options par défaut
start-process -wait docker-installer.exe " install --quiet"

# Suppression de l'exécutable
rm docker-installer.exe

# Lancement de docker
start-process "$env:ProgramFiles\docker\Docker\Docker for Windows.exe"

write-host "Docker et docker-compose sont installés."


# Détection et configuration d'un éventuel proxy
Set-Location -Path C:\Users\$env:USERNAME\
New-Item -Name ".docker" -ItemType directory -force

Set-Location -Path C:\Users\$env:USERNAME\.docker\
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
$noProxy = $settings.ProxyOverride
$noProxy = $noProxy.Replace(';',',')
new-item "config.json" –type file -force 
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
Set-Content config.json -Encoding UTF8 -Value (Get-Content config.json)
}
else {
new-item "config.json" –type file -force
}

# Start-Sleep -Seconds 5 ; Restart-Computer -Force