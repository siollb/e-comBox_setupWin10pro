# lancement de l'URL avec un éventuel démarrage de Docker

# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts\"

Write-Output "" >> $pathlog\initialiserEcombox.log
Write-Output "=======================================================================" >> $pathlog\initialiserEcombox.log
Write-Output "$(Get-Date) -  Lancement de l'application" >> $pathlog\initialiserEcombox.log
Write-Output "=======================================================================" >> $pathlog\initialiserEcombox.log
Write-Output "" >> $pathlog\initialiserEcombox.log

New-Item -Path "$pathlog\demarrerEcombox.log" -ItemType file -force >> $pathlog\initialiserEcombox.log
If ($? -eq 0) {
  $allProcesses = Get-Process
  foreach ($process in $allProcesses) { 
    $process.Modules | where {$_.FileName -eq "$pathlog\demarrerEcombox.log"} | Stop-Process -Force -ErrorAction SilentlyContinue
  }
Remove-Item "$pathlog\demarrerEcombox.log"
New-Item -Path "$pathlog\demarrerEcombox.log" -ItemType file -force
}


Write-Output "=======================================================================" >> $pathlog\demarrerEcombox.log
Write-Output "$(Get-Date) -  Lancement de l'application" >> $pathlog\demarrerEcombox.log
Write-Output "=======================================================================" >> $pathlog\demarrerEcombox.log
Write-Output "" >> $pathlog\demarrerEcombox.log


#Vérification de Docker
docker info *>> $pathlog\demarrerEcombox.log
Write-Output "" >> $pathlog\demarrerEcombox.log

$info_docker = (docker info)

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré. Le processus doit démarrer Docker avant de lancer l'application..." >> $pathlog\demarrerEcombox.log 
     Write-Output "" >> $pathlog\demarrerEcombox.log
     Write-host "Le processus doit démarrer Docker avant de lancer l'application..."
     write-host ""
     
     #Lancement de Docker en super admin
     
     if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
         Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Arrêt des processus résiduels." >> $pathlog\demarrerEcombox.log
         #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker s'il est démarré."

         $process = Get-Process "com.docker.backend" -ErrorAction SilentlyContinue
         if ($process.Count -gt 0)
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé" >> $pathlog\demarrerEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé"
            Stop-Process -Name "com.docker.backend" -Force  >> $pathlog\demarrerEcombox.log
         }
            else {
                Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas" >> $pathlog\demarrerEcombox.log
                #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas"
            }


         $service = get-service com.docker.service
         if ($service.status -eq "Stopped")
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté." >> $pathlog\demarrerEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté."
         }
            else
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé." >> $pathlog\demarrerEcombox.log
               #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé."
               net stop com.docker.service >> $pathlog\demarrerEcombox.log
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
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error?: $($info -ilike "*error*"). Result was: $info" >> $pathlog\demarrerEcombox.log
            if ($info -ilike "*error*")
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..." >> $pathlog\demarrerEcombox.log
               throw "Error running info command $info"
            }
            $timeoutHit = $false
            break
         }
         catch 
         {

             if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*")  -or ($_ -ilike "*Error running info command*"))
             {
                 Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre." >> $pathlog\demarrerEcombox.log
                 Write-host "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre."
             }
             else
            {
                write-host ""
                write-host "Unexpected Error: `n $_"
                Write-Output "Unexpected Error: `n $_" >> $pathlog\demarrerEcombox.log
                return
            }
         }
         $ErrorActionPreference = 'Stop'
     }
     if ($timeoutHit -eq $true)
     {
         throw "Délai d'attente en attente du démarrage de docker"
     }

     Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a redémarré." >> $pathlog\demarrerEcombox.log
     Write-host "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a redémarré."
     Write-host "$((Get-Date).ToString("HH:mm:ss")) - `t  L'application e-comBox va être lancée dans le navigateur."
     Write-Output " `t L'application e-comBox va être lancée dans le navigateur." >> $pathlog\demarrerEcombox.log
     Write-Output "" >> $pathlog\demarrerEcombox.log 

     #Lancement de l'URL
     Start-Process "C:\Program Files\e-comBox\e-comBox.url"    
                    
     }
        else {
            Write-Output "Docker est démarré. Le processus peut lancer directement l'URL..." >> $pathlog\demarrerEcombox.log 
            Write-Output "" >> $pathlog\demarrerEcombox.log
            # Lancement de l'URL
            Start-Process "C:\Program Files\e-comBox\e-comBox.url"
            Write-Output "" >> $pathlog\demarrerEcombox.log
            Write-Output "L'application e-comBox a été lancée dans le navigateur." >> $pathlog\demarrerEcombox.log
            Write-Output "" >> $pathlog\demarrerEcombox.log
            }

 