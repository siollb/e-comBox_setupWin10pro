; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "e-comBox"
#define MyAppVersion "1.0"
#define MyAppPublisher "BTS SIO LLB Ajaccio / R�seau Certa"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{AE3F5FEF-D723-417C-B5F3-9D491655D7DB}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
MinVersion=10.0.15063
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=C:\Users\daniel\e-comBox_setupWin10pro\licence_e-comBox.rtf
InfoBeforeFile=C:\Users\daniel\e-comBox_setupWin10pro\avantInstallation.rtf
; InfoAfterFile=C:\Users\daniel\e-comBox_setupWin10pro\apresInstallation.rtf
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=admin
OutputDir=C:\Users\daniel\e-comBox_setupWin10pro
OutputBaseFilename=e-combox_pro_educ_ent_v1.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupLogging=yes
ArchitecturesInstallIn64BitMode=x64 ia64
UninstallLogMode=overwrite
AllowUNCPath=False
DisableDirPage=yes
ShowComponentSizes=False
DisableProgramGroupPage=yes
UninstallDisplayIcon={uninstallexe}
VersionInfoVersion=1.0
DisableWelcomePage=False
AlwaysShowDirOnReadyPage=True
AlwaysShowGroupOnReadyPage=True
WizardImageFile=C:\Users\daniel\e-comBox_setupWin10pro\imageSetupGrande.bmp
WizardSmallImageFile=C:\Users\daniel\e-comBox_setupWin10pro\imageSetupPetite.bmp
FlatComponentsList=False
;SignTool=SignatureCode

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Files]
; Les scripts qui vont permettre d'initialiser l'application
Source: "lanceScriptPS_initialisationApplication.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "initialisationApplication.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_installPortainer.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_startPortainer.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_startApplication.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion

; Les scripts bat suppl�mentaires qui vont �tre utlis�s dans les shortcut
Source: "lanceScriptPS_restartPortainer.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_stopPortainer.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_restartApplication.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_restartDocker.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_configProxyDocker.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_configEnvironnement.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion

Source: "restartPortainer.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "stopPortainer.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "restartApplication.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "restartDocker.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "configProxyDocker.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversionSource: "configEnvironnement.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion

; Les scripts pour installer les pr�-requis

Source: "checkHyperV.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "activeHyperV.bat"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "downloadDocker.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installDocker.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installGit.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installPortainer.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "lanceScriptPS_startPortainer.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "startPortainer.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "startApplication.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
;Name: "{group}\Initialiser e-comBox"; Filename: "{app}\lanceScriptPS_initialisationApplication.bat"
Name: "{group}\Lancer e-comBox"; Filename: "{app}\{#MyAppName}.url"
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.url"
;Name: "{userstartmenu}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.url"; Tasks: desktopicon
Name: "{group}\R�initialiser l'environnement"; Filename: "{app}\scripts\lanceScriptPS_restartApplication.bat"
;Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\scripts\lanceScriptPS_restartApplication.bat"
Name: "{group}\V�rifier et configurer l'environnement"; Filename: "{app}\scripts\lanceScriptPS_configEnvironnement.bat"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\scripts\lanceScriptPS_initialisationApplication.bat"; Flags: waituntilterminated postinstall runhidden hidewizard; Description: "{cm:LaunchProgram,l'initialisation de e-comBox}"
;Filename: "{app}\scripts\lanceScriptPS_installPortainer.bat"; Flags: waituntilterminated postinstall runhidden hidewizard; Description: "{cm:LaunchProgram,initialisation}"
;Filename: "{app}\scripts\lanceScriptPS_startPortainer.bat"; Flags: waituntilterminated postinstall runhidden hidewizard; Description: "{cm:LaunchProgram,initialisation}"
;Filename: "{app}\scripts\lanceScriptPS_startApplication.bat"; Flags: waituntilterminated postinstall runhidden hidewizard; Description: "{cm:LaunchProgram,initialisation}"
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\installPortainer.ps1"""""; WorkingDir: "{app}"; Flags: waituntilterminated
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\startPortainer.ps1"""""; WorkingDir: "{app}"; Flags: waituntilterminated
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\startApplication.ps1"""""; WorkingDir: "{app}"; Flags: waituntilidle; Description: "{cm:LaunchProgram,initialisation}"


[INI]
;Filename: "{app}\{#MyAppName}.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://localhost:8888"; Flags: uninsdeleteentry ; Tasks: quicklaunchicon
Filename: "{app}\{#MyAppName}.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://localhost:8888"; Flags: uninsdeleteentry

[UninstallDelete]
Type: files; Name: "{app}\{#MyAppName}.url"
Type: filesandordirs; Name: "{userdocs}\..\e-comBox_portainer"

[Components]
Name: "HyperV"; Description: "Active Hyper V"; Types: full custom compact; Flags: fixed
Name: "Docker"; Description: "Docker Dekstop CEE pour Windows 10"; Types: full compact custom; Flags: fixed
Name: "Git"; Description: "Git pour Windows"; Types: full compact custom; Flags: fixed

[Tasks]
;Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"
;Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"

[ThirdParty]
CompileLogFile=C:\Users\daniel\e-comBox_setupWin10pro\logSetupEcomBox.txt

[Messages]
french.SelectComponentsDesc=Pour que l'application e-comBox fonctionne, les composants ci-dessous doivent �tre install�s. Vous devez disposer des droits d'administrateur.
french.SelectComponentsLabel2=Selon le d�bit de votre connexion Internet et la puissance de votre machine, l'installation sera plus ou moins longue. %n%nCliquez sur suivant pour continuer.
french.FinishedLabel=L'assistant a termin� l'installation de e-comBox sur votre ordinateur.
french.ClickFinish=Avant de pouvoir profiter pleinement de l'application, vous pouvez d�s maintenant initialiser e-comBox en cochant la case ci-dessous. %n%nSi vous ne le fa�tes pas tout de suite, cette derni�re pourra se faire ult�rieurement via le lien D�marrage de l'application.
french.ConfirmUninstall=Vous vous appr�tez �  d�sinstaller %1. Si vous n'avez plus besoin des composants install�s (Git, Docker et HyperV), vous pourrez ensuite proc�der � leur d�sinstallation en suivant la proc�dure mise � disposition. Cliquez sur oui pour continuer.
french.WelcomeLabel2=Cet assistant va vous guider dans l'installation de [name/ver] sur votre ordinateur.%n%nL'installation de pr�-requis sera peut-�tre n�cessaire. Merci de permettre le red�marrage de votre ordinateur quand cela vous le sera demand� (� deux reprises au maximum). ll est recommand� de fermer toutes les applications actives avant de continuer.%n%nPar ailleurs, le t�l�chargement et l'installation de ces pr�-requis peuvent parfois �tre long, merci d'�tre patient.

[UninstallRun]
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{tmp}\desinstallGit.ps1"""""; WorkingDir: "{app}"; Flags: waituntilterminated; StatusMsg: "Git a �t� d�sinstall�"; Components: Git
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{tmp}\desinstallDocker.ps1"""""; WorkingDir: "{app}"; Flags: waituntilterminated; StatusMsg: "Docker a �t� d�sinstall�"; Components: Docker
;Filename: "{tmp}\desactiveHyperV.bat"; Components: HyperV

[Dirs]
Name: "{app}\uninstall"; Flags: uninsalwaysuninstall
Name: "{app}\scripts"; Flags: uninsalwaysuninstall

[Code]
const
  RunOnceName = 'Red�marrage de la machine';

  QuitMessageReboot = 'L''installation de pr�-requis sera peut-�tre n�cessaire. Merci de permettre le red�marrage de votre ordinateur quand cela vous le sera demand�. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera.';
  QuitMessage1Reboot = 'Suite � l''activation d''HyperV, votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera.';
  QuitMessage2Reboot = 'Suite � l''installation de Docker, votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera.';
  QuitMessageInstallDocker = 'Docker a �t� install�. '#13#13' Vous pouvez fermer la fen�tre "Welcome" de bienvenue et poursuivre l''installation';
  QuitMessageError = 'Erreur. Il est impossible de continuer.';

var
  Restarted: Boolean;
  FinishedInstall: Boolean;
  PrepareToInstallWithProgressPage: TOutputProgressWizardPage;

function InitializeSetup(): Boolean;

var
  Version: TWindowsVersion;
  S: String;

  begin
  // V�rification de la version de Windows
  GetWindowsVersionEx(Version);

  // D�sactivation de l'installation sur une version Home de Windows
  if Version.SuiteMask and VER_SUITE_PERSONAL <> 0 then
  begin
    SuppressibleMsgBox('L''application e-comBox ne peut pas �tre install�e sur Windows 10 Famille mais n�cessite une version de Windows 10 professionnel, �ducation ou entreprise.',
      mbCriticalError, MB_OK, IDOK);
    Result := False;
    Exit;
  end;

  // D�sactivation de l'installation sur une version serveur de Windows
  if Version.ProductType = VER_NT_DOMAIN_CONTROLLER then
  begin
    SuppressibleMsgBox('L''application e-comBox ne peut pas �tre install�e sur Windows Serveur mais n�cessite une version de Windows 10 professionnel, �ducation ou entreprise.',
      mbCriticalError, MB_OK, IDOK);
    Result := False;
    Exit;
  end;

  Restarted := ExpandConstant('{param:restart|0}') = '1';

  if not Restarted then begin
    Result := not RegValueExists(HKA, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', RunOnceName);
    if not Result then
      MsgBox(QuitMessageReboot, mbInformation, mb_Ok);
      
  end else    
    Result := True;
end;


procedure InitializeWizard;
var
  A: AnsiString;
  S: String;
begin
  S := SetupMessage(msgPreparingDesc); 
  StringChange(S, '[name]', '{#MyAppName}');
  A := S;
  PrepareToInstallWithProgressPage := CreateOutputProgressPage(SetupMessage(msgWizardPreparing), A);
end;



function DetectAndInstallPrerequisites: Boolean;

begin
  Result:= true;
end;

function Quote(const S: String): String;
begin
  Result := '"' + S + '"';
end;

function AddParam(const S, P, V: String): String;
begin
  if V <> '""' then
    Result := S + ' /' + P + '=' + V;
end;

function AddSimpleParam(const S, P: String): String;
begin
 Result := S + ' /' + P;
end;

procedure CreateRunOnceEntry;
var
  RunOnceData: String;
begin
  RunOnceData := Quote(ExpandConstant('{srcexe}')) + ' /restart=1';
  RunOnceData := AddParam(RunOnceData, 'LANG', ExpandConstant('{language}'));
  RunOnceData := AddParam(RunOnceData, 'DIR', Quote(WizardDirValue));
  RunOnceData := AddParam(RunOnceData, 'GROUP', Quote(WizardGroupValue));
  if WizardNoIcons then
    RunOnceData := AddSimpleParam(RunOnceData, 'NOICONS');
    RunOnceData := AddParam(RunOnceData, 'TYPE', Quote(WizardSetupType(False)));
    RunOnceData := AddParam(RunOnceData, 'COMPONENTS', Quote(WizardSelectedComponents(False)));
    RunOnceData := AddParam(RunOnceData, 'TASKS', Quote(WizardSelectedTasks(False)));
 
  RegWriteStringValue(HKA, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', RunOnceName, RunOnceData);
end;


function PrepareToInstall(var NeedsRestart: Boolean): String;
var
ResultCodeHyperV: Integer;
ResultCode: Integer;

begin
  
  if DetectAndInstallPrerequisites then begin

    PrepareToInstallWithProgressPage.SetProgress (0, 0);
    PrepareToInstallWithProgressPage.Show;

    try
     begin
     
     //Installation de la derni�re version de Git si ce dernier n'est pas d�j� install�       
     PrepareToInstallWithProgressPage.SetProgress(1, 10);
     PrepareToInstallWithProgressPage.SetText(('V�rification et installation des pr�-requis...'), '');
     ExtractTemporaryFile('installGit.ps1');
     Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installGit.ps1"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
     //MsgBox('La derni�re version de Git a �t� install�, vous pouvez continuer' , mbInformation, mb_Ok);  
     PrepareToInstallWithProgressPage.SetProgress(2, 10);
     
     // V�rifie si HyperV est activ� et l'active au cas o� puis red�marre la machine     
     ExtractTemporaryFile('checkHyperV.ps1');
     Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\checkHyperV.ps1"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCodeHyperV);
     //MsgBox('Le RESULT CODE HYPER V est : ' + IntToStr(ResultCodeHyperV), mbInformation, mb_Ok);
     PrepareToInstallWithProgressPage.SetProgress (3, 10);

     if ResultCodeHyperV <> 0 then begin
        PrepareToInstallWithProgressPage.SetText(('Activation d''hyperV...'), '');
        ExtractTemporaryFile('activeHyperV.bat');
        Exec(ExpandConstant('{tmp}\activeHyperV.bat'), '', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
        MsgBox('L''activation d''hyperV a �t� r�alis�e, vous pouvez continuer', mbInformation, mb_Ok);
        PrepareToInstallWithProgressPage.SetProgress (4, 10);
        //Red�marrage de la machine
        CreateRunOnceEntry;
        NeedsRestart := True;
        Result := QuitMessage1Reboot;
        //end
       end else begin
         // V�rifie si Docker est install� et l'installe et le configure au cas o�.
         if RegValueExists(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Run','Docker Desktop') = false then begin
           MsgBox('Docker n''est pas install�. '#13#13'Le programme va proc�der � son installation. '#13#10'Le temps de t�l�chargement peut �tre long. Merci de patienter.', mbInformation, mb_Ok);
           PrepareToInstallWithProgressPage.SetText(('T�l�chargement de Docker...'), '');
           PrepareToInstallWithProgressPage.SetProgress(5, 10);
           ExtractTemporaryFile('downloadDocker.ps1');
           Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\downloadDocker.ps1"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
           PrepareToInstallWithProgressPage.SetProgress(7, 10);
           PrepareToInstallWithProgressPage.SetText(('Installation de Docker...'), '');
           ExtractTemporaryFile('installDocker.ps1');
           Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installDocker.ps1"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
           PrepareToInstallWithProgressPage.SetProgress(8, 10);
           PrepareToInstallWithProgressPage.SetText(('Pr�paration du red�marrage...'), '');
           //ExtractTemporaryFile('lanceDocker.ps1');
           //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\lanceDocker.ps1"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
           PrepareToInstallWithProgressPage.SetProgress(10, 10);
           MsgBox('Docker a �t� install�, vous pouvez continuer.', mbInformation, mb_Ok);
           CreateRunOnceEntry;
           NeedsRestart := True;
           Result := QuitMessage2Reboot;
         end;
      end;     
       
     end;  
     finally
      PrepareToInstallWithProgressPage.Hide;
      end;              
    end else
    Result := QuitMessageError;
end;



procedure CurStepChanged(CurStep: TSetupStep);

var
ResultCode: Integer;
ErrorCode: Integer;
AdresseProxy: string;
ProxyByPass: string;
V: Cardinal;

begin

Log('CurStepChanged(' + IntToStr(Ord(CurStep)) + ') called');

  if(CurStep=ssInstall) then begin
     MsgBox('Merci d''attendre la fen�tre "Welcome" de bienvenue de Docker avant de continuer l''installation, signe que Docker a d�marr�. '#13#13'Vous pouvez ensuite fermer cette fen�tre qui n''appara�t qu''une fois au premier d�marrage de Docker.'#13#13'Vous pouvez suivre le statut de Docker dans la barre des t�ches au survol de son ic�ne pr�sente dans la zone de notifications dans la partie inf�rieure droite de l��cran. '#13#13'Ce statut est sur starting quand Docker est en train de d�marrer puis passe � running quand Docker a d�marr� et cela peut prendre du temps au d�marrage de la machine.', mbInformation, mb_Ok);
      // Configuration d'un �ventuel proxy
        PrepareToInstallWithProgressPage.SetText(('D�tection d''un �ventuel proxy par l''assistant d''installation'), '');
        ExtractTemporaryFile('configProxyDocker.ps1');
        Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\scripts\configProxyDocker.ps1"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode);  
        PrepareToInstallWithProgressPage.SetProgress(9, 10);

        // V�rifie si un proxy est activ� sur la machine et donne les informations le cas �ch�ant
        RegQueryDWordValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', V);
        if IntToStr(V)='1' then begin
          ShellExec('open', 'https://docs.google.com/document/d/1qXXyaMNMtY24VgItIv0gdasyT2souVMLRdYkTMEIBeo/edit', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
          RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyServer', AdresseProxy);
          RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyOverride', ProxyByPass);
          StringChangeEx(ProxyByPass,';',',',True);
          ProxyByPass:= ProxyByPass;
          MsgBox('Le programme d''installation a constat� qu''un proxy est configur� sur votre machine. '#13#13'Avant de continuer, vous devez configurer les informations suivantes sur Docker (voir documentation qui a �t� lanc�e dans votre navigateur par d�faut) : '#13#13'Adresse IP du Proxy : ' + AdresseProxy + ' '#13#10'ByPass : ' + ProxyByPass + ' '#13#13'Vous devez attendre que le service ait red�marr� (ce qu''il fait automatiquement) avant de continuer.', mbInformation, mb_Ok);
          Log('Proxy Enable : ' +IntToStr(V) + 'Informations du proxy : ' + AdresseProxy + 'Proxy by pass : " ' + ProxyByPass);
        end;         
          PrepareToInstallWithProgressPage.SetProgress(10, 10);
         
     FinishedInstall := True
  end;  
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := Restarted;
end;

procedure DeinitializeSetup();

var
NeedsRestart: Boolean;

begin
  Log('DeinitializeSetup called');
  if NeedsRestart then begin
     MsgBox('L''installation continue au prochain d�marrage...', mbInformation, MB_OK);
     end ;
  if FinishedInstall then begin
     MsgBox('Fin de l''installation:' #13#13'L''application e-comBox est en train d''�tre initialis�e. Veuillez patienter.' #13#13'Elle sera ensuite lanc�e automatiquement dans votre navigateur par d�faut.' #13#13'Par la suite, vous pouvez d�marrer e-comBox en saisissant l''URL http://localhost:8888 dans un navigateur ou via l''ic�ne du bureau ou bien via le lien du menu de d�marrage.'#13#13'Pour prendre en compte les modifications de l''environnement comme un changement d''adresse IP ou l''ajout d''un proxy, il est n�cessaire de r�initialiser e-comBox avec le lien correspondant.', mbInformation, MB_OK);
     end ;
     // else
     //MsgBox('L''installation continue au prochain d�marrage...', mbInformation, MB_OK);
  end;


//procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
//var
  //ErrorCode: Integer;

//begin
  //if CurUninstallStep = usDone then begin
    // ShellExec('open', 'https://docs.google.com/document/d/11RxyTEsPuGdWgp5C3ZNbglBpxfSsMQS2UvazFqZdVSo/edit?usp=sharing', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);   
 // end;
//end;


procedure DeinitializeUninstall;
var
  ErrorCode: Integer;

begin
     ShellExec('open', 'https://docs.google.com/document/d/11RxyTEsPuGdWgp5C3ZNbglBpxfSsMQS2UvazFqZdVSo/edit?usp=sharing', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);   
end;
