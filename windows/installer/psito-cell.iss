; O instalador do Psito Cell no Windows, gerado no CI com o Inno Setup.
;
;   ISCC /DAppVersion=1.2.3 windows\installer\psito-cell.iss
;
; Instala só para quem está usando, sem pedir administrador, e quem quiser pode
; instalar para todos no diálogo.
#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#define AppName "Psito Cell"
#define AppExe "psito_cell.exe"
#define AppModelId "Psito.Cell"
#define Release "..\..\build\windows\x64\runner\Release"

[Setup]
AppId={{B8E3D2A6-4C1F-4F7A-A5D9-6E2C0F9B7134}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=Psito Cell contributors
AppPublisherURL=https://francisceioseph.github.io/psito-cell/
AppSupportURL=https://github.com/francisceioseph/psito-cell/issues
AppUpdatesURL=https://github.com/francisceioseph/psito-cell/releases
VersionInfoVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DisableProgramGroupPage=yes
DisableDirPage=auto
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.17763
OutputDir=Output
OutputBaseFilename=psito-cell-windows-x64-setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=force
RestartApplications=no

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#Release}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\LICENSE"; DestDir: "{app}\licenses"; DestName: "LICENSE.txt"; Flags: ignoreversion
Source: "..\..\THIRD_PARTY_LICENSES.md"; DestDir: "{app}\licenses"; Flags: ignoreversion
Source: "..\..\assets\LICENSE.md"; DestDir: "{app}\licenses"; DestName: "ART-LICENSE.md"; Flags: ignoreversion
Source: "..\..\assets\fonts\OFL.txt"; DestDir: "{app}\licenses"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"; AppUserModelID: "{#AppModelId}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; AppUserModelID: "{#AppModelId}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent

; O desinstalador não fecha o jogo sozinho, e o arquivo aberto ficaria para trás
[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im {#AppExe}"; Flags: runhidden; RunOnceId: "StopGame"
