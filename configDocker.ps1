#Requires -RunAsAdministrator
# Détection et configuration d'un éventuel proxy pour Docker
Set-Location -Path C:\Users\$env:USERNAME\
New-Item -Name ".docker" -ItemType directory -force

Set-Location -Path C:\Users\$env:USERNAME\.docker\
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
new-item "config.json" –type file -force
}
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "https://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
# Lancement de docker
$processes = Get-Process "*docker for windows*"
if ($processes.Count -gt 0)
{
    $processes[0].Kill()
    $processes[0].WaitForExit()
}

net stop com.docker.service
net start com.docker.service


Start-Process "C:\Program Files\Docker\Docker\Docker for Windows.exe"
#start-process "$env:ProgramFiles\docker\Docker\Docker for Windows.exe"


#net stop com.docker.service
#net start com.docker.service

#Start-Process "C:\Program Files\docker\docker\Docker for Windows.exe"

#Start-Process "$env:ProgramFiles\docker\Docker\Docker for Windows.exe"

# write-host "Docker et docker-compose sont installés."
Start-Sleep -Seconds 120