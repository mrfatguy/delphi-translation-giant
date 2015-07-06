program TransGiant;

uses
  Forms,
  frmMain in 'frmMain.pas' {MainForm},
  frmInfo in 'frmInfo.pas' {InfoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Translation Giant 1.00';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.Run;
end.
