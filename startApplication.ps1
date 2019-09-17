# Création du réseau utilisé par les sites
docker network create bridge_e-combox

# Téléchargement d'e-comBox
docker pull aporaf/e-combox:1.0

# Lancement d'e-comBox
docker run -dit --name e-combox -v ecombox_data:/usr/local/apache2/htdocs/ --restart always -p 8888:80 aporaf/e-combox:1.0

# Lancement de l'URL
Start-Process "C:\Program Files\e-comBox\e-comBox.url"
