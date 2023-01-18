unit Unit_Conversions_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls;

type
  TConversionTable = class(TForm)
    pnlMetric: TPanel;
    pnlImperial: TPanel;
    lbledtG: TLabeledEdit;
    lbledtC: TLabeledEdit;
    lbledtML: TLabeledEdit;
    lblNote4: TLabel;
    imgLogo: TImage;
    lblMetric: TLabel;
    lblNote1: TLabel;
    lblNote2: TLabel;
    lblNote3: TLabel;
    lblImperial: TLabel;
    lbledtF: TLabeledEdit;
    lbledtOZ: TLabeledEdit;
    lbledtFLOZ: TLabeledEdit;
    lbledtPOUND: TLabeledEdit;
    lbledtPINT: TLabeledEdit;
    btnConvertC: TButton;
    btnConvertG: TButton;
    btnConvertML: TButton;
    btnConvertFLOZ: TButton;
    btnConvertOZ: TButton;
    btnConvertF: TButton;
    btnConvertPINT: TButton;
    btnConvertPOUND: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConvertCClick(Sender: TObject);
    procedure btnConvertFClick(Sender: TObject);
    procedure btnConvertGClick(Sender: TObject);
    procedure btnConvertOZClick(Sender: TObject);
    procedure btnConvertPOUNDClick(Sender: TObject);
    procedure btnConvertMLClick(Sender: TObject);
    procedure btnConvertFLOZClick(Sender: TObject);
    procedure btnConvertPINTClick(Sender: TObject);
    procedure lbledtCKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtFKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtGKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtOZKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtPOUNDKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtMLKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtFLOZKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtPINTKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConversionTable: TConversionTable;

implementation

{$R *.dfm}
// procedures with appropriate calculations and error messages if invalid values are entered

procedure TConversionTable.btnConvertCClick(Sender: TObject);
begin
  try
    lbledtF.Text := FloatToStrF((StrToFloat(lbledtC.Text) * 1.8 + 32), ffFixed,
      8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertFClick(Sender: TObject);
begin
  try
    lbledtC.Text := FloatToStrF(((StrToFloat(lbledtF.Text) - 32) / 1.8),
      ffFixed, 8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertFLOZClick(Sender: TObject);
begin
  try
    lbledtML.Text := FloatToStrF((StrToFloat(lbledtFLOZ.Text) * 29.57352956),
      ffFixed, 8, 2);
    lbledtPINT.Text := FloatToStrF((StrToFloat(lbledtFLOZ.Text) * 16), ffFixed,
      8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertGClick(Sender: TObject);
begin
  try
    lbledtOZ.Text := FloatToStrF((StrToFloat(lbledtG.Text) * 0.03527396),
      ffFixed, 8, 2);
    lbledtPOUND.Text := FloatToStrF((StrToFloat(lbledtG.Text) / 453.59237),
      ffFixed, 8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertMLClick(Sender: TObject);
begin
  try
    lbledtFLOZ.Text := FloatToStrF((StrToFloat(lbledtML.Text) * 0.033814),
      ffFixed, 8, 2);
    lbledtPINT.Text := FloatToStrF((StrToFloat(lbledtML.Text) * 0.002113),
      ffFixed, 8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertOZClick(Sender: TObject);
begin
  try
    lbledtG.Text := FloatToStrF((StrToFloat(lbledtOZ.Text) * 28.34952313),
      ffFixed, 8, 2);
    lbledtPOUND.Text := FloatToStrF((StrToFloat(lbledtOZ.Text) * 0.0625),
      ffFixed, 8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertPINTClick(Sender: TObject);
begin
  try
    lbledtML.Text := FloatToStrF((StrToFloat(lbledtPINT.Text) * 473.176473),
      ffFixed, 8, 2);
    lbledtFLOZ.Text := FloatToStrF((StrToFloat(lbledtPINT.Text) / 16), ffFixed,
      8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.btnConvertPOUNDClick(Sender: TObject);
begin
  try
    lbledtG.Text := FloatToStrF((StrToFloat(lbledtPOUND.Text) * 453.59237),
      ffFixed, 8, 2);
    lbledtOZ.Text := FloatToStrF((StrToFloat(lbledtPOUND.Text) * 16), ffFixed,
      8, 2);
  except
    ShowMessage('Please enter a valid value');
  end;
end;

procedure TConversionTable.FormCreate(Sender: TObject);
begin
  // formatting of components
  lblMetric.Left := (pnlMetric.Width - lblMetric.Width) DIV 2;
  lblImperial.Left := (pnlImperial.Width - lblImperial.Width) DIV 2;
  lbledtG.Left := (pnlMetric.Width - lbledtG.Width) DIV 2;
  lbledtC.Left := (pnlMetric.Width - lbledtC.Width) DIV 2;
  lbledtML.Left := (pnlMetric.Width - lbledtML.Width) DIV 2;
  btnConvertC.Left := (pnlMetric.Width - btnConvertC.Width) DIV 2;
  btnConvertML.Left := (pnlMetric.Width - btnConvertML.Width) DIV 2;
  btnConvertG.Left := (pnlMetric.Width - btnConvertG.Width) DIV 2;
end;

// procedures if 'return' button on keyboard is clicked when typing

procedure TConversionTable.lbledtCKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertCClick(self);
end;

procedure TConversionTable.lbledtFKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertFClick(self);
end;

procedure TConversionTable.lbledtFLOZKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertFLOZClick(self);
end;

procedure TConversionTable.lbledtGKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertGClick(self);
end;

procedure TConversionTable.lbledtMLKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertMLClick(self);
end;

procedure TConversionTable.lbledtOZKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertOZClick(self);
end;

procedure TConversionTable.lbledtPINTKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertPINTClick(self);
end;

procedure TConversionTable.lbledtPOUNDKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnConvertPOUNDClick(self);
end;

end.