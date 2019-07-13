REM -->  DISM /Online /NoRestart /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
dism.exe /Online  /NoRestart /Enable-Feature:Microsoft-Hyper-V-All
REM --> shutdown.exe /r /t 00