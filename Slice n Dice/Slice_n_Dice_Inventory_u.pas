unit Slice_n_Dice_Inventory_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, DBGrids, DBCtrls, pngimage,
  dmSlicenDice_u, Add_Ingredient_u;

type
  TSnDInventory = class(TForm)
    btnGoHome: TButton;
    imgCarrot: TImage;
    imgBread: TImage;
    imgCheese: TImage;
    imgMilk: TImage;
    imgSteak: TImage;
    imgWatermelon: TImage;
    tcInventory: TTabControl;
    dbGrdIngredients: TDBGrid;
    btnAddIngredient: TButton;
    btnDeleteIngredient: TButton;
    imgLogo: TImage;
    procedure btnGoHomeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbGrdIngredientsCellClick(Column: TColumn);
    procedure dbGrdIngredientsDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure dbGrdIngredientsColEnter(Sender: TObject);
    procedure dbGrdIngredientsColExit(Sender: TObject);
    procedure tcInventoryChange(Sender: TObject);
    procedure btnDeleteIngredientClick(Sender: TObject);
    procedure btnAddIngredientClick(Sender: TObject);
  private
    { Private declarations }
  var
    FOriginalOptions: TDBGridOptions;

  public
    { Public declarations }
  end;

var
  SnDInventory: TSnDInventory;

implementation

{$R *.dfm}

procedure TSnDInventory.btnAddIngredientClick(Sender: TObject);
// open form for entering new ingredient information
begin
  AddIngredient := TAddIngredient.Create(self);
  try
    AddIngredient.ShowModal;
  finally
    AddIngredient.Free;
  end;
end;

procedure TSnDInventory.btnDeleteIngredientClick(Sender: TObject);
// delete selected ingredient from database
begin
  with dmSlicenDice do
  begin
    qryIngredients.SQL.Clear;
    qryIngredients.SQL.Add
      ('DELETE FROM tblIngredient WHERE IngName = :IngName');
    qryIngredients.Parameters[0].Value := dbGrdIngredients.Fields[0].AsString;
    qryIngredients.ExecSQL;
    tblIngredient.Close; // close and open table to refresh values in Delphi application
    tblIngredient.Open;
  end;

  btnDeleteIngredient.Enabled := false; // disable delete button until an ingredient is selected for deleting
end;

procedure TSnDInventory.btnGoHomeClick(Sender: TObject);
begin
  Close;
end;

procedure TSnDInventory.FormCreate(Sender: TObject);
begin
  // formatting of components
  imgBread.Width := btnGoHome.Width;
  imgCarrot.Width := imgBread.Width;
  imgWatermelon.Width := imgBread.Width;
  imgCheese.Width := imgBread.Width;
  imgMilk.Width := imgBread.Width;
  imgSteak.Width := imgBread.Width;
  imgWatermelon.Top := imgBread.Top + imgBread.Height + 5;
  imgCheese.Top := imgWatermelon.Top + imgWatermelon.Height + 5;
  imgMilk.Top := imgCheese.Top + imgCheese.Height + 5;
  imgSteak.Top := imgMilk.Top + imgMilk.Height + 5;
  imgCarrot.Top := imgSteak.Top + imgSteak.Height + 5;

  tcInventory.Width := ClientWidth DIV 2;

  with dbGrdIngredients do
  begin
    Left := tcInventory.Left + 2 * tcInventory.TabHeight;
    Width := tcInventory.Width - 2 * tcInventory.TabHeight - GetSystemMetrics
      (SM_CXVSCROLL);
    Columns[0].Width := dbGrdIngredients.Width - 95; // name column width adjusted based on screen resolution
    Columns[1].Width := 65; // available column has a constant width
  end;

  imgLogo.Left := tcInventory.Left + tcInventory.Width + 5;
  imgLogo.Width := Screen.Width - tcInventory.Width - tcInventory.Left -
    imgCarrot.Width;
  imgLogo.Height := Trunc(((imgLogo.Width DIV 16) * 9)); // values 16 and 9 used for 16:9 ratio and trunc function used to get rid of decimals and set value as integer
  imgLogo.Top :=
    ((Screen.Height - (btnAddIngredient.Top + btnAddIngredient.Height)) DIV 2)
    - imgLogo.Height DIV 2 - 20;

  with dmSlicenDice do
  begin
    tblIngredient.Filter := 'IngType = ''Carbohydrates'''; // always start at carbs on form create so set filter to this
    tblIngredient.Filtered := true;
    tblIngredient.Sort := 'IngName ASC'; // sort ingredients alphabetically
  end;
end;

procedure TSnDInventory.tcInventoryChange(Sender: TObject);
// set table filters according to tab the user is on
begin
  if tcInventory.TabIndex = 0 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Carbohydrates''';
  end
  else if tcInventory.TabIndex = 1 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Dairy''';
  end
  else if tcInventory.TabIndex = 2 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Fats, Oils and Sugar''';
  end
  else if tcInventory.TabIndex = 3 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Fruit and Vegetables''';
  end
  else if tcInventory.TabIndex = 4 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Herbs and Spices''';
  end
  else if tcInventory.TabIndex = 5 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Meat''';
  end
  else if tcInventory.TabIndex = 6 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Nuts and Seeds''';
  end
  else if tcInventory.TabIndex = 7 then
  begin
    dmSlicenDice.tblIngredient.Filter := 'IngType = ''Other''';
  end;

  btnDeleteIngredient.Enabled := false; // deactivate delete button because user has not selected anything
end;

procedure TSnDInventory.dbGrdIngredientsCellClick(Column: TColumn);
begin
  if Column.FieldName = 'IngAvailable' then
  // if cell clicked is 'IngAvailable' then cell is boolean
  begin
    Column.Grid.DataSource.DataSet.Edit;
    Column.Field.Value := not Column.Field.AsBoolean;
    // field updates to opposite of what it is
    Column.Grid.DataSource.DataSet.Post;
  end;

  if Column.FieldName = 'IngName' then
  // if cell clicked is 'IngName' then delete button should be activated
  begin
    btnDeleteIngredient.Enabled := true;
  end
  else
    btnDeleteIngredient.Enabled := false;
end;

procedure TSnDInventory.dbGrdIngredientsColEnter(Sender: TObject);
begin
  if self.dbGrdIngredients.SelectedField.FieldName = 'IngAvailable' then
  begin
    self.FOriginalOptions := self.dbGrdIngredients.Options; // set original options variable to dbgrid orginal options
    self.dbGrdIngredients.Options := self.dbGrdIngredients.Options -
      [dgEditing]; // adjust dbgrid's options so fields can be edited
  end;
end;

procedure TSnDInventory.dbGrdIngredientsColExit(Sender: TObject);
begin
  if self.dbGrdIngredients.SelectedField.FieldName = 'IngAvailable' then
    self.dbGrdIngredients.Options := self.FOriginalOptions;
  // reapply original options to dbgrid
end;

procedure TSnDInventory.dbGrdIngredientsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
const
  CtrlState: array [Boolean] of Integer = (DFCS_BUTTONCHECK,
    DFCS_BUTTONCHECK or DFCS_CHECKED);
begin
  if Column.FieldName = 'IngAvailable' then // if column is the 'IngAvailable' column
  begin
    dbGrdIngredients.Canvas.FillRect(Rect);
    if (VarIsNull(Column.Field.Value)) then
      // draw the appropriate checkboxes
      DrawFrameControl(dbGrdIngredients.Canvas.Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_INACTIVE)
    else
      DrawFrameControl(dbGrdIngredients.Canvas.Handle, Rect, DFC_BUTTON,
        CtrlState[Column.Field.AsBoolean]);
  end;
end;

end.