# Redémarrage de Portainer
Start-Process -wait lanceScriptPS_restartPortainer.bat

# Redémarrage de l'application
docker rm -fv e-combox
docker volume rm $(docker volume ls -qf dangling=true)
docker pull aporaf/e-combox:1.0
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 --network bridge_e-combox aporaf/e-combox:1.0

# Nettoyage des images
docker rmi $(docker images -q -f dangling=true)

# Lancement de l'application
Start-Process "C:\Program Files\e-comBox\e-comBox.url"