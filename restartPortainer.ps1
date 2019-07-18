$Path="$env:USERPROFILE\e-comBox_portainer\"
$TestPath=Test-Path $Path

If ($TestPath -eq $False) {
    # Installation de Portainer sur Git
    Write-host "    --> Portainer n'est pas installé." -Fore Red
    Start-Process -wait lanceScriptPS_installPortainer.bat
    }
    else {
      # Arrêt de Portainer
      Write-host "    --> Portainer est démarré." -Fore blue
      Start-Process -wait lanceScriptPS_stopPortainer.bat       
      }

Start-Process -wait lanceScriptPS_startPortainer.bat