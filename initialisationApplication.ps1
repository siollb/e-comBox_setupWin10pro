
#Start-Process -wait lanceScriptPS_installPortainer.bat 
#Start-Process -wait lanceScriptPS_startPortainer.bat
#Start-Process -wait lanceScriptPS_startApplication.bat

Start-Process -wait -NoNewWindow lanceScriptPS_installPortainer.bat 
Start-Process -wait -NoNewWindow lanceScriptPS_startPortainer.bat
Start-Process -wait -NoNewWindow lanceScriptPS_startApplication.bat
