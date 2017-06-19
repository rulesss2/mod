
; #FUNCTION# ====================================================================================================================
; Name ..........: ProfileReport
; Description ...: This function will report Attacks Won, Defenses Won, Troops Donated and Troops Received from Profile info page
; Syntax ........: ProfileReport()
; Parameters ....:
; Return values .: None
; Author ........: Sardo
; Modified ......: KnowJack (July 2015) add wait loop for slow PC read of OCR
;                  Sardo 2015-08, CodeSlinger69 9(2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ProfileReport()
	Local $AttacksWon = 0, $DefensesWon = 0

	Local $iCount
	ClickP($aAway, 1, 0, "#0221") ;Click Away
	If _Sleep($DELAYPROFILEREPORT1) Then Return

	SetLog("Profile Report", $COLOR_INFO)
	SetLog("Opening Profile page to read atk, def, donated and received...", $COLOR_INFO)

	; ********* OPEN TAB AND CHECK IT ***********
	Local $sPageDirectory = @ScriptDir & "\imgxml\Resources\Pages\Profile"

	; Click Info Profile Button
	Click(30, 40, 1, 0, "#0222")
	If _Sleep($DELAYPROFILEREPORT2) Then Return

	; Check the 'My Profile' tab region
	While Not QuickMIS("BC1", $sPageDirectory, 110, 67, 250, 100, True, False)
		If $g_iDebugSetlog = 1 Then Setlog("Profile wait time: " & $iCount, $COLOR_DEBUG)
		; 1000ms between checks
		If _Sleep($DELAYPROFILEREPORT2) Then Return
		$iCount += 1
		If $iCount > 12 Then
			Setlog("Excess wait time for profile to open: " & $iCount, $COLOR_DEBUG)
			Return
		EndIf
	WEnd

	; Check If exist 'Claim Reward' button , click and return to Top of the Profile Page
	Local $sClaimDirectory = @ScriptDir & "\imgxml\Resources\Pico Humanization\ClaimReward"
	; Local to check if was all dragclick to top
	Local $CheckTopProfile[4] = [180, 272, 0x8f93b2, 5]
	For $i = 0 to 1 ; Check twice,  because the button is animated
		If QuickMIS("BC1", $sClaimDirectory, 680, 165, 855, 680) Then
			Click($g_iQuickMISX + 680, $g_iQuickMISY + 165)
			SetLog("Reward collected !!! Good Job Chief :D !!!", $COLOR_SUCCESS)
			For $i = 0 To 9
				ClickDrag(421, 200, 421, 630, 2000)
				If _Sleep(2000) Then Return ; 2000ms
				If _ColorCheck(_GetPixelColor($CheckTopProfile[0], $CheckTopProfile[1], True), Hex($CheckTopProfile[2], 6), $CheckTopProfile[3]) = True Then ExitLoop
			Next
			ExitLoop ; ok task was done , lets exit from here|
		EndIf
		If _Sleep($DELAYPROFILEREPORT1) Then Return ; 500ms
	NExt

	If _Sleep($DELAYPROFILEREPORT1) Then Return
	$AttacksWon = ""

	If _ColorCheck(_GetPixelColor($ProfileRep01[0], $ProfileRep01[1], True), Hex($ProfileRep01[2], 6), $ProfileRep01[3]) = True Then ; MAY UPDATE
		If $g_iDebugSetlog = 1 Then Setlog("Village have no attack and no defenses " & $ProfileRep01[0] & "," & $ProfileRep01[1] + $g_iMidOffsetY, $COLOR_DEBUG)
		$AttacksWon = 0
		$DefensesWon = 0
	Else
		$AttacksWon = getProfile(578, 346) ; MAY UPDATE
		If $g_iDebugSetlog = 1 Then Setlog("$AttacksWon 1st read: " & $AttacksWon, $COLOR_DEBUG)
		$iCount = 0
		While $AttacksWon = "" ; Wait for $attacksWon to be readable in case of slow PC
			If _Sleep($DELAYPROFILEREPORT1) Then Return
			$AttacksWon = getProfile(578, 346) ; MAY UPDATE
			If $g_iDebugSetlog = 1 Then Setlog("Read Loop $AttacksWon: " & $AttacksWon & ", Count: " & $iCount, $COLOR_DEBUG)
			$iCount += 1
			If $iCount >= 20 Then ExitLoop
		WEnd
		If $g_iDebugSetlog = 1 And $iCount >= 20 Then Setlog("Excess wait time for reading $AttacksWon: " & getProfile(578, 268 + $g_iMidOffsetY), $COLOR_DEBUG)
		$DefensesWon = getProfile(790, 346) ; MAY UPDATE
	EndIf
	$g_iTroopsDonated = getProfile(158, 346) ; MAY UPDATE
	$g_iTroopsReceived = getProfile(360, 346) ; MAY UPDATE

	SetLog(" [ATKW]: " & _NumberFormat($AttacksWon) & " [DEFW]: " & _NumberFormat($DefensesWon) & " [TDON]: " & _NumberFormat($g_iTroopsDonated) & " [TREC]: " & _NumberFormat($g_iTroopsReceived), $COLOR_SUCCESS)
	Click(830, 80, 1, 0, "#0223") ; Close Profile page
	If _Sleep($DELAYPROFILEREPORT3) Then Return

	$iCount = 0
	While _CheckPixel($aIsMain, $g_bCapturePixel) = False ; wait for profile report window very slow close
		If _Sleep($DELAYPROFILEREPORT3) Then Return
		$iCount += 1
		If $g_iDebugSetlog = 1 Then Setlog("End ProfileReport $iCount= " & $iCount, $COLOR_DEBUG)
		If $iCount > 50 Then
			If $g_iDebugSetlog = 1 Then Setlog("Excess wait time clearing ProfileReport window: " & $iCount, $COLOR_DEBUG)
			ExitLoop
		EndIf
	WEnd

EndFunc   ;==>ProfileReport
