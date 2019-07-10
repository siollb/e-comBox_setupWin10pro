# Détection et configuration d'un éventuel proxy pour Docker
#Set-Location -Path $env:USERPROFILE\
#New-Item -Name ".docker" -ItemType directory -force

Set-Location -Path $env:USERPROFILE\.docker
#Set-Location -Path C:\Users\Daniel\.docker

$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

$settings = Get-ItemProperty -Path $reg
$adresseProxy = $settings.ProxyServer
$proxyEnable = $settings.ProxyEnable

Write-Host "l'adresse du proxy est $adresseProxy"
Write-Host "le proxy est enable à $proxyEnable"

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

#Set-Content config.json -Encoding UTF8 -Value (Get-Content config.json)
Set-Content config.json -Encoding ASCII -Value (Get-Content config.json)

}
else {
new-item "config.noproxy.json" –type file -force
 Write-Host "Rien à faire"
}

New-Item -Name "fichierTemoinConfigProyx.txt" -ItemType file -Value "Deuxième passage."  -force

#cd $env:USERPROFILE\.docker\

#[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "https://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, [EnvironmentVariableTarget]::Machine)
