; #FUNCTION# ====================================================================================================================
; Name ..........: GoToBBFeatures()
; Description ...: Point of start of BB Features
; Syntax ........: GoToBBFeatures()
; Parameters ....:
; Return values .: None
; Author ........: RoroTiti (05-2017)
; Modified ......: ProMac (05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GoToBBFeatures()

	; Is Not necessary go to Builder Island
	If $g_ichkCollectBldGE = 0 And $g_ichkCollectBldGems = 0 And $g_ichkActivateClockTower = 0 Then Return

	Static $hTimer_BB = 0

	; Run the code only once peer hour ???
	; Will be necessary Make a Txtbox on GUI?
	If $hTimer_BB <> 0 then
		Local $fDiff = ((TimerDiff($hTimer_BB) /1000) / 60)
		If $fDiff < 60 then return
	EndIf

	If GoToBuildersBase() Then

		If $g_ichkCollectBldGE = 1 Or $g_ichkCollectBldGems = 1 Then
			CollectBuildersResources()
		EndIf

		; Get values
		BuilderBaseReport()

		If $g_ichkActivateClockTower = 1 Then
			ActivateClockTower()
		EndIf

		; Suggested Upgrades
		MainSuggestedUpgradeCode()

		ClickP($aAway, 1, 0, "#0121")
		If _Sleep(250) Then Return
		GoToNormalVillage()

		$hTimer_BB = TimerInit()
	EndIf
EndFunc   ;==>GoToBBFeatures

Func GoToBuildersBase()
	If ClickOnTravelBoat() Then
		Click($g_iQuickMISX + 100, $g_iQuickMISY + 480)

		Local $iCheckStep = 0 ; Sleep(5000) if needed.
		While Not isOnBuilderIsland(True)
			If _Sleep(100) Then Return
			$iCheckStep += 1
			If $iCheckStep = 50 Then
				Setlog("Error when tryng to go to Builders Island... skipping...", $COLOR_ERROR)
				If _Sleep(100) Then Return
				Return False
			EndIf
		WEnd

		SetLog("We're now on Builders Island !", $COLOR_INFO)
		; Necessary a Delay to center the village and zoomout
		If _Sleep(1000) Then Return
		ZoomOut(True)
		If _Sleep(1000) Then Return
		Return True
	Else
		Setlog("Error when tryng to find Travel Boat... skipping...", $COLOR_ERROR)
		If _Sleep(100) Then Return
		Return False
	EndIf
EndFunc   ;==>GoToBuildersBase

Func ClickOnTravelBoat()
	Local $bBoatFound = QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\Boat", 100, 480, 200, 590)
	Return $bBoatFound
EndFunc   ;==>ClickOnTravelBoat
