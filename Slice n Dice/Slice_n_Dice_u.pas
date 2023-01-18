unit Slice_n_Dice_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Grids, pngimage, DBGrids,
  SnDDependencies_u, ExtDlgs, Printers, jpeg, ShellAPI, DBCtrls, StrUtils;

type
  TSnDRecipes = class(TForm)
    btnSearch: TButton;
    edtSearch: TEdit;
    btnView: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnAddRecipe: TButton;
    btnAddShoppingList: TButton;
    lblFilter: TLabel;
    cmbxFilter: TComboBox;
    btnGoHome: TButton;
    tcRecipes: TTabControl;
    grpbxRecipes: TGroupBox;
    lblServes1: TLabel;
    lblTime1: TLabel;
    lblServes3: TLabel;
    lblTime3: TLabel;
    lblServes4: TLabel;
    lblTime4: TLabel;
    lblServes5: TLabel;
    lblTime5: TLabel;
    lblServes6: TLabel;
    lblTime6: TLabel;
    img1: TImage;
    lblName1: TLabel;
    lblServesOut1: TLabel;
    lblTimeOut1: TLabel;
    img2: TImage;
    lblName2: TLabel;
    lblServes2: TLabel;
    lblTime2: TLabel;
    lblServesOut2: TLabel;
    lblTimeOut2: TLabel;
    img3: TImage;
    lblName3: TLabel;
    lblServesOut3: TLabel;
    lblTimeOut3: TLabel;
    img4: TImage;
    lblName4: TLabel;
    lblServesOut4: TLabel;
    lblTimeOut4: TLabel;
    img5: TImage;
    lblName5: TLabel;
    lblServesOut5: TLabel;
    lblTimeOut5: TLabel;
    img6: TImage;
    lblName6: TLabel;
    lblServesOut6: TLabel;
    lblTimeOut6: TLabel;
    pnlNav: TPanel;
    btnPrevious: TButton;
    btnNext: TButton;
    grpbxPreview: TGroupBox;
    imgPreview: TImage;
    dbTxtNamePreview: TDBText;
    lblTimePreview: TLabel;
    lblServesPreview: TLabel;
    dbTxtServesPreview: TDBText;
    dbTxtTimePreview: TDBText;
    dbMemPreview: TDBMemo;
    imgLogo: TImage;
    dbGrdRecipeSearch: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddRecipeClick(Sender: TObject);
    procedure FormatMeals(pImg: TImage; pName, pOutServes, pOutTime, pServes,
      pTime: TLabel; pGBRecipes: TGroupBox);
    procedure FormatBox(pGrpBxRecipes, pGrpBxPreview: TGroupBox; pNav: TPanel;
      pTabType: TTabControl);
    procedure FormatRecipe(pGrpBxRecipes, pGrpBxPreview: TGroupBox;
      pNav: TPanel; pTabType: TTabControl; pImg1, pImg2, pImg3, pImg4,
      pImg5, pImg6: TImage; pName1, pName2, pName3, pName4, pName5, pName6,
      pOutServes1, pOutServes2, pOutServes3, pOutServes4, pOutServes5,
      pOutServes6, pOutTime1, pOutTime2, pOutTime3, pOutTime4, pOutTime5,
      pOutTime6, pServes1, pServes2, pServes3, pServes4, pServes5, pServes6,
      pTime1, pTime2, pTime3, pTime4, pTime5, pTime6: TLabel);
    procedure btnGoHomeClick(Sender: TObject);
    procedure NextRecipe(pImg: TImage; pName, pServe, pTime: TLabel);
    procedure NewRecipeSet;
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure DisablePrevNav(pPrev: TButton);
    procedure DisableNextNav(pNext: TButton);
    procedure NextPage(pPrevious, pNext: TButton);
    procedure PreviousPage(pPrevious, pNext: TButton);
    procedure HideDuplicateRecipes(pImg, pImg2, pImg3, pImg4, pImg5: TImage;
      pName, pServeOut, pServe, pTimeOut, pTime, pName2, pServeOut2, pServe2,
      pTimeOut2, pTime2, pName3, pServeOut3, pServe3, pTimeOut3, pTime3,
      pName4, pServeOut4, pServe4, pTimeOut4, pTime4, pName5, pServeOut5,
      pServe5, pTimeOut5, pTime5: TLabel);
    procedure RecipeChosen(pNum: integer);
    procedure img1Click(Sender: TObject);
    procedure img2Click(Sender: TObject);
    procedure img3Click(Sender: TObject);
    procedure img4Click(Sender: TObject);
    procedure img5Click(Sender: TObject);
    procedure img6Click(Sender: TObject);
    procedure cmbxFilterClick(Sender: TObject);
    procedure FormatPreview(pGrpBox: TGroupBox; pImg: TImage;
      pServe, pTime: TLabel; pName, pServeOut, pTimeOut: TDBText;
      pMethod: TDBMemo);
    procedure btnDeleteClick(Sender: TObject);
    procedure tcRecipesChange(Sender: TObject);
    procedure dbMemPreviewMouseEnter(Sender: TObject);
    procedure edtSearchClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure dbGrdRecipeSearchMouseEnter(Sender: TObject);
    procedure dbGrdRecipeSearchCellClick(Column: TColumn);
    procedure btnSearchClick(Sender: TObject);
    procedure btnAddShoppingListClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure lblName1Click(Sender: TObject);
    procedure lblName2Click(Sender: TObject);
    procedure lblName3Click(Sender: TObject);
    procedure lblName4Click(Sender: TObject);
    procedure lblName5Click(Sender: TObject);
    procedure lblName6Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  var
    objDependencies: TDependencies;
  end;

var
  SnDRecipes: TSnDRecipes;
  iImageCount: integer = 0;
  iPage: integer = 0;
  iRecordNumber: integer;
  sID: String;
  arrKeys: Array [1 .. 6] of string = (
    '',
    '',
    '',
    '',
    '',
    ''
  );

implementation

uses
  Slice_n_Dice_View_u,
  Slice_n_Dice_Add_OR_Edit_u, dmSlicenDice_u, Add_Meal_to_Shop_List_u,
  Slice_n_Dice_Home_u;

procedure TSnDRecipes.DisableNextNav(pNext: TButton);
{ Six meals per page.  If the page counter * six is greater than the number of records, disable the next button }
begin
  if (iPage + 1) * 6 >= iRecordNumber then
  begin
    pNext.Enabled := false;
  end
  else
  begin
    pNext.Enabled := true;
  end;
end;

procedure TSnDRecipes.DisablePrevNav(pPrev: TButton);
// if user is on first page (page counter is 0) then disable the previous button
begin
  if iPage = 0 then
  begin
    pPrev.Enabled := false;
  end
  else if iPage > 0 then
  begin
    pPrev.Enabled := true;
  end;
end;

procedure TSnDRecipes.edtSearchChange(Sender: TObject);
// when the user types in the search bar, call a sql statement to search for meals with names similar to search bar text
begin
  with dmSlicenDice do
  begin
    if edtSearch.Text <> '' then
    begin
      dbGrdRecipeSearch.Visible := true; // drop down search (like in Google) shown through a dbGrid
      dbGrdRecipeSearch.DataSource := dmSlicenDice.dsrRecipeSearch;
      // connect dbGrid to database table
      qryRecipeSearch.SQL.Clear;
      qryRecipeSearch.SQL.Add('SELECT RecName FROM tblRecipe');
      qryRecipeSearch.SQL.Add
        ('WHERE RecName LIKE :SearchWord ORDER BY RecName');
      qryRecipeSearch.Parameters[0].Value := '%' + edtSearch.Text + '%';
      qryRecipeSearch.Open; // open SQL statement to search
      btnSearch.Enabled := true; // allow search button when something has been searched
    end
    else
    begin
      dbGrdRecipeSearch.DataSource := nil; // blank the dbGrid
      btnSearch.Enabled := false;
      dbGrdRecipeSearch.Visible := false;
    end;

  end;
end;

procedure TSnDRecipes.edtSearchClick(Sender: TObject);
begin
  dbGrdRecipeSearch.DataSource := nil; // empty the "drop down box" by clearing the dbGrid datasource
end;
{$R *.dfm}

procedure TSnDRecipes.edtSearchKeyPress(Sender: TObject; var Key: Char);
// on return key press, execute search
begin
  if ord(Key) = VK_RETURN then
    btnSearchClick(self);
end;

procedure TSnDRecipes.btnAddRecipeClick(Sender: TObject);
begin
  SnDHome.objDependencies.SetAddOREdit('Add');
  // set dependencies unit to contain "Add"
  // this is used to tell form ADDorEdit that form is of type ADD
  AddOREditRecipe := TAddOREditRecipe.Create(self);
  try
    AddOREditRecipe.ShowModal;
  finally
    AddOREditRecipe.Free;
  end;
end;

procedure TSnDRecipes.btnAddShoppingListClick(Sender: TObject);
// create and open form to add ingredients to shopping list
begin
  AddMealToShopList := TAddMealToShopList.Create(self);
  try
    AddMealToShopList.ShowModal;
  finally
    AddMealToShopList.Free;
  end;
end;

procedure TSnDRecipes.btnDeleteClick(Sender: TObject);
var
  sRecName: string;

begin
  dmSlicenDice.tblRecipe.Locate('RecID', SnDHome.objDependencies.GetSelectedID,
    []); // locate selected recipe

  sRecName := dmSlicenDice.tblRecipe['RecName'];

  if MessageDlg('Are you sure you want to delete ' + sRecName + '?', mtWarning,
    [mbYes, mbNo], 0) = mrYes then // warn user about delete
  begin
    dmSlicenDice.tblRecipe.Delete;
    NewRecipeSet; // refresh meals viewed in viewer
    ShowMessage(sRecName + ' successfully deleted');
    // tell user about successful delete
  end;
end;

procedure TSnDRecipes.btnEditClick(Sender: TObject);
begin
  SnDHome.objDependencies.SetAddOREdit('Edit');
  // set dependencies unit to contain "Edit"
  // this is used to tell form ADDorEdit that form is of type EDIT

  AddOREditRecipe := TAddOREditRecipe.Create(self);
  try
    AddOREditRecipe.ShowModal;
  finally
    AddOREditRecipe.Free;
  end;
end;

procedure TSnDRecipes.btnGoHomeClick(Sender: TObject);
begin
  Close;
end;

procedure TSnDRecipes.btnNextClick(Sender: TObject);
begin
  NextPage(btnPrevious, btnNext);
end;

procedure TSnDRecipes.btnPreviousClick(Sender: TObject);
begin
  PreviousPage(btnPrevious, btnNext);
end;

procedure TSnDRecipes.btnSearchClick(Sender: TObject);
var
  sSearchedID, sSearchText: string;

begin
  if dbGrdRecipeSearch.Visible = true then
  begin
    sSearchText := dbGrdRecipeSearch.fields[0].AsString; // get first item of dbGrid as search text (if user clicks search with half-finished search term)
    if sSearchText <> '' then // text must not be blank else there is no meal match with search criteria
    begin
      with dmSlicenDice do
      begin
        qryRecipeSearch.SQL.Clear;
        tblRecipe.Filtered := false;
        qryRecipeSearch.SQL.Add(
          'SELECT RecID FROM tblRecipe WHERE RecName = :RecName');
        qryRecipeSearch.Parameters[0].Value := sSearchText;
        qryRecipeSearch.Open;
        sSearchedID := qryRecipeSearch.FieldByName('RecID').AsString;
        // get RecID of searched meal
      end;
      SnDHome.objDependencies.setSelectedID(sSearchedID);
      // set dependencies unit SelectedID
      btnViewClick(self); // view meal
      dmSlicenDice.tblRecipe.Filtered := true; // apply appropriate filters
    end
    else
    begin
      ShowMessage('There is no meal with that name'); // tell user search failed
    end;
  end;
end;

procedure TSnDRecipes.btnViewClick(Sender: TObject);
begin
  SelectedRecipe := TSelectedRecipe.Create(self);
  try
    SelectedRecipe.ShowModal;
  finally
    SelectedRecipe.Free;
  end;
end;

procedure TSnDRecipes.cmbxFilterClick(Sender: TObject);
begin
  if cmbxFilter.ItemIndex = 0 then // alphabetical order
  begin
    dmSlicenDice.tblRecipe.Sort := 'RecName ASC';
  end;

  if cmbxFilter.ItemIndex = 1 then
  begin
    dmSlicenDice.tblRecipe.Sort := 'RecCookTime ASC, RecName ASC';
    // increasing cookTime
  end;

  if cmbxFilter.ItemIndex = 2 then
  begin
    dmSlicenDice.tblRecipe.Sort := 'RecCookTime DESC, RecName ASC';
    // decreasing cookTime
  end;

  if cmbxFilter.ItemIndex = 3 then
  begin
    dmSlicenDice.tblRecipe.Sort := 'RecServe ASC, RecName ASC';
    // increasing serve count
  end;

  if cmbxFilter.ItemIndex = 4 then
  begin
    dmSlicenDice.tblRecipe.Sort := 'RecServe DESC, RecName ASC';
    // decreasing serve count
  end;

  tcRecipesChange(tcRecipes); // reload page
end;

procedure TSnDRecipes.dbGrdRecipeSearchCellClick(Column: TColumn);
begin
  edtSearch.Text := dbGrdRecipeSearch.fields[0].AsString; // fill search bar with text of selected item from dropbox
end;

procedure TSnDRecipes.dbGrdRecipeSearchMouseEnter(Sender: TObject);
begin
  dbGrdRecipeSearch.SetFocus;
end;

procedure TSnDRecipes.dbMemPreviewMouseEnter(Sender: TObject);
begin
  dbMemPreview.SetFocus;
end;

procedure TSnDRecipes.FormatBox(pGrpBxRecipes, pGrpBxPreview: TGroupBox;
  pNav: TPanel; pTabType: TTabControl);
// formatting of two groupboxes
begin
  pGrpBxRecipes.Width := (pTabType.Width - (2 * pTabType.TabHeight)) DIV 2;
  pGrpBxRecipes.Height := pTabType.Height - 10;
  pGrpBxPreview.Height := pGrpBxRecipes.Height;
  pGrpBxPreview.Width := pGrpBxRecipes.Width;
  pGrpBxRecipes.Left := pTabType.Left + pTabType.TabHeight + 5;
  pGrpBxPreview.Left := pGrpBxRecipes.Left + pGrpBxRecipes.Width + 5;
  pNav.Top := (pGrpBxRecipes.Top + pGrpBxRecipes.Height) - pNav.Height - 10;
  pNav.Left := (pGrpBxRecipes.Width div 2) - pNav.Width div 2;

  imgLogo.Left := pGrpBxPreview.Left;
  imgLogo.Width := pGrpBxPreview.Width;
  imgLogo.Height := Trunc(((imgLogo.Width DIV 16) * 9));
  imgLogo.Top := (pGrpBxPreview.Height DIV 2) - imgLogo.Height DIV 2;
end;

procedure TSnDRecipes.FormatMeals(pImg: TImage; pName, pOutServes, pOutTime,
  pServes, pTime: TLabel; pGBRecipes: TGroupBox);
// formatting for individual meal load
begin
  pImg.Width := (pGBRecipes.Width - 21) DIV 3;
  pImg.Height := pImg.Width;

  pName.Left := pImg.Left;
  pName.Top := pImg.Top + pImg.Height + 3;
  pName.Width := pImg.Width;
  pName.Height := pImg.Height DIV 6 + 6;

  pServes.Left := pImg.Left;
  pTime.Left := pImg.Left;
  pOutServes.Left := pTime.Left + pTime.Width + 5;
  pOutTime.Left := pTime.Left + pTime.Width + 5;
  pOutServes.Width := pImg.Width - pTime.Width;
  pOutTime.Width := pImg.Width - pTime.Width;
  pServes.Height := pImg.Height DIV 12;
  pTime.Height := pImg.Height DIV 12;
  pOutServes.Height := pImg.Height DIV 12;
  pOutTime.Height := pImg.Height DIV 12;
  pServes.Top := pName.Top + pName.Height;
  pTime.Top := pServes.Top + pServes.Height;
  pOutServes.Top := pServes.Top;
  pOutTime.Top := pTime.Top;
end;

procedure TSnDRecipes.FormatPreview(pGrpBox: TGroupBox; pImg: TImage;
  pServe, pTime: TLabel; pName, pServeOut, pTimeOut: TDBText;
  pMethod: TDBMemo);
// format components in preview groupbox
begin
  pImg.Width := (pGrpBox.Width - 10) DIV 2;
  pImg.Height := pImg.Width;
  pMethod.Left := pImg.Left + pImg.Width + 5;
  pMethod.Width := pGrpBox.Width - pMethod.Left - 5;
  pName.Width := pImg.Width;
  pName.Height := Trunc(pName.Height * 3.5);
  pName.Top := Trunc(pImg.Top + 1.05 * pImg.Height);
  pServe.Top := pName.Top + pName.Height + pServe.Height;
  pServeOut.Top := pServe.Top;
  pTime.Top := pServe.Top + pServe.Height + pTime.Height;
  pTimeOut.Top := pTime.Top;
  pServe.Left := (pMethod.Left div 2) - (pTime.Width + pTimeOut.Width + 5)
    div 2;
  pTime.Left := (pMethod.Left div 2) - (pTime.Width + pTimeOut.Width + 5) div 2;
  pServeOut.Left := pTime.Left + pTime.Width + 5;
  pTimeOut.Left := pTime.Left + pTime.Width + 5;
end;

procedure TSnDRecipes.FormatRecipe(pGrpBxRecipes, pGrpBxPreview: TGroupBox;
  pNav: TPanel; pTabType: TTabControl; pImg1, pImg2, pImg3, pImg4, pImg5,
  pImg6: TImage; pName1, pName2, pName3, pName4, pName5, pName6, pOutServes1,
  pOutServes2, pOutServes3, pOutServes4, pOutServes5, pOutServes6, pOutTime1,
  pOutTime2, pOutTime3, pOutTime4, pOutTime5, pOutTime6, pServes1, pServes2,
  pServes3, pServes4, pServes5, pServes6, pTime1, pTime2, pTime3, pTime4,
  pTime5, pTime6: TLabel);
// format all components in the recipe viewer
begin
  FormatBox(pGrpBxRecipes, pGrpBxPreview, pNav, pTabType);

  pImg1.Left := 6;
  FormatMeals(pImg1, pName1, pOutServes1, pOutTime1, pServes1, pTime1,
    pGrpBxRecipes);

  pImg2.Left := pImg1.Width + pImg1.Left + 4;
  pImg2.Top := pImg1.Top;
  FormatMeals(pImg2, pName2, pOutServes2, pOutTime2, pServes2, pTime2,
    pGrpBxRecipes);

  pImg3.Left := pImg2.Width + pImg2.Left + 4;
  pImg3.Top := pImg1.Top;
  FormatMeals(pImg3, pName3, pOutServes3, pOutTime3, pServes3, pTime3,
    pGrpBxRecipes);

  pImg4.Left := pImg1.Left;
  pImg4.Top := pTime1.Top + pTime1.Height * 2;
  FormatMeals(pImg4, pName4, pOutServes4, pOutTime4, pServes4, pTime4,
    pGrpBxRecipes);

  pImg5.Left := pImg2.Left;
  pImg5.Top := pImg4.Top;
  FormatMeals(pImg5, pName5, pOutServes5, pOutTime5, pServes5, pTime5,
    pGrpBxRecipes);

  pImg6.Left := pImg3.Left;
  pImg6.Top := pImg4.Top;
  FormatMeals(pImg6, pName6, pOutServes6, pOutTime6, pServes6, pTime6,
    pGrpBxRecipes);
end;

procedure TSnDRecipes.FormCreate(Sender: TObject);
begin

  WindowState := wsMaximized;
  BorderStyle := bsSizeable;
  Left := 0;
  Top := 0;
  Width := Screen.Width;
  Height := Screen.Height;
  tcRecipes.TabIndex := 0; // start at first tab

  dmSlicenDice.tblRecipe.Filter := 'RecType = ''Breakfast''';
  // first tab is breakfast
  dmSlicenDice.tblRecipe.Filtered := true;

  grpbxPreview.Visible := false; // no meal selected therefore preview groupbox must not be visible

  FormatRecipe(grpbxRecipes, grpbxPreview, pnlNav, tcRecipes, img1, img2, img3,
    img4, img5, img6, lblName1, lblName2, lblName3, lblName4, lblName5,
    lblName6, lblServesOut1, lblServesOut2, lblServesOut3,
    lblServesOut4, lblServesOut5, lblServesOut6, lblTimeOut1,
    lblTimeOut2, lblTimeOut3, lblTimeOut4, lblTimeOut5, lblTimeOut6,
    lblServes1, lblServes2, lblServes3, lblServes4, lblServes5, lblServes6,
    lblTime1, lblTime2, lblTime3, lblTime4, lblTime5, lblTime6);

  FormatPreview(grpbxPreview, imgPreview, lblServesPreview, lblTimePreview,
    dbTxtNamePreview, dbTxtServesPreview, dbTxtTimePreview, dbMemPreview);

  cmbxFilterClick(cmbxFilter); // apply filter (default to alphabetical order)

  tcRecipesChange(tcRecipes); // reload recipes

  btnPrevious.Enabled := false;
  btnSearch.Enabled := false;

end;

procedure TSnDRecipes.HideDuplicateRecipes(pImg, pImg2, pImg3, pImg4,
  pImg5: TImage; pName, pServeOut, pServe, pTimeOut, pTime, pName2,
  pServeOut2, pServe2, pTimeOut2, pTime2, pName3, pServeOut3, pServe3,
  pTimeOut3, pTime3, pName4, pServeOut4, pServe4, pTimeOut4, pTime4, pName5,
  pServeOut5, pServe5, pTimeOut5, pTime5: TLabel);
// compares current RecID to next meal's RecID in array containing RecIDs.  If duplicate - hide all components for meals after the first one else show all components because not a duplicate
begin
  if arrKeys[2] = arrKeys[1] then
  begin
    pImg.Visible := false;
    pName.Visible := false;
    pServeOut.Visible := false;
    pServe.Visible := false;
    pTimeOut.Visible := false;
    pTime.Visible := false;
  end
  else
  begin
    pImg.Visible := true;
    pName.Visible := true;
    pServeOut.Visible := true;
    pServe.Visible := true;
    pTimeOut.Visible := true;
    pTime.Visible := true;
  end;

  if arrKeys[3] = arrKeys[2] then
  begin
    pImg2.Visible := false;
    pName2.Visible := false;
    pServeOut2.Visible := false;
    pServe2.Visible := false;
    pTimeOut2.Visible := false;
    pTime2.Visible := false;
  end
  else
  begin
    pImg2.Visible := true;
    pName2.Visible := true;
    pServeOut2.Visible := true;
    pServe2.Visible := true;
    pTimeOut2.Visible := true;
    pTime2.Visible := true;
  end;

  if arrKeys[4] = arrKeys[3] then
  begin
    pImg3.Visible := false;
    pName3.Visible := false;
    pServeOut3.Visible := false;
    pServe3.Visible := false;
    pTimeOut3.Visible := false;
    pTime3.Visible := false;
  end
  else
  begin
    pImg3.Visible := true;
    pName3.Visible := true;
    pServeOut3.Visible := true;
    pServe3.Visible := true;
    pTimeOut3.Visible := true;
    pTime3.Visible := true;
  end;

  if arrKeys[5] = arrKeys[4] then
  begin
    pImg4.Visible := false;
    pName4.Visible := false;
    pServeOut4.Visible := false;
    pServe4.Visible := false;
    pTimeOut4.Visible := false;
    pTime4.Visible := false;
  end
  else
  begin
    pImg4.Visible := true;
    pName4.Visible := true;
    pServeOut4.Visible := true;
    pServe4.Visible := true;
    pTimeOut4.Visible := true;
    pTime4.Visible := true;
  end;

  if arrKeys[6] = arrKeys[5] then
  begin
    pImg5.Visible := false;
    pName5.Visible := false;
    pServeOut5.Visible := false;
    pServe5.Visible := false;
    pTimeOut5.Visible := false;
    pTime5.Visible := false;
  end
  else
  begin
    pImg5.Visible := true;
    pName5.Visible := true;
    pServeOut5.Visible := true;
    pServe5.Visible := true;
    pTimeOut5.Visible := true;
    pTime5.Visible := true;
  end;
end;

procedure TSnDRecipes.img1Click(Sender: TObject);
begin
  RecipeChosen(1);
end;

procedure TSnDRecipes.img2Click(Sender: TObject);
begin
  RecipeChosen(2);
end;

procedure TSnDRecipes.img3Click(Sender: TObject);
begin
  RecipeChosen(3);
end;

procedure TSnDRecipes.img4Click(Sender: TObject);
begin
  RecipeChosen(4);
end;

procedure TSnDRecipes.img5Click(Sender: TObject);
begin
  RecipeChosen(5);
end;

procedure TSnDRecipes.img6Click(Sender: TObject);
begin
  RecipeChosen(6);
end;

// if user clicks the name instead of the image, the same procedures must happen so call the image click procedures
procedure TSnDRecipes.lblName1Click(Sender: TObject);
begin
  img1Click(self);
end;

procedure TSnDRecipes.lblName2Click(Sender: TObject);
begin
  img2Click(self);
end;

procedure TSnDRecipes.lblName3Click(Sender: TObject);
begin
  img3Click(self);
end;

procedure TSnDRecipes.lblName4Click(Sender: TObject);
begin
  img4Click(self);
end;

procedure TSnDRecipes.lblName5Click(Sender: TObject);
begin
  img5Click(self);
end;

procedure TSnDRecipes.lblName6Click(Sender: TObject);
begin
  img6Click(self);
end;

procedure TSnDRecipes.NewRecipeSet;
begin
  iImageCount := 0; // initialise image counter for the six images
  NextRecipe(img1, lblName1, lblServesOut1, lblTimeOut1);
  // load appropriate components with data
  arrKeys[1] := sID; // update array with RecIDs
  NextRecipe(img2, lblName2, lblServesOut2, lblTimeOut2);
  arrKeys[2] := sID;
  NextRecipe(img3, lblName3, lblServesOut3, lblTimeOut3);
  arrKeys[3] := sID;
  NextRecipe(img4, lblName4, lblServesOut4, lblTimeOut4);
  arrKeys[4] := sID;
  NextRecipe(img5, lblName5, lblServesOut5, lblTimeOut5);
  arrKeys[5] := sID;
  NextRecipe(img6, lblName6, lblServesOut6, lblTimeOut6);
  arrKeys[6] := sID;
  HideDuplicateRecipes(img2, img3, img4, img5, img6, lblName2, lblServes2,
    lblServesOut2, lblTime2, lblTimeOut2, lblName3, lblServes3, lblServesOut3,
    lblTime3, lblTimeOut3, lblName4, lblServes4, lblServesOut4, lblTime4,
    lblTimeOut4, lblName5, lblServes5, lblServesOut5, lblTime5, lblTimeOut5,
    lblName6, lblServes6, lblServesOut6, lblTime6, lblTimeOut6);
  // check for duplicates and hide if needs be

  btnView.Enabled := false; // nothing is selected therefore disable components affecting selected meals
  btnEdit.Enabled := false;
  btnAddShoppingList.Enabled := false;
  btnDelete.Enabled := false;
  grpbxPreview.Visible := false;
end;

procedure TSnDRecipes.NextPage(pPrevious, pNext: TButton);
begin
  inc(iPage); // increase page counter which is multiplied by image counter when loading meals
  DisablePrevNav(pPrevious);
  DisableNextNav(pNext);

  NewRecipeSet;
end;

procedure TSnDRecipes.NextRecipe(pImg: TImage; pName, pServe, pTime: TLabel);
var
  sImageField, sName, sServe, sTime: string;

begin
  with dmSlicenDice do
  begin
    inc(iImageCount); // goes through the six meals in viewer
    tblRecipe.RecNo := iImageCount + (iPage * 6); // sets record to load based on image and page count
    if tblRecipe.RecNo <= iRecordNumber then // if record is still within number of records in database
    begin
      sImageField := tblRecipe['RecImage']; // load image
      pImg.Picture.LoadFromFile
        (ExpandFileName(ExtractFileDir(Application.ExeName))
          + '/Recipe Images/' + sImageField);

      sName := tblRecipe['RecName']; // load name
      sID := tblRecipe['RecID'];
      pName.Caption := sName;

      sServe := tblRecipe['RecServe']; // load serve
      pServe.Caption := sServe;

      sTime := tblRecipe['RecCookTime']; // load time
      pTime.Caption := sTime;
    end;
  end;
end;

procedure TSnDRecipes.PreviousPage(pPrevious, pNext: TButton);
begin
  dec(iPage);
  DisablePrevNav(pPrevious);
  DisableNextNav(pNext);

  NewRecipeSet;
end;

procedure TSnDRecipes.RecipeChosen(pNum: integer);
var
  sImageField: String;

begin
  SnDHome.objDependencies.setSelectedID(arrKeys[pNum]);
  // set the selected RecID based on array of RecIDs
  btnView.Enabled := true; // user has selected a meal therefore enable components for meals
  btnEdit.Enabled := true;
  btnAddShoppingList.Enabled := true;
  btnDelete.Enabled := true;

  // load data into the preview groupbox based on selected meal
  with dmSlicenDice do
  begin
    tblRecipePreview.Filter := 'RecID = ' + arrKeys[pNum];
    tblRecipePreview.Filtered := true;
    sImageField := tblRecipePreview['RecImage']; // load image
    imgPreview.Picture.LoadFromFile
      (ExpandFileName(ExtractFileDir(Application.ExeName))
        + '/Recipe Images/' + sImageField);
  end;

  grpbxPreview.Visible := true;
end;

procedure TSnDRecipes.tcRecipesChange(Sender: TObject);
begin
  iPage := 0; // meal type change, therefore go to start of records
  btnPrevious.Enabled := false;
  btnNext.Enabled := true;

  if tcRecipes.TabIndex = 0 then
  begin
    SnDHome.objDependencies.SetMealType('Breakfast'); // save meal type in dependencies unit for if user selects "Add" button to auto select meal type
    with dmSlicenDice do
    begin
      tblRecipe.Filter := 'RecType = ''Breakfast''';
      iRecordNumber := tblRecipe.RecordCount;
    end;
  end
  else if tcRecipes.TabIndex = 1 then
  begin
    SnDHome.objDependencies.SetMealType('Lunch');
    with dmSlicenDice do
    begin
      tblRecipe.Filter := 'RecType = ''Lunch''';
      iRecordNumber := tblRecipe.RecordCount;
    end;
  end
  else if tcRecipes.TabIndex = 2 then
  begin
    SnDHome.objDependencies.SetMealType('Dinner');
    with dmSlicenDice do
    begin
      tblRecipe.Filter := 'RecType = ''Dinner''';
      iRecordNumber := tblRecipe.RecordCount;
    end;
  end
  else if tcRecipes.TabIndex = 3 then
  begin
    SnDHome.objDependencies.SetMealType('Dessert');
    with dmSlicenDice do
    begin
      tblRecipe.Filter := 'RecType = ''Dessert''';
      iRecordNumber := tblRecipe.RecordCount;
    end;
  end
  else if tcRecipes.TabIndex = 4 then
  begin
    SnDHome.objDependencies.SetMealType('Drinks');
    with dmSlicenDice do
    begin
      tblRecipe.Filter := 'RecType = ''Drinks''';
      iRecordNumber := tblRecipe.RecordCount;
    end;
  end;

  NewRecipeSet;
end;

end.
