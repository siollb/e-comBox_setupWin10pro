docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 aporaf/e-combox:1.0
# Pour test
Set-Location -Path $env:USERPROFILE

#Start-Sleep -Seconds 45
New-Item -Name "fichierTemoinInstallApplication.txt" -ItemType file -Value "Docker run ne s'exécute pas"  -force