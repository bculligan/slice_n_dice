unit Slice_n_Dice_Splash_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls;

type
  TSnDSplash = class(TForm)
    imgSplash: TImage;
    splashTimer: TTimer;
    procedure splashTimerTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SnDSplash: TSnDSplash;

implementation

{$R *.dfm}

procedure TSnDSplash.splashTimerTimer(Sender: TObject);
begin
  splashTimer.Enabled := false; // when timer is complete, close form to show home screen
  close;
end;

end.
