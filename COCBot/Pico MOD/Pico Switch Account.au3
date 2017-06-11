; #FUNCTION# ====================================================================================================================
; Name ..........: Pico Switch Account (v2)
; Description ...: This file contains all functions of Pico Switch Account feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti & Ezeck0001
; Modified ......: 08/05/2017
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

; ================================================== MAIN FUNCTIONS PART ================================================== ;

Func SwitchAccount($g_bInit = False)

	If $g_ichkSwitchAccount = 0 Then
		$g_bFirstInit = False
		Return
	EndIf

	Local $iRetry = 0

	If $g_bInit Then $g_bFirstInit = False

	checkMainScreen()
	Setlog("Starting Pico Switch Account...", $COLOR_SUCCESS)
	MakeSummaryLog()

	If Not $g_bInit And $g_iachkDonateAccount[$g_iCurrentAccount] = 0 Then GetWaitTime() ; gets wait time for current account

	If $g_bInit Then
		SetLog("Initialization of Pico Switch Account...", $COLOR_INFO)
		$g_iCurrentAccount = 1
		$g_iSwitchAccountLoop = 2 ; Don't Ask.. It Just Works...
		FindFirstAccount()
		$g_iNextAccount = $g_iCurrentAccount
		GetYCoordinates($g_iNextAccount)
		;$g_iFirstRun = 1 ; To Update Stats as First Run for each Account

	ElseIf $g_iSwitchAccountLoop <= $g_iTotalAccountsInUse And Not $g_bInit Then
		SetLog("Continue Initialization of Pico Switch Account...", $COLOR_INFO)
		$g_iNextAccount = $g_iCurrentAccount
		Do
			$g_iNextAccount += 1
			If $g_iNextAccount > $g_iTotalAccountsOnEmu Then $g_iNextAccount = 1
		Until $g_iachkCanUse[$g_iNextAccount] = 1
		$g_iSwitchAccountLoop += 1
		SetLog("Next Account will be : " & $g_iNextAccount, $COLOR_INFO)
		GetYCoordinates($g_iNextAccount)
		;$g_iFirstRun = 1 ; To Update Stats as First Run for each Account

	ElseIf $g_iSwitchAccountLoop > $g_iTotalAccountsInUse And Not $g_bInit Then
		If ($g_iCurrentAccountWaitTime <= $g_iMinDelayToSwitch And $g_bForceSwitch) Or ($g_iCurrentAccountWaitTime > $g_iMinDelayToSwitch) Then
			SetLog("Switching to next Account...", $COLOR_INFO)
			GetNextAccount()
			GetYCoordinates($g_iNextAccount)
		Else
			SetLog("Remaining Train delay is short... We will not Switch Account...", $COLOR_INFO)
			Return
		EndIf
	EndIf

	If _Sleep(10) Then Return

	If $g_iNextAccount = $g_iCurrentAccount And Not $g_bInit And $g_iSwitchAccountLoop >= $g_iTotalAccountsInUse Then
		SetLog("Next Account is already the account we are on, no need to change...", $COLOR_SUCCESS)
	Else
		Switch EnterSwitchAccountProcess()
			Case 4 To 6
				;Three Attempts then Restart Emulator
				$iRetry += 1
				If $iRetry >= 3 Then
					;Restart emulator
					$iRetry = 0
					;$g_bInit = False
					$g_bFirstInit = True
					CloseCoC(True)
					;ZoomOut()
					;If Not $g_bRunState Then Return
					checkMainScreen()
					runBot()
				EndIf
				ReturnAtHome()
				If $g_bInit Then
					SwitchAccount(True)
				Else
					SwitchAccount()
				EndIf

			Case 3
				;More Serious Problem - Just restart No Retry's
				;Switch account reset first start condition
				;$g_bInit = False
				$g_bFirstInit = True
				CloseCoC(True)
				;ZoomOut()
				;If Not $g_bRunState Then Return
				checkMainScreen()
				runBot()

			Case 1 To 2
				Setlog("Switch Process Success !", $COLOR_SUCCESS)
		EndSwitch
		$iRetry = 0

		$g_iCurrentAccount = $g_iNextAccount
		If $g_bInit Then
			$g_iNextProfile = _GUICtrlComboBox_GetCurSel($g_acmbAccount[$g_iCurrentAccount])
			_GUICtrlComboBox_SetCurSel($g_hcmbProfile, $g_iNextProfile)
			cmbProfile()
		Else
			$g_iNextProfile = _GUICtrlComboBox_GetCurSel($g_acmbAccount[$g_iNextAccount])
			_GUICtrlComboBox_SetCurSel($g_hcmbProfile, $g_iNextProfile)
			cmbProfile()
		EndIf

		If _Sleep(10) Then Return
		IdentifyDonateOnly()
		waitMainScreen()
		$g_iOnAccountSince = TimerInit()
		runBot()
	EndIf

EndFunc   ;==>SwitchAccount

Func EnterSwitchAccountProcess()
	; return 1 switch account Worked.
	; return 2 Already on the right account...
	; Errors
	; Return 3 Unknow error restart needed
	; return 4 Settings Page did not open
	; return 5 Account List Not Found
	; Return 6 Confirm button did not appear

	; ================================================== Start the Switch Process, Click setting ================================================== ;
	Local $iCheckStep
	Click(820, 590, 1, 0, "Click Settings")
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks

	; ================================================== Wait for red X - then preform DoubleClick ================================================== ;
	$iCheckStep = 0 ; Sleep(5000) if needed.
	While Not _ColorCheck(_GetPixelColor(766, 103, True), "FF8F95", 20)
		If _Sleep(100) Then Return
		$iCheckStep += 1
		If $iCheckStep = 50 Then
			Setlog("Settings page didn't open...", $COLOR_ERROR)
			Return 4 ; Settings Page did not open
		EndIf
	WEnd
	If _Sleep(100) Then Return ; Some Delays to slow down the click
	;The Double Click check for either green or red then click twice
	If _ColorCheck(_GetPixelColor(408, 408, True), "DDF585", 20) Then
		Click(440, 420, 2, 750, "Click Connect Twice with long pause")
	ElseIf _ColorCheck(_GetPixelColor(408, 408, True), "FF8185", 20) Then
		Click(440, 420, 1, 750, "Click Connect Once with long pause")
	EndIf
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks

	; ================================================== Google Play animation ================================================== ;
	$iCheckStep = 0 ; Sleep(5000) if needed. Wait for Google Play animation
	While Not _ColorCheck(_GetPixelColor(550, 450, True), "0B8043", 20) ; Green
		If _Sleep(50) Then Return
		$iCheckStep += 1
		If $iCheckStep = 100 Then ExitLoop
	WEnd
	If $iCheckStep < 100 Then
		ClickP($aAway, 1, 0, "#0167") ;Click Away - disable Google Play animation
	EndIf
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks

	; ================================================== Wait for White in Account List ================================================== ;
	If _Sleep(50) Then Return
	$iCheckStep = 0 ; sleep(10000) or until account list appears
	While Not _ColorCheck(_GetPixelColor(165, 330, True), "FFFFFF", 20)
		If _Sleep(100) Then Return
		$iCheckStep += 1
		If $iCheckStep = 100 Then
			Setlog("Account list not found...", $COLOR_ERROR)
			Return 5
		EndIf
	WEnd
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks
	Click(430, $g_iSwitchAccountYCoord) ; Click Account
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks

	; ================================================== Get Results from Wait For Next Step() ================================================== ;
	If _Sleep(10) Then Return
	WaitForNextStep()

	; ================================================== Do Based off of next step result ================================================== ;
	If $g_iSwitchAccountNextStep = 1 Then ; All Was Good.. click load, type confirm, click confirm
		Setlog("Load button appeared !", $COLOR_SUCCESS)

		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Click(520, 430)
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks

		;Fancy delay to wait for Enter Confirm text box
		$iCheckStep = 0
		While Not _ColorCheck(_GetPixelColor(587, 16, True), "FF8D95", 20)
			If _Sleep(100) Then Return
			$iCheckStep += 1
			If $iCheckStep = 50 Then ExitLoop
		WEnd
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Click(360, 195)
		If _Sleep(250) Then Return
		SendText("CONFIRM")

		$iCheckStep = 0 ; Another Fancy Sleep wait for Click Confirm Button
		While Not _ColorCheck(_GetPixelColor(480, 200, True), "81CB2C", 20)
			If _Sleep(100) Then Return
			$iCheckStep += 1
			If $iCheckStep = 100 Then
				SetLog("Confirm button didn't appear...", $COLOR_ERROR)
				Return 6
			EndIf
		WEnd
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Click(530, 195)
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Return 1

		; ================================================== Already on the right account ================================================== ;
	ElseIf $g_iSwitchAccountNextStep = 2 Then ; wait for next step result says we match no switch needed
		Setlog("We are already on the right account...", $COLOR_SUCCESS)
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		ClickP($aAway, 1, 0, "#0167") ;Click Away
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Return 2

		; ================================================== Was a problem ================================================== ;
	ElseIf $g_iSwitchAccountNextStep = 0 Then ; Was a problem
		SetLog("Error when trying to go to the next step... skipping...", $COLOR_ERROR)
		Return 3
	EndIf
EndFunc   ;==>EnterSwitchAccountProcess

Func GetYCoordinates($AccountNumber)
	$g_iSwitchAccountYCoord = 338 - 36 * $g_iTotalAccountsOnEmu + 72 * $AccountNumber
EndFunc   ;==>GetYCoordinates

Func GetWaitTime()

	$g_aiTimeTrain[0] = 0
	$g_aiTimeTrain[1] = 0
	Local $HeroesRemainingWait[3] = [0, 0, 0]

	openArmyOverview()
	If _Sleep(1500) Then Return
	getArmyTroopTime()
	If IsWaitforSpellsActive() Then getArmySpellTime()
	If IsWaitforHeroesActive() Then

		If GUICtrlRead($g_hChkABActivateSearches) = $GUI_CHECKED Then
			If GUICtrlRead($g_hchkABKingWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[0] = getArmyHeroTime($eKing)
			EndIf
			If GUICtrlRead($g_hChkABQueenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[1] = getArmyHeroTime($eQueen)
			EndIf
			If GUICtrlRead($g_hChkABWardenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[2] = getArmyHeroTime($eWarden)
			EndIf
		EndIf
		If GUICtrlRead($g_hchkDBActivateSearches) = $GUI_CHECKED Then
			If GUICtrlRead($g_hchkDBKingWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[0] = getArmyHeroTime($eKing)
			EndIf
			If GUICtrlRead($g_hchkDBQueenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[1] = getArmyHeroTime($eQueen)
			EndIf
			If GUICtrlRead($g_hchkDBWardenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[2] = getArmyHeroTime($eWarden)
			EndIf
		EndIf
		If GUICtrlRead($g_hchkTSActivateSearches) = $GUI_CHECKED Then
			If GUICtrlRead($g_hchkTSKingAttack) = $GUI_CHECKED Then
				$HeroesRemainingWait[0] = getArmyHeroTime($eKing)
			EndIf
			If GUICtrlRead($g_hchkTSQueenAttack) = $GUI_CHECKED Then
				$HeroesRemainingWait[1] = getArmyHeroTime($eQueen)
			EndIf
			If GUICtrlRead($g_hchkTSWardenAttack) = $GUI_CHECKED Then
				$HeroesRemainingWait[2] = getArmyHeroTime($eWarden)
			EndIf
		EndIf

		If $HeroesRemainingWait[0] > 0 Then SetLog("King time: " & $HeroesRemainingWait[0] & ".00 min", $COLOR_INFO)
		If $HeroesRemainingWait[1] > 0 Then SetLog("Queen time: " & $HeroesRemainingWait[0] & ".00 min", $COLOR_INFO)
		If $HeroesRemainingWait[2] > 0 Then SetLog("Warden time: " & $HeroesRemainingWait[0] & ".00 min", $COLOR_INFO)

	EndIf

	ClickP($aAway, 1, 0, "#0167") ;Click Away

	Local $MaxTime[3] = [$g_aiTimeTrain[0], $g_aiTimeTrain[1], _ArrayMax($HeroesRemainingWait)]
	$g_iCurrentAccountWaitTime = _ArrayMax($MaxTime)
	$g_iaAllAccountsWaitTime[$g_iCurrentAccount] = $g_iCurrentAccountWaitTime
	$g_iaTimerDiffStart[$g_iCurrentAccount] = TimerInit()
	If $g_iCurrentAccountWaitTime = 0 Then
		SetLog("Wait time for current Account : training finished, Chief !", $COLOR_SUCCESS)
	Else
		SetLog("Wait time for current Account : " & Round($g_iCurrentAccountWaitTime, 2) & " minutes", $COLOR_SUCCESS)
	EndIf

EndFunc   ;==>GetWaitTime

Func FindFirstAccount()
	For $x = 1 To 8
		$g_iNextAccount = $x
		If $g_iachkCanUse[$x] = 1 Then ExitLoop
	Next
;	$g_iCurrentAccount = $g_iNextAccount
;	$g_iNextProfile = _GUICtrlComboBox_GetCurSel($g_acmbAccount[$g_iNextAccount])
;	_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $g_iNextProfile)
;	cmbProfile()
EndFunc   ;==>FindFirstAccount

Func GetNextAccount()
	If $g_bMustGoToDonateAccount = 1 And $g_iTotalDonateAccountsInUse <> 0 And $g_iachkDonateAccount[$g_iCurrentAccount] = 0 Then

		SetLog("Time to go to Donate Account...", $COLOR_SUCCESS)

		Local $NextDAccount = $g_iCurrentDAccount
		Do
			$NextDAccount += 1
			If $NextDAccount > $g_iTotalAccountsOnEmu Then $NextDAccount = 1
		Until $g_iachkCanUse[$NextDAccount] = 1 And $g_iachkDonateAccount[$NextDAccount] = 1

		If _Sleep(10) Then Return

		SetLog("So, next Account will be : " & $NextDAccount, $COLOR_SUCCESS)

		If _Sleep(10) Then Return

		$g_iCurrentDAccount = $NextDAccount
		$g_iNextAccount = $NextDAccount
		$g_bMustGoToDonateAccount = 0

	Else

		For $x = 1 To 8
			If $g_iachkCanUse[$x] = 1 And $g_iachkDonateAccount[$x] = 0 Then
				$g_iaTimerDiffEnd[$x] = TimerDiff($g_iaTimerDiffStart[$x])
				$g_iaAllAccountsWaitTimeDiff[$x] = Round($g_iaAllAccountsWaitTime[$x] * 60 * 1000 - $g_iaTimerDiffEnd[$x])
				If Round($g_iaAllAccountsWaitTimeDiff[$x] / 60 / 1000, 2) < 0 Then
					Local $FinishedSince = StringReplace(Round($g_iaAllAccountsWaitTimeDiff[$x] / 60 / 1000, 2), "-", "")
					SetLog("Account " & $x & " wait time left : training finished since " & $FinishedSince & " minutes", $COLOR_SUCCESS)
				Else
					SetLog("Account " & $x & " wait time left : " & Round($g_iaAllAccountsWaitTimeDiff[$x] / 60 / 1000, 2) & " minutes", $COLOR_SUCCESS)
				EndIf
			EndIf
		Next

		If _Sleep(10) Then Return

		$g_iNextAccount = _ArrayMinIndex($g_iaAllAccountsWaitTimeDiff, 1, 1, 8)
		SetLog("So, next Account will be : " & $g_iNextAccount, $COLOR_SUCCESS)

		If _Sleep(10) Then Return

		$g_bMustGoToDonateAccount = 1

	EndIf
EndFunc   ;==>GetNextAccount

Func CheckDelayStayOnAccount()
	If $g_ichkSwitchAccount = 0 Then Return False
	Local $iDelaySinceLastSwitch = TimerDiff($g_iOnAccountSince) / 1000 / 60
	If $iDelaySinceLastSwitch > $g_iMaxStayDelay Then
		SetLog("Max stay on Account Delay exceeded... Time to Switch Account !", $COLOR_INFO)
		$g_bForceSwitch = True
		Return True ; return True, so BOT will continue to Switch part, and will Switch
	Else
		SetLog("Stay on Account Delay not exceeded yet...", $COLOR_INFO)
		$g_bForceSwitch = False
		Return False ; return False, delay not exceeded, BOT will process attacking
	EndIf
EndFunc   ;==>CheckDelayStayOnAccount

Func WaitForNextStep()
	Local $iCheckStep = 0

	SetLog("Waiting for Load Button or Already Connected...", $COLOR_INFO)

	While (Not (IsLoadButton() Or AlreadyConnected())) And $iCheckStep < 150
		If _Sleep(200) Then Return
		$iCheckStep += 1
	WEnd

	If $g_bIsLoadButton Then
		$g_iSwitchAccountNextStep = 1
	ElseIf $g_bAlreadyConnected Then
		$g_iSwitchAccountNextStep = 2
	Else
		$g_iSwitchAccountNextStep = 0
	EndIf
EndFunc   ;==>WaitForNextStep

Func TrainDonateOnlyLoop() ; not used func
	Setlog("Entering in the Train/Donate Only Loop...", $COLOR_INFO)

	DonateCC()
	randomSleep(2000)

	DonateCC()
	randomSleep(2000)

	CheckArmyCamp(True, True)
	If ($g_bFullArmy = False Or $g_bFullArmySpells = False) And $g_bTrainEnabled = True Then
		TrainRevamp()
		randomSleep(10000)
	EndIf

	DonateCC()
	randomSleep(2000)

	DonateCC()
	randomSleep(2000)

	CheckArmyCamp(True, True) ; Only Train if Camps not Full
	If ($g_bFullArmy = False Or $g_bFullArmySpells = False) And $g_bTrainEnabled = True Then
		TrainRevamp()
		randomSleep(2000)
	EndIf

	Setlog("Train/Donate Only Loop Done !", $COLOR_INFO)
	SwitchAccount()
EndFunc   ;==>TrainDonateOnlyLoop

Func CheckAccountsInUse()
	$g_iTotalAccountsInUse = 8
	For $x = 1 To 8
		If $g_iachkCanUse[$x] = 0 Then
			$g_iaAllAccountsWaitTimeDiff[$x] = 2147483647
			$g_iTotalAccountsInUse -= 1
		EndIf
	Next
EndFunc   ;==>CheckAccountsInUse

Func CheckDAccountsInUse()
	$g_iTotalDonateAccountsInUse = 0
	For $x = 1 To 8
		If $g_iachkDonateAccount[$x] = 1 Then
			$g_iaAllAccountsWaitTimeDiff[$x] = 2147483647
			$g_iTotalDonateAccountsInUse += 1
		EndIf
	Next
EndFunc   ;==>CheckDAccountsInUse

; ================================================== CHECKS PART PART ================================================== ;

Func IsLoadButton()
	$g_bIsLoadButton = _ColorCheck(_GetPixelColor(480, 441, True), "60B010", 20)
	Return $g_bIsLoadButton
EndFunc   ;==>IsLoadButton

Func AlreadyConnected()
	$g_bAlreadyConnected = _ColorCheck(_GetPixelColor(408, 408, True), "D0E878", 20)
	Return $g_bAlreadyConnected
EndFunc   ;==>AlreadyConnected

; ================================================== GUI PART ================================================== ;

Func MakeSummaryLog()
	;cmbAccountsQuantity()
	CheckAccountsInUse()
	CheckDAccountsInUse()
	SetLog("Pico Switch Account : " & $g_iTotalAccountsOnEmu & " Accounts - " & $g_iTotalAccountsInUse & " in use - " & $g_iTotalDonateAccountsInUse & " Donate Accounts", $COLOR_WARNING)
EndFunc   ;==>MakeSummaryLog

Func chkSwitchAccount()
	If GUICtrlRead($chkEnableSwitchAccount) = $GUI_CHECKED Then
		$g_ichkSwitchAccount = 1
		For $i = $lblNB To $g_lblEndSwitchAccount
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_ichkSwitchAccount = 0
		For $i = $lblNB To $g_lblEndSwitchAccount
			GUICtrlSetState($i, $GUI_DISABLE)
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	EndIf
	cmbAccountsQuantity()
EndFunc   ;==>chkSwitchAccount

Func cmbAccountsQuantity()
	$g_iTotalAccountsOnEmu = GUICtrlRead($g_cmbAccountsQuantity)
	$g_icmbAccountsQuantity = _GUICtrlComboBox_GetCurSel($g_cmbAccountsQuantity)
	For $h = 1 To 8
		If $h <= $g_iTotalAccountsOnEmu Then
			For $i = $g_achkCanUse[$h] To $g_achkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_SHOW)
			Next
		Else
			For $i = $g_achkCanUse[$h] To $g_achkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_HIDE)
				GUICtrlSetState($i, $GUI_UNCHECKED)
			Next
		EndIf
	Next
	chkAccountsProperties()
EndFunc   ;==>cmbAccountsQuantity

Func chkAccountsProperties()
	For $h = 1 To 8
		If GUICtrlRead($g_achkCanUse[$h]) = $GUI_CHECKED Then
			For $i = $g_acmbAccount[$h] To $g_achkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			$g_iachkCanUse[$h] = 1
		Else
			For $i = $g_acmbAccount[$h] To $g_achkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_DISABLE)
				GUICtrlSetState($i, $GUI_UNCHECKED)
			Next
			$g_iachkCanUse[$h] = 0
		EndIf
		If GUICtrlRead($g_achkDonateAccount[$h]) = $GUI_CHECKED Then
			$g_iachkDonateAccount[$h] = 1
		Else
			$g_iachkDonateAccount[$h] = 0
		EndIf
		$g_iacmbAccount[$h] = _GUICtrlComboBox_GetCurSel($g_acmbAccount[$h])
	Next
EndFunc   ;==>chkAccountsProperties

Func IdentifyDonateOnly()
	If $g_iachkDonateAccount[$g_iCurrentAccount] = 1 Then
		SetLog("Current Account is a Train/Donate Only Account...", $COLOR_DEBUG1)
	Else
		SetLog("Current Account is not a Train/Donate Only Account...", $COLOR_DEBUG1)
	EndIf
EndFunc   ;==>IdentifyDonateOnly

Func cmbMaxStayDelay()
	$g_iMaxStayDelay = GUICtrlRead($g_cmbMaxStayDelay)
	$g_icmbMaxStayDelay = _GUICtrlComboBox_GetCurSel($g_cmbMaxStayDelay)
EndFunc   ;==>cmbMaxStayDelay

Func cmbMinDelayToSwitch()
	$g_iMinDelayToSwitch = GUICtrlRead($g_cmbMinDelayToSwitch)
	$g_icmbMinDelayToSwitch = _GUICtrlComboBox_GetCurSel($g_cmbMinDelayToSwitch)
EndFunc   ;==>cmbMinDelayToSwitch

; ================================================== LOG PART ================================================== ;

Func AddLineToPicoSwitchAccountLog($AtkReportLine)
	If $g_ichkSwitchAccount = 1 Then
		If $g_sSwitchAccountLastDate <> _NowDate() Then
			$g_sSwitchAccountLastDate = _NowDate()
			FileWriteLine($g_sSwitchAccountAtkLog, @CRLF)
			FileWriteLine($g_sSwitchAccountAtkLog, _NowDate())
			FileWriteLine($g_sSwitchAccountAtkLog, @CRLF)
			FileWriteLine($g_sSwitchAccountAtkLog, "SW" & GetTranslatedFileIni("MBR Func_AtkLogHead", "AtkLogHead_Text_02", '|                   --------  LOOT --------       ----- BONUS ------'))
			FileWriteLine($g_sSwitchAccountAtkLog, "AC" & GetTranslatedFileIni("MBR Func_AtkLogHead", "AtkLogHead_Text_03", '| TIME|TROP.|SEARCH|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L.'))
		EndIf
		If FileWriteLine($g_sSwitchAccountAtkLog, $AtkReportLine) = 0 Then Setlog("Error when trying to add Attack Report line to Pico Switch Account log...", $COLOR_ERROR)
	EndIf
EndFunc   ;==>AddLineToPicoSwitchAccountLog
