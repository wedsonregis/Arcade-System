# Arcade-System
This front was developed at Tokyo delphi without using third party components, some of the concepts involved:

### XML
### INI files
### Windows Processes
### Windows API
### API Joysticks
### Class

the games will only be loaded if the Snaps and Wheels and roms have the same names
```Delphi
 if (
       (FileExists(Emuladores[II].DirectoryWhells + Match + '.png'))
         and (FileExists(Emuladores[II].DirectoryPrints + Match + '.png'))
           and (CheckExtenssion(Emuladores[II].DirectoryRoms,Match,Emuladores[II].RomsExtenssion))
```           
Link to download the Snaps
https://github.com/ekeeke/no-intro-thumbnails

Link to download the Wheels
https://www.arcadepunks.com/download-hyperspin-wheels/

Link to download Database XML
https://hyperlist.hyperspin-fe.com/


# Parameter INI
Para adicionar novos emuladore segue a estrutura EMULADOR_X onde "x" é o numero do emulador, atualmente o sustema trabalha com 3 tipos de emuladores 
# mameui,  Snes9x e  Fusion
[EMULADOR_1]
XML=C:\Arcade System\XML\MAME.xml
DIRETORIOEMULADOR=C:\Arcade System\Emuladores\MAME\MameUI_0.183_32bit\
DIRETORIOROMS=C:\Arcade System\Emuladores\MAME\ROMs\ROMs\
DIRETORIOWHEELS=C:\Arcade System\Wheel\MAME\
DIRETORIOSNAPS=C:\Arcade System\Snaps\MAME\
NOMEEMULADOR=mameui.exe
EXTENSAO=7z|rar|zip
IMGEMULADOR=C:\Arcade System\Logos\MAME.png

[EMULADOR_2]
XML=C:\Arcade System\XML\Sega Genesis.xml
DIRETORIOEMULADOR=D:\Arcade System\Emuladores\SEGA\
DIRETORIOROMS=D:\Arcade System\Emuladores\SEGA\roms megadrive\
DIRETORIOWHEELS=C:\Arcade System\Wheel\SEGA\
DIRETORIOSNAPS=C:\Arcade System\Snaps\SEGA\
NOMEEMULADOR=Fusion.exe
EXTENSAO=md|7z|rar|zip
IMGEMULADOR=C:\Arcade System\Logos\SEGA.png

[EMULADOR_3]
XML=C:\Arcade System\XML\Super Nintendo Entertainment System.xml
DIRETORIOEMULADOR=D:\Arcade System\Emuladores\SNES\
DIRETORIOROMS=D:\Arcade System\Emuladores\SNES\Roms\
DIRETORIOWHEELS=C:\Arcade System\Wheel\SNES\
DIRETORIOSNAPS=C:\Arcade System\Snaps\SNES\
NOMEEMULADOR=snes9x.exe
EXTENSAO=sfc|smc|zip
IMGEMULADOR=C:\Arcade System\Logos\SNES.png

Note that at the end of each directory we have a "\" is extremely necessary to use this bar, the extensions are separated by "|"
EXTENSAO = sfc | smc | zip
