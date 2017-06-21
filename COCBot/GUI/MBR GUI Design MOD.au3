; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac ( 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; *********************************** JUST INFOS ************************************
; To change the Child Tabs Icons ITEM1 , ITEM 2 and ITEM 3 :
; GUI Control.au3 line 1841 :
; Case $g_hGUI_MOD_TAB
; the icons for MOD tab
;Local $aIconIndex[3] = [$eIcnPBNotify, $eIcnPBNotify, $eIcnPBNotify]

; TO change the TAB icon MOD
; GUI Control.au3 line 1793 :
; Case $g_hTabMain
; the icons for main tab
;Local $aIconIndex[6] = [$eIcnHourGlass, $eIcnTH11, $eIcnAttack, ** $eIcnPBNotify ** , $eIcnGUI, $eIcnInfo]

; *********************************** END  INFOS ************************************

; ================================================== SWITCH ACCOUNT PART ================================================== ;
Global $chkEnableSwitchAccount = 0, $lblNB = 0, $g_cmbAccountsQuantity = 0
Global $g_achkCanUse[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_achkDonateAccount[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_acmbAccount[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_cmbMaxStayDelay = 0, $g_cmbMinDelayToSwitch = 0
Global $g_lblEndSwitchAccount

; ================================================== BOT HUMANIZATION PART ================================================== ;
Global $g_chkUseBotHumanization = 0, $g_chkUseAltRClick = 0, $g_acmbPriority = 0, $g_challengeMessage = 0, $g_ahumanMessage
Global $g_Label1 = 0, $g_Label2 = 0, $g_Label3 = 0, $g_Label4 = 0
Global $g_Label5 = 0, $g_Label6 = 0, $g_Label7 = 0, $g_Label8 = 0
Global $g_Label9 = 0, $g_Label10 = 0, $g_Label11 = 0, $g_Label12 = 0
Global $g_Label14 = 0, $g_Label15 = 0, $g_Label16 = 0, $g_Label13 = 0
Global $g_Label17 = 0, $g_Label18 = 0, $g_Label20 = 0
Global $g_chkCollectAchievements = 0, $g_chkLookAtRedNotifications = 0, $g_cmbMaxActionsNumber = 0
Global $g_acmbPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_acmbMaxSpeed[2] = [0, 0]
Global $g_acmbPause[2] = [0, 0]
Global $g_ahumanMessage[2] = ["", ""]

; ================================================== TREASURY COLLECT PART ================================================== ;
Global $g_chkEnableTrCollect = 0, $g_chkForceTrCollect = 0
Global $g_chkGoldTrCollect = 0, $g_chkElxTrCollect = 0, $g_chkDarkTrCollect = 0
Global $g_txtMinGoldTrCollect = 0, $g_txtMinElxTrCollect = 0, $g_txtMinDarkTrCollect = 0
Global $g_chkFullGoldTrCollect = 0, $g_chkFullElxTrCollect = 0, $g_chkFullDarkTrCollect = 0

; ================================================== AUTO UPGRADE PART ================================================== ;
Global $g_chkAutoUpgrade = 0, $g_AutoUpgradeLog = 0
Global $g_chkIgnoreTH = 0, $g_chkIgnoreKing = 0, $g_chkIgnoreQueen = 0, $g_chkIgnoreWarden = 0, $g_chkIgnoreCC = 0, $g_chkIgnoreLab = 0
Global $g_chkIgnoreBarrack = 0, $g_chkIgnoreDBarrack = 0, $g_chkIgnoreFactory = 0, $g_chkIgnoreDFactory = 0, $g_chkIgnoreGColl = 0, $g_chkIgnoreEColl = 0, $g_chkIgnoreDColl = 0
Global $g_SmartMinGold = 0, $g_SmartMinElixir = 0, $g_SmartMinDark = 0

; ================================================== BB FEATURES PART ================================================== ;

Global $g_alblBldBaseStats[4] = ["", "", ""], $g_chkCollectBldGE = 0, $g_chkCollectBldGems = 0, $g_chkActivateClockTower = 0
Global $g_chkBBSuggestedUpgrades = 0, $g_chkBBSuggestedUpgradesIgnoreGold = 0 , $g_chkBBSuggestedUpgradesIgnoreElixir , $g_chkBBSuggestedUpgradesIgnoreHall = 0

; ================================================== ChatBot FEATURES PART ================================================== ;
Global $chatIni = ""
Global $cmblang = 0,  $icmblang = 0
Global $chkGlobalChat = 0,$chkGlobalScramble = 0,$chkSwitchLang = 0,$chkGlobChatTimeDalay = 0, $chkClanChat = 0
Global $chkUseResponses = 0,$chkUseGeneric = 0,$chkChatPushbullet = 0,$chkPbSendNewChats = 0
Global $editGlobalMessages1 = "", $editGlobalMessages2 = "",$editGlobalMessages3 = "",$editGlobalMessages4 = ""
Global $editResponses = 0,$editGeneric = 0,$ChatbotQueuedChats[0],$ChatbotReadQueued = False,$ChatbotReadInterval = 0,$ChatbotIsOnInterval = False,$TmpResp
Global $g_alblAinGlobal,$g_alblSGchats,$g_alblSwitchlang,$g_alblChatclan,$g_alblUsecustomresp,$g_alblUsegenchats,$g_alblNotifyclanchat,$g_alblSwitchlang,$g_alblUseremotechat,$g_alblTimeDalay

Global $g_hGUI_MOD = 0

; For future child Tabs
; #include "MBR GUI Design Child MOD - ITEMXXX.au3"
; The Child Tabs
Global $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0, $g_hGUI_MOD_TAB_ITEM2 = 0, $g_hGUI_MOD_TAB_ITEM3 = 0, $g_hGUI_MOD_TAB_ITEM4 = 0, $g_hGUI_MOD_TAB_ITEM5 = 0, $g_hGUI_MOD_TAB_ITEM6 = 0, $g_hGUI_MOD_TAB_ITEM7 = 0

Func CreateMODTab()

	$g_hGUI_MOD = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_SINGLELINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem("Profiles")
	CreateBotProfiles()
	TabItem1()
	$g_hGUI_MOD_TAB_ITEM3 = GUICtrlCreateTabItem("Treasury")
	TabItem3()
	$g_hGUI_MOD_TAB_ITEM2 = GUICtrlCreateTabItem("Humanization")
	TabItem2()
	$g_hGUI_MOD_TAB_ITEM4 = GUICtrlCreateTabItem("Auto Upgrade")
	TabItem4()
	$g_hGUI_MOD_TAB_ITEM5 = GUICtrlCreateTabItem("Builders Base")
	TabItem5()
	$g_hGUI_MOD_TAB_ITEM6 = GUICtrlCreateTabItem("Chat")
	TabItem6()
	$g_hGUI_MOD_TAB_ITEM7 = GUICtrlCreateTabItem("Forecast")
	TabItem7()
    ; needed to init the window now, like if it's a tab
	CreateDropOrderGUI()
	
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateMODTab

; ITEM TABS ZONE
Func TabItem1()

	Local $x = 11, $z = 189, $w = 357, $y = 85

	GUICtrlCreateGroup("Smart Switch Accounts", $x, $y, 430, 330)

	$x += 10
	$y += 20

	$chkEnableSwitchAccount = GUICtrlCreateCheckbox("Use Smart Switch Accounts", $x, $y, 152, 17)
	GUICtrlSetOnEvent(-1, "chkSwitchAccount")
	$lblNB = GUICtrlCreateLabel("Number of accounts on Emulator :", $x + 195, $y + 2, 165, 17)
	$g_cmbAccountsQuantity = GUICtrlCreateCombo("", $x + 365, $y - 2, 45, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "cmbAccountsQuantity")
	GUICtrlSetData(-1, "2|3|4|5|6|7|8", "2")

	$y += 35

	$g_achkCanUse[1] = GUICtrlCreateCheckbox("Use Account 1 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[1] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[1] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[2] = GUICtrlCreateCheckbox("Use Account 2 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[2] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[2] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[3] = GUICtrlCreateCheckbox("Use Account 3 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[3] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[3] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[4] = GUICtrlCreateCheckbox("Use Account 4 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[4] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[4] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[5] = GUICtrlCreateCheckbox("Use Account 5 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[5] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[5] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[6] = GUICtrlCreateCheckbox("Use Account 6 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[6] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[6] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[7] = GUICtrlCreateCheckbox("Use Account 7 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[7] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[7] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")

	$y += 30

	$g_achkCanUse[8] = GUICtrlCreateCheckbox("Use Account 8 with Profile :", $x, $y, 150, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_acmbAccount[8] = GUICtrlCreateCombo("", $z, $y - 2, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	$g_achkDonateAccount[8] = GUICtrlCreateCheckbox("Donate only", $w, $y, 77, 17)
	GUICtrlSetOnEvent(-1, "chkAccountsProperties")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	setupProfileComboBox()
	;PopulatePresetComboBox()

	$y += 35

	GUICtrlCreateLabel("Stay on Accounts max", $x, $y + 2, -1, 17)
	$g_cmbMaxStayDelay = GUICtrlCreateCombo("", $x + 110, $y - 2, 45, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "20|25|30|35|40|45|50|55|60", "30")
	_GUICtrlSetTip(-1, "That will force Switch Account to Switch, even if Army is ready when delay is exceeded." & @CRLF & _
					   "That is useful if you are in higher league, where search delay is very long, so, when attack" & @CRLF & _
					   "is finished, you army is always ready, so Switch Account never Switch to another account." & @CRLF & _
					   "This setting allow to prevent that to happens, by force switching after selected delay.")
	GUICtrlSetOnEvent(-1, "cmbMaxStayDelay")
	GUICtrlCreateLabel("mins", $x + 160, $y + 2, -1, 17)

	$x += 200

	GUICtrlCreateLabel("Don't switch if Train Delay <", $x, $y + 2, -1, 17)
	$g_cmbMinDelayToSwitch = GUICtrlCreateCombo("", $x + 138, $y - 2, 45, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1|2|3|4|5|8|10|15", "3")
	_GUICtrlSetTip(-1, "That will prevent Switch Account to Switch if remaining train delay for current account is short." & @CRLF & _
					   "Warning: this setting is overwritten by Max Stay on Account delay. If remaining train delay is" & @CRLF & _
					   "short but Max Stay on Account delay is exceeded, Switch Account will go to next account anyway...")
	GUICtrlSetOnEvent(-1, "cmbMinDelayToSwitch")
	$g_lblEndSwitchAccount = GUICtrlCreateLabel("mins", $x + 188, $y + 2, -1, 17)

EndFunc   ;==>TabItem1

Func TabItem2()

	GUICtrlCreateGroup("Settings", 5, 25, 442, 360)

	Local $x = 0, $y = 20

	$g_chkUseBotHumanization = GUICtrlCreateCheckbox("Enable Bot Humanization", 20, 47, 137, 17)
	GUICtrlSetOnEvent(-1, "chkUseBotHumanization")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$g_chkUseAltRClick = GUICtrlCreateCheckbox("Make ALL BOT clicks random", 274, 47, 162, 17)
	GUICtrlSetOnEvent(-1, "chkUseAltRClick")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 10
	$y += 60

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnChat, $x, $y + 5, 32, 32)
	$g_Label1 = GUICtrlCreateLabel("Read the Clan Chat", $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[0] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label2 = GUICtrlCreateLabel("Read the Global Chat", $x + 240, $y + 5, 110, 17)
	$g_acmbPriority[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label4 = GUICtrlCreateLabel("Say...", $x + 40, $y + 30, 31, 17)
	$g_ahumanMessage[0] = GUICtrlCreateInput("Hello !", $x + 75, $y + 25, 121, 21)
	$g_Label3 = GUICtrlCreateLabel("Or", $x + 205, $y + 30, 15, 17)
	$g_ahumanMessage[1] = GUICtrlCreateInput("Re !", $x + 225, $y + 25, 121, 21)
	$g_acmbPriority[2] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label20 = GUICtrlCreateLabel("Launch Challenges with message", $x + 40, $y + 55, 170, 17)
	$g_challengeMessage = GUICtrlCreateInput("Can you beat my village ?", $x + 205, $y + 50, 141, 21)
	$g_acmbPriority[12] = GUICtrlCreateCombo("", $x + 355, $y + 50, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 81

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnRepeat, $x, $y + 5, 32, 32)
	$g_Label5 = GUICtrlCreateLabel("Watch Defenses", $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[3] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$g_Label6 = GUICtrlCreateLabel("Watch Attacks", $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[4] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$g_Label7 = GUICtrlCreateLabel("Max Replay Speed", $x + 240, $y + 5, 110, 17)
	$g_acmbMaxSpeed[0] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sReplayChain, "2")
	$g_Label8 = GUICtrlCreateLabel("Pause Replay", $x + 240, $y + 30, 110, 17)
	$g_acmbPause[0] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 56

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnClan, $x, $y + 5, 32, 32)
	$g_Label9 = GUICtrlCreateLabel("Look at War log", $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[5] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label10 = GUICtrlCreateLabel("Visit Clanmates", $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[6] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label11 = GUICtrlCreateLabel("Look at Best Players", $x + 240, $y + 5, 110, 17)
	$g_acmbPriority[7] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label12 = GUICtrlCreateLabel("Look at Best Clans", $x + 240, $y + 30, 110, 17)
	$g_acmbPriority[8] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 56

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnTarget, $x, $y + 5, 32, 32)
	$g_Label14 = GUICtrlCreateLabel("Look at Current War", $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[9] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label16 = GUICtrlCreateLabel("Watch Replays", $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[10] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	GUICtrlSetOnEvent(-1, "cmbWarReplay")
	$g_Label13 = GUICtrlCreateLabel("Max Replay Speed", $x + 240, $y + 5, 110, 17)
	$g_acmbMaxSpeed[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sReplayChain, "2")
	$g_Label15 = GUICtrlCreateLabel("Pause Replay", $x + 240, $y + 30, 110, 17)
	$g_acmbPause[1] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 56

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnSettings, $x, $y + 5, 32, 32)
	$g_Label17 = GUICtrlCreateLabel("Do nothing", $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[11] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
	$g_Label18 = GUICtrlCreateLabel("Max Actions by Loop", $x + 240, $y + 5, 103, 17)
	$g_cmbMaxActionsNumber = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1|2|3|4|5", "2")

	$y += 25

	$g_chkCollectAchievements = GUICtrlCreateCheckbox("Collect achievements automatically", $x + 40, $y, 182, 17)
	GUICtrlSetOnEvent(-1, "chkCollectAchievements")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$g_chkLookAtRedNotifications = GUICtrlCreateCheckbox("Look at red/purple flags on buttons", $x + 240, $y, 187, 17)
	GUICtrlSetOnEvent(-1, "chkLookAtRedNotifications")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	For $i = $g_Label1 To $g_chkLookAtRedNotifications
		GUICtrlSetState($i, $GUI_DISABLE)
	Next

	chkUseBotHumanization()

EndFunc   ;==>TabItem2

Func TabItem3()

	Local $x = 5, $y = 25

	Local $Group1 = GUICtrlCreateGroup("Treasury Collect", $x, $y, 442, 110)

	$x -= 2

	GUICtrlCreatePic(@ScriptDir & "\images\Treasury.jpg", $x + 12, $y + 25, 70, 38.6)
	$g_chkEnableTrCollect = GUICtrlCreateCheckbox("Enable", $x + 93, $y + 35, 52, 17)
	GUICtrlSetOnEvent(-1, "chkEnableTrCollect")
	_GUICtrlSetTip(-1, "Check to enable automatic Treasury collecion")
	$g_chkForceTrCollect = GUICtrlCreateCheckbox("Always collect Treasury", $x + 15, $y + 75, 127, 17)
	GUICtrlSetOnEvent(-1, "chkForceTrCollect")
	_GUICtrlSetTip(-1, "Check to force Treasury collection" & _
			@CRLF & "Treasury will be collected all the time, ignoring any criteria")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 160, $y + 15, 24, 24)
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 160, $y + 45, 24, 24)
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 160, $y + 75, 24, 24)

	$g_chkGoldTrCollect = GUICtrlCreateCheckbox("Collect when Gold <", $x + 190, $y + 18, 112, 17)
	GUICtrlSetOnEvent(-1, "chkResTrCollect")
	_GUICtrlSetTip(-1, "When your Village Gold is below this value, it will collect Treasury")
	$g_txtMinGoldTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 17, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	$g_chkFullGoldTrCollect = GUICtrlCreateCheckbox("When full", $x + 370, $y + 18, 67, 17)
	GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
	_GUICtrlSetTip(-1, "When your Gold level in Treasury is full, it will colect it to empty Treasury")

	$g_chkElxTrCollect = GUICtrlCreateCheckbox("Collect when Elixir <", $x + 190, $y + 48, 112, 17)
	GUICtrlSetOnEvent(-1, "chkResTrCollect")
	_GUICtrlSetTip(-1, "When your Village Elixir is below this value, it will collect Treasury")
	$g_txtMinElxTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 47, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	$g_chkFullElxTrCollect = GUICtrlCreateCheckbox("When full", $x + 370, $y + 48, 67, 17)
	GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
	_GUICtrlSetTip(-1, "When your Elixir level in Treasury is full, it will colect it to empty Treasury")

	$g_chkDarkTrCollect = GUICtrlCreateCheckbox("Collect when Dark <", $x + 190, $y + 78, 112, 17)
	GUICtrlSetOnEvent(-1, "chkResTrCollect")
	_GUICtrlSetTip(-1, "When your Village Dark is below this value, it will collect Treasury")
	$g_txtMinDarkTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 77, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	$g_chkFullDarkTrCollect = GUICtrlCreateCheckbox("When full", $x + 370, $y + 78, 67, 17)
	GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
	_GUICtrlSetTip(-1, "When your Dark level in Treasury is full, it will colect it to empty Treasury")

	chkEnableTrCollect()
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>TabItem3

Func TabItem4()

	Local $x = 25, $y = 45

	GUICtrlCreateGroup("Auto Upgrade", $x - 20, $y - 20, 442, 340)

	$g_chkAutoUpgrade = GUICtrlCreateCheckbox("Enable Auto Upgrade", $x - 5, $y, -1, -1)
	_GUICtrlSetTip(-1, "Check box to enable automatically starting Upgrades from builders menu")
	GUICtrlSetOnEvent(-1, "chkAutoUpgrade")

	GUICtrlCreateGroup("Upgrades to ignore", $x - 15, $y + 30, 432, 155)

	Local $x = 21, $y = 45

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnTH11, $x + 5, $y + 50, 40, 40)
	$g_chkIgnoreTH = GUICtrlCreateCheckbox("", $x + 20, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreTH")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x + 95, $y + 50, 40, 40)
	$g_chkIgnoreKing = GUICtrlCreateCheckbox("", $x + 110, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreKing")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 140, $y + 50, 40, 40)
	$g_chkIgnoreQueen = GUICtrlCreateCheckbox("", $x + 155, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreQueen")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x + 185, $y + 50, 40, 40)
	$g_chkIgnoreWarden = GUICtrlCreateCheckbox("", $x + 200, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreWarden")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x + 275, $y + 50, 40, 40)
	$g_chkIgnoreCC = GUICtrlCreateCheckbox("", $x + 290, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreCC")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x + 365, $y + 50, 40, 40)
	$g_chkIgnoreLab = GUICtrlCreateCheckbox("", $x + 380, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreLab")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrack, $x + 5, $y + 120, 40, 40)
	$g_chkIgnoreBarrack = GUICtrlCreateCheckbox("", $x + 20, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreBarrack")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrack, $x + 50, $y + 120, 40, 40)
	$g_chkIgnoreDBarrack = GUICtrlCreateCheckbox("", $x + 65, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreDBarrack")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactory, $x + 140, $y + 120, 40, 40)
	$g_chkIgnoreFactory = GUICtrlCreateCheckbox("", $x + 155, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreFactory")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellFactory, $x + 185, $y + 120, 40, 40)
	$g_chkIgnoreDFactory = GUICtrlCreateCheckbox("", $x + 200, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreDFactory")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 275, $y + 120, 40, 40)
	$g_chkIgnoreGColl = GUICtrlCreateCheckbox("", $x + 290, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreGColl")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 320, $y + 120, 40, 40)
	$g_chkIgnoreEColl = GUICtrlCreateCheckbox("", $x + 335, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreEColl")

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 365, $y + 120, 40, 40)
	$g_chkIgnoreDColl = GUICtrlCreateCheckbox("", $x + 380, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreDColl")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_SmartMinGold = GUICtrlCreateInput("200000", 174, 37, 57, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("Gold to save", 236, 40, 64, 17)
	$g_SmartMinElixir = GUICtrlCreateInput("200000", 174, 57, 57, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("Elixir to save", 236, 60, 63, 17)
	$g_SmartMinDark = GUICtrlCreateInput("1500", 302, 37, 65, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("Dark to save", 372, 40, 65, 17)
	GUICtrlCreateLabel("... after launching upgrade", 302, 60, 128, 17)

	$g_AutoUpgradeLog = GUICtrlCreateEdit("", 10, 232, 432, 124, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
	GUICtrlSetData(-1, "                                             ----- AUTO UPGRADE LOG -----")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>TabItem4

Func TabItem5()

	; New group
	Local $x = 15, $y = 45

	GUICtrlCreateGroup("Builders Base Stats", $x - 10, $y - 20, 442, 50)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldGold, $x, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootGold] = GUICtrlCreateLabel("---", $x + 35, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldElixir, $x + 140, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootElixir] = GUICtrlCreateLabel("---", $x + 175, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldTrophy, $x + 280, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootTrophy] = GUICtrlCreateLabel("---", $x + 315, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; New group
	Local $x = 15, $y = 100

	GUICtrlCreateGroup("Some awesome features !", $x - 10, $y - 20, 442, 110)

		$x += 45

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldGold, $x, $y - 2, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldElixir, $x + 28, $y - 2, 24, 24)
		$g_chkCollectBldGE = GUICtrlCreateCheckbox("Collect Gold and Elixir", $x + 60, $y - 2, -1, -1)
			GUICtrlSetOnEvent(-1, "chkCollectBldGE")

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 14, $y + 28, 24, 24)
		$g_chkCollectBldGems = GUICtrlCreateCheckbox("Collect Gems", $x + 60, $y + 28)
			GUICtrlSetOnEvent(-1, "chkCollectBldGems")

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldClockBtn, $x + 14, $y + 58, 24, 24)
		$g_chkActivateClockTower = GUICtrlCreateCheckbox("Activate Clock Tower when available (awesome !)", $x + 60, $y + 58)
			GUICtrlSetOnEvent(-1, "chkActivateClockTower")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; New group
	Local $x = 13, $y = 220

	GUICtrlCreateGroup("Suggested Upgrades ", $x - 10, $y - 20, 442, 233)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMBisland, $x , $y , 64, 64)
		$g_chkBBSuggestedUpgrades = GUICtrlCreateCheckbox("Suggested Upgrades", $x + 70, $y + 25, -1, -1)
			;GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgrades")
		$g_chkBBSuggestedUpgradesIgnoreGold = GUICtrlCreateCheckbox("Ignore Gold values", $x + 200, $y + 15, -1, -1)
			;GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")
		$g_chkBBSuggestedUpgradesIgnoreElixir = GUICtrlCreateCheckbox("Ignore Elixir values", $x + 200, $y + 40, -1, -1)
			;GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesElixir")
		$g_chkBBSuggestedUpgradesIgnoreHall = GUICtrlCreateCheckbox("Ignore Builder Hall", $x + 320, $y + 28, -1, -1)
			;GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")

	GUICtrlCreateGroup("", -99, -99, 1, 1)


EndFunc   ;==>TabItem5

Func TabItem6()
    	
	Local $x = 25, $y = 47

   GUICtrlCreateGroup("Global Chat", $x - 20, $y - 20, 215, 360)
    $y -= 5
   $chkGlobalChat = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkGlobalChat, "Use global chat to send messages")
   GUICtrlSetState($chkGlobalChat, $ChatbotChatGlobal)
   GUICtrlSetOnEvent(-1, "chkGlobalChat")
	$g_alblAinGlobal = GUICtrlCreateLabel("Advertise in global", $x + 7, $y, -1, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
   $y += 18
   $chkGlobalScramble = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkGlobalScramble, "Scramble the message pieces defined in the textboxes below to be in a random order")
   GUICtrlSetState($chkGlobalScramble, $ChatbotScrambleGlobal)
   GUICtrlSetOnEvent(-1, "chkGlobalScramble")
   $g_alblSGchats = GUICtrlCreateLabel("Scramble global chats", $x + 7, $y, -1, -1)
   $y += 22
   $g_alblTimeDalay = GUICtrlCreateLabel("Time Dalay", $x + 8, $y - 2, -1, -1)
   $chkGlobChatTimeDalay = GUICtrlCreateInput("0", $x + 70, $y - 5, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
   _GUICtrlSetTip($chkGlobChatTimeDalay, "Global Chat time dalay in seconds.")
   GUICtrlSetLimit(-1, 3)
   GUICtrlSetOnEvent(-1, "chkGlobChatTimeDalay")
   GUICtrlSetState($chkGlobChatTimeDalay, $ichkGlobChatTimeDalay)
   $y += 18
   $chkSwitchLang = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkSwitchLang, "Switch languages after spamming for a new global chatroom")
   GUICtrlSetState($chkSwitchLang, $ChatbotSwitchLang)
   GUICtrlSetOnEvent(-1, "chkSwitchLang")
   $g_alblSwitchlang = GUICtrlCreateLabel("Switch languages", $x + 7, $y, -1, -1)
	;======kychera===========
   $cmbLang = GUICtrlCreateCombo("", $x + 120, $y - 3, 45, 45, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, "FR|DE|ES|IT|NL|NO|PR|TR|RU", "RU")
   ;==========================
   $y += 20
   $editGlobalMessages1 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages1, @CRLF), $x - 15, $y, 202, 65)
   GUICtrlSetTip($editGlobalMessages1, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   $editGlobalMessages2 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages2, @CRLF), $x - 15, $y, 202, 65)
   GUICtrlSetTip($editGlobalMessages2, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   $editGlobalMessages3 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages3, @CRLF), $x - 15, $y, 202, 65)
   GUICtrlSetTip($editGlobalMessages3, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   $editGlobalMessages4 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages4, @CRLF), $x - 15, $y, 202, 55)
   GUICtrlSetTip($editGlobalMessages4, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 245, $y = 47

   GUICtrlCreateGroup("Clan Chat", $x - 20, $y - 20, 218, 360)
   $y -= 5
   $chkClanChat = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkClanChat, "Use clan chat to send messages")
   GUICtrlSetState($chkClanChat, $ChatbotChatClan)
   GUICtrlSetOnEvent(-1, "chkClanChat")
   $g_alblChatclan = GUICtrlCreateLabel("Chat in clan chat" & ":", $x + 7, $y, -1, -1)
   $y += 22
   $chkUseResponses = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkUseResponses, "Use the keywords and responses defined below")
   GUICtrlSetState($chkUseResponses, $ChatbotClanUseResponses)
   GUICtrlSetOnEvent(-1, "chkUseResponses")
   $g_alblUsecustomresp = GUICtrlCreateLabel("Use custom responses", $x + 7, $y, -1, -1)
   $y += 22
   $chkUseGeneric = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkUseGeneric, "Use generic chats if reading the latest chat failed or there are no new chats")
   GUICtrlSetState($chkUseGeneric, $ChatbotClanAlwaysMsg)
   GUICtrlSetOnEvent(-1, "chkUseGeneric")
   $g_alblUsegenchats = GUICtrlCreateLabel("Use generic chats", $x + 7, $y, -1, -1)
   $y += 22
   $chkChatPushbullet = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkChatPushbullet, "Send and recieve chats via pushbullet or telegram." & @CRLF & "Use BOT <myvillage> GETCHATS <interval|NOW|STOP> to get the latest clan" & @CRLF &  "chat as an image, and BOT <myvillage> SENDCHAT <chat message> to send a chat to your clan") 
   GUICtrlSetState($chkChatPushbullet, $ChatbotUsePushbullet)
   GUICtrlSetOnEvent(-1, "chkChatPushbullet")
   $g_alblUseremotechat = GUICtrlCreateLabel("Use remote for chatting", $x + 7, $y, -1, -1)
   $y += 22
   $chkPbSendNewChats = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkPbSendNewChats, "Will send an image of your clan chat via pushbullet & telegram when a new chat is detected. Not guaranteed to be 100% accurate.")
   GUICtrlSetState($chkPbSendNewChats, $ChatbotPbSendNew)
   GUICtrlSetOnEvent(-1, "chkPbSendNewChats")
   $g_alblNotifyclanchat = GUICtrlCreateLabel("Notify me new clan chat", $x + 7, $y, -1, -1)
   $y += 25

   $editResponses = GUICtrlCreateEdit(_ArrayToString($ClanResponses, ":", -1, -1, @CRLF), $x - 15, $y, 206, 80)
   GUICtrlSetTip($editResponses, "Look for the specified keywords in clan messages and respond with the responses. One item per line, in the format keyword:response")
   GUICtrlSetOnEvent(-1, "editResponses")
   $y += 92
   $editGeneric = GUICtrlCreateEdit(_ArrayToString($ClanMessages, @CRLF), $x - 15, $y, 206, 80)
   GUICtrlSetTip($editGeneric, "Generic messages to send, one per line")
   GUICtrlSetOnEvent(-1, "editGeneric")
      
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   
EndFunc   ;==>TabItem6

Func TabItem7()

    Global $g_alblSwitchto
	
    Local $sTxtTip = ""
	Local $xStart = 0, $yStart = 0
	Local $x = $xStart + 10, $y = $yStart + 25
	$ieForecast = GUICtrlCreateObj($oIE, $x , $y , 430, 310)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

$y += + 318
	$chkForecastBoost = GUICtrlCreateCheckbox("Boost When >", $x, $y, -1, -1)
		$sTxtTip = "Boost Barracks,Heroes, when the loot index."
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkForecastBoost")
	$txtForecastBoost = GUICtrlCreateInput("6.0", $x + 87, $y + 2, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		$sTxtTip =  "Minimum loot index for boosting."
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetTip(-1, $sTxtTip)
		_GUICtrlEdit_SetReadOnly(-1, True)
		GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += - 27
	$chkForecastHopingSwitchMax = GUICtrlCreateCheckbox("", $x + 150, $y + 27, 13, 13)
		$sTxtTip = "" ; Information
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkForecastHopingSwitchMax")
		$g_alblSwitchto = GUICtrlCreateLabel("Switch to", $x + 168, $y + 27, -1, -1)
	$cmbForecastHopingSwitchMax = GUICtrlCreateCombo("", $x + 218, $y + 25, 95, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$sTxtTip = "" ; Information
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblForecastHopingSwitchMax = GUICtrlCreateLabel("When Index <", $x + 316, $y + 28, -1, -1)
	$txtForecastHopingSwitchMax = GUICtrlCreateInput("2.5", $x + 400, $y + 26, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		$sTxtTip = "" ; Information
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetData(-1, 2.5)
		GUICtrlSetTip(-1, $sTxtTip)
		_GUICtrlEdit_SetReadOnly(-1, True)
	$chkForecastHopingSwitchMin = GUICtrlCreateCheckbox("", $x + 150, $y + 55, 13, 13)
		$sTxtTip = "" ; Information
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkForecastHopingSwitchMin")
		$g_alblSwitchto = GUICtrlCreateLabel("Switch to", $x + 168, $y + 55, -1, -1)
	$cmbForecastHopingSwitchMin = GUICtrlCreateCombo("", $x + 218, $y + 53, 95, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$sTxtTip = "" ; Information
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblForecastHopingSwitchMin = GUICtrlCreateLabel("When Index >", $x + 316, $y + 58, -1, -1)
	$txtForecastHopingSwitchMin = GUICtrlCreateInput("2.5", $x + 400, $y + 54, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		$sTxtTip = "" ; Information
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetData(-1, 2.5)
		GUICtrlSetTip(-1, $sTxtTip)
		_GUICtrlEdit_SetReadOnly(-1, True)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	setupProfileComboBox()
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$chkForecastPause = GUICtrlCreateCheckbox("Halt when below", $x, $y + 50, -1, -1)
		$sTxtTip = "Halt attacks when the loot index is below the specified value."
		GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkForecastPause")
	$txtForecastPause = GUICtrlCreateInput("2.0", $x + 100, $y + 50, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		$sTxtTip =  "Minimum loot index for halting attacks."
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetTip(-1, $sTxtTip)
		_GUICtrlEdit_SetReadOnly(-1, True)
		GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$cmbSwLang = GUICtrlCreateCombo("", $x, $y + 75, 45, 45, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "EN" & "|" & "RU" & "|" & "FR" & "|" & "DE" & "|" & "ES" & "|" & "FA" & "|" & "PT" & "|" & "IN", "EN")
		GUICtrlSetOnEvent(-1, "cmbSwLang")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>TabItem7