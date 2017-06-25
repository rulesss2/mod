; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (10-2016), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bSetLog = True, $CheckWindow = True)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SetLog("Begin getArmyHeroCount:", $COLOR_DEBUG)

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview() Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	$g_iHeroAvailable = $eHeroNone ; Reset hero available data
	Local $iDebugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $iHeroes = 3
	Local $sMessage = ""

	For $i = 0 To $iHeroes - 1
		$sResult = ArmyHeroStatus($i)
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					If $bSetLog Then Setlog(" - Barbarian King available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					If $bSetLog Then Setlog(" - Archer Queen available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					If $bSetLog Then Setlog(" - Grand Warden available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $g_iDebugSetlogTrain = 1 Or $iDebugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								$sMessage = "-Barbarian King"
							Case 1
								$sMessage = "-Archer Queen"
							Case 2
								$sMessage = "-Grand Warden"
							Case Else
								$sMessage = "-Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Healing", $COLOR_DEBUG)
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							$sMessage = "-Barbarian King"
							; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing Then ; check wait for hero status
								_GUI_Value_STATE("SHOW", $groupKingSleeping) ; Show king sleeping icon
								SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
							EndIf
						Case 1
							$sMessage = "-Archer Queen"
							; safety code
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen Then
								_GUI_Value_STATE("SHOW", $groupQueenSleeping)
								SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
							EndIf
						Case 2
							$sMessage = "-Grand Warden"
							; safety code
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden Then
								_GUI_Value_STATE("SHOW", $groupWardenSleeping)
								SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
							EndIf
						Case Else
							$sMessage = "-Need to Get Monkey"
					EndSwitch
					If $g_iDebugSetlogTrain = 1 Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG)
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $g_iDebugSetlogTrain = 1 Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & " Empty, stop count", $COLOR_DEBUG)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_ERROR)
			EndSelect
		Else
			If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " status read problem!", $COLOR_ERROR)
		EndIf
	Next

	If $g_iDebugSetlogTrain = 1 Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($g_iHeroAvailable, $eHeroKing) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden), $COLOR_DEBUG)

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount

#cs
	Func ArmyHeroStatus($i)
	;update hero status on gui.. from better method
	ArmyHeroStatusOld($i)

	Local $sImageDir = "trainwindow-HeroStatus-bundle", $sResult = ""
	Local Const $aHeroesRect[3][4] = [[660, 349, 673, 361], [734, 349, 747, 361], [807, 349, 822, 361]]

	; Perform the search
	_CaptureRegion2($aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3])
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $sImageDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If $res[0] <> "" Then
	Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)
	If StringInStr($aKeys[0], "xml", $STR_NOCASESENSEBASIC) Then
	Local $aResult = StringSplit($aKeys[0], "_", $STR_NOCOUNT)
	$sResult = $aResult[0]
	Return $sResult
	EndIf
	EndIf

	;return 'none' if there was a problem with the search , like the hero doesn't exist
	Switch $i
	Case 0
	Return "none"
	Case 1
	Return "none"
	Case 2
	Return "none"
	EndSwitch

	EndFunc   ;==>ArmyHeroStatus
#ce

Func ArmyHeroStatus($Hero)
	;============Notes
	; Empty is a new return for this function but is changed back to none to make rest of bot happy
	; none is also a return possable from QuickMIS and is used for a error msg in log before being changed back to royal's name.. ie preserving func old behavior.

	Local $DebugThisFunc = 0
	Local $directory = @ScriptDir & "\imgxml\Resources\herostatus"
	Local Const $aHeroesRect[3][4] = [[606, 338, 682, 390], [681, 338, 756, 390], [755, 338, 833, 390]] ; [[643, 340, 683, 390], [718, 340, 758, 390], [749, 340, 833, 390]]
	Local $Status
	Select
		Case $Hero = "King" Or $Hero = 0 Or $Hero = $eKing
			$Status = QuickMIS("N1", $directory, $aHeroesRect[0][0], $aHeroesRect[0][1], $aHeroesRect[0][2], $aHeroesRect[0][3])
			If $DebugThisFunc = 1 Then
				Setlog("return from quickMis for King :" & $Status)
			EndIf
			Switch $Status
				Case "heal" ; Blue
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_SHOW)
				Case "upgrade" ; Red
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
				Case "empty" ; Gray
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
				Case "king" ; Green
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
			EndSwitch

			If $Status = "" Or $Status = "none" Then
				Setlog("some kind of error, no image file return, king")
				$Status = "king"
			EndIf
			If $Status = "empty" Then $Status = "none"
			Return $Status

		Case $Hero = "Queen" Or $Hero = 1 Or $Hero = $eQueen
			$Status = QuickMIS("N1", $directory, $aHeroesRect[1][0], $aHeroesRect[1][1], $aHeroesRect[1][2], $aHeroesRect[1][3])
			If $DebugThisFunc = 1 Then
				Setlog("return from quickMis for Queen :" & $Status)
			EndIf
			Switch $Status
				Case "heal" ; Blue
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_SHOW)
				Case "upgrade" ; Red
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
				Case "empty" ; Gray
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
				Case "queen" ; Green
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
			EndSwitch
			If $Status = "" Or $Status = "none" Then
				Setlog("some kind of error, no image file return, queen")
				$Status = "queen"
			EndIf
			If $Status = "empty" Then $Status = "none"
			Return $Status

		Case $Hero = "Warden" Or $Hero = 2 Or $Hero = $eWarden
			;$Result = SearchArmy($directory, $aHeroesRect[2][0], $aHeroesRect[2][1], $aHeroesRect[2][2], $aHeroesRect[2][3], "", True)
			$Status = QuickMIS("N1", $directory, $aHeroesRect[2][0], $aHeroesRect[2][1], $aHeroesRect[2][2], $aHeroesRect[2][3])
			If $DebugThisFunc = 1 Then
				Setlog("return from quickMis for Warden :" & $Status)
			EndIf
			Switch $Status
				Case "heal" ; Blue
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_SHOW)
				Case "upgrade" ; Red
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
				Case "empty" ; Gray
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
				Case "warden" ; Green
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
			EndSwitch
			If $Status = "" Or $Status = "none" Then
				Setlog("some kind of error, no image file return, warden")
				$Status = "warden"
			EndIf
			If $Status = "empty" Then $Status = "none"
			Return $Status
	EndSelect
EndFunc   ;==>ArmyHeroStatus

Func LabGuiDisplay() ; called from main loop to get an early status for indictors in bot bottom

	;CLOSE ARMY WINDOW
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then
		SetLog("Laboratory Location not found!", $COLOR_ERROR)
		LocateLab() ; Lab location unknown, so find it.
		If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
			SetLog("Problem locating Laboratory, train laboratory position before proceeding", $COLOR_ERROR)
			;============Hide Red  Hide Green  Show Gray==
			GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
			;============================================
			Return
		EndIf
	EndIf
	BuildingClickP($g_aiLaboratoryPos, "#0197") ;Click Laboratory
	If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	; Find Research Button

	If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\herostatus\lab button", 400, 610, 600, 710) Then
		Click($g_iQuickMISX + 400, $g_iQuickMISY + 610)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	Else
		Setlog("Trouble finding research button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		;===========================================
		Return
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Laboratory is Running. ", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		Return True
	ElseIf _ColorCheck(_GetPixelColor(730, 200, True), Hex(0x8088B0, 6), 20) Then ; Look for light purple in upper right corner of lab window.
		SetLog("Laboratory has Stopped", $COLOR_INFO)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
		;============================================
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		Return
	Else
		SetLog("Unable to determine Lab Status", $COLOR_INFO)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		;=============================================
		Return
	EndIf
	; EndIf
EndFunc   ;==>LabGuiDisplay
