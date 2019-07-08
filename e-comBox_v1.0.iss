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
LicenseFile=C:\Users\daniel\e-comBox_setupWin10pro\licence_e-comBox.txt
InfoBeforeFile=C:\Users\daniel\e-comBox_setupWin10pro\avantInstallation.txt
InfoAfterFile=C:\Users\daniel\e-comBox_setupWin10pro\apresInstallation.txt
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=admin
OutputDir=C:\Users\daniel\e-comBox_setupWin10pro
OutputBaseFilename=e-combox_pro_educ_ent_v1.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupLogging=yes

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Files]
Source: "fichierTemoin.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "fichierTemoinBis.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "checkHyperV.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
;Source: "activeHyperV.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "activeHyperV.bat"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installDocker.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "configDocker.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "restartDocker.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "installGit.ps1"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "installPortainer.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "installApplication.ps1"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{tmp}\fichierTemoinBis.ps1"""""; WorkingDir: "{app}"; Flags: 64bit; StatusMsg: "Le fichier temoinBis.txt a �t� cr��"
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{tmp}\installGit.ps1"""""; WorkingDir: "{app}";
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\configDocker.ps1"""""; WorkingDir: "{app}";
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\installPortainer.ps1"""""; WorkingDir: "{app}";
;Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """"{app}\installApplication.ps1"""""; WorkingDir: "{app}";

[LangOptions]
;LanguageID=$040C

[INI]
Filename: "{app}\{#MyAppName}.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://localhost:8888"

[UninstallDelete]
Type: files; Name: "{app}\{#MyAppName}.url"

[Code]
const
  RunOnceName = 'Red�marrage de la machine';

  QuitMessageReboot = 'L''installation de pr�-requis sera peut-�tre n�cessaire. Merci de permettre le red�marrage de votre ordinateur quand cela vous le sera demand�. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez.';
  QuitMessage1Reboot = 'L''activation d''HyperV a �t� r�alis�e. Votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez.';
  QuitMessage2Reboot = 'L''installation de Docker a �t� effectu�. Votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez. Vous pourrez �galement, � ce moment l�, fermer le popup de bienvenue de Docker.';
  QuitMessageError = 'Erreur. Il est impossible de continuer.';

var
  Restarted: Boolean;





function InitializeSetup(): Boolean;
begin
  Restarted := ExpandConstant('{param:restart|0}') = '1';
  MsgBox('Fonction InitializeSetup D�but' , mbInformation, mb_Ok);
  if not Restarted then begin
    Result := not RegValueExists(HKA, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', RunOnceName);
    MsgBox('Fonction InitializeSetup if not restarted' , mbInformation, mb_Ok);
    if not Result then
      MsgBox('Fonction InitializeSetup if not result' , mbInformation, mb_Ok);
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
   MsgBox('Message dans la fonction DetectAndInstallPrerequisites', mbInformation, mb_Ok);
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
WasVisible: Boolean;
ResultCodeHyperV: Integer;
ResultCode: Integer;
AdresseProxy: string;
ProxyByPass: string;
V: Cardinal;

begin
  
  WasVisible := WizardForm.PreparingLabel.Visible;
  
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

     // V�rifie si Docker est install� et l'installe et le configure au cas o�.
     if RegValueExists(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Run','Docker for Windows') = false then begin
       MsgBox('Docker n''est pas install�. '#13#13' Le programme va proc�der � son installation. '#13#10' Le temps de t�l�chargement peut �tre long. Merci de patienter.', mbInformation, mb_Ok);
       ExtractTemporaryFile('installDocker.ps1');
       Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installDocker.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
       
       // Configuration de Docker
       ExtractTemporaryFile('configDocker.ps1');
       Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\configDocker.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
       MsgBox('Message apr�s configDocker' , mbInformation, mb_Ok);     

       // V�rifie si un proxy est activ� sur la machine et donne les informations le cas �ch�ant
       RegQueryDWordValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', V);
       if IntToStr(V)='1' then begin
         RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyServer', AdresseProxy);
         RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyOverride', ProxyByPass);
         StringChangeEx(ProxyByPass,';',',',True);
         ProxyByPass:= ProxyByPass
         MsgBox('Le programme d''installation a constat� qu''un proxy est configur� sur votre machine. '#13#13'Avant de continuer, vous devez configurer les informations suivantes sur Docker (voir documentation fournie) et attendre que le service red�marre, ce qu''il fait automatiquement :'#13#13' ' + AdresseProxy + ' '#13#10' ByPass : ' + ProxyByPass, mbInformation, mb_Ok);
         end;
        Log('Proxy Enable : ' +IntToStr(V) + 'Informations du proxy : ' + AdresseProxy + 'Proxy by pass : " ' + ProxyByPass);
    end                    
  end else
    Result := QuitMessageError;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
ResultCode: Integer;
begin
  if(CurStep=ssInstall) then begin
   MsgBox('Message dans CurStepchanged' , mbInformation, mb_Ok);
   
   MsgBox('Message avant InstallGit' , mbInformation, mb_Ok);
   ExtractTemporaryFile('installGit.ps1');
   Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installGit.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
   MsgBox('Message apr�s InstallGit' , mbInformation, mb_Ok); 
   ExtractTemporaryFile('installPortainer.ps1');
   Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\installPortainer.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
   MsgBox('Message apr�s InstallPortainer' , mbInformation, mb_Ok);
   ExtractTemporaryFile('installApplication.ps1');
   Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\installApplication.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
   MsgBox('Message apr�s installApplication' , mbInformation, mb_Ok);
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := Restarted;
end;
