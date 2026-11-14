[Setup]
AppName=UniversalWorkspace
AppVersion={#AppVersion}
AppPublisher=yashhasan570
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
DefaultDirName={autopf}\UniversalWorkspace\
DefaultGroupName=UniversalWorkspace
SetupIconFile=uniflow_logo.ico
UninstallDisplayIcon={app}\UniversalWorkspace.exe
UninstallDisplayName=UniversalWorkspace
VersionInfoVersion={#AppVersion}
UsePreviousAppDir=no

[Files]
Source: "UniversalWorkspace\UniversalWorkspace.exe"; DestDir: "{app}"; DestName: "UniversalWorkspace.exe"; Flags: ignoreversion
Source: "UniversalWorkspace\*";DestDir: "{app}"
Source: "UniversalWorkspace\data\*";DestDir: "{app}\data\"; Flags: recursesubdirs

[Icons]
Name: "{userdesktop}\UniversalWorkspace"; Filename: "{app}\UniversalWorkspace.exe"
Name: "{group}\UniversalWorkspace"; Filename: "{app}\UniversalWorkspace.exe"

[Registry]
Root: HKCR; Subkey: "UniversalWorkspace"; ValueType: "string"; ValueData: "URL:Custom Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "UniversalWorkspace"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "UniversalWorkspace\DefaultIcon"; ValueType: "string"; ValueData: "{app}\UniversalWorkspace.exe,0"
Root: HKCR; Subkey: "UniversalWorkspace\shell\open\command"; ValueType: "string"; ValueData: """{app}\UniversalWorkspace.exe"" ""%1"""