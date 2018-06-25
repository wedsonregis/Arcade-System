program Arcade;

uses
  System.StartUpCopy,
  FMX.Forms,
  U_main in 'U_main.pas' {F_Shifst_Main},
  Emuladores in 'Emuladores.pas',
  U_Jogos in 'U_Jogos.pas',
  U_Joy in 'U_Joy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_Shifst_Main, F_Shifst_Main);
  Application.Run;
end.
