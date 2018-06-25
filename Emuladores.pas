unit Emuladores;

interface
   uses
    System.Generics.Collections,System.Generics.Defaults,System.SysUtils;

   type
      ListaEmuladores =  class
   Private
    FDirectoryPrints: WideString;
    FDirectoryWhells: WideString;
    FEmulator: String;
    FXml: WideString;
    FDirectoryRoms: WideString;
    FDirectoryEmulator: WideString;
    FRomsExtenssion: String;
    FImgEmulator: String;

  Public
  constructor Create(const PXML: WideString;const PDirectoryEmulator: WideString; const PDirectoryRoms: WideString;
  const PDirectoryWhells: WideString;const PDirectoryPrints: WideString;const PEmulator: string; const Pextenssion:string; const PImgEmulator:string);

   Property Xml : WideString read FXml write FXml;
   Property DirectoryEmulator : WideString read FDirectoryEmulator write FDirectoryEmulator;
   Property DirectoryRoms : WideString read FDirectoryRoms write FDirectoryRoms;
   Property DirectoryWhells : WideString read FDirectoryWhells write FDirectoryWhells;
   Property DirectoryPrints : WideString read FDirectoryPrints write FDirectoryPrints;
   Property Emulator : String read FEmulator write FEmulator;
   Property RomsExtenssion : String read FRomsExtenssion write FRomsExtenssion;
   Property ImgEmulator : String read FImgEmulator write FImgEmulator;

end;

implementation

{ ListaEmuladores }


constructor ListaEmuladores.Create(const PXML, PDirectoryEmulator,
  PDirectoryRoms, PDirectoryWhells, PDirectoryPrints: WideString;
  const PEmulator, Pextenssion ,PImgEmulator : string);
begin
    FXml                := PXML;
    FDirectoryEmulator  := PDirectoryEmulator;
    FDirectoryRoms      := PDirectoryRoms;
    FDirectoryWhells    := PDirectoryWhells;
    FDirectoryPrints    := PDirectoryPrints;
    FEmulator           := PEmulator;
    FRomsExtenssion     := Pextenssion;
    FImgEmulator        := PImgEmulator;
end;

end.
