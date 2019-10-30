# Gestion des logs
$pathlog="$env:USERPROFILE\.docker\logEcombox"

# Détection et configuration d'un éventuel proxy pour Docker

 Write-Output "" >> $pathlog\initialisationEcombox.log
 Write-Output "Détection et configuration d'un éventuel proxy pour Docker" >> $pathlog\initialisationEcombox.log
 Write-Output "" >> $pathlog\initialisationEcombox.log

Set-Location -Path $env:USERPROFILE\.docker

$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

$settings = Get-ItemProperty -Path $reg
$adresseProxy = $settings.ProxyServer
$proxyEnable = $settings.ProxyEnable

Write-Host "l'adresse du proxy est $adresseProxy"
Write-Output "le proxy est enable à $proxyEnable et est $adresseProxy" >> $pathlog\initialisationEcombox.log

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
    Write-Output "le proxy est bien configuré à $adresseProxy" >> $pathlog\initialisationEcombox.log

$noProxy = $settings.ProxyOverride

if ($noProxy)
       { 
             $noProxy = $noProxy.Replace(';',',')
       }
       else
       {     
             $noProxy = "localhost"
       }

    Write-Output "le no proxy est bien configuré à $noProxy"  >> $pathlog\initialisationEcombox.log


new-item "config.json" –type file -force *>> $pathlog\initialisationEcombox.log
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

Set-Content config.json -Encoding ASCII -Value (Get-Content config.json) *>> $pathlog\initialisationEcombox.log

Write-Output ""  >> $pathlog\initialisationEcombox.log
Write-Output "le fichier config.json a été créé et complété"  >> $pathlog\initialisationEcombox.log
Write-Output ""  >> $pathlog\initialisationEcombox.log

}
     else {
         remove-item "config.json" *>> $pathlog\initialisationEcombox.log
         Write-Output ""  >> $pathlog\initialisationEcombox.log
         Write-Output "le fichier config.json a été supprimé"  >> $pathlog\initialisationEcombox.log
         Write-Output ""  >> $pathlog\initialisationEcombox.log
      }

#cd $env:USERPROFILE\.docker\

#[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "https://172.16.160.100:3130", [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, [EnvironmentVariableTarget]::Machine)
#[Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, [EnvironmentVariableTarget]::Machine)
