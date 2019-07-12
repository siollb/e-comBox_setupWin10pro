#Requires -RunAsAdministrator

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments
  break
}


$installPath = "C:\Program Files\Git\bin\git.exe"

## Some Git stuff might be running.. kill them.
Stop-Process -processname Bash -erroraction 'silentlycontinue'
Stop-Process -processname Putty* -erroraction 'silentlycontinue'

Write-Host "Removing Git from " $installPath

### Find if there's an uninstaller in the folder.
$uninstallers = Get-ChildItem $installPath"\unins*.exe"

### In reality, there should only be just one that matches.
foreach ($uninstaller in $uninstallers)
{
### Invoke the uninstaller.
#$uninstallerCommandLineOptions = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS"
$uninstallerCommandLineOptions = "/FORCECLOSEAPPLICATIONS"
Start-Process -Wait -FilePath $uninstaller -ArgumentList $uninstallerCommandLineOptions
}

### Remove the folder if it didn't clean up properly.
       
Remove-Item -Recurse -Force $installPath
        