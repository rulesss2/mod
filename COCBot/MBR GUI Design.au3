; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#cs
The MBR GUI is a nested tabbed design.  This file is called from MyBot.run.au3 to begin the build.  Other files are called as follows:

MBR GUI Design.au3; CreateMainGUI()
   MBR GUI Design Bottom.au3; CreateBottomPanel()

   MBR GUI Design Log.au3; CreateLogTab()

   MBR GUI Design Village.au3; CreateVillageTab()
	  MBR GUI Design Child Village - Misc.au3; CreateVillageMisc()
	  MBR GUI Design Child Village - Donate.au3; CreateVillageDonate()
	  MBR GUI Design Child Village - Upgrade.au3; CreateVillageUpgrade()
	  MBR GUI Design Child Village - Achievements.au3; CreateVillageAchievements()
	  MBR GUI Design Child Village - Notify.au3; CreateVillageNotify()

   MBR GUI Design Attack.au3; CreateAttackTab()
	  MBR GUI Design Child Attack - Troops.au3; CreateAttackTroops()
	  MBR GUI Design Child Attack - Search.au3; CreateAttackSearch()
		 MBR GUI Design Child Attack - Deadbase.au3; CreateAttackSearchDeadBase()
			MBR GUI Design Child Attack - Deadbase Attack Standard.au3; CreateAttackSearchDeadBaseStandard()
			MBR GUI Design Child Attack - Deadbase Attack Scripted.au3; CreateAttackSearchDeadBaseScripted()
			MBR GUI Design Child Attack - Deadbase Attack Milking.au3; CreateAttackSearchDeadBaseMilking()
			MBR GUI Design Child Attack - Deadbase-Search.au3; CreateAttackSearchDeadBaseSearch()
			MBR GUI Design Child Attack - Deadbase-Attack.au3; CreateAttackSearchDeadBaseAttack()
			MBR GUI Design Child Attack - Deadbase-EndBattle.au3; CreateAttackSearchDeadBaseEndBattle()
			MBR GUI Design Child Attack - Deadbase-Collectors.au3; CreateAttackSearchDeadBaseCollectors()
		 MBR GUI Design Child Attack - Activebase.au3; CreateAttackSearchActiveBase()
			MBR GUI Design Child Attack - Activebase Attack Standard.au3; CreateAttackSearchActiveBaseStandard()
			MBR GUI Design Child Attack - Activebase Attack Scripted.au3; CreateAttackSearchActiveBaseScripted()
			MBR GUI Design Child Attack - Activebase-Search.au3; CreateAttackSearchActiveBaseSearch()
			MBR GUI Design Child Attack - Activebase-Attack.au3; CreateAttackSearchActiveBaseAttack()
			MBR GUI Design Child Attack - Activebase-EndBattle.au3; CreateAttackSearchActiveBaseEndBattle()
		 MBR GUI Design Child Attack - THSnipe.au3; CreateAttackSearchTHSnipe()
			MBR GUI Design Child Attack - THSnipe-Search.au3; CreateAttackSearchTHSnipeSearch()
			MBR GUI Design Child Attack - THSnipe-Attack.au3; CreateAttackSearchTHSnipeAttack()
			MBR GUI Design Child Attack - THSnipe-EndBattle.au3; CreateAttackSearchTHSnipeEndBattle()
		 MBR GUI Design Child Attack - Bully.au3; CreateAttackSearchBully()
		 MBR GUI Design Child Attack - Options.au3; CreateAttackSearchOptions()
			MBR GUI Design Child Attack - Options-Search.au3; CreateAttackSearchOptionsSearch()
			MBR GUI Design Child Attack - Options-Attack.au3; CreateAttackSearchOptionsAttack()
			MBR GUI Design Child Attack - NewSmartZap.au3; CreateAttackNewSmartZap()
			MBR GUI Design Child Attack - Options-EndBattle.au3;CreateAttackSearchOptionsEndBattle()
			MBR GUI Design Child Attack - Options-TrophySettings.au3; CreateAttackSearchOptionsTrophySettings()
	  MBR GUI Design Child Attack - Strategies.au3; CreateAttackStrategies()

   MBR GUI Design Bot.au3; CreateBotTab()
	  MBR GUI Design Child Bot - Options.au3; CreateBotOptions()
	  MBR GUI Design Child Bot - Android.au3; CreateBotAndroid()
	  MBR GUI Design Child Bot - Debug.au3; CreateBotDebug()
	  MBR GUI Design Child Bot - Profiles.au3; CreateBotProfiles()
	  MBR GUI Design Child Bot - Stats.au3; CreateBotStats()
#ce

#include-once

#include "Functions\Other\AppUserModelId.au3"
#include "Functions\GUI\_GUICtrlSetTip.au3"
#include "functions\GUI\_GUICtrlCreatePic.au3"
#include "functions\GUI\GUI_State.au3"

Global Const $TCM_SETITEM = 0x1306
Global Const $_GUI_MAIN_WIDTH = 472 ; changed from 470 to 472 for DPI scaling cutting off right by 2 pixel
Global Const $_GUI_MAIN_HEIGHT = 692 ; changed from 690 to 692 for DPI scaling cutting off bottom by 2 pixel
Global $_GUI_MAIN_TOP = 23 ; Adjusted in CreateMainGUI()
Global $_GUI_MAIN_BUTTON_SIZE = [25, 17] ; minimize/close button size
Global $_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP ; Adjusted in CreateMainGUI()
Global Const $_GUI_BOTTOM_HEIGHT = 135
Global Const $_GUI_CHILD_LEFT = 10
Global Const $g_bBtnColor = False; True

Global Const $g_iSizeWGrpTab1 = $_GUI_MAIN_WIDTH - 20
Global Const $g_iSizeHGrpTab1 = $_GUI_MAIN_HEIGHT - 255
Global Const $g_iSizeWGrpTab2 = $_GUI_MAIN_WIDTH - 30 ;440
Global Const $g_iSizeHGrpTab2 = $_GUI_MAIN_HEIGHT - 285 ;405
Global Const $g_iSizeWGrpTab3 = $_GUI_MAIN_WIDTH - 40 ;430
Global Const $g_iSizeHGrpTab3 = $_GUI_MAIN_HEIGHT - 315 ;375
Global Const $g_iSizeWGrpTab4 = $_GUI_MAIN_WIDTH - 50 ;420
Global Const $g_iSizeHGrpTab4 = $_GUI_MAIN_HEIGHT - 345 ;345

Global $g_iBotDesignFlags = 3 ; Bit 0 = Use Windows Default Title Bar, 1 = Use new custom Title Bar, 2 = Auto Slide bot when docked and window activation changes, 4, 8, ... future features
Global $g_bCustomTitleBarActive = Default ; Current state if custom title bar has been designed, set to True or False in CreateMainGUI()
Global $g_bBotDockedShrinked = False ; Bot is shrinked or not when docked
Global $hImageList = 0
Global $g_hFrmBotButtons, $g_hFrmBotLogoUrlSmall, $g_hFrmBotEx = 0, $g_hLblBotTitle, $g_hLblBotShrink = 0, $g_hLblBotExpand = 0, $g_hLblBotMinimize = 0, $g_hLblBotClose = 0, $g_hFrmBotBottom = 0
Global $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedShieldInput = 0, $g_hFrmBotEmbeddedGraphics = 0
Global $g_hFrmBot_MAIN_PIC = 0, $g_hFrmBot_URL_PIC = 0, $g_hFrmBot_URL_PIC2 = 0
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
;Global $g_hTabMain = 0, $g_hTabLog = 0, $g_hTabVillage = 0, $g_hTabAttack = 0, $g_hTabBot = 0, $g_hTabAbout = 0
Global $g_hTabMain = 0, $g_hTabLog = 0, $g_hTabVillage = 0, $g_hTabAttack = 0, $g_hTabBot = 0, $g_hTabAbout = 0, $g_hTabMOD = 0
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
Global $g_hStatusBar = 0
Global $g_hTiShow = 0, $g_hTiHide = 0, $g_hTiDonate = 0, $g_hTiAbout = 0, $g_hTiExit = 0
Global $g_aFrmBotPosInit[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hFirstControlToHide = 0, $g_hLastControlToHide = 0, $g_aiControlPrevState[1]
Global $g_bFrmBotMinimized = False ; prevents bot flickering

#include "GUI\MBR GUI Design Bottom.au3"
#include "GUI\MBR GUI Design Log.au3"
#include "GUI\MBR GUI Design Village.au3"
#include "GUI\MBR GUI Design Attack.au3"
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
#include "GUI\MBR GUI Design MOD.au3"
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
#include "GUI\MBR GUI Design Bot.au3"
#include "GUI\MBR GUI Design About.au3"

Func CreateMainGUI()

	;~ ------------------------------------------------------
	;~ Main GUI
	;~ ------------------------------------------------------
	Local $iStyle = $WS_BORDER
	If BitAND($g_iBotDesignFlags, 1) = 0 Then
		; Window default title bar
		$g_bCustomTitleBarActive = False
		$iStyle = $WS_CAPTION
		; adjust some hights
		$_GUI_MAIN_TOP = 5
		$_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP
	Else
		$g_bCustomTitleBarActive = True
	EndIf
	$g_hFrmBot = _GUICreate($g_sBotTitle, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT + $_GUI_MAIN_TOP, $g_iFrmBotPosX, $g_iFrmBotPosY, _
					BitOr($WS_MINIMIZEBOX, $WS_POPUP, $WS_SYSMENU, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $iStyle))
    ; group multiple bot windows using _WindowAppId
	_WindowAppId($g_hFrmBot, "MyBot.run")
	GUISetIcon($g_sLibIconPath, $eIcnGUI)
EndFunc   ;==>CreateMainGUI

Func CreateMainGUIControls()
   Local $aBtnSize = $_GUI_MAIN_BUTTON_SIZE
   GUISwitch($g_hFrmBot)
   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_01", "Loading Main GUI..."))

   If $g_bCustomTitleBarActive Then
	   $g_hFrmBotButtons = GUICreate("My Bot Title Buttons", 3 * $aBtnSize[0], $aBtnSize[1], $_GUI_MAIN_WIDTH - $aBtnSize[0] * 3, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, ($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED)), $g_hFrmBot)
	   WinSetTrans($g_hFrmBotButtons, "", 254) ; trick to hide buttons from Android Screen that is not always refreshing
   EndIf
   ; Need $g_hFrmBotEx for embedding Android
   $g_hFrmBotEx = _GUICreate("My Bot Controls", $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, 0, 0, _
						    BitOR($WS_CHILD, $WS_TABSTOP), 0, $g_hFrmBot)
   If $g_bCustomTitleBarActive = False Then
		; Window default title bar
	   GUICtrlCreateLabel("", 0, 0, $_GUI_MAIN_WIDTH, $_GUI_MAIN_TOP)
	   GUICtrlSetOnEvent(-1, "BotMoveRequest")
	   GUICtrlSetBkColor(-1, $COLOR_WHITE)
   Else
	   ; align title bar with logo
	   Local $iTitleX = 25
	   GUICtrlCreateLabel("", 0, 0, $iTitleX, $_GUI_MAIN_TOP)
	   GUICtrlSetOnEvent(-1, "BotMoveRequest")
	   GUICtrlSetBkColor(-1, $COLOR_WHITE)
	   ; title
	   $g_hLblBotTitle = GUICtrlCreateLabel($g_sBotTitle, $iTitleX, 0, $_GUI_MAIN_WIDTH - 3 * $aBtnSize[0] - 25, $_GUI_MAIN_TOP) ;, $SS_CENTER)
	   GUICtrlSetOnEvent(-1, "BotMoveRequest")
	   GUICtrlSetFont(-1, 11, 0, 0, "Segoe UI") ; "Verdana" "Lucida Console"
	   GUICtrlSetBkColor(-1, $COLOR_WHITE)
	   GUICtrlSetColor(-1, 0x171717)

	   ; buttons, positions are adjusted also in BotShrinkExpandToggle()
	   GUISwitch($g_hFrmBotButtons)
	   ; ◄ ► docked shrink/expand
	   $g_hLblBotShrink = GUICtrlCreateLabel(ChrW(0x25C4), 0, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
	   GUICtrlSetFont(-1, 10)
	   GUICtrlSetBkColor(-1, 0xF0F0F0)
	   GUICtrlSetColor(-1, 0xB8B8B8)
	   $g_hLblBotExpand = GUICtrlCreateLabel(ChrW(0x25BA), 0, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
	   GUICtrlSetState(-1, $GUI_HIDE)
	   GUICtrlSetFont(-1, 10)
	   GUICtrlSetBkColor(-1, 0xF0F0F0)
	   GUICtrlSetColor(-1, 0xB8B8B8)
	   ; minimize button
	   $g_hLblBotMinimize = GUICtrlCreateLabel("̶", $aBtnSize[0], 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
	   GUICtrlSetFont(-1, 10)
	   GUICtrlSetBkColor(-1, 0xF0F0F0)
	   GUICtrlSetColor(-1, 0xB8B8B8)
	   ; close button
	   $g_hLblBotClose = GUICtrlCreateLabel("×", $aBtnSize[0] * 2, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
	   GUICtrlSetFont(-1, 10)
	   GUICtrlSetBkColor(-1, 0xFF4040)
	   GUICtrlSetColor(-1, 0xF8F8F8)

	   $g_hFrmBotLogoUrlSmall = _GUICreate("My Bot URL", 290, 13, 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, ($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED)), $g_hFrmBot)
	   ;WinSetTrans($g_hFrmBotLogoUrlSmall, "", 254) ; trick to hide buttons from Android Screen that is not always refreshing
	   $g_hFrmBot_URL_PIC2 = _GUICtrlCreatePic($g_sLogoUrlSmallPath, 0, 0, 290, 13)
	   GUICtrlSetCursor(-1, 0)

	   GUISwitch($g_hFrmBotEx)
	   ; fill button space
	   GUICtrlCreateLabel("", $_GUI_MAIN_WIDTH - 3 * $aBtnSize[0], $aBtnSize[1], 3 * $aBtnSize[0], $_GUI_MAIN_TOP - $aBtnSize[1])
	   GUICtrlSetOnEvent(-1, "BotMoveRequest")
	   GUICtrlSetBkColor(-1, $COLOR_WHITE)
   EndIf

   $g_hFrmBot_MAIN_PIC = _GUICtrlCreatePic($g_sLogoPath, 0, $_GUI_MAIN_TOP, 472, 67)
   GUICtrlSetOnEvent(-1, "BotMoveRequest")

   $g_hFrmBot_URL_PIC = _GUICtrlCreatePic($g_sLogoUrlPath, 0, $_GUI_MAIN_TOP + 67, 472, 13)
   GUICtrlSetCursor(-1, 0)

   $g_hToolTip = _GUIToolTip_Create($g_hFrmBot) ; tool tips for URL links etc
   _GUIToolTip_SetMaxTipWidth($g_hToolTip, $_GUI_MAIN_WIDTH) ; support multiple lines

   GUISwitch($g_hFrmBot)
   $g_hFrmBotEmbeddedShieldInput = GUICtrlCreateInput("", 0, 0, -1, -1, $WS_TABSTOP)
   ;$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateLabel("", 0, 0, 0, 0, $WS_TABSTOP)
   ;$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateDummy()
   GUICtrlSetState($g_hFrmBotEmbeddedShieldInput, $GUI_HIDE)

   $g_hFrmBotBottom = _GUICreate("My Bot Buttons", $_GUI_MAIN_WIDTH, $_GUI_BOTTOM_HEIGHT, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, _
							    BitOR($WS_CHILD, $WS_TABSTOP), 0, $g_hFrmBot)

   ;~ ------------------------------------------------------
   ;~ Header Menu
   ;~ ------------------------------------------------------
   GUISwitch($g_hFrmBot)
   ;$idMENU_DONATE = GUICtrlCreateMenu("&" & GetTranslatedFileIni("MBR GUI Design Bottom", "g_hLblDonate_Info_01", "Paypal Donate?"))
   ;_GUICtrlMenu_SetItemType(_GUICtrlMenu_GetMenu($g_hFrmBot), 0, $MFT_RIGHTJUSTIFY) ; move to right
   ;$idMENU_DONATE_SUPPORT = GUICtrlCreateMenuItem(GetTranslatedFileIni("MBR GUI Design Bottom", "g_hLblDonate", "Support the development"), $idMENU_DONATE)
   ;GUICtrlSetOnEvent(-1, "")

   ;~ ------------------------------------------------------
   ;~ GUI Bottom Panel
   ;~ ------------------------------------------------------
   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_02", "Loading GUI Bottom..."))
   GUISwitch($g_hFrmBotBottom)
   CreateBottomPanel()

   ;~ ------------------------------------------------------
   ;~ GUI Child Tab Files
   ;~ ------------------------------------------------------
   GUISwitch($g_hFrmBotEx)

   ; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
   $g_hFirstControlToHide = GUICtrlCreateDummy()

   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_03", "Loading Log tab..."))
   CreateLogTab()

   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_04", "Loading Village tab..."))
   CreateVillageTab()

   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_05", "Loading Attack tab..."))
   CreateAttackTab()

; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
   SplashStep("Loading MOD tab...")
   CreateMODTab()
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;

   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_06", "Loading Bot tab..."))
   CreateBotTab()

   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_07", "Loading About Us tab..."))
   CreateAboutTab()

   SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_08", "Initializing GUI..."))

   ;~ ------------------------------------------------------
   ;~ GUI Main Tab Control
   ;~ ------------------------------------------------------
   GUISwitch($g_hFrmBotEx)
   $g_hTabMain = GUICtrlCreateTab(5, 85 + $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH - 9, $_GUI_MAIN_HEIGHT - 225); , $TCS_MULTILINE)
   $g_hTabLog = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_01", "Log"))
   $g_hTabVillage = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village"))
   $g_hTabAttack = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03", "Attack Plan"))
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
   $g_hTabMOD = GUICtrlCreateTabItem("Pico")
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
   $g_hTabBot = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04", "Bot"))
   $g_hTabAbout = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_05", "About Us"))
   GUICtrlCreateTabItem("")
   GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

   ;~ -------------------------------------------------------------
   ;~ GUI init
   ;~ -------------------------------------------------------------
   ; Bind Icon images to all Tabs in all GUI windows (main and children)
   Bind_ImageList($g_hTabMain)

   Bind_ImageList($g_hGUI_VILLAGE_TAB)
	  Bind_ImageList($g_hGUI_DONATE_TAB)
	  Bind_ImageList($g_hGUI_UPGRADE_TAB)
	  Bind_ImageList($g_hGUI_NOTIFY_TAB)

   Bind_ImageList($g_hGUI_ATTACK_TAB)
	  Bind_ImageList($g_hGUI_TRAINARMY_TAB)
	  Bind_ImageList($g_hGUI_SEARCH_TAB)
		 Bind_ImageList($g_hGUI_DEADBASE_TAB)
		 Bind_ImageList($g_hGUI_ACTIVEBASE_TAB)
		 Bind_ImageList($g_hGUI_THSNIPE_TAB)
		 Bind_ImageList($g_hGUI_ATTACKOPTION_TAB)
	  Bind_ImageList($g_hGUI_STRATEGIES_TAB)

; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;
   Bind_ImageList($g_hGUI_MOD_TAB)
; ================================================== ADDITION BY ROROTITI - PICO MOD ================================================== ;

   Bind_ImageList($g_hGUI_BOT_TAB)

   Bind_ImageList($g_hGUI_STATS_TAB)

   ; Show Tab LOG
   GUICtrlSetState($g_hGUI_LOG, $GUI_SHOW)

   ; Create log window
   cmbLog()

   ; Bottom status bar
   $g_hStatusBar = _GUICtrlStatusBar_Create($g_hFrmBotBottom)
   _GUICtrlStatusBar_SetSimple($g_hStatusBar)
   GUISetDefaultFont($g_hStatusBar)
   _GUICtrlStatusBar_SetText($g_hStatusBar, "Status : Idle")
   $g_hTiShow = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_01", "Show bot"))
   TrayItemSetOnEvent($g_hTiShow, "tiShow")
   $g_hTiHide = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_02", "Hide when minimized"))
   TrayItemSetOnEvent($g_hTiHide, "tiHide")
   TrayCreateItem("")
   $g_hTiDonate = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_03", "Support Development"))
   TrayItemSetOnEvent($g_hTiDonate, "tiDonate")
   $g_hTiAbout = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_04", "About"))
   TrayItemSetOnEvent($g_hTiAbout, "tiAbout")
   TrayCreateItem("")
   $g_hTiExit = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_05", "Exit"))
   TrayItemSetOnEvent($g_hTiExit, "tiExit")

   ;~ -------------------------------------------------------------
   SetDebugLog("$g_hFrmBot=" & $g_hFrmBot, Default, True)
   SetDebugLog("$g_hFrmBotEx=" & $g_hFrmBotEx, Default, True)
   SetDebugLog("$g_hFrmBotBottom=" & $g_hFrmBotBottom, Default, True)
   SetDebugLog("$g_hFrmBotEmbeddedShield=" & $g_hFrmBotEmbeddedShield, Default, True)
   SetDebugLog("$g_hFrmBotEmbeddedShieldInput=" & $g_hFrmBotEmbeddedShieldInput, Default, True)
   SetDebugLog("$g_hFrmBotEmbeddedGraphics=" & $g_hFrmBotEmbeddedGraphics, Default, True)

EndFunc   ;==>CreateMainGUIControls

Func ShowMainGUI()
	CheckDpiAwareness(False, $g_bBotLaunchOption_ForceDpiAware, True)

	If Not $g_bNoFocusTampering Then
		; normal
		GUISetState(@SW_SHOW, $g_hFrmBot)
	Else
		GUISetState(@SW_SHOW, $g_hFrmBot)
		;GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBot)
		;Local $lCurExStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE)
		;_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_TOPMOST))
		;_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $lCurExStyle)
	EndIf

	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotButtons)
	If $g_hFrmBotEx Then GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEx)
	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotBottom)
    CheckBotShrinkExpandButton()

    GUISwitch($g_hFrmBotEx)
	$g_bFrmBotMinimized = False

	Local $p = WinGetPos($g_hFrmBot)
	$g_aFrmBotPosInit[0] = $p[0]
	$g_aFrmBotPosInit[1] = $p[1]
	$g_aFrmBotPosInit[2] = $p[2]
	$g_aFrmBotPosInit[3] = $p[3]
	$g_aFrmBotPosInit[4] = _WinAPI_GetClientWidth($g_hFrmBot)
	$g_aFrmBotPosInit[5] = _WinAPI_GetClientHeight($g_hFrmBot)
	$g_aFrmBotPosInit[6] = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)[3]

EndFunc   ;==>ShowMainGUI

Func UpdateMainGUI()
   If $g_hLibMyBot <> -1 Then
	   ;enable buttons start and search mode only if MRBfunctions.dll loaded, prevent click of buttons before dll loaded in memory
	   GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
	   ; enable search only button when TH level variable has valid level, to avoid posts from users not pressing start first
	   If $g_iTownHallLevel > 2 Then
		   GUICtrlSetState($g_hBtnSearchMode, $GUI_ENABLE)
	   EndIf
   EndIf
EndFunc   ;==>UpdateMainGUI

Func CheckDpiAwareness($bCheckOnlyIfAlreadyAware = False, $bForceDpiAware = False, $bForceDpiAware2 = False)

	Static $sbDpiAware = False
	Static $sbDpiAlreadyChecked = False

	If $bCheckOnlyIfAlreadyAware = True Then Return $sbDpiAware

	Local $bDpiAware = False
	Local $bChanged = False

	if $sbDpiAlreadyChecked = True Or ($g_iBotLaunchTime = 0 And $bForceDpiAware2 = False) Then Return $bChanged

	If $g_iDpiAwarenessMode <> 0 And RegRead("HKCU\Control Panel\Desktop\WindowMetrics", "AppliedDPI") <> 96 Then
		; DPI is different, check if awareness needs to be set
		$bDpiAware = $bForceDpiAware = True _ ; override to set DPI Awareness regardless of current state
			Or $g_bChkBackgroundMode = False _ ; in non background mode Desktop screen capture is totally wrong due to the scaling
			Or ($g_bAndroidAdbScreencap = False And GetProcessDpiAwareness(GetAndroidPid())) ; in normal background mode using WinAPI and Android is DPI Aware, bot must be too or window will be scaled and blury
		$bChanged = $bDpiAware And Not $sbDpiAware
		If $bChanged Then ; only required when not running with screencap
			$sbDpiAware = True ; do it only once, assume bot will become DPI aware
			Local $bWasEmbedded = AndroidEmbedded()
			If $bWasEmbedded Then AndroidEmbed(False)
			; Make this process DPI aware, so it doesn't scale (for now only way to get bot working right)
			If $g_bCustomTitleBarActive = False Then
				; Default Windows Title Bar changes height
				Local $g_iDpiAwarenessYcomp = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
				Local $aResult = DllCall("user32.dll", "boolean", "SetProcessDPIAware")
				$g_aFrmBotPosInit[7] = _WinAPI_GetSystemMetrics($SM_CYCAPTION) - $g_iDpiAwarenessYcomp
				SetDebugLog("Enabled DPI Awareness, height compensation: " & $g_aFrmBotPosInit[7])
				;DllCall("user32.dll", "dword", "SetProcessDpiAwareness", "dword", 0)
			Else
				; custom Custom Title Bar
				Local $aResult = DllCall("user32.dll", "boolean", "SetProcessDPIAware")
			EndIf
			SetDebugLog("SetProcessDPIAware called: " & @error & ((UBound($aResult) = 0) ? ("") : (", " & $aResult[0])))
			If $bWasEmbedded Then AndroidEmbed(True)
		EndIf

	EndIf

	;$sbDpiAlreadyChecked = True ; executed often so cache result (even if DPI changes!)

	return $bChanged
EndFunc   ;==>CheckDpiAwareness

Func GetProcessDpiAwareness($iPid)
	$iPid = ProcessExists($iPid)
	If $iPid = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $hProcess
	If _WinAPI_GetVersion() >= 6.0 Then
		$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $iPID)
	Else
		$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION, 0, $iPID)
	EndIf
	If @error Then
		Return SetError(2, 0, 0)
	EndIf
	Local $aResult = DllCall("user32.dll", "boolean", "GetProcessDpiAwarenessInternal", "handle", $hProcess, "ulong*", 0)
	_WinAPI_CloseHandle($hProcess)
	If @error Or UBound($aResult) < 3 Then Return SetError(3, 0, 0)
	Local $iDpiAwareness = $aResult[2]
	Return $iDpiAwareness
EndFunc   ;==>GetProcessDpiAwareness

Func _GUICreate($title, $width, $height, $left = -1, $top = -1, $style = -1, $exStyle = -1, $parent = 0)
	Local $h = GUICreate($title, $width, $height, $left, $top, $style, $exStyle, $parent)
	GUISetDefaultFont($h)
	Return $h
EndFunc   ;==>_GUICreate

Func GUISetDefaultFont($h)
	; Disabled for now as DPI Aware support is more difficult to add
	;GUISetFont(8.5 * GetDPIRatio(), 0, 0, "", $h) ; update gui for scales DPI settings
EndFunc   ;==>GUISetDefaultFont

;######################################################################################################################################
; #FUNCTION# ====================================================================================================================
; Name ..........: GetDPIRatio
; Description ...:
; Syntax ........: GetDPIRatio([$iDPIDef = 96])
; Parameters ....: $iDPIDef             - [optional] An integer value. Default is 96.
; Return values .: Desktop Scaling float (1 = 100% for 96 DPI)
; Author ........: UEZ
; Modified ......:
; Remarks .......: Update GUI like this: GUISetFont(8.5 * _GDIPlus_GraphicsGetDPIRatio())
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/159612-dpi-resolution-problem/?hl=%2Bdpi#entry1158317
; Example .......: No
; ===============================================================================================================================
Func GetDPIRatio($iDPIDef = 96)
	;return 1
    _GDIPlus_Startup()
    Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
    If @error Then Return SetError(1, @extended, 0)
    Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)
    If @error Then Return SetError(2, @extended, 1)
    Local $iDPI = $iDPIDef / $aResult[2]
    _GDIPlus_GraphicsDispose($hGfx)
    _GDIPlus_Shutdown()
    Return $iDPI
EndFunc   ;==>GetDPIRatio
