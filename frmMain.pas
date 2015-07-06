unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, SHDocVw, ExtCtrls, WinInet, Buttons, ComCtrls, ImgList, 
  ActiveX;

type
  TMainForm = class(TForm)
    pnlTool: TPanel;
    gbLast: TGroupBox;
    cbList: TListBox;
    chbAuto: TCheckBox;
    btnClearList: TButton;
    pgMain: TPageControl;
    TsLing: TTabSheet;
    tsDict: TTabSheet;
    wbDict: TWebBrowser;
    wbLing: TWebBrowser;
    btnAbout: TButton;
    Label1: TLabel;
    eStr: TEdit;
    tsGoogle: TTabSheet;
    wbGoogle: TWebBrowser;
    tsCambridge: TTabSheet;
    wbCambridge: TWebBrowser;
    tsTlumacz: TTabSheet;
    wbTlumacz: TWebBrowser;
    btnGo: TButton;
    cbLang: TComboBox;
    tiMaximize: TTimer;
    imgDocAnimation: TImageList;
    btnRemember: TButton;
    lblLingWarning: TLabel;
    tsGetionary: TTabSheet;
    wbGetionary: TWebBrowser;
    tsAngool: TTabSheet;
    tsDictionary: TTabSheet;
    tsTranslate: TTabSheet;
    tsWiki: TTabSheet;
    tsOneLook: TTabSheet;
    tsMerriam: TTabSheet;
    wbAngool: TWebBrowser;
    wbDictionary: TWebBrowser;
    wbTranslate: TWebBrowser;
    wbWiki: TWebBrowser;
    wbOneLook: TWebBrowser;
    wbMerriam: TWebBrowser;
    lblGetionaryWarning: TLabel;
    lblOneLookInfo: TLabel;
    lblMerriamInfo: TLabel;
    lblCambridgeInfo: TLabel;
    pnlNavigation: TPanel;
    sbBack: TSpeedButton;
    sbForward: TSpeedButton;
    sbRefresh: TSpeedButton;
    sbStop: TSpeedButton;
    lblNavigInfo: TLabel;
    sbHome: TSpeedButton;
    function Connected: Boolean;
    procedure ResetTabs();
    function Win2ISO(const sWin: String): String;

    procedure btnAboutClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tiMaximizeTimer(Sender: TObject);
    procedure WebBrowserProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure FormShow(Sender: TObject);
    procedure btnClearListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbListClick(Sender: TObject);
    procedure btnRememberClick(Sender: TObject);
    procedure cbListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pgMainChange(Sender: TObject);
    procedure ButtonNavigateMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WebBrowserCommandStateChange(Sender: TObject; Command: Integer;
      Enable: WordBool);
  private
    CanGoBack: array [0..20] of Boolean;
    CanGoForward: array [0..20] of Boolean;
  public
    HomeAddress: array [0..1, 0..20] of String;
  end;

var
  MainForm: TMainForm;

implementation

uses frmInfo;

{$R *.DFM}
{$R WinXP.res}

function TMainForm.Connected: Boolean;
var
     Flags: DWORD;
begin
     Flags:=INTERNET_CONNECTION_MODEM or INTERNET_CONNECTION_LAN ;
     Result := InternetGetConnectedState(@Flags, 0);
end;

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
        InfoForm.ShowModal;
end;

procedure TMainForm.btnGoClick(Sender: TObject);
var
        sWord, sAdr, sLang: String;
begin
        if eStr.Text = '' then
        begin
                Application.MessageBox('Empty search phrase!','Error!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                exit;
        end;

        if not Connected then
        begin
                Application.MessageBox('You need an active connection to the Internet to use this program.'+chr(13)+'No active connection has been found.'+chr(13)+''+chr(13)+'Connect to the Internet and try again...','No Internet connection!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                exit;
        end;

        Screen.Cursor := crAppStart;
        ResetTabs();
        sWord := eStr.Text;

        //Onet T³umacz
        case cbLang.ItemIndex of
                0: sLang := 'pol-ang';
                1: sLang := 'ang-pol';
        end;
        sAdr := 'http://portalwiedzy.onet.pl/tlumacz.html?qs=' + Win2ISO(sWord) + '&tr=' + sLang;
        wbTlumacz.Navigate(sAdr);

        //Dict.pl
        sAdr := 'http://www.dict.pl/plen?word=' + Win2ISO(sWord) + '&lang=PL';
        wbDict.Navigate(sAdr);

        //Ling.pl
        case cbLang.ItemIndex of
                0: sLang := '100';
                1: sLang := '1';
        end;
        sAdr := 'http://www.ling.pl/index.jsp?word=' + sWord + '&chooseLang=' + sLang;
        wbLing.Navigate(sAdr);

        //Google.com
        sAdr := 'http://www.google.com/search?q=' + Win2ISO(sWord);
        wbGoogle.Navigate(sAdr);

        //Getionary.pl
        case cbLang.ItemIndex of
                0: sLang := 'pol_ang';
                1: sLang := 'ang_pol';
        end;
        sAdr := 'http://www.getionary.pl/search?query=' + Win2ISO(sWord) + '&from=' + sLang;
        wbGetionary.Navigate(sAdr);

        //Angool.com
        sAdr := 'http://www.angool.com/search/index.php?query=' + Win2ISO(sWord);
        wbAngool.Navigate(sAdr);

        //Dictionary.pl
        sAdr := 'http://www.dictionary.pl/web/vocabulary/?query=' + Win2ISO(sWord);
        wbDictionary.Navigate(sAdr);

        //Translate.pl
        case cbLang.ItemIndex of
                0: sLang := '2';
                1: sLang := '1';
        end;
        sAdr := 'http://www.translate.pl/odp.php4?word=' + Win2ISO(sWord) + '&direction=' + sLang;
        wbTranslate.Navigate(sAdr);

        //Wikipedia
        case cbLang.ItemIndex of
                0: sLang := 'pl.';
                1: sLang := 'en.';
        end;
        sAdr := 'http://' + sLang + 'wikipedia.org/wiki/' + Win2ISO(sWord);
        wbWiki.Navigate(sAdr);

        //One Look
        case cbLang.ItemIndex of
                0:
                begin
                        lblOneLookInfo.Visible := True;
                        wbOneLook.Navigate('about:blank');
                        tsOneLook.ImageIndex := 0;
                end;
                1:
                begin
                        lblOneLookInfo.Visible := False;
                        sAdr := 'http://www.onelook.com/?ls=b&w=' + Win2ISO(sWord);
                        wbOneLook.Navigate(sAdr);
                end;
        end;

        //Merriam
        case cbLang.ItemIndex of
                0:
                begin
                        lblMerriamInfo.Visible := True;
                        wbMerriam.Navigate('about:blank');
                        tsMerriam.ImageIndex := 0;
                end;
                1:
                begin
                        lblMerriamInfo.Visible := False;
                        sAdr := 'http://www.m-w.com/dictionary/' + Win2ISO(sWord);
                        wbMerriam.Navigate(sAdr);
                end;
        end;

        //Cambridge
        case cbLang.ItemIndex of
                0:
                begin
                        lblCambridgeInfo.Visible := True;
                        wbCambridge.Navigate('about:blank');
                        tsCambridge.ImageIndex := 0;
                end;
                1:
                begin
                        lblCambridgeInfo.Visible := False;
                        sAdr := 'http://dictionary.cambridge.org/results.asp?searchword=' + Win2ISO(sWord);
                        wbCambridge.Navigate(sAdr);
                end;
        end;

        //eStr.Text := sAdr;

        eStr.SetFocus();

        Screen.Cursor := crDefault;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
        slSaver: TStringList;
        a: Integer;
begin
        cbLang.ItemIndex := 0;

        if FileExists('LastPhrasesList.dat') then cbList.Items.LoadFromFile('LastPhrasesList.dat');

        if not FileExists('Settings.dat') then exit;
        slSaver := TStringList.Create;
        slSaver.LoadFromFile('Settings.dat');
        eStr.Text := slSaver.Values['Phrase'];
        cbLang.ItemIndex := StrToIntDef(slSaver.Values['Lang'], 0);
        pgMain.ActivePageIndex := StrToIntDef(slSaver.Values['Tab'], 0);
        chbAuto.Checked := (StrToIntDef(slSaver.Values['AutoSelect'], 0) = 1);
        slSaver.Free;

        for a := 0 to 20 do
        begin
                CanGoBack[a] := False;
                CanGoForward[a] := False;
        end;

        HomeAddress[0, 0] := 'http://www.dict.pl/plen?lang=PL';
        HomeAddress[1, 0] := 'http://www.dict.pl/plen?lang=EN';
        HomeAddress[0, 1] := 'http://www.angool.com/';
        HomeAddress[1, 1] := 'http://www.angool.com/';
        HomeAddress[0, 2] := 'http://portalwiedzy.onet.pl/tlumacz.html?tr=pol-ang';
        HomeAddress[1, 2] := 'http://portalwiedzy.onet.pl/tlumacz.html?tr=ang-pol';
        HomeAddress[0, 3] := 'http://www.google.pl/';
        HomeAddress[1, 3] := 'http://www.google.com/';
        HomeAddress[0, 4] := 'http://www.getionary.pl/';
        HomeAddress[1, 4] := 'http://www.getionary.pl/';
        HomeAddress[0, 5] := 'http://www.ling.pl/';
        HomeAddress[1, 5] := 'http://www.ling.pl/';
        HomeAddress[0, 6] := 'http://www.dictionary.pl/web/';
        HomeAddress[1, 6] := 'http://www.dictionary.pl/web/';
        HomeAddress[0, 7] := 'http://www.translate.pl/';
        HomeAddress[1, 7] := 'http://www.translate.pl/';
        HomeAddress[0, 8] := 'http://pl.wikipedia.org/';
        HomeAddress[1, 8] := 'http://en.wikipedia.org/';
        HomeAddress[0, 9] := 'about:blank';
        HomeAddress[1, 9] := 'http://www.m-w.com/';
        HomeAddress[0, 10] := 'about:blank';
        HomeAddress[1, 10] := 'http://dictionary.cambridge.org/';
        HomeAddress[0, 11] := 'about:blank';
        HomeAddress[1, 11] := 'http://www.onelook.com/';
end;

procedure TMainForm.tiMaximizeTimer(Sender: TObject);
begin
        MainForm.WindowState := wsMaximized;
        tiMaximize.Enabled := False;
end;

 procedure TMainForm.WebBrowserProgressChange(Sender: TObject; Progress, ProgressMax: Integer);
var
        iPerc: Integer;
begin
        if (Progress > 0) and (Progress < ProgressMax) then
        begin
                iPerc := Round(((Progress * 100) div ProgressMax) / 10);
                if (iPerc > 0) and (iPerc < 11) then pgMain.Pages[(Sender as TWebBrowser).Tag].ImageIndex := iPerc;
        end;

        if Progress = ProgressMax then pgMain.Pages[(Sender as TWebBrowser).Tag].ImageIndex := 11;
end;

procedure TMainForm.ResetTabs();
var
        a: Integer;
begin
        for a := 0 to pgMain.PageCount - 1 do pgMain.Pages[a].ImageIndex := 0;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
        ResetTabs();
end;

procedure TMainForm.btnClearListClick(Sender: TObject);
begin
        if Application.MessageBox('Are you sure, you want to delete all items?','Confirm...',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) = ID_NO then exit;

        cbList.Clear;
        cbList.Items.SaveToFile('LastPhrasesList.dat');
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
        slSaver: TStringList;
begin
        slSaver := TStringList.Create;
        slSaver.Values['Phrase'] := eStr.Text;
        slSaver.Values['Lang'] := IntToStr(cbLang.ItemIndex);
        slSaver.Values['Tab'] := IntToStr(pgMain.ActivePageIndex);
        slSaver.Values['AutoSelect'] := IntToStr(Ord(chbAuto.Checked));
        slSaver.SaveToFile('Settings.dat');
        slSaver.Free;

        cbList.Items.SaveToFile('LastPhrasesList.dat');
end;

procedure TMainForm.cbListClick(Sender: TObject);
var
        sElem: String;
begin
        sElem := cbList.Items[cbList.ItemIndex];

        eStr.Text := Copy(sElem, 1, Pos('[', sElem) - 2);
        eStr.SetFocus();

        if Copy(sElem, Pos('[', sElem) + 1, 2) = 'PL' then cbLang.ItemIndex := 0 else cbLang.ItemIndex := 1;

        if chbAuto.Checked then btnGoClick(self);
end;

function TMainForm.Win2ISO(const sWin: String): String;
var
        c: Char;
        i: Integer;
begin
        Result := '';

        for i := 1 to Length(sWin) do
        begin
                case sWin[i] of
                        '¹' : c := #177;
                        'œ' : c := #182;
                        'Ÿ' : c := #188;
                        '¥' : c := #161;
                        'Œ' : c := #166;
                        '' : c := #172;
                else c := sWin[i];
                end;
                Result := Result + c;
        end;
end;

procedure TMainForm.btnRememberClick(Sender: TObject);
var
        sWord, sAdr, sLang: String;
begin
        if eStr.Text = '' then
        begin
                Application.MessageBox('Empty search phrase!','Error!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                exit;
        end;

        sWord := eStr.Text;

        //Wio na listê...
        case cbLang.ItemIndex of
                0: sLang := ' [PL --> EN]';
                1: sLang := ' [EN --> PL]';
        end;
        sAdr := sWord + sLang;
        if cbList.Items.IndexOf(sAdr) = -1 then cbList.Items.Text := sAdr + chr(13) + cbList.Items.Text;
end;

procedure TMainForm.cbListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
        if Key = VK_Delete then cbList.Items.Delete(cbList.ItemIndex);
end;

procedure TMainForm.pgMainChange(Sender: TObject);
var
        i: Integer;
begin
        sbBack.Enabled := CanGoBack[pgMain.ActivePageIndex];
        sbForward.Enabled := CanGoForward[pgMain.ActivePageIndex];

        for i := 0 to MainForm.ComponentCount - 1 do
        begin
                if MainForm.Components[i] is TWebBrowser then
                begin
                        if (MainForm.Components[i] as TWebBrowser).Tag = pgMain.activePageIndex then
                        begin
                                with (MainForm.Components[i] as TWebBrowser) do
                                begin
                                        sbStop.Enabled := Busy;
                                        sbRefresh.Enabled := not (Document = nil);
                                end;
                        end;
                end;
        end;
end;

procedure TMainForm.ButtonNavigateMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
        i: Integer;
begin
        (Sender as TSpeedButton).Down := False;
        
        for i := 0 to MainForm.ComponentCount - 1 do
        begin
                if MainForm.Components[i] is TWebBrowser then
                begin
                        if (ssCtrl in Shift) or ((MainForm.Components[i] as TWebBrowser).Tag = pgMain.ActivePageIndex) then
                        begin
                                with (MainForm.Components[i] as TWebBrowser) do
                                begin
                                        case (Sender as TSpeedButton).Tag of
                                                1: if not (ssCtrl in Shift) then GoBack();
                                                2: if not (ssCtrl in Shift) then GoForward();
                                                3: Refresh();
                                                4: Stop();
                                                5: Navigate(HomeAddress[cbLang.ItemIndex, pgMain.ActivePageIndex]);
                                        end;
                                end;
                        end;
                end;
        end;
end;

procedure TMainForm.WebBrowserCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
begin
        case Command of
                CSC_NAVIGATEFORWARD: CanGoForward[(Sender as TWebBrowser).Tag] := Enable;
                CSC_NAVIGATEBACK: CanGoBack[(Sender as TWebBrowser).Tag] := Enable;
        end;

        pgMainChange(self);
end;

initialization OleInitialize(nil);

finalization OleUninitialize;

end.
