; #FUNCTION# ====================================================================================================================
; Name ..........: Treasury Collect
; Description ...: This file contains all functions of Pico Treasury Collect feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 08/05/2017
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

; ================================================== MAIN PART ================================================== ;

Func CollectTreasury()
	If $g_ichkEnableTrCollect = 1 Then

		Setlog("Collecting treasury...", $COLOR_INFO)

		If OpenTreasuryMenu() Then
			If _Sleep(1500) Then Return
			If _ColorCheck(_GetPixelColor(430, 510, True), "6db91d", 20) Then ; 6db91d  | 60AC10

				If $g_ichkForceTrCollect = 1 Then
					CollectTreasuryStand()
				Else

					Local $iNeedToCollect = 0

					If $g_ichkGoldTrCollect = 1 And (GUICtrlRead($g_txtMinGoldTrCollect) > $g_aiCurrentLoot[$eLootGold]) Then
						Setlog("Gold amount is below minimum, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $g_ichkGoldTrCollect = 1 Then
						Setlog("Gold amount is above minimum...", $COLOR_ORANGE)
					EndIf

					If $g_ichkElxTrCollect = 1 And (GUICtrlRead($g_txtMinElxTrCollect) > $g_aiCurrentLoot[$eLootElixir]) Then
						Setlog("Elixir amount is below minimum, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $g_ichkElxTrCollect = 1 Then
						Setlog("Elixir amount is above minimum...", $COLOR_ORANGE)
					EndIf

					If $g_ichkDarkTrCollect = 1 And (GUICtrlRead($g_txtMinDarkTrCollect) > $g_aiCurrentLoot[$eLootDarkElixir]) Then
						Setlog("Dark amount is below minimum, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $g_ichkDarkTrCollect = 1 Then
						Setlog("Dark amount is above minimum...", $COLOR_ORANGE)
					EndIf

					If $g_ichkFullGoldTrCollect = 1 And _ColorCheck(_GetPixelColor(688, 284, True), "40AC00", 20) Then
						Setlog("Gold is full, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $g_ichkFullGoldTrCollect = 1 Then
						Setlog("Gold is not full...", $COLOR_ORANGE)
					EndIf

					If $g_ichkFullElxTrCollect = 1 And _ColorCheck(_GetPixelColor(688, 318, True), "40AC00", 20) Then
						Setlog("Elixir is full, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $g_ichkFullElxTrCollect = 1 Then
						Setlog("Elixir is not full...", $COLOR_ORANGE)
					EndIf

					If $g_ichkFullDarkTrCollect = 1 And _ColorCheck(_GetPixelColor(688, 351, True), "40AC00", 20) Then
						Setlog("Dark is full, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $g_ichkFullElxTrCollect = 1 Then
						Setlog("Dark is not full...", $COLOR_ORANGE)
					EndIf

					If $iNeedToCollect > 1 Then
						SetLog($iNeedToCollect & " conditions met to collect treasury, collecting...", $COLOR_ACTION1)
						CollectTreasuryStand()
					ElseIf $iNeedToCollect = 1 Then
						SetLog($iNeedToCollect & " condition met to collect treasury, collecting...", $COLOR_ACTION1)
						CollectTreasuryStand()
					Else
						SetLog("No condition met to collect treasury, skipping...", $COLOR_WARNING)
					EndIf

				EndIf

			Else
				SetLog("Collect button unavailable, treasury empty... skipping...", $COLOR_WARNING)
			EndIf
		EndIf

	EndIf

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(500) Then Return
EndFunc   ;==>CollectTreasury

Func CollectTreasuryStand()
	If _ColorCheck(_GetPixelColor(690, 210, True), "FFFFFF", 20) Then ; check treasury menu
		Click(435, 490)
		randomSleep(1500)
		If _ColorCheck(_GetPixelColor(520, 450, True), "60AD10", 20) And _ColorCheck(_GetPixelColor(590, 280, True), "E8E8E0", 20) Then ; check okay button
			Click(520, 450)
			SetLog("Treasury collected successfully", $COLOR_SUCCESS)
		Else
			SetLog("Error when trying to find Okay button... skipping...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error when trying to find Treasury menu... skipping...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>CollectTreasuryStand

Func OpenTreasuryMenu()
	If $g_aiClanCastlePos[0] = -1 Or $g_aiClanCastlePos[1] = -1 Then
		Setlog("Clan Castle unlocated, please, locate it manually. skipping...", $COLOR_ERROR)
		Return False
	Else
		Click($g_aiClanCastlePos[0], $g_aiClanCastlePos[1])
		randomSleep(1500)
		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Pico Treasury", 480, 610, 650, 710) Then ; search for treasury button
			Click($g_iQuickMISX + 480, $g_iQuickMISY + 610)
			randomSleep(1500)
		Else
			SetLog("Error when trying to open Treasury menu... skipping...", $COLOR_WARNING)
			Return False
		EndIf
		Return True
	EndIf
EndFunc   ;==>OpenTreasuryMenu

; ================================================== GUI PART ================================================== ;

Func chkEnableTrCollect()
	If GUICtrlRead($g_chkEnableTrCollect) = $GUI_CHECKED Then
		$g_ichkEnableTrCollect = 1
		For $i = $g_chkForceTrCollect To $g_chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkResTrCollect()
		chkFullResTrCollect()
		chkForceTrCollect()
	Else
		$g_ichkEnableTrCollect = 0
		For $i = $g_chkForceTrCollect To $g_chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkEnableTrCollect

Func chkForceTrCollect()
	If GUICtrlRead($g_chkForceTrCollect) = $GUI_CHECKED Then
		$g_ichkForceTrCollect = 1
		For $i = $g_chkGoldTrCollect To $g_chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		$g_ichkForceTrCollect = 0
		For $i = $g_chkGoldTrCollect To $g_chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkResTrCollect()
		chkFullResTrCollect()
	EndIf
EndFunc   ;==>chkForceTrCollect

Func chkResTrCollect()
	If GUICtrlRead($g_chkGoldTrCollect) = $GUI_CHECKED Then
		$g_ichkGoldTrCollect = 1
		GUICtrlSetState($g_txtMinGoldTrCollect, $GUI_ENABLE)
	Else
		$g_ichkGoldTrCollect = 0
		GUICtrlSetState($g_txtMinGoldTrCollect, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($g_chkElxTrCollect) = $GUI_CHECKED Then
		$g_ichkElxTrCollect = 1
		GUICtrlSetState($g_txtMinElxTrCollect, $GUI_ENABLE)
	Else
		$g_ichkElxTrCollect = 0
		GUICtrlSetState($g_txtMinElxTrCollect, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($g_chkDarkTrCollect) = $GUI_CHECKED Then
		$g_ichkDarkTrCollect = 1
		GUICtrlSetState($g_txtMinDarkTrCollect, $GUI_ENABLE)
	Else
		$g_ichkDarkTrCollect = 0
		GUICtrlSetState($g_txtMinDarkTrCollect, $GUI_DISABLE)
	EndIf
	chkFullResTrCollect()
EndFunc   ;==>chkResTrCollect

Func chkFullResTrCollect()
	If GUICtrlRead($g_chkFullGoldTrCollect) = $GUI_CHECKED Then
		$g_ichkFullGoldTrCollect = 1
	Else
		$g_ichkFullGoldTrCollect = 0
	EndIf

	If GUICtrlRead($g_chkFullElxTrCollect) = $GUI_CHECKED Then
		$g_ichkFullElxTrCollect = 1
	Else
		$g_ichkFullElxTrCollect = 0
	EndIf

	If GUICtrlRead($g_chkFullDarkTrCollect) = $GUI_CHECKED Then
		$g_ichkFullDarkTrCollect = 1
	Else
		$g_ichkFullDarkTrCollect = 0
	EndIf
EndFunc   ;==>chkFullResTrCollect
