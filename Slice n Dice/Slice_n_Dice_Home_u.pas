unit Slice_n_Dice_Home_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, StdCtrls, ComCtrls, jpeg, ExtCtrls, ExtDlgs, ShellAPI,
  Printers, SnDDependencies_u;

type
  TSnDHome = class(TForm)
    dlgSaveTxtFileShopList: TSaveTextFileDialog;
    dlgPrint: TPrintDialog;
    imgBackground: TImage;
    imgShoppingList: TImage;
    imgRecipes: TImage;
    imgAnalytics: TImage;
    imgInventory: TImage;
    redShopList: TRichEdit;
    imgPicknPay: TImage;
    imgWoolworths: TImage;
    btnPrintSL: TButton;
    btnAddSL: TButton;
    btnClearSL: TButton;
    btnSaveSL: TButton;
    pnlShopList: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure imgRecipesMouseEnter(Sender: TObject);
    procedure imgInventoryMouseEnter(Sender: TObject);
    procedure imgAnalyticsMouseEnter(Sender: TObject);
    procedure ShopListHeader;
    procedure imgShoppingListClick(Sender: TObject);
    procedure imgWoolworthsClick(Sender: TObject);
    procedure imgPicknPayClick(Sender: TObject);
    procedure btnPrintSLClick(Sender: TObject);
    procedure btnAddSLClick(Sender: TObject);
    procedure btnClearSLClick(Sender: TObject);
    procedure btnSaveSLClick(Sender: TObject);
    procedure ViewRecipe;
    procedure imgRecipesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewAnalytics;
    procedure imgAnalyticsClick(Sender: TObject);
    procedure ViewInventory;
    procedure imgInventoryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  var
    objDependencies: TDependencies;
  end;

var
  SnDHome: TSnDHome;

implementation

uses
  dmSlicenDice_u, Slice_n_Dice_Splash_u, Slice_n_Dice_u,
  Slice_n_Dice_Analytics_u, Slice_n_Dice_Inventory_u;

procedure TSnDHome.ViewRecipe;
begin
  SnDRecipes := TSnDRecipes.Create(self); // Create the form
  try
    SnDRecipes.ShowModal; // Show the form
  finally
    SnDRecipes.Free; // Free the form from memory
  end;
end;

procedure TSnDHome.ViewAnalytics;
begin
  SnDAnalytics := TSnDAnalytics.Create(self);
  try
    SnDAnalytics.ShowModal;
  finally
    SnDAnalytics.Free;
  end;
end;

procedure TSnDHome.ViewInventory;
begin
  SnDInventory := TSnDInventory.Create(self);
  try
    SnDInventory.ShowModal;
  finally
    SnDInventory.Free;
  end;
end;
{$R *.dfm}

procedure TSnDHome.imgAnalyticsClick(Sender: TObject);
begin
  ViewAnalytics;
end;

procedure TSnDHome.imgAnalyticsMouseEnter(Sender: TObject);
// When user hovers cursor over Analytics bubble, background adjusts to match the theme - ie the images in the right upper corner change
begin
  imgBackground.Picture.LoadFromFile('SnDHomeFour.png');
end;

procedure TSnDHome.imgInventoryClick(Sender: TObject);
begin
  ViewInventory;
end;

procedure TSnDHome.imgInventoryMouseEnter(Sender: TObject);
begin
  imgBackground.Picture.LoadFromFile('SnDHomeThree.png');
end;

procedure TSnDHome.imgPicknPayClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'https://www.pnp.co.za/welcome?rf=y&_ga=2.258583689.2005233561.1525418824-1984058615.1525418822', nil, nil, SW_ShowNormal);
  // Calls from the ShellAPI to open the link included on computer's default internet browswer as a normal window
end;

procedure TSnDHome.imgRecipesClick(Sender: TObject);
begin
  ViewRecipe;
end;

procedure TSnDHome.imgRecipesMouseEnter(Sender: TObject);
begin
  imgBackground.Picture.LoadFromFile('SnDHomeTwo.png');
end;

procedure TSnDHome.imgShoppingListClick(Sender: TObject);
// when the user clicks on the shopping list icon, shopping list panel becomes visible or invisible dependent on whether it was already visible or invisible
begin
  if pnlShopList.Visible = false then
  begin
    pnlShopList.Visible := true;
  end
  else if pnlShopList.Visible = true then
  begin
    pnlShopList.Visible := false;
  end;
end;

procedure TSnDHome.imgWoolworthsClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.woolworths.co.za/store/cat/_/N-1z13sk5Z1ha6kkl', nil, nil,
    SW_ShowNormal);
end;

procedure TSnDHome.ShopListHeader;
var
  sDate: string;

begin
  sDate := FormatDateTime('yyyymmdd', Now); // saves current date to variable sDate in format 'yyyymmdd'
  redShopList.Lines.Add('Shopping List ' + sDate + ' :'); // heading for shopping list which includes current date
  redShopList.SelStart := 0;
  redShopList.SelLength := 24; // selects heading text
  redShopList.SelAttributes.Style := redShopList.SelAttributes.Style + [fsBold]
    + [fsUnderline]; // makes heading text bold and underlined
end;

procedure TSnDHome.btnAddSLClick(Sender: TObject);
var
  sItem, sQuantity, sLine: string;
  tFile: TextFile;
  iLineCounter: integer;

begin
  sItem := InputBox('Add to shopping list',
    'What ingredient would you like to add to your shopping list?', '');
  // gets item from user
  sQuantity := InputBox('Add to shopping list',
    'How much of the ingredient do you need to buy?', '');
  // gets quantity of item from user
  redShopList.Lines.Add('');
  redShopList.Lines.Add(sItem + #9 + sQuantity);
  // adds item and quantity to shopping list

  AssignFile(tFile, 'Shopping List.txt'); // assign shopping list textfile to variable
  if fileexists('Shopping List.txt') = true then
  begin
    Append(tFile); // if shopping list textfile is present, go to end of textfile
  end
  else
    Rewrite(tFile); // create new text file for shopping list
  for iLineCounter := redShopList.Lines.Count downto redShopList.Lines.Count -
    1 do // last line has most recently added item and line before that contains space for ease of readibility
  begin
    sLine := redShopList.Lines[iLineCounter];
    Writeln(tFile, sLine); // writes these lines to the shopping list textfile so shopping list data is saved
  end;
  CloseFile(tFile);
end;

procedure TSnDHome.btnClearSLClick(Sender: TObject);
var
  tFile: TextFile;

begin
  redShopList.Clear;
  ShopListHeader; // rewrites the shopping list heading to the richedit which is now empty

  AssignFile(tFile, 'Shopping List.txt');
  Rewrite(tFile); // Clears text file
  CloseFile(tFile);
end;

procedure TSnDHome.btnPrintSLClick(Sender: TObject);
begin
  if dlgPrint.Execute then
  // Print the desired number of copies
  begin
    Application.ProcessMessages; // allow application to continue
    redShopList.Print('Shopping List'); // print the text on the shopping list richedit
  end;
end;

procedure TSnDHome.btnSaveSLClick(Sender: TObject);
var
  tShopList: TextFile;
  sDate: string;

begin
  dlgSaveTxtFileShopList.Filter := 'Text file|*.txt';
  // filters save dialog to textfile formats
  dlgSaveTxtFileShopList.DefaultExt := 'txt'; // automatically sets file to be saved's extension as .txt

  sDate := FormatDateTime('yyyymmdd', Now); // gets current date, formatted
  dlgSaveTxtFileShopList.FileName := 'Shopping List ' + sDate; // automatically sets textfiles name to be 'Shopping List' with the date afterwards

  if dlgSaveTxtFileShopList.Execute then
  begin
    try
      redShopList.PlainText := true; // sets shopping list to plaintext to be saved
      AssignFile(tShopList, dlgSaveTxtFileShopList.FileName);
      Rewrite(tShopList); // textfile made
      Writeln(tShopList, redShopList.Text); // shopping list contents added to textfile
      CloseFile(tShopList);
      redShopList.PlainText := false; // set shopping list richedit back to formatted
      ShowMessage('File has successfully been saved');
    except
      ShowMessage('File save was cancelled'); // tell user that shopping list save has been cancelled
    end
  end;

end;

procedure TSnDHome.FormCreate(Sender: TObject);
var
  tFile: TextFile;
  sLine: string;

begin
  objDependencies := TDependencies.Create; // create dependencies object from dependencies unit in order to save certain information which needs to be retrieved from other forms

  redShopList.Paragraph.TabCount := 2; // set formatting for shopping list
  redShopList.Paragraph.Tab[1] := 110;
  redShopList.Paragraph.Tab[2] := 200;
  WindowState := wsMaximized;
  BorderStyle := bsSizeable;
  pnlShopList.Left := (Screen.Width div 2) - pnlShopList.Width div 2;
  // centre items
  pnlShopList.Top := ((Screen.Height div 2) - pnlShopList.Height div 2)
    - imgShoppingList.Height;

  // formatting for buttons on shopping list
  btnPrintSL.Left := imgWoolworths.Left;
  btnAddSL.Left := imgWoolworths.Left;
  btnClearSL.Left := imgWoolworths.Left;
  btnSaveSL.Left := imgWoolworths.Left;
  btnPrintSL.Width := imgWoolworths.Width;
  btnAddSL.Width := imgWoolworths.Width;
  btnClearSL.Width := imgWoolworths.Width;
  btnSaveSL.Width := imgWoolworths.Width;

  redShopList.Clear; // initialise shopping list richedit
  ShopListHeader; // add appropriate header
  if fileexists('Shopping List.txt') = true then
  begin
    AssignFile(tFile, 'Shopping List.txt');
    Reset(tFile);
    while NOT EOF(tFile) do
    begin
      Readln(tFile, sLine);
      redShopList.Lines.Add(sLine); // if shopping list textfile exists, add contents to shopping list richedit
    end;
    CloseFile(tFile);
  end
  else
    MessageDlg('No previous shopping list could be found', mtWarning, [mbOK],
      0); // warn user of missing shopping list textfile

end;

procedure TSnDHome.FormShow(Sender: TObject);
begin
  SnDSplash := TSnDSplash.Create(self);
  try
    SnDSplash.ShowModal; // display splash until splash is closed (after set interval)
  finally
    SnDSplash.Free; // free splash from memory
  end;
end;

end.
