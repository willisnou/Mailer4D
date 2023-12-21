unit Mailer4D.Mailer.Interfaces;

interface

uses
  System.Classes,
  System.SysUtils;

type
  IMailer = interface ['{24CC4F06-D558-4A4C-B646-67C4F377220D}']
    function AddRecipient(const AAddress: String; const AName: String) : IMailer;  overload;  {message stuff}
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
    function Host(const AHost: String)                                 : IMailer;  overload; {settings stuff}
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
    function Send: Boolean;
    procedure SendAsynch(const ASentCallback: TProc<Boolean>); overload;
    procedure SendAsynch; overload;
    function Connect: Boolean;
    procedure ConnectAsynch(const AConnectCallback: TProc<Boolean>); overload;
    procedure ConnectAsynch; overload;
    function Connected: Boolean;
    function Disconnect: Boolean;
  end;

implementation

end.
