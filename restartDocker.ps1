# Gestion des logs
$pathlog="$env:USERPROFILE\.docker\logEcombox"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }



# Mettre les messages en français et enlever la référence à une "erreur".


# Run your code that needs to be elevated here
#Write-Host -NoNewLine "Press any key to continue..."
#$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Redémarrage de Docker" >> $pathlog\verifDocker.log
Write-host "$((Get-Date).ToString("HH:mm:ss")) - Redémarrage de Docker"

$process = Get-Process "com.docker.backend"
if ($process.Count -gt 0)
{
    #$process[0].Kill()
    Stop-Process -Name "com.docker.backend" -Force
}

net stop com.docker.service

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

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Redémarrage de Docker"
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
        Write-Verbose "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error?: $($info -ilike "*error*"). Result was: $info"
        if ($info -ilike "*error*")
        {
            Write-Verbose "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..."
            throw "Error running info command $info"
        }
        $timeoutHit = $false
        break
    }
    catch 
    {

        if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*")  -or ($_ -ilike "*Error running info command*"))
        {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre." >> $pathlog\verifDocker.log
            Write-host "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop n'a pas encore complètement démarré, il faut attendre."
        }
        else
        {
            write-host ""
            write-host "Unexpected Error: `n $_"
            Write-Output "Unexpected Error: `n $_" >> $pathlog\verifDocker.log
            return
        }
    }
    $ErrorActionPreference = 'Stop'
}
if ($timeoutHit -eq $true)
{
    throw "Délai d'attente en attente du démarrage de docker"
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker a redémarré." >> $pathlog\verifDocker.log
Write-host "$((Get-Date).ToString("HH:mm:ss")) - Docker a redémarré."