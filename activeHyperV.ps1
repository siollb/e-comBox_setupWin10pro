#Requires -RunAsAdministrator
#$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#if ($testadmin -eq $false) {
#Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
#exit $LASTEXITCODE
#}

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# Restart-Computer -Force (géré par Innosetup)