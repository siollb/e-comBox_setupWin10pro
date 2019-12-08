# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts\"

# Création d'un fichier de log et écriture de la date

Write-host ""
Write-host "============================"
Write-host "Création d'un fichier de log"
Write-host "============================"
Write-host ""

Set-Location -Path $env:USERPROFILE
New-Item -Path "$pathlog\supprimeSitesEcombox.log" -ItemType file -force

If ($? -eq 0) {
  $allProcesses = Get-Process
  foreach ($process in $allProcesses) { 
    $process.Modules | where {$_.FileName -eq "$pathlog\supprimeSitesEcombox.log"} | Stop-Process -Force -ErrorAction SilentlyContinue
  }
Remove-Item "$pathlog\supprimeSitesEcombox.log
New-Item -Path "$pathlog\supprimeSitesEcombox.log -ItemType file -force
}


write-host ""
Write-host "Le fichier de log supprimeSitesEcombox.log a été créé à la racine du dossier $pathlog."
Write-host "$(Get-Date) - Configuration de l'environnement"

Write-Output "==========================================================================================" >> $pathlog\supprimeSitesEcombox.log
Write-Output "$(Get-Date) -  Suppression de tous les sites" >> $pathlog\supprimeSitesEcombox.log
Write-Output "==========================================================================================" >> $pathlog\supprimeSitesEcombox.log
Write-Output "" >> $pathlog\supprimeSitesEcombox.log

# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

Write-host ""
Write-host "================================"
Write-host "Vérification de l'état de Docker"
Write-host "================================"
Write-host ""

docker info *>> $pathlog\supprimeSitesEcombox.log
Write-Output "" >> $pathlog\supprimeSitesEcombox.log

$info_docker = (docker info)

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré. Le processus doit démarrer Docker avant de continuer..." >> $pathlog\supprimeSitesEcombox.log 
     Write-Output "" >> $pathlog\supprimeSitesEcombox.log
     Write-host "Le processus doit démarrer Docker avant de continuer..."
     write-host ""
     
     #Lancement de Docker en super admin
     
     if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
         Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Arrêt des processus résiduels." >> $pathlog\supprimeSitesEcombox.log
         #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker s'il est démarré."

         $process = Get-Process "com.docker.backend" -ErrorAction SilentlyContinue
         if ($process.Count -gt 0)
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé" >> $pathlog\supprimeSitesEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé"
            Stop-Process -Name "com.docker.backend" -Force  >> $pathlog\supprimeSitesEcombox.log
         }
            else {
                Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas" >> $pathlog\supprimeSitesEcombox.log
                #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas"
            }


         $service = get-service com.docker.service
         if ($service.status -eq "Stopped")
         {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté." >> $pathlog\supprimeSitesEcombox.log
            #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Rien à faire car Docker est arrêté."
         }
            else
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé." >> $pathlog\supprimeSitesEcombox.log
               #Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé."
               net stop com.docker.service >> $pathlog\supprimeSitesEcombox.log
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
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error?: $($info -ilike "*error*"). Result was: $info" >> $pathlog\supprimeSitesEcombox.log
            if ($info -ilike "*error*")
            {
               Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..." >> $pathlog\supprimeSitesEcombox.log
               throw "Error running info command $info"
            }
            $timeoutHit = $false
            break
         }
         catch 
         {

             if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*")  -or ($_ -ilike "*Error running info command*"))
             {
                 Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre." >> $pathlog\supprimeSitesEcombox.log
                 Write-host "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre."
             }
             else
            {
                write-host ""
                write-host "Unexpected Error: `n $_"
                Write-Output "Unexpected Error: `n $_" >> $pathlog\supprimeSitesEcombox.log
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
     Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `t Docker a démarré." >> $pathlog\supprimeSitesEcombox.log
     Write-Output " $((Get-Date).ToString("HH:mm:ss")) - `t Le processus peut continuer." >> $pathlog\supprimeSitesEcombox.log
     Write-Output "" >> $pathlog\supprimeSitesEcombox.log 
   }
   else {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker est démarré. Le processus peut continuer..." >> $pathlog\supprimeSitesEcombox.log 
            Write-Output "" >> $pathlog\supprimeSitesEcombox.log
            Write-Host "$((Get-Date).ToString("HH:mm:ss")) - Docker est démarré. Le processus peut continuer..." 
            Write-Host ""          
            }


# Suppression des sites, des volumes et des images associées
 Write-host ""
 Write-Host "ATTENTION, il va être procédé à la suppression de vos sites, les données ne pourront pas être récupérées."
 Write-Host ""

 $confirmReseau=Read-Host "Veuillez confirmer que c'est ce que vous voulez (répondre par oui pour confirmer ou par n'importe quel autre caractère pour arrêter la procédure)"
 Write-host ""
   if ($confirmReseau -eq "oui") 
     {
       if (docker ps -q) {       
           Write-Output "Arrêt des conteneurs :" >> $pathlog\supprimeSitesEcombox.log
           docker stop $(docker ps -q) *>> $pathlog\supprimeSitesEcombox.log          
           Write-Output "" >> $pathlog\supprimeSitesEcombox.log
        }
      Write-Output "$(Get-Date) - Suppression complète de tous les objets en cours :" >> $pathlog\supprimeSitesEcombox.log
      Write-host ""
      Write-Host "Suppression des sites en cours, le processus peut être assez long, veuillez patienter..."
      Write-Host ""
      docker system prune -a --volumes -f *>> $pathlog\supprimeSitesEcombox.log
      Write-Output "" >> $pathlog\supprimeSitesEcombox.log
      Write-Output "$(Get-Date) - Suppression de tous les objets réalisée :" >> $pathlog\supprimeSitesEcombox.log
      Write-host ""
      Write-Host "La suppression des sites est terminée, le système va procéder à la réinitialisation de l'application e-comBox."      
      
      # Réinitialisation de l'appli
      Write-Output "" >> $pathlog\supprimeSitesEcombox.log
      Write-Output "$(Get-Date) - Réinitialisation de l'application en cours." >> $pathlog\supprimeSitesEcombox.log
      Write-Output "" >> $pathlog\supprimeSitesEcombox.log
      Write-host ""
      Write-Host "Réinitialisation de l'application en cours..."
      Write-Host ""
      Start-Process "$pathscripts\lanceScriptPS_initialisationApplication.bat" -wait -NoNewWindow
      Write-Output "" >> $pathlog\supprimeSitesEcombox.log
      Write-Output "$(Get-Date) - Réinitialisation de l'application réalisée." >> $pathlog\supprimeSitesEcombox.log
      Write-Output "" >> $pathlog\supprimeSitesEcombox.log      
     }              
  


# Read-Host "Appuyez sur la touche Entrée pour continuer."



