<p align="center">
  <img src="https://github.com/willisnou/Mailer4D/blob/main/resources/logo%20JPG.jpg"><br>
  Mailer4D is a minimalist Delphi framework to configure a SMTP client and send email messages.<br>Also natively supports inline (base64) images for html messages.<br>
</p>

## Requisites
`[Required]` For SSL/TLS support libeay32.dll and ssleay32.dll is required, check out OpenSSL folder.

## Instalation
`[Optional]` [**Boss**](https://github.com/HashLoad/boss) instalation:
```
boss install github.com/willisnou/Mailer4D
```
`[Manual]` For manual installation add the `../Mailer4D/src` directory on library path in **Tools** > **Options** > **Language** > **Delphi** > **Library** > **Library Path** _or_ add the files manually to the project in **Project** > **Add to Project...** menu.

## Getting started
```delphi
uses Mailer4D.Mailer;
```

## Sending an email message
```delphi
var
  Mailer: IMailer;

begin
  Mailer:= TMailer.New;

  Mailer.
    .Host('smtp.host.com')
    .Port(587)
    .Username('username@example.com')
    .Password('user_password')
    .TLS(True)
    .Auth(True)
    .From('from@example.com', 'from name')
    .AddRecipient('recipient@example.com')
    .AddCC('cc@example.com')
    .AddBCC('cco@example.com')
    .ReceiptRecipient(False)
    .Subject('email subject')
    .AddBody('email body part', 'message part content-type')
    .AddAttachment('..\.\attachment.txt')
.Send;
end;
```

## Sending an `asynchronous` email message
Define a callback of `TProc<Boolean>`:
```delphi
procedure SentStatusCallback(ASent: Boolean);
begin
// TODO
end;
```
And then use `SendAsynch` method with the callback as parameter.
```delphi
var
  Mailer: IMailer;

begin
  Mailer:= TMailer.New;

  Mailer.
    .Host('smtp.host.com')
    .Port(587)
    .Username('username@example.com')
    .Password('user_password')
    .TLS(True)
    .Auth(True)
    .From('from@example.com', 'from name')
    .AddRecipient('recipient@example.com')
    .AddCC('cc@example.com')
    .AddBCC('cco@example.com')
    .ReceiptRecipient(False)
    .Subject('email subject')
    .AddBody('email body part', 'message part content-type')
    .AddAttachment('..\.\attachment.txt')
.SendAsynch(SentStatusCallback);
end;
```

## Sample code
Check out the sample code available with a simple user case.
<p align="left">
  <img src="https://github.com/willisnou/Mailer4D/blob/main/resources/sample-project.png"><br>
</p>
Issues, questions or suggestions are apreciated.
