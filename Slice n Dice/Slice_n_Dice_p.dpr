program Slice_n_Dice_p;

uses
  Forms,
  Slice_n_Dice_u in 'Slice_n_Dice_u.pas' {SnDRecipes},
  Slice_n_Dice_Splash_u in 'Slice_n_Dice_Splash_u.pas' {SnDSplash},
  Slice_n_Dice_View_u in 'Slice_n_Dice_View_u.pas' {SelectedRecipe},
  Slice_n_Dice_Add_OR_Edit_u in 'Slice_n_Dice_Add_OR_Edit_u.pas' {AddOREditRecipe},
  SnDDependencies_u in 'SnDDependencies_u.pas',
  dmSlicenDice_u in 'dmSlicenDice_u.pas' {dmSlicenDice: TDataModule},
  Slice_n_Dice_Home_u in 'Slice_n_Dice_Home_u.pas' {SnDHome},
  Slice_n_Dice_Inventory_u in 'Slice_n_Dice_Inventory_u.pas' {SnDInventory},
  Slice_n_Dice_Analytics_u in 'Slice_n_Dice_Analytics_u.pas' {SnDAnalytics},
  Unit_Conversions_u in 'Unit_Conversions_u.pas' {ConversionTable},
  Add_Meal_to_Shop_List_u in 'Add_Meal_to_Shop_List_u.pas' {AddMealToShopList},
  Add_Ingredient_u in 'Add_Ingredient_u.pas' {AddIngredient},
  Pie_Charts_u in 'Pie_Charts_u.pas' {PieCharts};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Slice ''n Dice';
  Application.CreateForm(TdmSlicenDice, dmSlicenDice);
  Application.CreateForm(TSnDHome, SnDHome);
  Application.Run;
end.
