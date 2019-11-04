# Déclaration des chemins
$pathlog="$env:USERPROFILE\.docker\logEcombox"
$pathscripts="C:\Program Files\e-comBox\scripts\"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -WindowStyle Normal -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Output "" >> $pathlog\verifDocker.log
Write-Output "=============================================================" >> $pathlog\verifDocker.log
Write-Output "$(Get-Date) -  Le script stopDocker a été lancé" >> $pathlog\verifDocker.log
Write-Output "=============================================================" >> $pathlog\verifDocker.log
Write-Output "" >> $pathlog\verifDocker.log


Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker." >> $pathlog\verifDocker.log
Write-host "$((Get-Date).ToString("HH:mm:ss")) - Arrêt de Docker."

$process = Get-Process "com.docker.backend" -ErrorAction SilentlyContinue
if ($process.Count -gt 0)
{
    Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé" >> $pathlog\verifDocker.log
    Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend existe et va être stoppé"
    Stop-Process -Name "com.docker.backend" -Force  >> $pathlog\verifDocker.log
}
    else {
      Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas" >> $pathlog\verifDocker.log
      Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le processus com.docker.backend n'existe pas"
     }


$service = get-service com.docker.service
if ($service.status -eq "Stopped")
{

    Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker est déja arrêté." >> $pathlog\verifDocker.log
    Write-host "$((Get-Date).ToString("HH:mm:ss")) - Docker est déjà arrêté."
}
    else
    {
      Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé." >> $pathlog\verifDocker.log
      Write-host "$((Get-Date).ToString("HH:mm:ss")) - Le service Docker va être stoppé."
      net stop com.docker.service >> $pathlog\verifDocker.log
    }


foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Running"}))
{
    $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
    $svc.WaitForStatus('Stopped','00:00:20')
}

Get-Process | Where-Object {$_.Name -ilike "*docker*"} | Stop-Process -ErrorAction Continue -Confirm:$false -Force


Write-Output "$((Get-Date).ToString("HH:mm:ss")) - `tDocker est arrêté." >> $pathlog\verifDocker.log
Write-host "$((Get-Date).ToString("HH:mm:ss")) - `tDocker est arrêté."