$Path="$env:USERPROFILE\e-comBox_portainer\"
$TestPath=Test-Path $Path

If ($TestPath -eq $False) {
    # Installation de Portainer sur Git
    Write-host ""
    Write-host "    --> Portainer n'est pas installé, il faut l'installer."
    Write-host ""
    Start-Process -wait lanceScriptPS_installPortainer.bat
    }
    else {
      # Arrêt de Portainer
      Write-host ""
      Write-host "    --> Portainer est démarré, il faut le stopper."
      Write-host ""
      Start-Process -wait lanceScriptPS_stopPortainer.bat       
      }


Start-Process -wait lanceScriptPS_startPortainer.bat