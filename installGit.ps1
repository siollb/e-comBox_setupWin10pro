# Installation de la dernière version stable de Git

# Téléchargement et installation si Git n'est pas déjà installé

$gitExePath = "C:\Program Files\Git\bin\git.exe"
 
try {
    $ProgressPreference = 'SilentlyContinue'

    if (!(Test-Path $gitExePath)) {

       # Détermination de l'URL

       [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

       foreach ($asset in (Invoke-RestMethod https://api.github.com/repos/git-for-windows/git/releases/latest).assets) {
           if ($asset.name -match 'Git-\d*\.\d*\.\d*-64-bit\.exe') {
               $dlurl = $asset.browser_download_url
               $newver = $asset.name
           }
       }

       # Téléchargement de le dernière version satble
       Write-Host "`nTéléchargement de la dernière version stable de Git..." -ForegroundColor Yellow
       Remove-Item -Force $env:TEMP\git-stable.exe -ErrorAction SilentlyContinue
       Invoke-WebRequest -Uri $dlurl -OutFile $env:TEMP\git-stable.exe

       # Installation de Git
       Write-Host "`nInstallation de Git..." -ForegroundColor Yellow
       Start-Process -Wait $env:TEMP\git-stable.exe -ArgumentList /silent
       Write-Host "`nInstallation terminée!`n`n" -ForegroundColor Green
    }
    else {
        Write-Host "`ngit est déjà installé" -ForegroundColor Yellow
        }
       
}

finally {
        $ProgressPreference = 'Continue'
    }

$s = get-process ssh-agent -ErrorAction SilentlyContinue
if ($s) {$true}