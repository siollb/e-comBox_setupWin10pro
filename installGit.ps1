# Installation de la derni�re version stable de Git

# T�l�chargement et installation si Git n'est pas d�j� install�

$gitExePath = "C:\Program Files\Git\bin\git.exe"
 
try {
    $ProgressPreference = 'SilentlyContinue'

    if (!(Test-Path $gitExePath)) {

       # D�termination de l'URL

       [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

       foreach ($asset in (Invoke-RestMethod https://api.github.com/repos/git-for-windows/git/releases/latest).assets) {
           if ($asset.name -match 'Git-\d*\.\d*\.\d*-64-bit\.exe') {
               $dlurl = $asset.browser_download_url
               $newver = $asset.name
           }
       }

       # T�l�chargement de le derni�re version satble
       Write-Host "`nT�l�chargement de la derni�re version stable..." -ForegroundColor Yellow
       Remove-Item -Force $env:TEMP\git-stable.exe -ErrorAction SilentlyContinue
       Invoke-WebRequest -Uri $dlurl -OutFile $env:TEMP\git-stable.exe

       # Installation de Git
       Write-Host "`nInstallation de Git..." -ForegroundColor Yellow
       Start-Process -Wait $env:TEMP\git-stable.exe -ArgumentList /silent
       Write-Host "`nInstallation termin�e!`n`n" -ForegroundColor Green
    }
    else {
        Write-Host "`ngit est d�j� install�" -ForegroundColor Yellow
        }
       
}

finally {
        $ProgressPreference = 'Continue'
    }

$s = get-process ssh-agent -ErrorAction SilentlyContinue
if ($s) {$true}