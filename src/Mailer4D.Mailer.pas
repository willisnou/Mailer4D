unit Mailer4D.Mailer;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.RegularExpressions,
  System.NetEncoding,
  Mailer4D.Mailer.Interfaces,
  Mailer4D.Commons,
  IdSMTP,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdSSLOpenSSLHeaders,
  IdMessage,
  IdText,
  IdAttachmentFile;


type
  IMailer = Mailer4D.Mailer.Interfaces.IMailer;

  TMailer = class(TInterfacedObject, IMailer)
  strict private const
    C_CONNECT_TIMEOUT = 60000;
    C_READ_TIMEOUT    = 60000;
  strict private
    FSocket          : TIdSMTP;
    FSocketSSL       : TIdSSLIOHandlerSocketOpenSSL;
    FSSLLibPath      : String;
    FConnectCallback : TProc<Boolean>;
    FSentCallback    : TProc<Boolean>;
    FMessage         : TIdMessage;
    FTextParts       : TIdText;
    FAttachmentParts : TIdAttachmentFile;
    FListRecipients  : TStrings;
    FListRepliesTo   : TStrings;
    FListCC          : TStrings;
    FListBCC         : TStrings;
    FListAttachments : TStrings;
    FReceiptRecipient: Boolean;

    procedure Defaults;
    procedure ResetMessage;
    procedure HandleMsgMIME;
    procedure HandleInlineImages;
    procedure Prepare;

  private
    function AddRecipient(const AAddress: String; const AName: String) : IMailer;  overload;  // message Stuff //
    function AddRecipient(const AAddress: String)                      : IMailer;  overload;
    function ListRecipients                                            : TStrings;
    function From(const AAddress: String; const AName: String)         : IMailer;  overload;
    function From(const AAddress: String)                              : IMailer;  overload;
    function From                                                      : String;   overload;
    function Subject(const ASubject: String)                           : IMailer;  overload;
    function Subject                                                   : String;   overload;
    function ReceiptRecipient(const AValue: Boolean)                   : IMailer;  overload;
    function ReceiptRecipient                                          : Boolean;  overload;
    function AddReplyTo(const AAddress: String; const AName: String)   : IMailer;  overload;
    function AddReplyTo(const AAddress: String)                        : IMailer;  overload;
    function ListRepliesTo                                             : TStrings; overload;
    function AddCC(const AAddress: String; const AName: String)        : IMailer;  overload;
    function AddCC(const AAddress: String)                             : IMailer;  overload;
    function ListCC                                                    : TStrings; overload;
    function AddBCC(const AAddress: String; const AName: String)       : IMailer;  overload;
    function AddBCC(const AAddress: String)                            : IMailer;  overload;
    function ListBCC                                                   : TStrings; overload;
    function AddBody(const AValue: String; const AContentType: String) : IMailer;  overload;
    function AddBody(const AValue: String)                             : IMailer;  overload;
    function Body                                                      : String;
    function AddAttachment(const AFilename: String; ATempFile: Boolean): IMailer;  overload;
    function AddAttachment(const AFilename: String)                    : IMailer;  overload;
    function RemoveAttachment(const AFilename: String)                 : IMailer;
    function ListAttachments                                           : TStrings;
    function MessageContentType(const AValue: String)                  : IMailer;  overload;
    function MessageContentType                                        : String;   overload;
    function Clear                                                     : IMailer;
    function ClearRecipients                                           : IMailer;
    function ClearRepliesTo                                            : IMailer;
    function ClearCC                                                   : IMailer;
    function ClearBCC                                                  : IMailer;
    function ClearBody                                                 : IMailer;
    function ClearAttachments                                          : IMailer;
    function Host(const AHost: String)                                 : IMailer;  overload; // setting stuff //
    function Host                                                      : String;   overload;
    function Username(const AUserName: String)                         : IMailer;  overload;
    function Username                                                  : String;   overload;
    function Password(const APassword: String)                         : IMailer;  overload;
    function Password                                                  : String;   overload;
    function Port(const APort: Word)                                   : IMailer;  overload;
    function Port                                                      : Word;     overload;
    function Auth(const AValue: Boolean)                               : IMailer;  overload;
    function Auth                                                      : Boolean;  overload;
    function TLS(const AValue: Boolean)                                : IMailer;  overload;
    function TLS                                                       : Boolean;  overload;
    function TLSLibraryPath(const APath: String)                       : IMailer;  overload;
    function TLSLibraryPath                                            : String;   overload;
    function ConnectTimeout(const ATimeout: Integer)                   : IMailer;  overload;
    function ConnectTimeout                                            : Integer;  overload;
    function ReadTimeout(const ATimeout: Integer)                      : IMailer;  overload;
    function ReadTimeout                                               : Integer;  overload;
    function Connect: Boolean;
    procedure ConnectAsynch(const AConnectCallback: TProc<Boolean>); overload;
    procedure ConnectAsynch; overload;
    function Connected: Boolean;
    function Disconnect: Boolean;
    function Send: Boolean;
    procedure SendAsynch(const ASentCallback: TProc<Boolean>); overload;
    procedure SendAsynch; overload;

  public
    class function New: IMailer;
    constructor Create;
    destructor Destroy; override;

  end;

implementation

{ TMailer }

class function TMailer.New: IMailer;
begin
  Result:= Self.Create;
end;

constructor TMailer.Create;
begin
  FSocket         := TIdSMTP.Create(nil);
  FSocketSSL      := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FListRecipients := TStringList.Create;
  FListRepliesTo  := TStringList.Create;
  FListCC         := TStringList.Create;
  FListBCC        := TStringList.Create;
  FListAttachments:= TStringList.Create;
  ResetMessage;
  Defaults;
end;

destructor TMailer.Destroy;
begin
  Self.Disconnect;
  if Assigned(FTextParts) then
    FreeAndNil(FTextParts);
  if Assigned(FAttachmentParts) then
    FreeAndNil(FAttachmentParts);
  if Assigned(FMessage) then
    FreeAndNil(FMessage);
  if Assigned(FSocket) then
    FreeAndNil(FSocket);
  if Assigned(FSocketSSL) then
    FreeAndNil(FSocketSSL);
  if Assigned(FListRecipients) then
    FreeAndNil(FListRecipients);
  if Assigned(FListRepliesTo) then
    FreeAndNil(FListRepliesTo);
  if Assigned(FListCC) then
    FreeAndNil(FListCC);
  if Assigned(FListBCC) then
    FreeAndNil(FListBCC);
  if Assigned(FListAttachments) then
    FreeAndNil(FListAttachments);

  inherited;
end;

procedure TMailer.Defaults;
begin
  Self.ConnectTimeout(C_CONNECT_TIMEOUT);
  Self.ReadTimeout(C_READ_TIMEOUT);
  Self.Auth(False);
  Self.TLS(False);
  FSocket.IOHandler           := FSocketSSL;
  FSocket.UseEhlo             := True;             {used to discover STARTTLS command}
  FSocketSSL.SSLOptions.Method:= sslvSSLv23;
  FSocketSSL.SSLOptions.Mode  := sslmClient;
  FSocketSSL.ConnectTimeout   := C_CONNECT_TIMEOUT;
  FSocketSSL.ReadTimeout      := C_READ_TIMEOUT;
end;

procedure TMailer.ResetMessage;
begin
  if Assigned(FTextParts) then
    FreeAndNil(FTextParts);
  if Assigned(FAttachmentParts) then
    FreeAndNil(FAttachmentParts);
  if Assigned(FMessage) then
    FreeAndNil(FMessage);
  FListRecipients.Clear;
  FListRepliesTo.Clear;
  FListCC.Clear;
  FListBCC.Clear;
  FListAttachments.Clear;
  FReceiptRecipient:= False;
  FMessage         := TIdMessage.Create(nil);
  FMessage.Encoding:= meMIME;
  FMessage.CharSet := 'utf-8';
  HandleMsgMIME;                       {MIME the message content type}
end;

procedure TMailer.HandleMsgMIME;
begin
  FMessage.MessageParts.CountParts;
  if FMessage.MessageParts.AttachmentCount > 0 then     {default attachment content type}
    FMessage.ContentType:= 'multipart/mixed'
  else if FMessage.MessageParts.TextPartCount > 0 then  {default text content type}
    FMessage.ContentType:= 'multipart/alternative';
end;

procedure TMailer.HandleInlineImages;
var
  LStream: TBytesStream;
  LCid: String;
begin
  {indy or most mail clients cant handle inline base64 images, so we get around referencing by cid and attaching them}
  FMessage.MessageParts.CountParts;
  if FMessage.MessageParts.TextPartCount > 0 then
  begin
    for var I := Pred(FMessage.MessageParts.Count-1) downto 0 do
      if TIdText(FMessage.MessageParts.Items[I]).ContentType.Contains('text/html') then
      begin
        for var LMatch in MatchInlineImages(TIdText(FMessage.MessageParts.Items[I]).Body.Text) do
        begin
          LStream:= TBytesStream.Create(TNetEncoding.Base64.DecodeStringToBytes(Base64Src(LMatch.Value)));
          try
            LCid:= FormatDateTime('yyyymmddhhnnsszzz', Now);
            FAttachmentParts:= TIdAttachmentFile.Create(FMessage.MessageParts);
            FAttachmentParts.LoadFromStream(LStream);
            FAttachmentParts.ContentType:= Format('image/%s', [Base64Extension(LMatch.Value)]);
            FAttachmentParts.ContentDisposition:= 'inline';
            FAttachmentParts.ExtraHeaders.Values['content-id']:= LCid;
            TIdText(FMessage.MessageParts.Items[I]).Body.Text:= StringReplace(TIdText(FMessage.MessageParts.Items[I]).Body.Text,
                                                                              LMatch.Value,
                                                                              Format('src="cid:%s"', [LCid]), [rfIgnoreCase]);
          finally
            FreeAndNil(LStream);
          end;
        end;
      end;

  end;
end;

procedure TMailer.Prepare;
begin
  if (FMessage.Recipients.Count > 0) then
    if not (FSocket.Host.Trim.IsEmpty) then
      if not (FSocket.UserName.Trim.IsEmpty) then
        if not (FSocket.Password.Trim.IsEmpty) then
          if not (FSocket.Port > 0) then
            raise Exception.Create('Before send a message you must have recipients and set SMTP.');
end;

function TMailer.AddRecipient(const AAddress, AName: String): IMailer;
begin
  Result:= Self;
  with FMessage.Recipients.Add do
  begin
    Address:= AAddress;
    Name   := AName;
  end;
end;

function TMailer.AddRecipient(const AAddress: String): IMailer;
begin
  Result:= Self.AddRecipient(AAddress, '');
end;

function TMailer.ListRecipients: TStrings;
begin
  FListRecipients.Clear;
  FMessage.Recipients.FillTStrings(FListRecipients);
  Result:= FListRecipients;
end;

function TMailer.From(const AAddress, AName: String): IMailer;
begin
  Result               := Self;
  FMessage.From.Address:= AAddress;
  FMessage.From.Name   := AName;
end;

function TMailer.From(const AAddress: String): IMailer;
begin
  Result:= Self.From(AAddress, '');
end;

function TMailer.From: String;
begin
  Result:= FMessage.From.Address;
end;

function TMailer.Subject(const ASubject: String): IMailer;
begin
  Result          := Self;
  FMessage.Subject:= ASubject;
end;

function TMailer.Subject: String;
begin
  Result:= FMessage.Subject;
end;

function TMailer.ReceiptRecipient(const AValue: Boolean): IMailer;
begin
  Result:= Self;
  FReceiptRecipient:= AValue;
end;

function TMailer.ReceiptRecipient: Boolean;
begin
  Result:= FReceiptRecipient;
end;

function TMailer.AddReplyTo(const AAddress, AName: String): IMailer;
begin
  Result:= Self;
  with FMessage.ReplyTo.Add do
  begin
    Address:= Aaddress;
    Name   := AName;
  end;
end;

function TMailer.AddReplyTo(const AAddress: String): IMailer;
begin
  Result:= Self.AddReplyTo(AAddress, '');
end;

function TMailer.ListRepliesTo: TStrings;
begin
  FListRepliesTo.Clear;
  FMessage.ReplyTo.FillTStrings(FListRepliesTo);
  Result:= FListRepliesTo;
end;

function TMailer.AddCC(const AAddress, AName: String): IMailer;
begin
  Result:= Self;
  with FMessage.CCList.Add do
  begin
    Address:= AAddress;
    Name   := AName;
  end;
end;

function TMailer.AddCC(const AAddress: String): IMailer;
begin
  Result:= Self.AddCC(AAddress, '');
end;

function TMailer.ListCC: TStrings;
begin
  FListCC.Clear;
  FMessage.CCList.FillTStrings(FListCC);
  Result:= FListCC;
end;

function TMailer.AddBCC(const AAddress, AName: String): IMailer;
begin
  Result:= Self;
  with FMessage.BCCList.Add do
  begin
    Address:= AAddress;
    Name   := AName;
  end;
end;

function TMailer.AddBCC(const AAddress: String): IMailer;
begin
  Result:= AddBCC(AAddress, '');
end;

function TMailer.ListBCC: TStrings;
begin
  FListBCC.Clear;
  FMessage.BCCList.FillTStrings(FListBCC);
  Result:= FListBCC;
end;

function TMailer.AddBody(const AValue, AContentType: String): IMailer;
begin
  Result                := Self;
  FTextParts            := TIdText.Create(FMessage.MessageParts);
  FTextParts.ContentType:= AContentType;
  FTextParts.Body.Text  := AValue;
end;

function TMailer.AddBody(const AValue: String): IMailer;
begin
  Result:= Self.AddBody(AValue, 'text/html');
end;

function TMailer.Body: String;
begin
  Result:= FMessage.Body.Text;
end;

function TMailer.AddAttachment(const AFilename: String; ATempFile: Boolean): IMailer;
begin
  Result                         := Self;
  FAttachmentParts               := TIdAttachmentFile.Create(FMessage.MessageParts, AFilename);
  FAttachmentParts.FileIsTempFile:= ATempFile;
  FAttachmentParts.FileName      := TPath.GetFileName(AFilename);

  FListAttachments.Add(AFilename);
end;

function TMailer.AddAttachment(const AFilename: String): IMailer;
begin
  Result:= Self.AddAttachment(AFilename, False);
end;

function TMailer.RemoveAttachment(const AFilename: String): IMailer;
begin
  Result:= Self;
  for var I := Pred(FMessage.MessageParts.Count) downto 0 do
  begin
    if FMessage.MessageParts[I] is TIdAttachmentFile then
      if (TIdAttachmentFile(FMessage.MessageParts[I]).FileName = AFilename) then
      begin
        FMessage.MessageParts.Delete(I);
        Exit;
      end;
  end;

  FListAttachments.Delete(FListAttachments.IndexOf(AFilename));
end;

function TMailer.ListAttachments: TStrings;
begin
  Result:= FListAttachments;
end;

function TMailer.MessageContentType(const AValue: String): IMailer;
begin
  Result:= Self;
  FMessage.ContentType:= AValue;
end;

function TMailer.MessageContentType: String;
begin
  Result:= FMessage.ContentType;
end;

function TMailer.Clear: IMailer;
begin
  Result:= Self;
  ResetMessage;
end;

function TMailer.ClearRecipients: IMailer;
begin
  Result:= Self;
  FMessage.Recipients.Clear;
end;

function TMailer.ClearRepliesTo: IMailer;
begin
  Result:= Self;
  FMessage.ReplyTo.Clear;
end;

function TMailer.ClearCC: IMailer;
begin
  Result:= Self;
  FMessage.CCList.Clear;
end;

function TMailer.ClearBCC: IMailer;
begin
  Result:= Self;
  FMessage.BCCList.Clear;
end;

function TMailer.ClearBody: IMailer;
begin
  Result:= Self;
  FMessage.Body.Clear;
end;

function TMailer.ClearAttachments: IMailer;
begin
  Result:= Self;
  for var I := Pred(FMessage.MessageParts.Count) downto 0 do
  begin
    if FMessage.MessageParts[I] is TIdAttachmentFile then
      FMessage.MessageParts.Delete(I);
  end;
end;

function TMailer.Host(const AHost: String): IMailer;
begin
  Result      := Self;
  FSocket.Host:= AHost;
end;

function TMailer.Host: String;
begin
  Result:= FSocket.Host;
end;

function TMailer.Username(const AUserName: String): IMailer;
begin
  Result          := Self;
  FSocket.Username:= AUserName;
end;

function TMailer.Username: String;
begin
  Result:= FSocket.Username;
end;

function TMailer.Password(const APassword: String): IMailer;
begin
  Result          := Self;
  FSocket.Password:= APassword;
end;

function TMailer.Password: String;
begin
  Result:= FSocket.Password;
end;

function TMailer.Port(const APort: Word): IMailer;
begin
  Result      := Self;
  FSocket.Port:= APort;
end;

function TMailer.Port: Word;
begin
  Result:= FSocket.Port;
end;

function TMailer.Auth(const AValue: Boolean): IMailer;
begin
  Result:= Self;
  case AValue of
    True : FSocket.AuthType:= satDefault;
    False: FSocket.AuthType:= satNone;
  end;
end;

function TMailer.Auth: Boolean;
begin
  Result:= False;
  case FSocket.AuthType of
    satNone   : Result:= False;
    satDefault: Result:= True;
    satSASL   : Result:= True;
  end;
end;

function TMailer.TLS(const AValue: Boolean): IMailer;
begin
  Result:= Self;
  case AValue of
    True : FSocket.UseTLS:= utUseRequireTLS;
    False: FSocket.UseTLS:= utNoTLSSupport;
  end;
end;

function TMailer.TLS: Boolean;
begin
  Result:= False;
  case FSocket.UseTLS of
    utNoTLSSupport  : Result:= False;
    utUseImplicitTLS: Result:= True;
    utUseRequireTLS : Result:= True;
    utUseExplicitTLS: Result:= False;
  end;
end;

function TMailer.TLSLibraryPath(const APath: String): IMailer;
begin
  Result:= Self;
  FSSLLibPath:= APath;
  IdOpenSSLSetLibPath(APath);
end;

function TMailer.TLSLibraryPath: String;
begin
  Result:= FSSLLibPath;
end;

function TMailer.ConnectTimeout(const ATimeout: Integer): IMailer;
begin
  Result                := Self;
  FSocket.ConnectTimeout:= ATimeout;
end;

function TMailer.ConnectTimeout: Integer;
begin
  Result:= FSocket.ConnectTimeout;
end;

function TMailer.ReadTimeout(const ATimeout: Integer): IMailer;
begin
  Result             := Self;
  FSocket.ReadTimeout:= ATimeout;
end;

function TMailer.ReadTimeout: Integer;
begin
  Result:= FSocket.ReadTimeout;
end;

function TMailer.Connect: Boolean;
begin
  Result:= False;
  try
    {connect to SMTP server}
    try
      if not (FSocket.Connected) then
        FSocket.Connect;
    except
      raise Exception.Create(Format('Error connect attempt to %s on port %d: %s%s', [FSocket.Host, FSocket.Port, sLineBreak, Exception(ExceptObject).Message]));
    end;

    {TLS handshake + auth to server with credentials}
    try
      FSocket.Authenticate;
    except
      on E: EIdTLSClientTLSHandShakeFailed do
      begin
        Self.Disconnect;
        FSocket.UseTLS:= utUseImplicitTLS;
        FSocket.Connect;
        Exit;
      end;

      on E: EIdTLSClientTLSNotAvailable do
      begin
        Self.Disconnect;
        raise Exception.Create(Format('SSL or TLS not available on SMPT server: %s%s', [sLineBreak, Exception(ExceptObject).Message]));
        Exit;
      end;

      on E: Exception do
      begin
        Self.Disconnect;
        raise Exception.Create(Format('Error during authentication or TLS negotiation attempt: %s%s', [sLineBreak, Exception(ExceptObject).Message]));
        Exit;
      end;
    end;
    Result:= True;

  finally
    if Assigned(FConnectCallback) then
      FConnectCallback(Result);
  end;
end;

procedure TMailer.ConnectAsynch(const AConnectCallback: TProc<Boolean>);
begin
  if Assigned(AConnectCallback) then
    FConnectCallback:= AConnectCallback;
  Self.ConnectAsynch;
end;

procedure TMailer.ConnectAsynch;
begin
  TThread.CreateAnonymousThread(
                                procedure
                                begin
                                  Self.Connect;
                                end);
end;

function TMailer.Connected: Boolean;
begin
  Result:= FSocket.Connected;
end;

function TMailer.Disconnect: Boolean;
begin
  if FSocket.Connected then
    FSocket.Disconnect;
  Result:= True;
end;

function TMailer.Send: Boolean;
begin
  Result:= False;
  try
    Prepare;

    if not (Self.Connected) then
      Self.Connect;

    try
      HandleMsgMIME;                    {MIME message content type before send}
      HandleInlineImages;               {handle existing inline images in 'text/html' parts}

      if FReceiptRecipient then
        FMessage.ReceiptRecipient.Text:= FMessage.From.Address;

      FSocket.Send(FMessage);

    except
      raise Exception.Create(Format('Error during sending mail attempt: %s', [Exception(ExceptObject).Message]));
    end;
    Self.ResetMessage;
    Result:= True;

  finally
    if Assigned(FSentCallback) then
      FSentCallback(Result);
  end;
end;

procedure TMailer.SendAsynch(const ASentCallback: TProc<Boolean>);
begin
  if Assigned(ASentCallback) then
    FSentCallback:= ASentCallback;
  Self.SendAsynch;
end;

procedure TMailer.SendAsynch;
begin
  TThread.CreateAnonymousThread(
                                procedure
                                begin
                                  Self.Send;
                                end);
end;

end.
