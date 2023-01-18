unit Slice_n_Dice_Add_OR_Edit_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, pngimage, ExtDlgs, SnDDependencies_u,
  Slice_n_Dice_Home_u,
  dmSlicenDice_u, Slice_n_Dice_u;

type
  TAddOREditRecipe = class(TForm)
    pnlViewBase: TPanel;
    pnlMethodView: TPanel;
    lblMethod: TLabel;
    memMethod: TMemo;
    pnlIngredients: TPanel;
    lblIngredients: TLabel;
    lbxIngredients: TListBox;
    pnlLogo: TPanel;
    btnBack: TButton;
    btnSaveMeal: TButton;
    pnlInfoANDImage: TPanel;
    imgMeal: TImage;
    edtName: TEdit;
    btnAddIng: TButton;
    btnDeleteIng: TButton;
    btnImgUpload: TButton;
    btnMethodUpload: TButton;
    btnIngredientsUpload: TButton;
    lbledtServe: TLabeledEdit;
    lbledtCookTime: TLabeledEdit;
    lbledtTimer: TLabeledEdit;
    cmbxMealType: TComboBox;
    imgColour1: TImage;
    imgColour2: TImage;
    imgColour3: TImage;
    imgColour4: TImage;
    imgColour5: TImage;
    imgColour6: TImage;
    dlgOpenTxtFile: TOpenTextFileDialog;
    dlgUploadImage: TOpenPictureDialog;
    lblRecType: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure memMethodClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnMethodUploadClick(Sender: TObject);
    procedure btnImgUploadClick(Sender: TObject);
    procedure btnAddIngClick(Sender: TObject);
    procedure btnDeleteIngClick(Sender: TObject);
    procedure btnIngredientsUploadClick(Sender: TObject);
    procedure btnSaveMealClick(Sender: TObject);
    procedure UpdateRecIngNeed;
    procedure VerifyImageBeforeSave;

  private
    { Private declarations }
  var
    dynLogoIMG: TImage;

  public
    { Public declarations }
  end;

var
  AddOREditRecipe: TAddOREditRecipe;
  bImgChange: Boolean = false;

implementation

{$R *.dfm}

procedure TAddOREditRecipe.btnAddIngClick(Sender: TObject);
var
  sIng: string;

begin
  sIng := InputBox('Adding Ingredient',
    'What ingredient would you like to add?', '');
  // get name of ingredient to add
  lbxIngredients.Items.Add(sIng); // add ingredient to listbox to be viewed by user
end;

procedure TAddOREditRecipe.btnBackClick(Sender: TObject);
// confirm if user wants to go back and close form if confirmed
begin
  if messagedlg(
    'Are you sure you want to go back?  No data will be saved if you proceed unless you have clicked the save button', mtConfirmation, mbOKCancel, 0) = mrOK then
    Close;
end;

procedure TAddOREditRecipe.btnDeleteIngClick(Sender: TObject);
begin
  if lbxIngredients.ItemIndex > -1 then // checks that at least one item has been selected for deleting else shows error message
  begin
    lbxIngredients.DeleteSelected; // deletes selected item from listbox
  end
  else
  begin
    ShowMessage('Please select an item to be deleted');
  end;
end;

procedure TAddOREditRecipe.btnImgUploadClick(Sender: TObject);
begin
  if dlgUploadImage.Execute then
    if FileExists(dlgUploadImage.FileName) then // Check file exists
    begin
      imgMeal.Picture.LoadFromFile(dlgUploadImage.FileName);
      // set new imgMeal image
      bImgChange := True;
    end
    else
      raise Exception.Create('File does not exist'); // shows user error
end;

procedure TAddOREditRecipe.btnIngredientsUploadClick(Sender: TObject);
// upload ingredients from a textfile to the current recipe
var
  sFile, sIng: String;
  tFile: TextFile;

begin
  sFile := ''; // initialise sFile

  dlgOpenTxtFile.Filter := 'Text files (*.txt)|*.TXT';
  // limit to only view textfiles
  if dlgOpenTxtFile.Execute then
    sFile := dlgOpenTxtFile.FileName; // set sFile to be name of selected file

  if sFile <> '' then // if the textfile has a name then open and read textfile
  begin
    AssignFile(tFile, sFile);
    Reset(tFile);
    while NOT EOF(tFile) do
    begin
      Readln(tFile, sIng);
      lbxIngredients.Items.Add(sIng); // add the ingredients in textfile to the listbox
    end;
    CloseFile(tFile);
  end;
end;

procedure TAddOREditRecipe.btnMethodUploadClick(Sender: TObject);
// upload a recipe method via textfile
var
  sFile: String;

begin
  sFile := ''; // initialise

  dlgOpenTxtFile.Filter := 'Text files (*.txt)|*.TXT';
  // limit to only view textfiles
  if dlgOpenTxtFile.Execute then
    sFile := dlgOpenTxtFile.FileName; // set sFile to be name of selected file

  if sFile <> '' then // if sFile has a name, clear the method memo and fill it with the contents of the textfile
  begin
    memMethod.Clear;
    memMethod.Lines.LoadFromFile(sFile);
  end;
end;

procedure TAddOREditRecipe.btnSaveMealClick(Sender: TObject);
var
  iIngCount: integer;

begin
  if lbledtServe.Text = '' then // if the values on the left are left blank, set values to zero
    lbledtServe.Text := '0';
  if lbledtCookTime.Text = '' then
    lbledtCookTime.Text := '0';
  if lbledtTimer.Text = '' then
    lbledtTimer.Text := '0';

  if SnDHome.objDependencies.GetAddOREdit = 'Add' then
  // receives (from dependencies unit) that the 'Add' button was clicked so all entered data is for a new recipe
  begin
    with dmSlicenDice do
    begin
      tblRecipe.Last;
      tblRecipe.Insert; // goes to last record and prepares tblRecipe for data to be inserted
      tblRecipe['RecName'] := edtName.Text;
      if bImgChange = True then
      begin
        VerifyImageBeforeSave; // calls procedure to save image
      end
      else
      begin
        tblRecipe['RecImage'] := 'camera.png'; // if an image wasn't inserted for the recipe, default image for recipe of camera will be used
      end;
      tblRecipe['RecType'] := cmbxMealType.Text;
      tblRecipe['RecServe'] := StrToInt(lbledtServe.Text);
      tblRecipe['RecMethod'] := memMethod.Text;
      tblRecipe['RecCookTime'] := StrToInt(lbledtCookTime.Text);
      tblRecipe['RecTimer'] := lbledtTimer.Text;
      tblRecipe.Post; // post the values to be inserted into tblRecipe

      for iIngCount := 0 to lbxIngredients.Items.Count - 1 do
      // go through listbox items and add the ingredient text to tblRecipeIngredientNeed
      begin
        tblRecipeIngredientNeed.Last;
        tblRecipeIngredientNeed.Insert;
        tblRecipeIngredientNeed['RecID'] := tblRecipe['RecID']; // sets RecID to be the same as the RecID of the new meal that has been inserted into tblRecipe
        tblRecipeIngredientNeed['RecIngNeedText'] := lbxIngredients.Items
          [iIngCount];
        tblRecipeIngredientNeed.Post;
      end;
    end;
  end;

  if SnDHome.objDependencies.GetAddOREdit = 'Edit' then
  // receives (from dependencies unit) that the 'Edit' button was clicked so entered data is adjustment to recipe that is already available
  begin
    with dmSlicenDice do
    begin
      tblRecipe.Edit; // prepares tblRecipe for data to be edited
      tblRecipe['RecName'] := edtName.Text;
      if bImgChange = True then
        VerifyImageBeforeSave; // if image was changed, save new image
      tblRecipe['RecType'] := cmbxMealType.Text;
      tblRecipe['RecServe'] := StrToInt(lbledtServe.Text);
      tblRecipe['RecMethod'] := memMethod.Text;
      tblRecipe['RecCookTime'] := StrToInt(lbledtCookTime.Text);
      tblRecipe['RecTimer'] := lbledtTimer.Text;
      tblRecipe.Post;

      if tblRecipeIngredientNeed.RecordCount > lbxIngredients.Items.Count then
      // Less ingredients needed for the recipe now so the last ingredients must be deleted
      begin
        UpdateRecIngNeed; // update values for the amount of ingredients that are needed
        for iIngCount := lbxIngredients.Items.Count +
          1 to tblRecipeIngredientNeed.RecordCount do
        begin
          tblRecipeIngredientNeed.Last;
          tblRecipeIngredientNeed.Delete; // delete the last ingredientNeed entry until the number of ingredients in the listbox equals the number of ingredients in the database
        end;
      end
      else if tblRecipeIngredientNeed.RecordCount <
        lbxIngredients.Items.Count then // More ingredients are needed now so new ingredients must be inserted into the table
      begin
        qryIngredientsNeeded.SQL.Clear;
        qryIngredientsNeeded.SQL.Add('UPDATE tblRecipeIngredientNeed');
        // update values for the amount of ingredients that are needed
        qryIngredientsNeeded.SQL.Add('SET RecIngNeedText = :RecIngNeedText');
        qryIngredientsNeeded.SQL.Add('WHERE RecIngNeedID = :RecIngNeedID');
        tblRecipeIngredientNeed.First;
        for iIngCount := 0 to tblRecipeIngredientNeed.RecordCount - 1 do
        begin
          qryIngredientsNeeded.Parameters[0].Value := lbxIngredients.Items
          // set SQL parameters
            [iIngCount];
          qryIngredientsNeeded.Parameters[1].Value := tblRecipeIngredientNeed
            ['RecIngNeedID'];
          qryIngredientsNeeded.ExecSQL;
          tblRecipeIngredientNeed.Next;
        end;

        for iIngCount :=
          tblRecipeIngredientNeed.RecordCount to lbxIngredients.Items.Count -
          1 do
        // insert remainder of ingredient text from listbox into database until all ingredients are saved in database
        begin
          tblRecipeIngredientNeed.Last;
          tblRecipeIngredientNeed.Insert;
          tblRecipeIngredientNeed['RecID'] :=
            SnDHome.objDependencies.GetSelectedID;
          tblRecipeIngredientNeed['RecIngNeedText'] := lbxIngredients.Items
            [iIngCount];
          tblRecipeIngredientNeed.Post;
        end;
      end
      else // Equal amount of ingredients in the table and the listbox therefore just update values for the ingredients in the table
      begin
        UpdateRecIngNeed;
      end;
    end;
  end;

  ShowMessage('Meal saved!'); // tell user that meal was successfully saved
  Close;

  dmSlicenDice.tblRecipe.Refresh; // refresh table values in Delphi application
  dmSlicenDice.tblRecipeIngredientNeed.Refresh;

  SnDRecipes.NewRecipeSet; // recall the NewRecipeSet procedure in the recipe viewer so new recipe and updated recipes can be found in the viewer
end;

procedure TAddOREditRecipe.FormCreate(Sender: TObject);
var
  sIng: string;
  iWidth, iMaxWidth, iItemCount: integer;

begin
  WindowState := wsMaximized;
  BorderStyle := bsSizeable;
  Left := 0;
  Top := 0;
  Width := Screen.Width;
  Height := Screen.Height;

  cmbxMealType.Text := SnDHome.objDependencies.GetMealType; // set the combobox of meal type to the value assigned in the dependencies unit

  // formatting of components
  pnlMethodView.Width := pnlIngredients.Left -
    (pnlInfoANDImage.Left + pnlInfoANDImage.Width);
  edtName.Left := pnlInfoANDImage.Left + pnlInfoANDImage.Width + 5;
  edtName.Width := memMethod.Width;
  lblIngredients.Left := (pnlIngredients.Width div 2)
    - lblIngredients.Width div 2;

  // formatting of images in bottom left corner which are used for colour
  imgColour1.Height := pnlInfoANDImage.Width DIV 4;
  imgColour1.Width := imgColour1.Height;
  imgColour2.Height := imgColour1.Height;
  imgColour2.Width := imgColour1.Height;
  imgColour3.Height := imgColour1.Height;
  imgColour3.Width := imgColour1.Height;
  imgColour4.Height := imgColour1.Height;
  imgColour4.Width := imgColour1.Height;
  imgColour5.Height := imgColour1.Height;
  imgColour5.Width := imgColour1.Height;
  imgColour6.Height := imgColour1.Height;
  imgColour6.Width := imgColour1.Height;
  imgColour1.Top := pnlInfoANDImage.Height - 6 - imgColour1.Height;
  imgColour4.Top := imgColour1.Top;
  imgColour6.Top := imgColour1.Top;
  imgColour2.Top := imgColour1.Top - imgColour2.Height;
  imgColour3.Top := imgColour2.Top - imgColour3.Height;
  imgColour5.Top := imgColour2.Top;
  imgColour4.Left := imgColour1.Left + imgColour1.Width;
  imgColour5.Left := imgColour4.Left;
  imgColour6.Left := imgColour4.Left + imgColour4.Width;

  // formatting of components on left side of screen
  btnMethodUpload.Top := ((imgColour3.Top + (imgMeal.Top + imgMeal.Height))
      - btnMethodUpload.Height) DIV 2;
  btnImgUpload.Top := btnMethodUpload.Top - 35 - btnImgUpload.Height;
  btnIngredientsUpload.Top := btnMethodUpload.Top + btnMethodUpload.Height + 35;
  lbledtServe.Top := btnImgUpload.Top + 1;
  lbledtCookTime.Top := btnMethodUpload.Top + 1;
  lbledtTimer.Top := btnIngredientsUpload.Top + 1;
  lbledtServe.Left :=
    ((pnlInfoANDImage.Width + btnImgUpload.Left +
        btnImgUpload.Width) - lbledtServe.Width) DIV 2;
  lbledtCookTime.Left :=
    ((pnlInfoANDImage.Width + btnImgUpload.Left + btnImgUpload.Width)
      - lbledtCookTime.Width) DIV 2;
  lbledtTimer.Left :=
    ((pnlInfoANDImage.Width + btnImgUpload.Left +
        btnImgUpload.Width) - lbledtTimer.Width) DIV 2;
  cmbxMealType.Top := btnIngredientsUpload.Top + btnIngredientsUpload.Height +
    36;
  cmbxMealType.Left :=
    ((pnlInfoANDImage.Width + btnImgUpload.Left + btnImgUpload.Width)
      - cmbxMealType.Width) DIV 2;
  lblRecType.Top := cmbxMealType.Top - lblRecType.Height - 2;
  lblRecType.Left := cmbxMealType.Left;
  lblRecType.Width := cmbxMealType.Width;

  dynLogoIMG := TImage.Create(Self); // dynamically create logo image to display
  dynLogoIMG.Parent := pnlLogo;
  dynLogoIMG.Name := 'imgLogo';
  dynLogoIMG.Height := pnlLogo.Height;
  dynLogoIMG.Width := pnlLogo.Width;
  dynLogoIMG.Left := pnlLogo.Left;
  dynLogoIMG.Top := pnlLogo.Top;
  dynLogoIMG.Picture.LoadFromFile('TimerReplace.png'); // load image

  if SnDHome.objDependencies.GetAddOREdit = 'Edit' then
  // if 'Edit' button was clicked, dependencies unit tells form to fill values with the correct recipe details
  begin
    memMethod.Clear; // initialisation
    lbxIngredients.Clear;

    dmSlicenDice.tblRecipe.Locate('RecID',
      SnDHome.objDependencies.GetSelectedID, []);
    // locates recipe that was clicked on in viewer
    edtName.Text := dmSlicenDice.tblRecipe['RecName'];
    // loads correct recipe data into form components
    AddOREditRecipe.Caption := 'Editing ' + dmSlicenDice.tblRecipe['RecName'];
    imgMeal.Picture.LoadFromFile
      (ExpandFileName(ExtractFileDir(Application.ExeName))
        + '/Recipe Images/' + dmSlicenDice.tblRecipe
        ['RecImage']); // gets location of application because that location contains folder which has recipe images in
    lbledtServe.Text := dmSlicenDice.tblRecipe['RecServe'];
    lbledtCookTime.Text := dmSlicenDice.tblRecipe['RecCookTime'];
    lbledtTimer.Text := dmSlicenDice.tblRecipe['RecTimer'];
    memMethod.Lines.Add(dmSlicenDice.tblRecipe['RecMethod']);
    cmbxMealType.Text := dmSlicenDice.tblRecipe['RecType'];

    // load the ingredients needed for the appropriate recipe into the listbox
    with dmSlicenDice do
    begin
      tblRecipeIngredientNeed.Filter :=
        'RecID = ' + SnDHome.objDependencies.GetSelectedID;
      tblRecipeIngredientNeed.Filtered := True;
      tblRecipeIngredientNeed.First;
      while not tblRecipeIngredientNeed.EOF do
      begin
        sIng := tblRecipeIngredientNeed['RecIngNeedText'];
        lbxIngredients.Items.Add(sIng);
        tblRecipeIngredientNeed.Next;
      end;
    end;
  end;

  // sets a horizontal scrollbar for the listbox if an item in the listbox is longer than the width of the listbox
  iMaxWidth := 0; // horizontal scroll bar for listbox
  with lbxIngredients do
  begin
    Canvas.Font.Assign(Font); // assigns the listbox font to the canvas
    for iItemCount := 0 to Items.Count - 1 do
    // go through each item and if its width is bigger than the max width variable, max width variable becomes that width
    begin
      iWidth := Canvas.TextWidth(Items[iItemCount]);
      if iWidth > iMaxWidth then
        iMaxWidth := iWidth;
    end;

    // makes horizontal scroll to max width and includes border widths and possible vertical scroll width plus width of text 'X' for some spacing
    ScrollWidth := iMaxWidth + (GetSystemMetrics(SM_CXBORDER) * 2)
      + GetSystemMetrics(SM_CXVSCROLL) + (Canvas.TextWidth('X') div 2);
  end;

end;

procedure TAddOREditRecipe.memMethodClick(Sender: TObject);
// if default text is in method memo, clear the memo so the user can type upon clicking in the memo field
begin
  if memMethod.Text = 'Type method here or click "Upload Method"' +
    sLineBreak then
    memMethod.Lines.Clear;
end;

procedure TAddOREditRecipe.UpdateRecIngNeed;
// updates values in the database according to values in the ingredients listbox
var
  jIngCount: integer;

begin
  with dmSlicenDice do
  begin
    qryIngredientsNeeded.SQL.Clear;
    qryIngredientsNeeded.SQL.Add('UPDATE tblRecipeIngredientNeed');
    qryIngredientsNeeded.SQL.Add('SET RecIngNeedText = :RecIngNeedText');
    qryIngredientsNeeded.SQL.Add('WHERE RecIngNeedID = :RecIngNeedID');
    tblRecipeIngredientNeed.First;
    for jIngCount := 0 to lbxIngredients.Items.Count - 1 do
    begin
      qryIngredientsNeeded.Parameters[0].Value := lbxIngredients.Items
        [jIngCount];
      qryIngredientsNeeded.Parameters[1].Value := tblRecipeIngredientNeed
        ['RecIngNeedID'];
      qryIngredientsNeeded.ExecSQL;
      tblRecipeIngredientNeed.Next;
    end;
  end;
end;

procedure TAddOREditRecipe.VerifyImageBeforeSave;
var
  Bmp: TBitmap;

begin
  with dmSlicenDice do
  begin
    tblRecipe['RecImage'] := edtName.Text + '.bmp'; // sets image name to be recipe name plus the bmp extension
    Bmp := TBitmap.Create; // creates bitmap variable
    try
      Bmp.Assign(imgMeal.Picture.Graphic); // changes loaded image to a bitmap for saving
      Bmp.SaveToFile(ExpandFileName(ExtractFileDir(Application.ExeName))
          + '/Recipe Images/' + edtName.Text + '.bmp');
      // saves image in correct folder
    finally
      Bmp.Free; // free from memory
    end;
  end;
end;

end.
