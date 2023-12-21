object frmSample: TfrmSample
  Left = 0
  Top = 0
  Caption = 'Sample Form'
  ClientHeight = 473
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 473
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 778
    ExplicitHeight = 322
    object pnlLeft: TPanel
      Left = 1
      Top = 1
      Width = 288
      Height = 471
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 321
      object lbHost: TLabel
        Left = 8
        Top = 23
        Width = 66
        Height = 15
        Caption = 'SMTP Host *'
      end
      object lbUsername: TLabel
        Left = 8
        Top = 103
        Width = 53
        Height = 15
        Caption = 'Username'
      end
      object lbPassword: TLabel
        Left = 8
        Top = 153
        Width = 50
        Height = 15
        Caption = 'Password'
      end
      object lbFrom: TLabel
        Left = 8
        Top = 203
        Width = 28
        Height = 15
        Caption = 'From'
      end
      object lbPort: TLabel
        Left = 159
        Top = 23
        Width = 30
        Height = 15
        Caption = 'Port *'
      end
      object lbConnectionStatus: TLabel
        Left = 2
        Top = 456
        Width = 72
        Height = 15
        Caption = 'Disconnected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object btnConnect: TButton
        Left = 8
        Top = 261
        Width = 266
        Height = 25
        Caption = 'Connect'
        TabOrder = 0
        OnClick = btnConnectClick
      end
      object pnlLeftTop: TPanel
        Left = 1
        Top = 1
        Width = 286
        Height = 16
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        Caption = 'SMTP settings'
        Color = clMedGray
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        ExplicitWidth = 310
      end
      object edtHost: TEdit
        Left = 8
        Top = 44
        Width = 137
        Height = 23
        TabOrder = 2
      end
      object edtUsername: TEdit
        Left = 8
        Top = 124
        Width = 193
        Height = 23
        TabOrder = 3
      end
      object edtPassword: TEdit
        Left = 8
        Top = 174
        Width = 193
        Height = 23
        TabOrder = 4
      end
      object edtFrom: TEdit
        Left = 8
        Top = 224
        Width = 193
        Height = 23
        TabOrder = 5
      end
      object edtPort: TEdit
        Left = 159
        Top = 44
        Width = 42
        Height = 23
        NumbersOnly = True
        TabOrder = 6
      end
      object cbAuth: TCheckBox
        Left = 8
        Top = 73
        Width = 97
        Height = 17
        Caption = 'Auth *'
        TabOrder = 7
      end
      object cbEncryption: TCheckBox
        Left = 125
        Top = 73
        Width = 76
        Height = 17
        Caption = 'SSL/TLS *'
        TabOrder = 8
      end
    end
    object pnlRight: TPanel
      Left = 289
      Top = 1
      Width = 496
      Height = 471
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 294
      ExplicitWidth = 492
      ExplicitHeight = 321
      object lbRecipient: TLabel
        Left = 6
        Top = 23
        Width = 57
        Height = 15
        Caption = 'Recipient *'
      end
      object lbCC: TLabel
        Left = 6
        Top = 73
        Width = 16
        Height = 15
        Caption = 'CC'
      end
      object lbRecipientName: TLabel
        Left = 159
        Top = 23
        Width = 84
        Height = 15
        Caption = 'Recipient Name'
      end
      object lbCcName: TLabel
        Left = 159
        Top = 74
        Width = 51
        Height = 15
        Caption = 'CC Name'
      end
      object lbCCO: TLabel
        Left = 6
        Top = 123
        Width = 25
        Height = 15
        Caption = 'CCO'
      end
      object lbCcoName: TLabel
        Left = 159
        Top = 124
        Width = 60
        Height = 15
        Caption = 'CCO Name'
      end
      object lbSubject: TLabel
        Left = 6
        Top = 174
        Width = 39
        Height = 15
        Caption = 'Subject'
      end
      object lbAttachments: TLabel
        Left = 239
        Top = 174
        Width = 68
        Height = 15
        Caption = 'Attachments'
      end
      object lbBody: TLabel
        Left = 6
        Top = 265
        Width = 76
        Height = 15
        Caption = 'Message body'
      end
      object lbContentType: TLabel
        Left = 6
        Top = 398
        Width = 174
        Height = 15
        Caption = 'Message content type (optional):'
      end
      object pnlRigtTop: TPanel
        Left = 1
        Top = 1
        Width = 494
        Height = 16
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        Caption = 'Message settings'
        Color = clMedGray
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 462
      end
      object btnSend: TButton
        Left = 6
        Top = 437
        Width = 483
        Height = 25
        Caption = 'Send'
        TabOrder = 1
        OnClick = btnSendClick
      end
      object edtRecipient: TEdit
        Left = 6
        Top = 44
        Width = 147
        Height = 23
        TabOrder = 2
      end
      object btnAddRecipient: TButton
        Left = 303
        Top = 43
        Width = 90
        Height = 25
        Caption = 'Add Recipient'
        TabOrder = 3
        OnClick = btnAddRecipientClick
      end
      object btnListRecipients: TButton
        Left = 399
        Top = 43
        Width = 90
        Height = 25
        Caption = 'List Recipients'
        TabOrder = 4
        OnClick = btnListRecipientsClick
      end
      object edtCC: TEdit
        Left = 6
        Top = 95
        Width = 147
        Height = 23
        TabOrder = 5
      end
      object btnAddCc: TButton
        Left = 303
        Top = 94
        Width = 90
        Height = 25
        Caption = 'Add CC'
        TabOrder = 6
        OnClick = btnAddCcClick
      end
      object btnListCC: TButton
        Left = 399
        Top = 94
        Width = 90
        Height = 25
        Caption = 'List CC'
        TabOrder = 7
        OnClick = btnListCCClick
      end
      object edtRecipientName: TEdit
        Left = 159
        Top = 44
        Width = 138
        Height = 23
        TabOrder = 8
      end
      object edtCcName: TEdit
        Left = 159
        Top = 95
        Width = 138
        Height = 23
        TabOrder = 9
      end
      object edtCCO: TEdit
        Left = 6
        Top = 145
        Width = 147
        Height = 23
        TabOrder = 10
      end
      object edtCcoName: TEdit
        Left = 159
        Top = 145
        Width = 138
        Height = 23
        TabOrder = 11
      end
      object btnAddCCO: TButton
        Left = 303
        Top = 144
        Width = 90
        Height = 25
        Caption = 'Add CCO'
        TabOrder = 12
        OnClick = btnAddCCOClick
      end
      object btnListCCO: TButton
        Left = 399
        Top = 144
        Width = 90
        Height = 25
        Caption = 'List CCO'
        TabOrder = 13
        OnClick = btnListCCOClick
      end
      object edtSubject: TEdit
        Left = 6
        Top = 195
        Width = 227
        Height = 23
        TabOrder = 14
      end
      object listAttachments: TListBox
        Left = 246
        Top = 195
        Width = 146
        Height = 60
        ItemHeight = 15
        TabOrder = 15
        OnKeyDown = listAttachmentsKeyDown
      end
      object btnAddAttachment: TButton
        Left = 398
        Top = 230
        Width = 90
        Height = 25
        Caption = 'Attach'
        TabOrder = 16
        OnClick = btnAddAttachmentClick
      end
      object cbReceiptRecipient: TCheckBox
        Left = 6
        Top = 224
        Width = 133
        Height = 17
        Caption = 'Read confirmation'
        TabOrder = 17
      end
      object btnRemoveAttachment: TButton
        Left = 398
        Top = 194
        Width = 90
        Height = 25
        Caption = 'Detach'
        TabOrder = 18
        OnClick = btnRemoveAttachmentClick
      end
      object mmBody: TMemo
        Left = 6
        Top = 286
        Width = 483
        Height = 103
        TabOrder = 19
      end
      object edtContentType: TEdit
        Left = 186
        Top = 395
        Width = 121
        Height = 23
        TabOrder = 20
      end
    end
  end
  object TimerConnStatus: TTimer
    OnTimer = TimerConnStatusTimer
    Left = 81
    Top = 385
  end
end
