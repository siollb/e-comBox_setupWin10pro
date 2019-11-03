﻿# Gestion des logs

If (-not (Test-Path "$env:USERPROFILE\.docker\logEcombox")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.docker\logEcombox" }

$pathlog="$env:USERPROFILE\.docker\logEcombox"


# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

# Création d'un fichier de log et écriture de la date

Write-host ""
Write-host "============================"
Write-host "Création d'un fichier de log"
Write-host "============================"
Write-host ""

 
New-Item -Path "$pathlog\initialisationEcombox.log" -ItemType file -force
write-host ""
Write-host "Le fichier de log initialisationEcombox.log a été créé à la racine du dossier $pathlog."
write-host ""


Write-Output "============================================================================" >> $pathlog\initialisationEcombox.log
Write-Output "$(Get-Date) - Initialisation de l'application" >> $pathlog\initialisationEcombox.log
Write-Output "============================================================================" >> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log
Write-host "$(Get-Date) - Initialisation de l'application"
write-host ""


# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

docker info *>> $pathlog\initialisationEcombox.log
Write-Output "" >> $pathlog\initialisationEcombox.log

$info_docker = (docker info)

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré. Le processus doit démarrer Docker avant de continuer..." >> $pathlog\initialisationEcombox.log 
     Write-Output "" >> $pathlog\initialisationEcombox.log
     Write-host "Le processus doit démarrer Docker avant de continuer..."
     write-host ""
     
     #Lancement de Docker en super admin
     
     if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
         Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Arrêt des processus résiduels." >> $pathlog\initialisationEcombox.log
         #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker s'il est démarré."

         $process = Get-Process "com.docker.backend" -ErrorAction SilentlyContinue
         if ($process.Count -gt 0)
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé" >> $pathlog\initialisationEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé"
            Stop-Process -Name "com.docker.backend" -Force  >> $pathlog\initialisationEcombox.log
         }
            else {
                Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas" >> $pathlog\initialisationEcombox.log
                #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas"
            }


         $service = get-service com.docker.service
         if ($service.status -eq "Stopped")
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté." >> $pathlog\initialisationEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté."
         }
            else
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé." >> $pathlog\initialisationEcombox.log
               #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé."
               net stop com.docker.service >> $pathlog\initialisationEcombox.log
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
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error?: $($info -ilike "*error*"). Result was: $info" >> $pathlog\initialisationEcombox.log
            if ($info -ilike "*error*")
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..." >> $pathlog\initialisationEcombox.log
               throw "Error running info command $info"
            }
            $timeoutHit = $false
            break
         }
         catch 
         {

             if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*")  -or ($_ -ilike "*Error running info command*"))
             {
                 Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre." >> $pathlog\initialisationEcombox.log
                 Write-host "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre."
             }
             else
            {
                write-host ""
                write-host "Unexpected Error: `n $_"
                Write-Output "Unexpected Error: `n $_" >> $pathlog\initialisationEcombox.log
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
     Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a démarré." >> $pathlog\initialisationEcombox.log
     Write-Output " $((Get-Date).ToString("HH:mm:ss")) - `t Le processus peut continuer." >> $pathlog\initialisationEcombox.log
     Write-Output "" >> $pathlog\initialisationEcombox.log 
   }
   else {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker est démarré. Le processus peut continuer..." >> $pathlog\initialisationEcombox.log 
            Write-Output "" >> $pathlog\initialisationEcombox.log
            Write-host "$((Get-Date).ToString("HH:mm:ss")) - `t Docker est démarré. Le processus peut continuer...."    
            }


Start-Process -wait -NoNewWindow "lanceScriptPS_installPortainer.bat"
Write-Output "Fin du processus d'install de Portainer." >> $pathlog\initialisationEcombox.log

Start-Process -wait -NoNewWindow "lanceScriptPS_startPortainer.bat"
if ((docker ps -a |  Select-String portainer-proxy)) {
    write-host ""
    write-host "Portainer est UP, on peut continuer."
    write-host ""
    Write-Output "" >> $pathlog\initialisationEcombox.log
    Write-Output "Portainer est UP, on peut continuer." >> $pathlog\initialisationEcombox.lo
    write-Output "" >> $pathlog\initialisationEcombox.log    
   }
    else {
       # Le redémarrage de Portainer peut entraîner un dysfonctionnement au niveau des processus 
       # On vérifie de nouveau que Docker fonctionne correctement sinon on le redémarre

       docker info *>> $pathlog\initialisationEcombox.log
       Write-Output "" >> $pathlog\initialisationEcombox.log

       $info_docker = (docker info)

       if ($info_docker -ilike "*error*") {      
           Write-Output "Docker n'est pas démarré. Le processus doit démarrer Docker avant de continuer..." >> $pathlog\initialisationEcombox.log 
           Write-Output "" >> $pathlog\initialisationEcombox.log
           Write-host "Le processus doit démarrer Docker avant de continuer..."
           write-host ""
     
           #Lancement de Docker en super admin
     
           if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
              Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Arrêt des processus résiduels." >> $pathlog\initialisationEcombox.log
              #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker s'il est démarré."

              $process = Get-Process "com.docker.backend" -ErrorAction SilentlyContinue
              if ($process.Count -gt 0)
              {
                 Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé" >> $pathlog\initialisationEcombox.log
                 #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé"
                 Stop-Process -Name "com.docker.backend" -Force  >> $pathlog\initialisationEcombox.log
              }
                 else {
                      Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas" >> $pathlog\initialisationEcombox.log
                      #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas"
                 }


                $service = get-service com.docker.service
                if ($service.status -eq "Stopped")
                {
                   Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté." >> $pathlog\initialisationEcombox.log
                   #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté."
                }
                   else
                   {
                      Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé." >> $pathlog\initialisationEcombox.log
                      #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé."
                     net stop com.docker.service >> $pathlog\initialisationEcombox.log
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
                      Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error?: $($info -ilike "*error*"). Result was: $info" >> $pathlog\initialisationEcombox.log
                      if ($info -ilike "*error*")
                      {
                           Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..." >> $pathlog\initialisationEcombox.log
                           throw "Error running info command $info"
                      }
                      $timeoutHit = $false
                      break
                      }
                      catch 
                     {

                        if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*")  -or ($_ -ilike "*Error running info command*"))
                        {
                            Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre." >> $pathlog\initialisationEcombox.log
                            Write-host "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre."
                        }
                        else
                           {
                              write-host ""
                              write-host "Unexpected Error: `n $_"
                              Write-Output "Unexpected Error: `n $_" >> $pathlog\initialisationEcombox.log
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
                     Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a démarré." >> $pathlog\initialisationEcombox.log
                     Write-Output " $((Get-Date).ToString("HH:mm:ss")) - `t Le processus peut continuer." >> $pathlog\initialisationEcombox.log
                     Write-Output "" >> $pathlog\initialisationEcombox.log

                     # On retente de démarrer Portainer                     
                     Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t On retente de redémarrer Portainer." >> $pathlog\initialisationEcombox.log                   
                     Write-Output "" >> $pathlog\initialisationEcombox.log
                     docker-compose up --build --force-recreate - t 20 -d *>> $pathlog\initialisationEcombox.log      
               }

    }

    # On vérifie de nouveau

    if ((docker ps -a |  Select-String portainer-proxy)) {
    write-host ""
    write-host "Portainer est UP, on peut continuer."
    write-host ""
    }
          else {
               write-host ""
               write-host "Toutes les tentatives pour démarrer Portainer ont échoué, consultez le fichier de log pour plus d'informations"
               Write-Host ""
               # Ce n'est pas la peine de continuer
               Read-Host "Appuyez sur la touche Entrée pour arrêter le processus"
               Write-host ""
               exit
               }


Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Fin du processus de démarrage de Portainer." >> $pathlog\initialisationEcombox.log
Write-Host "$((Get-Date).ToString("HH:mm:ss")) - `t Fin du processus de démarrage de Portainer."

Start-Process -wait -NoNewWindow "lanceScriptPS_startApplication.bat"

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Fin processus du démarrage et du lancement de l'application." >> $pathlog\initialisationEcombox.log
Write-Host "$((Get-Date).ToString("HH:mm:ss")) - `t Fin processus du démarrage et du lancement de l'application."