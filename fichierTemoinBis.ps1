# Création d'un fichier témoin
Set-Location -Path $env:USERPROFILE
New-Item -Name "fichierTemoinBis.txt" -ItemType file -Value "Deuxième passage."  -force