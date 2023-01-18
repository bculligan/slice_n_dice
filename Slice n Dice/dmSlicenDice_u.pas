unit dmSlicenDice_u;

interface

uses
  SysUtils, Classes, DB, ADODB, dialogs;

type
  TdmSlicenDice = class(TDataModule)
    conSlicenDice: TADOConnection;
    tblIngredient: TADOTable;
    dsrIngredient: TDataSource;
    tblRecipe: TADOTable;
    dsrRecipe: TDataSource;
    tblRecipeIngredientNeed: TADOTable;
    dsrRecipeIngredientNeed: TDataSource;
    tblTrack: TADOTable;
    dsrTrack: TDataSource;
    dsrIngredientsNeeded: TDataSource;
    qryIngredientsNeeded: TADOQuery;
    qryAnalytics: TADOQuery;
    dsrAnalytics: TDataSource;
    tblRecipePreview: TADOTable;
    dsrRecipePreview: TDataSource;
    dsrRecipeSearch: TDataSource;
    qryRecipeSearch: TADOQuery;
    qryIngredients: TADOQuery;
    dsrIngredients: TDataSource;
    tblDietaryGoal: TADOTable;
    dsrDietaryGoal: TDataSource;
    qryDietary: TADOQuery;
    dsrDietary: TDataSource;
    tblFillRecIDArray: TADOTable;
    dsrFillRecIDArray: TDataSource;
    tblFillIngredientArray: TADOTable;
    dsrFillIngredientArray: TDataSource;
    tblCheckIngredient: TADOTable;
    dsrCheckIngredient: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSlicenDice: TdmSlicenDice;

implementation

{$R *.dfm}

procedure TdmSlicenDice.DataModuleCreate(Sender: TObject);
begin
  // set connection string
  conSlicenDice.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=SlicenDiceDB.mdb;Mode=ReadWrite;Persist Security Info=False;';

  // attempt to connect database else show error
  try
    conSlicenDice.Open;
  except
    ShowMessage('Database not connected');
  end;

  if (conSlicenDice.Connected) then // set ADOelements to be active
  begin
    tblIngredient.Active := True;
    tblRecipe.Active := True;
    tblRecipeIngredientNeed.Active := True;
    tblTrack.Active := True;
    tblRecipePreview.Active := True;
    tblDietaryGoal.Active := True;
    tblFillRecIDArray.Active := True;
    tblFillIngredientArray.Active := True;
    tblCheckIngredient.Active := True;
    qryIngredientsNeeded.Active := True;
    qryAnalytics.Active := True;
    qryRecipeSearch.Active := True;
    qryIngredients.Active := True;
    qryDietary.Active := True;
  end;
end;

end.
