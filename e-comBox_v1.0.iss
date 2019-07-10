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
;OnlyBelowVersion=6.0
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

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Files]

; Les scripts qui vont permettre d'initialiser l'application
Source: "lanceScriptPS_initialisationApplication.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "initialisationApplication.ps1"; DestDir: "{app}"; Flags: ignoreversion

; Les scripts bat qui vont �tre utlis�s dans les shortcut
Source: "lanceScriptPS_restartPortainer.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "lanceScriptPS_restartApplication.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "lanceScriptPS_restartDocker.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "lanceScriptPS_configProxyDocker.bat"; DestDir: "{app}"; Flags: ignoreversion

Source: "restartPortainer.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "restartApplication.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "restartDocker.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "configProxyDocker.ps1"; DestDir: "{app}"; Flags: ignoreversion

; Les scripts pour installer les pr�-requis

Source: "checkHyperV.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
;Source: "activeHyperV.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "activeHyperV.bat"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installDocker.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installGit.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installPortainer.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "lanceScriptPS_startPortainer.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "startPortainer.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "startApplication.ps1"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Initialiser e-comBox"; Filename: "{app}\lanceScriptPS_startApplication.bat";
Name: "{group}\Lancer e-comBox"; Filename: "{app}\{#MyAppName}.url"; Tasks: desktopicon
Name: "{group}\Red�marrer e-comBox"; Filename: "{app}\lanceScriptPS_restartApplication.bat"; Tasks: quicklaunchicon
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{tmp}\fichierTemoinBis.ps1"""""; WorkingDir: "{app}"; Flags: 64bit; StatusMsg: "Le fichier temoinBis.txt a �t� cr��"
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{tmp}\installGit.ps1"""""; WorkingDir: "{app}";
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\configDocker.ps1"""""; WorkingDir: "{app}";
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\installPortainer.ps1"""""; WorkingDir: "{app}"; Flags: waituntilterminated
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\startPortainer.ps1"""""; WorkingDir: "{app}"; Flags: waituntilterminated
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\installApplication.ps1"""""; WorkingDir: "{app}"; Flags: waituntilidle
;Filename: "{app}\{#MyAppName}.url"; Flags: postinstall

[LangOptions]
;LanguageID=$040C

[INI]
Filename: "{app}\{#MyAppName}.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://localhost:8888"; Flags: uninsdeleteentry ; Tasks: quicklaunchicon

[UninstallDelete]
Type: files; Name: "{app}\{#MyAppName}.url"

[Components]
Name: "HyperV"; Description: "Active Hyper V"; Types: full; Flags: fixed
Name: "Docker"; Description: "Docker Dekstop CEE pour Windows 10"; Types: full; Flags: fixed
Name: "Git"; Description: "Git pour Windows"; Types: full; Flags: fixed

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked


[ThirdParty]
CompileLogFile=C:\Users\daniel\e-comBox_setupWin10pro\logSetupEcomBox.txt

[Messages]
french.SelectComponentsDesc=Pour que l'application e-comBox fonctionne, les composants ci-dessous doivent �tre install�s. Vous devez disposer des droits d'administrateur.
french.SelectComponentsLabel2=Selon le d�bit de votre connexion Internet et la puissance de votre machine, l'installation sera plus ou moins longue. Cliquez sur suivant pour continuer.
french.FinishedLabel=L'assistant a termin� l'installation de [name] sur votre ordinateur. Vous devez maintenant l'initialiser � l'aide du lien correspondant que vous trouverez dans le menu [name] du programme de d�marrage.

[Code]
const
  RunOnceName = 'Red�marrage de la machine';

  QuitMessageReboot = 'L''installation de pr�-requis sera peut-�tre n�cessaire. Merci de permettre le red�marrage de votre ordinateur quand cela vous le sera demand�. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez.';
  QuitMessage1Reboot = 'L''activation d''HyperV a �t� r�alis�e. Votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez.';
  QuitMessage2Reboot = 'L''installation de Docker a �t� effectu�. Votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez. Vous pourrez �galement, � ce moment l�, fermer le popup de bienvenue de Docker.';
  QuitMessageInstallDocker = 'Docker a �t� install�. '#13#13' Vous pouvez fermer la fen�tre "Welcome" de bienvenue et poursuivre l''installation';
  QuitMessageError = 'Erreur. Il est impossible de continuer.';

var
  Restarted: Boolean;


var
  cbIconForAllUser: TNewCheckBox;
 
procedure InitializeWizard();
begin
  cbIconForAllUser         := TNewCheckBox.Create(WizardForm);
  cbIconForAllUser.Parent  := WizardForm.SelectTasksPage;
  cbIconForAllUser.Left    := WizardForm.NoIconsCheck.Left; 
  cbIconForAllUser.Top     := WizardForm.NoIconsCheck.Top;
  cbIconForAllUser.Width   := 350;
  cbIconForAllUser.Caption := ExpandConstant('{cm:cmIconForAllUser}');    
//  cbIconForAllUser.Checked := True;
end;
 
Function PathIcon(Path: String): String;
begin
  if cbIconForAllUser.Checked then
    Result := ExpandConstant('{commondesktop}}')
  else
    Result := ExpandConstant('{{userdesktop}}');
end;


function InitializeSetup(): Boolean;
begin
  Restarted := ExpandConstant('{param:restart|0}') = '1';
  //MsgBox('Fonction InitializeSetup D�but' , mbInformation, mb_Ok);
  if not Restarted then begin
    Result := not RegValueExists(HKA, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', RunOnceName);
    //MsgBox('Fonction InitializeSetup if not restarted' , mbInformation, mb_Ok);
    if not Result then
      //MsgBox('Fonction InitializeSetup if not result' , mbInformation, mb_Ok);
      MsgBox(QuitMessageReboot, mbInformation, mb_Ok);
      
  end else
    MsgBox('Fonction InitializeSetup if restart' , mbInformation, mb_Ok);
    Result := True;
end;

function DetectAndInstallPrerequisites: Boolean;

begin
  (*** Place your prerequisite detection and installation code below. ***)
  (*** Return False if missing prerequisites were detected but their installation failed, else return True. ***)

  //<your code here>
  // MsgBox('Message dans la fonction DetectAndInstallPrerequisites', mbInformation, mb_Ok);
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

  (*** Place any custom user selection you want to remember below. ***)

  //<your code here>
  
  RegWriteStringValue(HKA, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', RunOnceName, RunOnceData);
end;


function PrepareToInstall(var NeedsRestart: Boolean): String;
var
ResultCodeHyperV: Integer;
ResultCode: Integer;

begin
  
  if DetectAndInstallPrerequisites then begin

     // V�rifie si HyperV est activ� et l'active au cas o� puis red�marre la machine
     ExtractTemporaryFile('checkHyperV.ps1');
     Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\checkHyperV.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCodeHyperV);
     if ResultCodeHyperV <> 0 then begin
      MsgBox('Hyper V doit �tre activ�', mbInformation, mb_Ok);
      ExtractTemporaryFile('activeHyperV.bat');
      Exec(ExpandConstant('{tmp}\activeHyperV.bat'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
      //ExtractTemporaryFile('activeHyperV.ps1');
      //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\activeHyperV.ps1" -Verb RunAs'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
      CreateRunOnceEntry;
      NeedsRestart := True;
      Result := QuitMessage1Reboot;
     end;
                     
    end else
    Result := QuitMessageError;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
ResultCode: Integer;
AdresseProxy: string;
ProxyByPass: string;
V: Cardinal;
begin
  if(CurStep=ssInstall) then begin
     
     //Installation de la derni�re version de Git si ce dernier n'est pas d�j� install�
      ExtractTemporaryFile('installGit.ps1');
      Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installGit.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
      MsgBox('La derni�re version de Git a �t� install�, vous pouvez continuer' , mbInformation, mb_Ok);      
     
     // V�rifie si Docker est install� et l'installe et le configure au cas o�.
     if RegValueExists(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Run','Docker for Windows') = false then begin
       MsgBox('Docker n''est pas install�. '#13#13' Le programme va proc�der � son installation. '#13#10' Le temps de t�l�chargement peut �tre long. Merci de patienter.', mbInformation, mb_Ok);
       ExtractTemporaryFile('installDocker.ps1');
       Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installDocker.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
       MsgBox('Docker a �t� install�. '#13#13' Vous pouvez fermer la fen�tre "Welcome" de bienvenue et continuer l''installation', mbInformation, mb_Ok);
     end;
    
    // Configuration de Docker pour la propagation du proxy
     ExtractTemporaryFile('configProxyDocker.ps1');
     Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\configProxyDocker.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
     //MsgBox('Message apr�s configDocker' , mbInformation, mb_Ok);     
     
     // V�rifie si un proxy est activ� sur la machine et donne les informations le cas �ch�ant
     RegQueryDWordValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', V);
     if IntToStr(V)='1' then begin
       RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyServer', AdresseProxy);
       RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyOverride', ProxyByPass);
       StringChangeEx(ProxyByPass,';',',',True);
       ProxyByPass:= ProxyByPass
       MsgBox('Le programme d''installation a constat� qu''un proxy est configur� sur votre machine. '#13#13'Avant de continuer, vous devez configurer les informations suivantes sur Docker (voir documentation fournie) :'#13#10'Adresse IP du Proxy ' + AdresseProxy + ' '#13#10'ByPass : ' + ProxyByPass + ' '#13#10'Vous devez attendre que le service ait red�marr� (ce qu''il fait automatiquement) avant de continuer.', mbInformation, mb_Ok);
       Log('Proxy Enable : ' +IntToStr(V) + 'Informations du proxy : ' + AdresseProxy + 'Proxy by pass : " ' + ProxyByPass);
     end;       
  end;
   
  if(CurStep=ssPostInstall) then begin                
   ExtractTemporaryFile('installPortainer.ps1');
   Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\installPortainer.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
   MsgBox('Message apr�s InstallPortainer' , mbInformation, mb_Ok);
   ExtractTemporaryFile('startPortainer.ps1');
   Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\startPortainer.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
   
   //ExtractTemporaryFile('lanceScriptPS_startPortainer.bat');
   //Exec(ExpandConstant('{app}\lanceScriptPS_startPortainer.bat'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
   MsgBox('Message apr�s startPortainer' , mbInformation, mb_Ok);
   ExtractTemporaryFile('startApplication.ps1');
   Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\startApplication.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
   //MsgBox('L''application e-comBox est install�e et d�marr�e. Vous pouvez la lancer via son URL http://localhost:8888 ou via son ic�ne de lancement' , mbInformation, mb_Ok);
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := Restarted;
end;
