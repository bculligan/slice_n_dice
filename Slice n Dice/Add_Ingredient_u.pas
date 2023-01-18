unit Add_Ingredient_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, pngimage, dmSlicenDice_u;

type
  TAddIngredient = class(TForm)
    lbledtIngName: TLabeledEdit;
    cmbxIngType: TComboBox;
    btnAddIngredient: TButton;
    lblIngType: TLabel;
    lblNote: TLabel;
    imgLogo: TImage;
    procedure lbledtIngNameChange(Sender: TObject);
    procedure cmbxIngTypeChange(Sender: TObject);
    procedure btnAddIngredientClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddIngredient: TAddIngredient;

implementation

{$R *.dfm}

procedure TAddIngredient.btnAddIngredientClick(Sender: TObject);
begin
  with dmSlicenDice do
  // insert new ingredient into database
  begin
    tblIngredient.Filtered := false;
    qryIngredients.SQL.Clear;
    qryIngredients.SQL.Add('INSERT INTO tblIngredient(IngName, IngType)');
    qryIngredients.SQL.Add('VALUES(:IngName, :IngType)');
    qryIngredients.Parameters[0].Value := lbledtIngName.Text;
    qryIngredients.Parameters[1].Value := cmbxIngType.Text;
    qryIngredients.ExecSQL;
    tblIngredient.Filtered := true;
    tblIngredient.Close; // referesh the data in the Delphi application
    tblIngredient.Open;
    tblIngredient.Sort := 'IngName ASC'; // sort must be reapplied
  end;

  lbledtIngName.Clear; // initialise fields for new data to be entered
  cmbxIngType.ItemIndex := -1;
end;

// following procedures check that all data has been entered in order to add an ingredient before enabling the 'add' button

procedure TAddIngredient.cmbxIngTypeChange(Sender: TObject);
begin
  if (lbledtIngName.Text <> '') AND (cmbxIngType.ItemIndex > -1) then
  begin
    btnAddIngredient.Enabled := true;
  end
  else
    btnAddIngredient.Enabled := false;
end;

procedure TAddIngredient.lbledtIngNameChange(Sender: TObject);
begin
  if (lbledtIngName.Text <> '') AND (cmbxIngType.ItemIndex > -1) then
  begin
    btnAddIngredient.Enabled := true;
  end
  else
    btnAddIngredient.Enabled := false;
end;

end.
