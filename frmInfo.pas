unit frmInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, ShellAPI;

type
  TInfoForm = class(TForm)
    lblCopyright: TLabel;
    lblFreeware: TLabel;
    imgInscription: TImage;
    imgLogo1: TImage;
    imgLogo2: TImage;
    imgLogo3: TImage;
    imgLogo4: TImage;
    imgLogoA: TImage;
    imgLogoB: TImage;
    mInfo: TMemo;
    lblAsterix1: TLabel;
    lblAsterix2: TLabel;
    procedure CloseWindow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InfoForm: TInfoForm;

implementation

{$R *.DFM}

procedure TInfoForm.CloseWindow(Sender: TObject);
begin
        Close;
end;

procedure TInfoForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if Key=27 then Close;
end;

procedure TInfoForm.FormPaint(Sender: TObject);
begin
        Canvas.LineTo(ClientWidth - 1, 0);
        Canvas.LineTo(ClientWidth - 1, ClientHeight - 1);
        Canvas.LineTo(0, ClientHeight - 1);
        Canvas.LineTo(0, 0);
end;

end.
