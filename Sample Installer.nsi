; sample installer.nsi
; 
; A sample showing how to make an installer for a SLUDGE game
; You'll need NSIS to use this script.
;
;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------

; The name of the installer
Name "My Amazing Game"

; The file to write
OutFile "MyAmazingGameInstaller (Windows).exe"

XPStyle on

; The default installation directory
InstallDir "$PROGRAMFILES\My Amazing Game"

;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\My Amazing Game" ""

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------
;Variables

  Var StartMenuFolder

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------

; Pages

; This is a bitmap image that's shown in the installer window
  !define MUI_WELCOMEFINISHPAGE_BITMAP "amazing.bmp"
  
  !define MUI_WELCOMEPAGE_TITLE "My Amazing Game"
  !define MUI_WELCOMEPAGE_TEXT "(Version 1.00)$\r$\nCopyright Rikard Peterson 2010$\r$\n$\r$\nThis wizard will guide you through the installation of My Amazing Game.$\r$\n$\r$\n$\r$\nClick Next to continue."
  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_DIRECTORY
  
  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\My Amazing Game" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES


;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put files there
  
  ; This is all the engine files
  File *.frag
  File *.vert
  File *.dll
  File *.exe
  
  ; Then the game data
  File Gamedata.slg
  
  ; A manual, perhaps?
  File Manual.pdf
  
  ; And an icon for the startup menu
  File Amazing.ico


  ;Store installation folder
  WriteRegStr HKCU "Software\My Amazing Game" "" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    
    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\My Amazing Game.lnk" "$INSTDIR\SLUDGE Engine.exe" "" "$INSTDIR\Amazing.ico"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Manual.lnk" "$INSTDIR\Manual.pdf"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\My Amazing Web Page.lnk" "http://www.google.com/"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_END


SectionEnd ; end the section

;--------------------------------
;Uninstaller Section

Section "Uninstall"


  Delete "$INSTDIR\*.slg"
  Delete "$INSTDIR\*.frag"
  Delete "$INSTDIR\*.vert"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.pdf"
  Delete "$INSTDIR\*.ico"
  Delete "$INSTDIR\*.exe"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"
  
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
    
  Delete "$SMPROGRAMS\$StartMenuFolder\My Amazing Game.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Manual.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\My Amazing Web Page.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"
  
  DeleteRegKey /ifempty HKCU "Software\My Amazing Game"

SectionEnd
