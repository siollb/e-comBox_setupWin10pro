@echo off
NET SESSION 1>NUL 2>NUL
IF %ERRORLEVEL% EQU 0 GOTO ADMINTASKS
CD %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 0); close();"
EXIT

:ADMINTASKS

powershell.exe -executionpolicy bypass -file "restartDocker.ps1"

