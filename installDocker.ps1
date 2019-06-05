# First Download the installer (wget is slow...)
# wget https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe -OutFile docker-installer.exe

(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe', 'docker-installer.exe')

# Install
start-process -wait docker-installer.exe " install --quiet"

# Clean-up
rm docker-installer.exe

# Run
start-process "$env:ProgramFiles\docker\Docker\Docker for Windows.exe"

write-host "Done."

# Récupération de portainer
git clone https://github.com/siollb/e-comBox_portainer.git 2>$null

# Récupération et mise au bon format de l'adresse IP 
$docker_ip_host = (Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Physical).InterfaceIndex).IPv4Address
$docker_ip_host = "$docker_ip_host"
$docker_ip_host = $docker_ip_host.Trim()

# Mise à jour de l'adresse IP
@"
DOCKER_IP_TOUT=0.0.0.0
DOCKER_IP_HOST=$docker_ip_host
"@ > .\e-comBox_portainer\.env