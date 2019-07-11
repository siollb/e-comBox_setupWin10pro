$Path = Test-Path $env:USERPROFILE\e-comBox_portainer\

If ($Path -eq $False) {
    # Installation de Portainer sur Git
    Write-host "    --> This folder does not exist." -Fore Red
    Start-Process -wait lanceScriptPS_installPortainer.bat
    else Set-Location -Path
    Write-host "    --> This folder exist." -Fore blue
    # Arrêt de Portainer
    docker-compose down
}

Start-Process -wait lanceScriptPS_startPortainer.bat