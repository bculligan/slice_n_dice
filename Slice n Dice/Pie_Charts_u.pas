unit Pie_Charts_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, ExtCtrls, TeeProcs, Chart, DBChart, dmSlicenDice_u,
  Series, Slice_n_Dice_Home_u, StrUtils, pngimage;

type
  TPieCharts = class(TForm)
    dbChrtGoal: TDBChart;
    Series1: TPieSeries;
    dbChrtAchievement: TDBChart;
    Series2: TPieSeries;
    imgLogo: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PieCharts: TPieCharts;
  arrRecID: array of string;
  arrIngredients: array of string;
  arrTypeCount: array [0 .. 7] of integer = (
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  );
  arrColours: array [0 .. 7] of TColor = (
    clWebGold,
    clWebOrange,
    clWebSalmon,
    clWebMistyRose,
    clWebMediumOrchid,
    clWebLavender,
    clWebCornSilk,
    clWebMediumSpringGreen
  );
  arrLabels: array [0 .. 7] of string = (
    'Carbohydrates',
    'Dairy',
    'Fats, Oils and Sugar',
    'Fruit and Vegetables',
    'Herbs and Spice',
    'Meat',
    'Nuts and Seeds',
    'Other'
  );

implementation

{$R *.dfm}

procedure TPieCharts.FormCreate(Sender: TObject);
var
  q, w, r, iCount: integer;

begin
  dbChrtAchievement.Show; // achievement chart must be shown

  for r := 0 to 7 do
  begin
    arrTypeCount[r] := 0; // initialise array to 0 for all indices
  end;

  SetLength(arrRecID, 1); // default dynamic arrays to a length of one
  SetLength(arrIngredients, 1);

  with dmSlicenDice do
  begin
    tblFillRecIDArray.Filter :=
      'TrackDate >= ' + SnDHome.objDependencies.GetFromDate +
      ' AND TrackDate <=' + SnDHome.objDependencies.GetToDate;
    tblFillRecIDArray.Filtered := True; // filter table based on dates specified in analytics form

    tblFillRecIDArray.First;
    while NOT tblFillRecIDArray.EOF do
    begin
      arrRecID[length(arrRecID) - 1] := tblFillRecIDArray['RecID']; // add RecIDs to the array of RecID for each meal that is being viewed
      tblFillRecIDArray.Next;
      SetLength(arrRecID, length(arrRecID) + 1); // increase the length of arrRecID to allow new data to be added to array
    end;

    // for each RecID in the arrRecID, get the appropriate ingredient text and add to dynamic array which will fill with ingredient text for all meals being viewed
    for q := low(arrRecID) to high(arrRecID) - 1 do
    begin
      tblFillIngredientArray.Filter := 'RecID = ' + arrRecID[q];
      tblFillIngredientArray.Filtered := True; // set table filter based on current arrRecID value
      tblFillIngredientArray.First;
      while NOT tblFillIngredientArray.EOF do
      begin
        arrIngredients[length(arrIngredients) - 1] := tblFillIngredientArray // for this RecID value, fill the array of ingredients with ingredient text
          ['RecIngNeedText'];
        tblFillIngredientArray.Next;
        SetLength(arrIngredients, length(arrIngredients) + 1);
        // adjust size of dynamic arrIngredients
      end;
    end;

    for w := low(arrIngredients) to high(arrIngredients) - 1 do
    begin
      // go through each element of the ingredients array and find its type in the database table containing the name of that ingredient
      tblCheckIngredient.First;
      while NOT tblCheckIngredient.EOF do
      begin
        if ContainsText(arrIngredients[w], tblCheckIngredient['IngName']) then
        // uses StrUtils to check if arrIngredients has a substring of tblCheckIngredient['IngName']
        begin // when that substring is found, the array containing a count of how many of each type of ingredient is found is incremented
          if tblCheckIngredient['IngType'] = 'Carbohydrates' then
          begin
            arrTypeCount[0] := arrTypeCount[0] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Dairy' then
          begin
            arrTypeCount[1] := arrTypeCount[1] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Fats, Oils and Sugar' then
          begin
            arrTypeCount[2] := arrTypeCount[2] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Fruit and Vegetables' then
          begin
            arrTypeCount[3] := arrTypeCount[3] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Herbs and Spices' then
          begin
            arrTypeCount[4] := arrTypeCount[4] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Meat' then
          begin
            arrTypeCount[5] := arrTypeCount[5] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Nuts and Seeds' then
          begin
            arrTypeCount[6] := arrTypeCount[6] + 1;
          end
          else if tblCheckIngredient['IngType'] = 'Other' then
          begin
            arrTypeCount[7] := arrTypeCount[7] + 1;
          end;
        end;
        tblCheckIngredient.Next;
      end;
    end;
  end;

  // all values are zero if no data is found in the specified date range
  if NOT((arrTypeCount[0] = 0) AND (arrTypeCount[1] = 0) AND
      (arrTypeCount[2] = 0) AND (arrTypeCount[3] = 0) AND
      (arrTypeCount[4] = 0) AND (arrTypeCount[5] = 0) AND
      (arrTypeCount[6] = 0) AND (arrTypeCount[7] = 0)) then
  begin
    // if all values are not zero, add the appropriate data to the chart series
    with dbChrtAchievement do
    begin
      Series2.Clear; // clear current series data
      for iCount := 0 to 7 do
        Series2.AddPie(arrTypeCount[iCount], arrLabels[iCount],
          arrColours[iCount]); // add new series data
      dbChrtAchievement.AddSeries(Series2); // add filled series to chart
    end;
  end
  else
  begin
    dbChrtAchievement.Hide; // otherwise data range has no data and therefore hide the chart to display the Slice n Dice logo
  end;
end;

end.