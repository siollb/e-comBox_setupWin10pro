
#Set-ExecutionPolicy -Scope CurrentUser Unrestricted

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"restartDockerBis.ps1`"" -Verb RunAs; exit }
#Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"restartDockerBis.ps1`"" -Verb RunAs

