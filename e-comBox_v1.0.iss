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

[Code]
const
  RunOnceName = 'Red�marrage de la machine';

  QuitMessageReboot = 'L''installation de pr�-requis est n�cessaire. Merci de permettre le red�marrage de votre ordinateur quand cela vous le sera demand�. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez.';
  QuitMessage1Reboot = 'L''activation d''HyperV a �t� r�alis�e. Votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez.';
  QuitMessage2Reboot = 'L''installation de Docker a �t� effectu�. Votre ordinateur va red�marrer. '#13#13'Apr�s ce red�marrage, le programme d''installation continuera d�s que vous vous connecterez. Vous pourrez �galement, � ce moment l�, fermer le popup de bienvenue de Docker.';
  QuitMessageError = 'Erreur. Il est impossible de continuer.';

var
  Restarted: Boolean;





function InitializeSetup(): Boolean;
begin
  Restarted := ExpandConstant('{param:restart|0}') = '1';

  if not Restarted then begin
    Result := not RegValueExists(HKA, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', RunOnceName);
    if not Result then
      MsgBox(QuitMessageReboot, mbInformation, mb_Ok);
  end else
    Result := True;
end;

function DetectAndInstallPrerequisites: Boolean;

begin
  (*** Place your prerequisite detection and installation code below. ***)
  (*** Return False if missing prerequisites were detected but their installation failed, else return True. ***)

  //<your code here>
 
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
ResultCode: Integer;
AdresseProxy: string;
V: Cardinal;

begin
  if DetectAndInstallPrerequisites then begin

     // V�rifie si HyperV est activ� et l'active au cas o� puis red�marre la machine
     ExtractTemporaryFile('checkHyperV.ps1');
     Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\checkHyperV.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
     if ResultCode <> 0 then begin
      MsgBox('Hyper V sera activ�', mbInformation, mb_Ok);
      ExtractTemporaryFile('activeHyperV.bat');
      Exec(ExpandConstant('{tmp}\activeHyperV.bat'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
      //ExtractTemporaryFile('activeHyperV.ps1');
      //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\activeHyperV.ps1" -Verb RunAs'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
      CreateRunOnceEntry;
      NeedsRestart := True;
      Result := QuitMessage1Reboot;
      // V�rifie si Docker est install� et l'installe au cas o� puis red�marre la machine
      end
      else if RegValueExists(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Run','Docker for Windows') = false then begin
        MsgBox('Docker n''est pas install�. '#13#13' Le programme va proc�der � son installation. '#13#10' Merci de patienter.', mbInformation, mb_Ok);
        //ExtractTemporaryFile('fichierTemoinBis.ps1');
        //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\fichierTemoinBis.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
        ExtractTemporaryFile('installDocker.ps1');
        Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installDocker.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
        CreateRunOnceEntry;
        NeedsRestart := True;
        Result := QuitMessage2Reboot;   
        end
       // Dans le cas o� Docker est install�          
        else begin 
          MsgBox('Docker est install�. '#13#13'Avant de poursuivre l''installation, validez le d�marrage de Docker si cela vous est demand�.', mbInformation, mb_Ok); 
          // V�rifie si un proxy est activ� sur la machine et donne les informations le cas �ch�ant
 
          RegQueryDWordValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', V);
     
          if IntToStr(V)='1' then begin
          RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Settings','ProxyServer', AdresseProxy);
          MsgBox('Le programme d''installation a constat� qu''un proxy est configur� sur votre machine. '#13#13'Avant de continuer, vous devez configurer les informations suivantes sur Docker (voir documentation fournie) :'#13#10' ' + AdresseProxy + ' Valeur de V ' + IntToStr(V), mbInformation, mb_Ok);
          end;
        end;
    Log('Informations du proxy : ' + AdresseProxy + 'Proxy Enable : ' +IntToStr(V));

    ExtractTemporaryFile('installGit.ps1');
    Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installGit.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
    ExtractTemporaryFile('configDocker.ps1');
    Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\configDocker.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
    ExtractTemporaryFile('installPortainer.ps1');
    Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\installPortainer.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
    ExtractTemporaryFile('installApplication.ps1');
    Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{app}\installApplication.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
 
  end else
    Result := QuitMessageError;
end;

//procedure CurStepChanged(CurStep: TSetupStep);
//var
//ResultCode: Integer;
//begin
  //if(CurStep=ssInstall) then begin
    //ExtractTemporaryFile('installGit.ps1');
    //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installGit.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
    //ExtractTemporaryFile('installPortainer.ps1');
    //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installPortainer.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
    //ExtractTemporaryFile('installApplication.ps1');
    //Exec('PowerShell.exe', ExpandConstant(' -ExecutionPolicy Bypass -File "{tmp}\installApplication.ps1"'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
  //end;
//end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := Restarted;
end;
