# Vérification que Docker fonctionne correctement sinon ce n'est pas la peine de continuer

# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts\"

Write-host ""
Write-host "============================"
Write-host "Création d'un fichier de log"
Write-host "============================"
Write-host ""

New-Item -Path "$pathlog\verifDocker.log" -ItemType file -force

If ($? -eq 0) {
  $allProcesses = Get-Process
  foreach ($process in $allProcesses) { 
    $process.Modules | where {$_.FileName -eq "$pathlog\verifDocker.log"} | Stop-Process -Force -ErrorAction SilentlyContinue
  }
Remove-Item "$pathlog\verifDocker.log"
New-Item -Path "$pathlog\verifDocker.log" -ItemType file -force
}


write-host ""
Write-host "Le fichier de log verifDocker.log a été créé à la racine du dossier $env:USERPROFILE."

Write-Output "=======================================================================" >> $pathlog\verifDocker.log
Write-Output "$(Get-Date) -  Vérification de Docker" >> $pathlog\verifDocker.log
Write-Output "=======================================================================" >> $pathlog\verifDocker.log
Write-Output "" >> $pathlog\verifDocker.log

Write-host ""
Write-host "===================================="
Write-host "$(Get-Date) - Vérification de Docker"
Write-host "===================================="
Write-host ""

docker info *>> $pathlog\verifDocker.log
Write-Output "" >> $pathlog\verifDocker.log

$info_docker = (docker info)

if ($info_docker -ilike "*error*") {      
     Write-Output "Docker n'est pas démarré" >> $pathlog\verifDocker.log 
     Write-Output "" >> $pathlog\verifDocker.log
     Write-host "Docker ne semble pas démarré, merci d'attendre le redémarrage avant de continuer."
     write-host "Si la situation ne vous parait pas normal, le système peut tenter un redémarrage de Docker."
     #write-host "Si Docker ne redémarre pas, merci de fermer la fenêtre et de lancer le script 'Redémarrer Docker'. Vous pourrez relancer le script ensuite"
     $confirmStart=Read-Host "Saisissez oui pour confirmer le redémarrage de Docker par le système ou appuyer sur n'importe quel touche pour continuer"
     #$confirmStart=Read-Host "Saisissez oui pour fermer la fenêtre ou appuyer sur n'importe quel touche pour continuer"
     if ($confirmStart -eq "oui") {
        Start-Process -Wait -NoNewWindow lanceScriptPS_restartDocker.bat
        #Start-Process "powershell.exe" -Wait -NoNewWindow restartDocker.ps1
        #Start-Process -Wait -NoNewWindow lanceScriptPS_restartDocker.bat *>> $pathlog\verifDocker.log
        Write-Output "Le processus est en train de démarrer Docker." >> $pathlog\verifDocker.log
        Write-Output "" >> $pathlog\verifDocker.log
        Write-host "Le processus est en train de démarrer Docker..."
        Write-host ""               
     }
        else {
            Write-Output "L'utilisateur a continué le processus" >> $pathlog\verifDocker.log 
            Write-Output "" >> $pathlog\verifDocker.log
        }
}
     else {
         Write-Output "Docker est démarré, le processus continue." >> $pathlog\verifDocker.log
         Write-Output "" >> $pathlog\verifDocker.log
         Write-host "Docker est démarré, le processus continue..."
         Write-host ""
    }       

    #Write-Output "Fin du processus de vérification de Docker." >> $pathlog\verifDocker.log
    #Write-Output "" >> $pathlog\verifDocker.log
    #Write-host "Fin du processus de vérification de Docker."
    #write-host ""