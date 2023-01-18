unit Add_Meal_to_Shop_List_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmSlicenDice_u, Slice_n_Dice_Home_u, Slice_n_Dice_u, StdCtrls;

type
  TAddMealToShopList = class(TForm)
    memIngredients: TMemo;
    lblHeading: TLabel;
    btnAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddMealToShopList: TAddMealToShopList;

implementation

{$R *.dfm}

procedure TAddMealToShopList.btnAddClick(Sender: TObject);
begin
  SnDHome.btnAddSLClick(self); // calls procedure from the home screen which adds items to the shopping list
end;

procedure TAddMealToShopList.FormCreate(Sender: TObject);
var
  sIng: string;

begin
  // gets the appropriate ingredients needed for clicked recipe so user can see what ingredients they may need to go buy when adding to shopping list

  with dmSlicenDice do
  begin
    tblRecipeIngredientNeed.Filter :=
      'RecID = ' + SnDHome.objDependencies.GetSelectedID;
    tblRecipeIngredientNeed.Filtered := true;
    tblRecipeIngredientNeed.First;
    while not tblRecipeIngredientNeed.Eof do
    begin
      sIng := tblRecipeIngredientNeed['RecIngNeedText'];
      memIngredients.Lines.Add(sIng); // displays the ingredients on the memo field for user to see
      memIngredients.Lines.Add('');
      tblRecipeIngredientNeed.Next;
    end;
  end;
end;

end.
