unit U_main;

// livre para uso

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,System.Generics.Collections, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,System.StrUtils,
  FMX.Layouts, FMX.Ani, FMX.Effects, FMX.Controls.Presentation, FMX.StdCtrls, U_joy, windows, U_jogos, Emuladores,TlHelp32,ShellAPI ,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, System.ImageList, FMX.ImgList,
  FMX.Filter.Effects,inifiles;

type
  TF_Shifst_Main = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    Circle1: TCircle;
    Rectangle2: TRectangle;
    ShadowEffect1: TShadowEffect;
    FloatAnimationDeg: TFloatAnimation;
    FloatAnimationY: TFloatAnimation;
    IM_Gamessnaps: TImage;
    L_NameGames: TLabel;
    L_AnoGames: TLabel;
    L_CategoryGames: TLabel;
    L_Emulador: TLabel;
    Layout1: TLayout;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    ShadowEffect4: TShadowEffect;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    GridPanelLayout1: TGridPanelLayout;
    Rectangle5: TRectangle;
    L_Info: TLabel;
    ShadowEffect5: TShadowEffect;
    Timer1: TTimer;
    ImageList1: TImageList;
    Glyph1: TGlyph;
    ShadowEffect6: TShadowEffect;
    ShadowEffect8: TShadowEffect;
    IM_snaps: TImage;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    IM_Emulator: TImage;
    L_EmulatorName: TLabel;
    ShadowEffect7: TShadowEffect;
    L_GamesQt: TLabel;
    ShadowEffect9: TShadowEffect;
    L_EmulatorExtenssion: TLabel;
    ShadowEffect10: TShadowEffect;
    GaussianBlurEffect1: TGaussianBlurEffect;
    procedure FormCreate(Sender: TObject);
    procedure FloatAnimationDegFinish(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitCards;
    function  DegPointY:Single;
    procedure gameUp();
    procedure gameDown();
    Procedure shift(paction:integer);
    Procedure Updateinfo();
    procedure OpenEmulator(Emulator,RunGame,DirectoryEmulator:string);
    procedure FindGame(latter:string);
  public
    { Public declarations }
    Win:Single;
    PointDelta:TPointF;
  end;

var
  F_Shifst_Main: TF_Shifst_Main;
  validation:Boolean;

  //declarações
  Joys:TGamepad;
  Jogos: TObjectList<Tlistajogos>;
  Emuladores: TObjectList<ListaEmuladores>;
  II,JI:Integer;

implementation

  Uses Math;

  {$R *.fmx}


  // pega a sessão do arquivo ini
  function GetMaxSectionIndex(const AFileName: string; Psection:string): Integer;
var
  S: string;
  I: Integer;
  Index: Integer;
  IniFile: TIniFile;
  Sections: TStringList;
begin
  Result := 0;
  IniFile := TIniFile.Create(AFileName);
  try
    Sections := TStringList.Create;
    try
      IniFile.ReadSections(Sections);
      for I := 0 to Sections.Count - 1 do
      begin
        S := Sections[I];
        if Pos(Psection, S) = 1 then
        begin
          Delete(S, 1, Length(Psection));
          if TryStrToInt(S, Index) then
            if Index > Result then
              Result := Index;
        end;
      end;
    finally
      Sections.Free;
    end;
  finally
    IniFile.Free;
  end;
end;


 // checa processos existente
  function ProcessExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
      FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
      ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
      Result := False;
      while Integer(ContinueLoop) <> 0 do
      begin
        if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
          UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
          UpperCase(ExeFileName))) then
        begin
          Result := True;
        end;
        ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
      end;
      CloseHandle(FSnapshotHandle);
end;

// fecha processo existente
 function KillTask(ExeFileName: string): Integer;
    const
      PROCESS_TERMINATE = $0001;
    var
      ContinueLoop: BOOL;
      FSnapshotHandle: THandle;
      FProcessEntry32: TProcessEntry32;
    begin
      Result := 0;
      FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
      ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
      while Integer(ContinueLoop) <> 0 do
      begin
        if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
          UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
          UpperCase(ExeFileName))) then
          Result := Integer(TerminateProcess(
                            OpenProcess(PROCESS_TERMINATE,
                                        BOOL(0),
                                        FProcessEntry32.th32ProcessID),
                                        0));
         ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
      end;
      CloseHandle(FSnapshotHandle);
    end;

// checa as extensões
 function CheckExtenssion(DirectoryRoms:WideString;RomName:String;Extession:String):boolean;
  var
    Ext:TStringDynArray;
    i:integer;
  begin
    Result := false;
    Ext := SplitString(Extession,'|');

     for I := 0 to pred(length(Ext)) do
      begin
         if FileExists(DirectoryRoms+RomName+'.'+ext[i]) then
         begin
           Result := true;
           Break
         end;
      end;
  end;
  // retorna as extensões do arquivo
   function GetExtenssion(DirectoryRoms:WideString;RomName:String;Extession:String):String;
  var
    Ext:TStringDynArray;
    i:integer;
  begin
    Result := '';
    Ext := SplitString(Extession,'|');

     for I := 0 to pred(length(Ext)) do
      begin
         if FileExists(DirectoryRoms+RomName+'.'+ext[i]) then
         begin
           Result := ext[i];
           Break
         end;
      end;
  end;

  // abre o emulador selecionado precisa melhorar a forma que identifica o emulador
 procedure TF_Shifst_Main.OpenEmulator(Emulator,RunGame,DirectoryEmulator:string);
  var
     parametro:string ;
     extenssion:string;
  begin
   try
        //Seta a extensão correta para rodar a rom
       extenssion := '.'+GetExtenssion(Emuladores[Jogos[JI].ID].DirectoryRoms,RunGame,Emuladores[Jogos[JI].ID].RomsExtenssion);

       if Emulator = 'mameui.exe' then
            ShellExecute(1,'open',pchar(Emulator),pchar(RunGame),pchar(DirectoryEmulator), SW_SHOWNORMAL)
         else
       if Emulator ='Fusion.exe'  then
       begin
           parametro := '"'+Emuladores[Jogos[JI].ID].DirectoryRoms+RunGame+extenssion+'" -gen -auto -fullscreen';
           ShellExecute(1,'open',pchar(Emuladores[Jogos[JI].ID].DirectoryEmulator+Emulator),pchar(parametro),pchar(DirectoryEmulator), SW_SHOWNORMAL)
       end
         else
       if Emulator = 'snes9x.exe' then
       begin
           parametro := '-fullscreen "'+Emuladores[Jogos[JI].ID].DirectoryRoms+RunGame+extenssion+'"';
           ShellExecute(1,'open',pchar(Emulator),pchar(parametro),pchar(DirectoryEmulator), SW_SHOWNORMAL)
       end;
   except
      L_Info.Text := 'Erro ao carregar os jogos, nenhum emulador foi configurado.';
   end;
end;


procedure TF_Shifst_Main.Rectangle5Click(Sender: TObject);
begin

end;

// função que seta o node do xml corretamente
function SelectXMLNode(AXMLRoot: IXmlNode; const ANodePath: String): IXmlNode;
var
  DomNodeSelect : IDomNodeSelect;
  DomNode : IDomNode;
  XMLDocumentAccess : IXmlDocumentAccess;
  XMLDocument: TXmlDocument;
begin
      Result := nil;
      if not Assigned(AXMLRoot) or not Supports(AXMLRoot.DOMNode, IDomNodeSelect, DomNodeSelect) then
        Exit;
      DomNode := DomNodeSelect.selectNode(ANodePath);
      if Assigned(DomNode) then
      begin
        if Supports(AXMLRoot.OwnerDocument, IXmlDocumentAccess, XMLDocumentAccess) then
          XMLDocument := XMLDocumentAccess.DocumentObject
        else
          XMLDocument := nil;
        Result := TXmlNode.Create(DomNode, nil, XMLDocument);
      end;
end;

// procedimento que lêr o xml e carrega na memoria
procedure LoadGameList();
var
  XML: IXMLDocument;
  XMLNode: IXMLNode;
  I:integer;
  Match:string;

begin
   XML := NewXMLDocument;
        try
           if Emuladores.Count <> 0 then
              begin
                XML.LoadFromFile(Emuladores[II].Xml);
            end;

               for I := 1 to pred(XML.DocumentElement.ChildNodes.Count) do
                begin
                 XMLNode := SelectXMLNode(XML.DocumentElement,'/menu/game['+inttostr(i)+']');
                 Match := XMLNode.AttributeNodes.FindNode('name').Text;
                 // checa as combinações
                 if (
                      (FileExists(Emuladores[II].DirectoryWhells + Match + '.png'))
                          and (FileExists(Emuladores[II].DirectoryPrints + Match + '.png'))
                              and (CheckExtenssion(Emuladores[II].DirectoryRoms,Match,Emuladores[II].RomsExtenssion))
                    )
                 then
                   begin
                        Jogos.Add(Tlistajogos.Create(
                        XMLNode.AttributeNodes.FindNode('name').Text,
                        TrimLeft(XMLNode.ChildNodes.FindNode('description').Text),
                        XMLNode.ChildNodes.FindNode('year').Text,
                        XMLNode.ChildNodes.FindNode('manufacturer').Text,
                        XMLNode.ChildNodes.FindNode('genre').Text,
                        pchar(Emuladores[II].DirectoryPrints + Match + '.png'),
                        pchar(Emuladores[II].DirectoryWhells + Match + '.png'),
                        Emuladores[II].Emulator,
                        II)
                        );
                   end;
                end;
        except
         // TF_Shifst_Main.L_Info.Text := 'Erros foram encontrados no arquivo XML.';
        end;
end;

procedure TF_Shifst_Main.Updateinfo;
begin
    // informações dos jogos
    if jogos.count > 0 then
    begin
         L_NameGames.Text      :='Nome: '  +     Jogos[JI].Des;
         L_Info.Text           :=' Nome: ' + Jogos[JI].des;
         L_CategoryGames.Text  :='Gênero: ' +    Jogos[JI].Genero;
         L_AnoGames.Text       :='Ano: '    +    Jogos[JI].Ano;
         L_Emulador.Text       :='Emulador: ' +  copy(emuladores[II].Emulator,1,Length(emuladores[II].Emulator)-4);
         IM_Gamessnaps.Bitmap.LoadFromFile(Jogos[JI].wheel);
         IM_snaps.Bitmap.LoadFromFile(Jogos[JI].prints);

         //informações do emulador
         IM_Emulator.Bitmap.LoadFromFile(emuladores[II].ImgEmulator);
         L_EmulatorName.Text :='Emulador: '+ copy(emuladores[II].Emulator,1,Length(emuladores[II].Emulator)-4);
         L_GamesQt.Text :='Jogos: ' + inttostr(jogos.count);
         L_EmulatorExtenssion.Text:= 'Tipos de Rom: ' +Emuladores[II].RomsExtenssion;
    end else
      L_Info.Text := 'A lista não contem nenhum jogo.';
end;

// emula as teclas para cima e para baixo
procedure  TF_Shifst_Main.gameUp();
  begin
          if JI < Pred(jogos.Count) then
          begin
           shift(+6);
           Updateinfo;
           JI := JI +1;
          end
       else
          begin
           shift(+6);
           Updateinfo;
           JI := 0;
          end;

  end;

procedure TF_Shifst_Main.gameDown();
 begin
        if (JI > 1) then
          begin
            shift(-6);
            Updateinfo;
            JI := JI -1;
          end
      else
          begin
            Updateinfo;
            JI :=  Pred(jogos.Count);
            shift(-6);
          end;
  end;

procedure TF_Shifst_Main.FindGame(latter:string);
 var i:integer;
 begin
    for I := 0 to pred(jogos.count) do
     begin

       if ((Jogos.Items[i].des[1] = AnsiUpperCase(latter)) or (Jogos.Items[i].des[1] = latter) ) then
        begin
           JI := i;
           Sleep(500);
           shift(+6);
           Updateinfo;
           break;
        end;

     end;
 end;

function TF_Shifst_Main.DegPointY: Single;
begin
 Result := ((Rectangle1.Height * 0.5) - (Circle1.Height * 0.5) +950);
end;

// procedimento responsável pela transição das animações
procedure TF_Shifst_Main.FloatAnimationDegFinish(Sender: TObject);
begin
    FloatAnimationDeg.AnimationType:= TAnimationType.&Out;
    FloatAnimationDeg.Interpolation := TInterpolationType.Back;
    FloatAnimationDeg.StopValue := 0;
    Updateinfo;
    FloatAnimationY.AnimationType := TAnimationType.&Out;
    FloatAnimationY.Interpolation := TInterpolationType.back;
    FloatAnimationY.StopValue := DegPointY;
    InitCards;
    Layout1.Repaint;
end;

procedure TF_Shifst_Main.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;
  i:integer;
  ini : string;

begin
  InitCards;
  Layout1.AutoCapture := True;
  joys := TGamepad.Create;

      try
        Emuladores:= TObjectList<ListaEmuladores>.Create;
        Jogos := TObjectList<Tlistajogos>.Create;
        ini := ExtractFilePath(Application.name)+'\Emuladore.ini';
        IniFile := TIniFile.Create(ini);


          try
            for I := 1 to GetMaxSectionIndex(ini,'EMULADOR_') do
             begin
                Emuladores.Add(ListaEmuladores.Create(
                IniFile.ReadString('EMULADOR_'+inttostr(i),'XML',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'DIRETORIOEMULADOR',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'DIRETORIOROMS',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'DIRETORIOWHEELS',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'DIRETORIOSNAPS',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'NOMEEMULADOR',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'EXTENSAO',''),
                IniFile.ReadString('EMULADOR_'+inttostr(i),'IMGEMULADOR','')
                ));
             end;

          finally
            IniFile.Free;
          end;


      except
         L_Info.Text := 'Erro ao carregar o o arquivo ini.';
      end;

end;

procedure TF_Shifst_Main.FormDestroy(Sender: TObject);
begin
    Jogos.Free;
    Emuladores.Free;
end;

procedure TF_Shifst_Main.FormShow(Sender: TObject);
begin
    JI :=0;
    II :=0;
    showcursor(false);
    LoadGameList;
    Updateinfo;
end;

// inicializa as posições do cards
procedure TF_Shifst_Main.InitCards;
begin
    Rectangle2.Width := Rectangle1.Width;
    Rectangle2.Height := Rectangle1.Height;

    Circle1.RotationAngle:=0;
    Circle1.Position.X := (Rectangle1.Width * 0.5) - (Circle1.Width * 0.5);
    Circle1.Position.Y := DegPointY;
    FloatAnimationY.StopValue := DegPointY;
    Rectangle2.Position.X := (Rectangle1.Width - Circle1.Width) * -0.5;
    Rectangle2.Position.Y := -DegPointY;
    GaussianBlurEffect1.Enabled := false;
end;

// execulta as animações
procedure TF_Shifst_Main.shift(paction:integer);
 var H:Single;
begin
      Circle1.RotationAngle := paction;
      // Shift Left and Right
      if Abs (Circle1.RotationAngle) > 3
       then begin
         FloatAnimationDeg.AnimationType:= TAnimationType.&In;
         FloatAnimationDeg.Interpolation := TInterpolationType.Quadratic;
         FloatAnimationDeg.StopValue := Sign(Circle1.RotationAngle) * 60;
         GaussianBlurEffect1.Enabled := true;
       end
 else  begin
        H:=DegPointY;
        // Shift UP and Down
         if Abs (Circle1.Position.Y - H) > Rectangle1.Height * 0.15
          then  begin
             H := Sign(Circle1.Position.Y - H) *  Rectangle1.Height * 1.5 + H;
             FloatAnimationY.AnimationType := TAnimationType.&In;
             FloatAnimationY.Interpolation := TInterpolationType.Quadratic;
          end;

        FloatAnimationY.StopValue := H;
        FloatAnimationY.Start;

        end;

    FloatAnimationDeg.Start;
end;

// faz a leitura dos comandos do joystick
procedure TF_Shifst_Main.Timer1Timer(Sender: TObject);
begin
      //atualiza os comandos
  try
      joys.update;

     if Joys.JoyActive then
       begin
              // verifica se o processo está rodando
             if ProcessExists(Emuladores[Jogos[JI].ID].Emulator) then
                begin
                   // teclas para finalizar o processo do emulador
                   if (joys.buttons[Pred(9)]) and (joys.buttons[pred(10)])  then
                    begin
                      KillTask(Emuladores[Jogos[JI].ID].Emulator);
                    end;
                end
             else  begin

               if (Glyph1.ImageIndex = -1) then
                begin
                        // verifica se foi up ou down analogico ou digital
                       if (joys.y < 0) or (joys.POV.up) then
                          begin
                            Jogos.Clear;
                            if ((II < pred(Emuladores.Count))) then II := II +1 else II :=0;
                            LoadGameList();
                            JI := 0;
                            Updateinfo();
                            shift(+6);
                          end
                    else
                       if (joys.y > 0) or (joys.POV.down) then
                          begin
                            Glyph1.ImageIndex := 0;
                          end
                    else
                        if (joys.x > 0) or (joys.POV.right) then
                          begin
                            gameUp();
                          end
                    else
                        if (joys.x < 0) or (joys.POV.left) then
                          begin
                            gameDown();
                          end;


                       // verifica se o botão para iniciar o jogo foi pressionado
                      if (joys.buttons[pred(4)]) or (joys.buttons[pred(1)]) then
                      begin
                        OpenEmulator(Jogos[JI].Emulador,Jogos[JI].Nome,Emuladores[Jogos[JI].ID].DirectoryEmulator);
                      end;

                end;
                      if ((joys.x > 0) and (Glyph1.ImageIndex > -1)) or ((joys.POV.right)and (Glyph1.ImageIndex > -1)) then
                        begin

                            if ((Glyph1.ImageIndex < 35)) then Glyph1.ImageIndex := Glyph1.ImageIndex + 1 else Glyph1.ImageIndex :=0;
                        end;

                         if ((joys.x < 0) and (Glyph1.ImageIndex > -1)) or ((joys.POV.left) and (Glyph1.ImageIndex > -1)) then
                        begin
                            Glyph1.ImageIndex := Glyph1.ImageIndex - 1;
                        end;

                      if (joys.buttons[pred(4)]) or (joys.buttons[pred(1)]) then
                      begin
                         FindGame(ImageList1.Source.Items[Glyph1.ImageIndex].Name);
                         Glyph1.ImageIndex := -1;
                      end;
            end;
       end
       else
       L_Info.Text := 'Controle não conectado. Por favor conecte um controle e reinicie o Arcade System.';

  except
    // L_Info.Text := 'Houve um erro no sistema, feche o ArcadeSystem.';
  end;
end;



end.
