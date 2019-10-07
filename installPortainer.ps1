# Les logs sont dans $env:USERPROFILE\initialisationEcombox.log

# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Initialisation de l'application" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
Write-host "$((Get-Date).ToString("HH:mm:ss")) - Initialisation de l'application"
write-host ""

Write-Output "Vérification du bon fonctionnement de Docker" >> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

docker info *>> $env:USERPROFILE\initialisationEcombox.log
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

$info_docker = (docker info)
Write-Host $info_docker

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré" >> $env:USERPROFILE\initialisationEcombox.log 
     Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
     Write-host "Docker ne semble pas démarré, merci d'attendre avant de continuer."
     #write-host "Si la situation ne vous parait pas normal, le système peut tenter un redémarrage de Docker."
     $confirmStart=Read-Host "Saisissez oui pour confirmer le redémarrage de Docker par le système ou sur n'importe quel touche pour continuer"
     #if ($confirmStart -eq "oui") {
        #Start-Process -wait C:\Users\daniel\e-comBox_setupWin10pro\lanceScriptPS_restartDocker.bat *>> $env:USERPROFILE\initialisationEcombox.log

     #}
        #else {
            #Write-Output "L'utilisateur a continué le processus d'initialisation" >> $env:USERPROFILE\initialisationEcombox.log 
            #Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
        #}
}
     else {
         Write-Output "Docker est démarré" >> $env:USERPROFILE\initialisationEcombox.log
         Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
         Write-host "Docker est démarré, on peut continuer..."
         Write-host ""
    }       
       
       

# Détection et configuration d'un éventuel proxy pour Git

Write-Output "Détection du proxy système" >> $env:USERPROFILE\initialisationEcombox.log 
Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log

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
    Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
    Write-Output "le proxy est $adresseProxy et le noProxy est $noProxy" >> $env:USERPROFILE\initialisationEcombox.log
    Write-Output "" >> $env:USERPROFILE\initialisationEcombox.log
    
    # Configuration de Git
    git config --global http.proxy $adresseProxy *>> $env:USERPROFILE\initialisationEcombox.log
    }
    else {
      write-Output ""
      Write-Output "Pas de proxy système." >> $env:USERPROFILE\initialisationEcombox.log
      Write-Output ""      
      # Configuration de Git
      git config --global --unset http.proxy *>> $env:USERPROFILE\initialisationEcombox.log
      }


# Récupération de portainer 

write-Output ""
Write-Output "Téléchargement de Portainer" >> $env:USERPROFILE\initialisationEcombox.log
git clone https://github.com/siollb/e-comBox_portainer.git *>> $env:USERPROFILE\initialisationEcombox.log

