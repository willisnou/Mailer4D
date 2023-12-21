unit Mailer4D.View.Sample;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils;

type
  TfrmSample = class(TForm)
    btnConnect: TButton;
    btnSend: TButton;
    pnlClient: TPanel;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    pnlLeftTop: TPanel;
    pnlRigtTop: TPanel;
    lbHost: TLabel;
    edtHost: TEdit;
    edtUsername: TEdit;
    lbUsername: TLabel;
    edtPassword: TEdit;
    lbPassword: TLabel;
    edtFrom: TEdit;
    lbFrom: TLabel;
    edtPort: TEdit;
    lbPort: TLabel;
    cbAuth: TCheckBox;
    cbEncryption: TCheckBox;
    edtRecipient: TEdit;
    lbRecipient: TLabel;
    btnAddRecipient: TButton;
    btnListRecipients: TButton;
    lbCC: TLabel;
    edtCC: TEdit;
    btnAddCc: TButton;
    btnListCC: TButton;
    edtRecipientName: TEdit;
    lbRecipientName: TLabel;
    edtCcName: TEdit;
    lbCcName: TLabel;
    lbCCO: TLabel;
    edtCCO: TEdit;
    edtCcoName: TEdit;
    lbCcoName: TLabel;
    btnAddCCO: TButton;
    btnListCCO: TButton;
    edtSubject: TEdit;
    lbSubject: TLabel;
    listAttachments: TListBox;
    btnAddAttachment: TButton;
    lbAttachments: TLabel;
    cbReceiptRecipient: TCheckBox;
    btnRemoveAttachment: TButton;
    mmBody: TMemo;
    lbBody: TLabel;
    edtContentType: TEdit;
    lbContentType: TLabel;
    TimerConnStatus: TTimer;
    lbConnectionStatus: TLabel;
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnAddRecipientClick(Sender: TObject);
    procedure btnListRecipientsClick(Sender: TObject);
    procedure btnAddCcClick(Sender: TObject);
    procedure btnListCCClick(Sender: TObject);
    procedure btnAddCCOClick(Sender: TObject);
    procedure btnListCCOClick(Sender: TObject);
    procedure btnAddAttachmentClick(Sender: TObject);
    procedure btnRemoveAttachmentClick(Sender: TObject);
    procedure listAttachmentsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerConnStatusTimer(Sender: TObject);
  private
    FAvoidConnected   : Boolean;
    FAvoidDisconnected: Boolean;
  public
    { Public declarations }
  end;

var
  frmSample: TfrmSample;

implementation

uses
  Mailer4D.Mailer;

var
  Mailer: IMailer;

{$R *.dfm}

procedure TfrmSample.btnAddRecipientClick(Sender: TObject);
begin
  Mailer.AddRecipient(edtRecipient.Text, edtRecipientName.Text);
  edtRecipient.Clear;
  edtRecipientName.Clear;
end;

procedure TfrmSample.btnListRecipientsClick(Sender: TObject);
begin
  ShowMessage(Mailer.ListRecipients.CommaText);
end;

procedure TfrmSample.btnAddCcClick(Sender: TObject);
begin
  Mailer.AddCC(edtCC.Text, edtCcName.Text);
  edtCC.Clear;
  edtCcName.Clear;
end;

procedure TfrmSample.btnListCCClick(Sender: TObject);
begin
  ShowMessage(Mailer.ListCC.CommaText);
end;

procedure TfrmSample.btnAddCCOClick(Sender: TObject);
begin
  Mailer.AddBCC(edtCCO.Text, edtCcoName.Text);
  edtCCO.Clear;
  edtCCOName.Clear;
end;

procedure TfrmSample.btnListCCOClick(Sender: TObject);
begin
  ShowMessage(Mailer.ListBCC.CommaText);
end;

procedure TfrmSample.btnAddAttachmentClick(Sender: TObject);
var
  LOpenDlg: TFileOpenDialog;
begin
  LOpenDlg:= TFileOpenDialog.Create(nil);
  try
    LOpenDlg.Options := [fdoAllowMultiSelect];
    LOpenDlg.DefaultFolder := TPath.GetDocumentsPath;
    if LOpenDlg.Execute then
      listAttachments.Items.AddStrings(LOpenDlg.Files);
  finally
    FreeAndNil(LOpenDlg);
  end;
end;

procedure TfrmSample.btnRemoveAttachmentClick(Sender: TObject);
begin
  if not (listAttachments.ItemIndex <> -1) then
    Exit;
  Mailer.RemoveAttachment(listAttachments.Items[listAttachments.ItemIndex]);
  listAttachments.DeleteSelected;
end;

procedure TfrmSample.listAttachmentsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    btnRemoveAttachmentClick(Self);
end;

procedure TfrmSample.TimerConnStatusTimer(Sender: TObject);
begin
  if (Mailer.Connected) and (not (FAvoidConnected)) then
  begin
    FAvoidConnected:= True;
    lbConnectionStatus.Caption:= 'Connected';
    lbConnectionStatus.Font.Color:= clGreen;
  end
  else if (not (Mailer.Connected)) and (not (FAvoidDisconnected)) then
  begin
    FAvoidDisconnected:= True;
    lbConnectionStatus.Caption:= 'Disconnected';
    lbConnectionStatus.Font.Color:= clRed;
  end;
end;

procedure TfrmSample.btnConnectClick(Sender: TObject);
begin
  Mailer.Host(edtHost.Text).
         Port(StrToInt(edtPort.Text)).
         Username(edtUsername.Text).
         Password(edtPassword.Text).
         From(edtFrom.Text).
         Auth(cbAuth.Checked).
         TLS(cbEncryption.Checked).
  Connect;
end;

procedure TfrmSample.btnSendClick(Sender: TObject);
begin
  for var I := Pred(listAttachments.Items.Count) downto 0 do
    Mailer.AddAttachment(listAttachments.Items[I]);

  Mailer.
         Subject(edtSubject.Text).
         ReceiptRecipient(cbReceiptRecipient.Checked).
         AddBody(mmBody.Lines.Text, edtContentType.Text);

  if Mailer.Send then
  begin
    edtSubject.Clear;
    mmBody.Clear;
    edtContentType.Clear;
    listAttachments.Clear;
    ShowMessage('Sent.');
  end
  else
    ShowMessage('Sent attempt failure.');
end;

procedure TfrmSample.FormCreate(Sender: TObject);
begin
  Mailer:= TMailer.New;
  FAvoidConnected   := False;
  FAvoidDisconnected:= False;
end;

end.
