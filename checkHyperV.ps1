#Requires -RunAsAdministrator

#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
#write-host $hyperv.State

# Check if Hyper-V is enabled
if($hyperv.State -eq "Enabled") {
    write-host "Hyper V est activé."
    #Set-Location -Path C:\Users\$env:USERNAME\
    #New-Item -Name "hyperVisActive.txt" -ItemType file -force
    exit 0
} else {
    write-host "Hyper V n'est pas activé."
    #Set-Location -Path C:\Users\$env:USERNAME\
    #New-Item -Name "hyperVisNotActive.txt" -ItemType file -force
    exit 1
}