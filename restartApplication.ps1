# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts\"

# Gestion des logs
New-Item -Path "$pathlog\reinitialiseEnvEcombox.log" -ItemType file -force

If ($? -eq 0) {
  $allProcesses = Get-Process
  foreach ($process in $allProcesses) { 
    $process.Modules | where {$_.FileName -eq "$pathlog\reinitialiseEnvEcombox.log"} | Stop-Process -Force -ErrorAction SilentlyContinue
  }
Remove-Item "$pathlog\reinitialiseEnvEcombox.log"
New-Item -Path "$pathlog\reinitialiseEnvEcombox.log" -ItemType file -force
}

Write-host ""
Write-host "================================================================================="
Write-host "$(Get-Date) - Réinitialisation de l'environnement"
Write-host "================================================================================="
Write-host ""

write-host ""
Write-host "Le fichier de log reinitialiseEnvEcombox.log a été créé à la racine du dossier $pathlog."
write-host ""

Write-Output "=======================================================================" > $pathlog\reinitialiseEnvEcombox.log
Write-Output "$(Get-Date) - Réinitialisation de l'environnement" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "=======================================================================" >> $pathlog\reinitialiseEnvEcombox.log


# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

Write-host ""
Write-host "================================"
Write-host "Vérification de l'état de Docker"
Write-host "================================"
Write-host ""

docker info *>> $pathlog\reinitialiseEnvEcombox.log
Write-Output "" >> $pathlog\reinitialiseEnvEcombox.log

$info_docker = (docker info)

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré. Le processus doit démarrer Docker avant de continuer..." >> $pathlog\reinitialiseEnvEcombox.log 
     Write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
     Write-host "Le processus doit démarrer Docker avant de continuer..."
     write-host ""
     
     #Lancement de Docker en super admin
     
     if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
         Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Arrêt des processus résiduels." >> $pathlog\reinitialiseEnvEcombox.log
         #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker s'il est démarré."

         $process = Get-Process "com.docker.backend" -ErrorAction SilentlyContinue
         if ($process.Count -gt 0)
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé" >> $pathlog\reinitialiseEnvEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé"
            Stop-Process -Name "com.docker.backend" -Force  >> $pathlog\reinitialiseEnvEcombox.log
         }
            else {
                Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas" >> $pathlog\reinitialiseEnvEcombox.log
                #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas"
            }


         $service = get-service com.docker.service
         if ($service.status -eq "Stopped")
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté." >> $pathlog\reinitialiseEnvEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté."
         }
            else
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé." >> $pathlog\reinitialiseEnvEcombox.log
               #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé."
               net stop com.docker.service >> $pathlog\reinitialiseEnvEcombox.log
            }


           foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Running"}))
           {
              $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
              $svc.WaitForStatus('Stopped','00:00:20')
           }

           Get-Process | Where-Object {$_.Name -ilike "*docker*"} | Stop-Process -ErrorAction Continue -Confirm:$false -Force

          foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Stopped"} ))
          {
             $svc | Start-Service 
             $svc.WaitForStatus('Running','00:00:20')
          }

          Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Démarrage de Docker"
          & "C:\Program Files\Docker\Docker\Docker Desktop.exe"
          $startTimeout = [DateTime]::Now.AddSeconds(90)
          $timeoutHit = $true
          while ((Get-Date) -le $startTimeout)
          {

          Start-Sleep -Seconds 10
          $ErrorActionPreference = 'Continue'

          try
         {
            $info = (docker info)
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error?: $($info -ilike "*error*"). Result was: $info" >> $pathlog\reinitialiseEnvEcombox.log
            if ($info -ilike "*error*")
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..." >> $pathlog\reinitialiseEnvEcombox.log
               throw "Error running info command $info"
            }
            $timeoutHit = $false
            break
         }
         catch 
         {

             if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*")  -or ($_ -ilike "*Error running info command*"))
             {
                 Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre." >> $pathlog\reinitialiseEnvEcombox.log
                 Write-host "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre."
             }
             else
            {
                write-host ""
                write-host "Unexpected Error: `n $_"
                Write-Output "Unexpected Error: `n $_" >> $pathlog\reinitialiseEnvEcombox.log
                return
            }
         }
         $ErrorActionPreference = 'Stop'
     }
     if ($timeoutHit -eq $true)
     {
         throw "Délai d'attente en attente du démarrage de docker"
     }
        
     Write-host "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a démarré."
     Write-host "$((Get-Date).ToString("HH:mm:ss")) - `t  Le processus peut continuer."
     Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a démarré." >> $pathlog\reinitialiseEnvEcombox.log
     Write-Output " $((Get-Date).ToString("HH:mm:ss")) - `t Le processus peut continuer." >> $pathlog\reinitialiseEnvEcombox.log
     Write-Output "" >> $pathlog\reinitialiseEnvEcombox.log 
   }
   else {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker est démarré. Le processus peut continuer..." >> $pathlog\reinitialiseEnvEcombox.log 
            Write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
            Write-Host "$((Get-Date).ToString("HH:mm:ss")) - Docker est démarré. Le processus peut continuer..." 
            Write-Host ""          
            }


# Ajout d'une pause pour la vérification de la configuration du Proxy sur Docker 
 Write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
 Write-Output "Ajout d'une pause pour la vérification de la configuration du Proxy sur Docker" >> $pathlog\reinitialiseEnvEcombox.log
 Write-Output "" >> $pathlog\reinitialiseEnvEcombox.log

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
    Write-Output "le proxy est activé et est configuré à $adresseProxy" >> $pathlog\reinitialiseEnvEcombox.log

$noProxy = $settings.ProxyOverride

if ($noProxy)
       { 
             $noProxy = $noProxy.Replace(';',',')
       }
       else
       {     
             $noProxy = "localhost"
       }

    Write-Output "le no proxy est configuré à $noProxy"  >> $pathlog\reinitialiseEnvEcombox.log


 # Ajout de la pause
 Write-Host "Le système a détecté que vous utilisez un proxy pour vous connecter à Internet, veillez à vérifier que ce dernier est correctement configuré au niveau de Docker avec les paramètres suivants :"
 Write-Host ""
 write-Host "Adresse IP du proxy (avec le port utilisé) : $adresseProxy"
 Write-host "By Pass : $noProxy"
 Write-Host ""
 write-Host "Si vous venez de procéder à la configuration, il faut attendre que Docker ait redémarré avant de continuer."
 Write-Host ""
 Read-Host "Appuyez sur la touche Entrée pour continuer."
 Write-host ""
}
     else {
         Write-Output ""  >> $pathlog\reinitialiseEnvEcombox.log
         Write-Output "Le proxy est désactivé et le fichier config.json a été supprimé"  >> $pathlog\reinitialiseEnvEcombox.log
         Write-Output ""  >> $pathlog\reinitialiseEnvEcombox.log
         Write-Host "Le système a détecté que vous n'utilisez pas de proxy pour vous connecter à Internet, vérifiez que cette fonctionnalité soit bien désactivée sur Docker." 
         write-Host "Si vous venez de procéder à la désactivation, il faut attendre que Docker ait redémarré avant de continuer."
         Write-Host ""
         Read-Host "Appuyez sur la touche Entrée pour continuer."
         Write-host ""         
      }


# Reinitialisation de Portainer
write-host ""
Write-host "Réinitialisation de Portainer"
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Réinitialisation de Portainer" >> $pathlog\reinitialiseEnvEcombox.log
Set-Location $pathscripts
Start-Process "$pathscripts\lanceScriptPS_restartPortainer.bat" -wait -NoNewWindow  

# Réinitialisation de l'application
write-host ""
Write-host "Réinitialisation de l'application"
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Réinitialisation de l'application" >> $pathlog\reinitialiseEnvEcombox.log
docker rm -f e-combox *>> $pathlog\reinitialiseEnvEcombox.log
docker volume rm $(docker volume ls -qf dangling=true) *>> $pathlog\reinitialiseEnvEcombox.log
docker pull aporaf/e-combox:1.0 *>> $pathlog\reinitialiseEnvEcombox.log
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0 *>> $pathlog\reinitialiseEnvEcombox.log


# Nettoyage des anciennes images si elles ne sont associées à aucun site
Write-host ""      
Write-host "Suppression des images si elles ne sont associées à aucun site"
Write-host ""
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "Suppression des images si elles ne sont associées à aucun site" >> $pathlog\reinitialiseEnvEcombox.log
docker rmi $(docker images -q) *>> $pathlog\reinitialiseEnvEcombox.log

# Suppression des éventuelles images dangling
if (docker images -q -f dangling=true) {
   docker rmi $(docker images -q -f dangling=true) *>> $pathlog\reinitialiseEnvEcombox.log
   }

# Lancement de l'application
Start-Process "C:\Program Files\e-comBox\e-comBox.url"
write-Output "" >> $pathlog\reinitialiseEnvEcombox.log
Write-Output "L'application a été lancée dans le navigateur le $(Get-Date)." >> $pathlog\reinitialiseEnvEcombox.log

