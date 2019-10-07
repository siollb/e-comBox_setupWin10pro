# Détection et configuration d'un éventuel proxy pour Docker

 Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
 Write-Output "Détection et configuration d'un éventuel proxy pour Docker" >> $env:USERPROFILE\initialisationEcombox.log
 Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

Set-Location -Path $env:USERPROFILE\.docker

$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

$settings = Get-ItemProperty -Path $reg
$adresseProxy = $settings.ProxyServer
$proxyEnable = $settings.ProxyEnable

Write-Host "l'adresse du proxy est $adresseProxy"
Write-Output "le proxy est enable à $proxyEnable et est $adresseProxy" >> $env:USERPROFILE\initialisationEcombox.log

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
    Write-Output "le proxy est bien configuré à $adresseProxy" >> $env:USERPROFILE\initialisationEcombox.log

$noProxy = $settings.ProxyOverride

if ($noProxy)
       { 
             $noProxy = $noProxy.Replace(';',',')
       }
       else
       {     
             $noProxy = "localhost"
       }

    Write-Output "le no proxy est bien configuré à $noProxy"  >> $env:USERPROFILE\initialisationEcombox.log


new-item "config.json" –type file -force *>> $env:USERPROFILE\initialisationEcombox.log
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

Set-Content config.json -Encoding ASCII -Value (Get-Content config.json) *>> $env:USERPROFILE\initialisationEcombox.log

Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "le fichier config.json a été créé et complété"  >> $env:USERPROFILE\initialisationEcombox.log
Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log

}
     else {
         remove-item "config.json" *>> $env:USERPROFILE\initialisationEcombox.log
         Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log
         Write-Output "le fichier config.json a été supprimé"  >> $env:USERPROFILE\initialisationEcombox.log
         Write-Output ""  >> $env:USERPROFILE\initialisationEcombox.log
      }

#cd $env:USERPROFILE\.docker\

#[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "https://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, [EnvironmentVariableTarget]::Machine)
