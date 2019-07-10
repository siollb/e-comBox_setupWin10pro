#Requires -RunAsAdministrator
$processes = Get-Process "*docker for windows*"
if ($processes.Count -gt 0)
{
    $processes[0].Kill()
    $processes[0].WaitForExit()
}

net stop com.docker.service
net start com.docker.service


Start-Process "C:\Program Files\Docker\Docker\Docker for Windows.exe"
Start-Sleep -Seconds 90