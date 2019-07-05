# Détection et configuration d'un éventuel proxy pour Docker
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

# Lancement de docker
start-process "$env:ProgramFiles\docker\Docker\Docker for Windows.exe"