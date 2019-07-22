﻿# Redémarrage de Portainer
Start-Process -wait lanceScriptPS_restartPortainer.bat

# Redémarrage de l'application
docker rm -f e-combox
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 aporaf/e-combox:1.0
Start-Process "C:\Program Files\e-comBox\e-comBox.url"