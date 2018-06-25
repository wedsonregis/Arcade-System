unit U_Jogos;



interface
  uses
    System.Generics.Collections,System.Generics.Defaults,System.SysUtils;
type
  Tlistajogos = class

  private
    FNome: string;
    FGenero: String;
    FID: Integer;
    Fprints: WideString;
    FAno: String;
    FDes: String;
    FFabricante: String;
    FEmulador: String;
    Fwheels: WideString;
  public
      constructor Create(const PNome: string;const PDesc: string;const PAno: string;
      const PFabricante: string;const PGenero: string;const PPrints: WideString;
      const Pwheels: WideString;const Pemulador: string; const PID: Integer);

      property Emulador: String read FEmulador write FEmulador;
      property Nome: String read FNome write FNome;
      property Des: String read FDes write FDes;
      property Ano: String read FAno write FAno;
      property Fabricante: String read FFabricante write FFabricante;
      property Genero: String read FGenero write FGenero;
      property prints: WideString read Fprints write Fprints;
      property wheel: WideString read Fwheels write Fwheels;
      property ID: integer read FID write FID;
      procedure adicionar(Lista: Tlistajogos);
  end;

implementation
 { Tlistajogos }

procedure Tlistajogos.adicionar(Lista: Tlistajogos);
begin

end;

constructor Tlistajogos.Create(const PNome: string;const PDesc: string;const PAno: string;
      const PFabricante: string;const PGenero: string;const PPrints: WideString;
      const Pwheels: WideString;const Pemulador: string; const PID: Integer);
begin
    FNome := PNome;
    FGenero:= PGenero;
    FID:= PID;
    Fprints:= PPrints;
    FAno:= PAno;
    FDes:= PDesc;
    FFabricante:= PFabricante;
    FEmulador:= PEmulador;
    Fwheels:= Pwheels;
end;

end.
