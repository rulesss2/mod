; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01), MonkeyHunter (2016-07),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_abPrepDon[4] = [False, False, False, False]
Global $g_iTotalDonateCapacity, $g_iTotalDonateSpellCapacity
Global $g_iDonTroopsLimit = 8, $iDonSpellsLimit = 1, $g_iDonTroopsAv = 0, $g_iDonSpellsAv = 0
Global $g_iDonTroopsQuantityAv = 0, $g_iDonTroopsQuantity = 0, $g_iDonSpellsQuantityAv = 0, $g_iDonSpellsQuantity = 0
Global $g_bSkipDonTroops = False, $g_bSkipDonSpells = False
Global $g_bDonateAllRespectBlk = False ; is turned on off durning donate all section, must be false all other times
Global $g_aiDonatePixel ; array holding x, y position of donate button in chat window
Global $g_bSetlogOnlyOnce = 0
Global $g_hTimerPreventTimeOut = 0
Global $g_hCurrentDonateButtonBitMap = 0
;Global $g_hTimerSpeedTest = 0

Func PrepareDonateCC()
	$g_abPrepDon[0] = 0
	$g_abPrepDon[1] = 0
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
		$g_abPrepDon[0] = BitOR($g_abPrepDon[0], ($g_abChkDonateTroop[$i] ? 1 : 0))
		$g_abPrepDon[1] = BitOR($g_abPrepDon[1], ($g_abChkDonateAllTroop[$i] ? 1 : 0))
	Next

	$g_abPrepDon[2] = 0
	$g_abPrepDon[3] = 0
	For $i = 0 To $eSpellCount - 1
		If $i <> $eSpellClone Then
			$g_abPrepDon[2] = BitOR($g_abPrepDon[2], ($g_abChkDonateSpell[$i] ? 1 : 0))
			$g_abPrepDon[3] = BitOR($g_abPrepDon[3], ($g_abChkDonateAllSpell[$i] ? 1 : 0))
		EndIf
	Next

	$g_iActiveDonate = BitOR($g_abPrepDon[0], $g_abPrepDon[1], $g_abPrepDon[2], $g_abPrepDon[3])
EndFunc   ;==>PrepareDonateCC

Func DonateCC($Check = False)

	Local $bDonateTroop = $g_abPrepDon[0]

	Local $bDonateAllTroop = $g_abPrepDon[1]

	Local $bDonateSpell = $g_abPrepDon[2]
	Local $bDonateAllSpell = $g_abPrepDon[3]

	Local $bDonate = $g_iActiveDonate

	Local $bOpen = True, $bClose = False

	Local $ReturnT = ($g_CurrentCampUtilization >= ($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct / 100) * .95) ? (True) : (False)

	Local $ClanString = ""

	Local $TimerDiff = 0 ;Used for DonateTrain only behavior change
	Local $iReturntoTrainTime = 0 ;Used for DonateTrain only behavior change
	$g_bSetlogOnlyOnce = 0 ; Set as global Used in 3 Functions  Used for DonateTrain only behavior change
	$g_hTimerPreventTimeOut = TimerInit ( )

	If Not $bDonate Or Not $g_bDonationEnabled Then
		If $g_iDebugSetlog = 1 Then Setlog("Donate Clan Castle troops skip", $COLOR_DEBUG)
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then
		If $g_iDebugSetlog = 1 Then SetLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_DEBUG)
		Return ; exit func if no planned donate checkmarks
	EndIf

	Local $y = 90

	;check for new chats first
	If $Check Then
		If Not _ColorCheck(_GetPixelColor(26, 312 + $g_iMidOffsetY, True), Hex(0xf00810, 6), 20) And $g_iCommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf

	;Opens clan tab and verbose in log
	ClickP($aAway, 1, 0, "#0167") ;Click Away
	Setlog("Checking for Donate Requests in Clan Chat", $COLOR_INFO)

;	ForceCaptureRegion()
	If Not _CheckPixel($aChatTab, $g_bCapturePixel) Or Not _CheckPixel($aChatTab2, $g_bCapturePixel) Or Not _CheckPixel($aChatTab3, $g_bCapturePixel) Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($DELAYDONATECC4) Then Return

	Local $iLoopCount = 0
	While 1
		;If Clan tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x706C50, 6), 20) Then ; color med gray
			;If _Sleep(200) Then Return ;small delay to allow tab to completely open
			;Clan tab already Selected no click needed
			;ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
			ExitLoop
		EndIf
		;If Global tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x383828, 6), 20) Then ; Darker gray
			If _Sleep($DELAYDONATECC1) Then Return ;small delay to allow tab to completely open
			ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
			ExitLoop
		EndIf
		;counter for time approx 3 sec max allowed for tab to open
		$iLoopCount += 1
		If $iLoopCount >= 15 Then ; allows for up to a sleep of 3000
			SetLog("Clan Chat Did Not Open - Abandon Donate")
			AndroidPageError("DonateCC")
			Return
		EndIf
		If _Sleep($DELAYDONATECC1) Then Return ; delay Allow 15x
	WEnd

	Local $Scroll
	Local $donateCCfilter = False
	; add scroll here
	While 1
;		ForceCaptureRegion()
		;$Scroll = _PixelSearch(288, 640 + $g_iBottomOffsetY, 290, 655 + $g_iBottomOffsetY, Hex(0x588800, 6), 20)
		$y = 90
		$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) And _ColorCheck(_GetPixelColor(300, 110, True), Hex(0x509808, 6), 20) Then ; a second pixel for the green
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 90
			If _Sleep($DELAYDONATECC2 + 100) Then Return
			ContinueLoop
		EndIf
		ExitLoop
	WEnd

	While $bDonate
		checkAttackDisable($g_iTaBChkIdle) ; Early Take-A-Break detection
		$ClanString = ""

		If _Sleep($DELAYDONATECC2) Then Return
		$g_aiDonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $g_iBottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 20)
		If IsArray($g_aiDonatePixel) Then ; if Donate Button found
			If $g_iDebugSetlog = 1 Then Setlog("$g_aiDonatePixel: (" & $g_aiDonatePixel[0] & "," & $g_aiDonatePixel[1] & ")", $COLOR_DEBUG)
			;$g_hTimerSpeedTest = TimerInit()
			_CaptureGameScreen($g_hCurrentDonateButtonBitMap)

			If  Not DonateWindow($bOpen) Then ; ($g_bSkipDonTroops And $g_bSkipDonSpells) Or
				$bDonate = True
				$y = $g_aiDonatePixel[1] + 50
				SetLog("Donate Window did not open - Exiting Donate", $COLOR_ERROR)
				ExitLoop ; Leave donate to prevent a bot hang condition
			EndIf

			; collect donate users images Filter whitelist blacklist etc.
			If $g_iCmbDonateFilter = 0 Then
				$donateCCfilter = True
			Else
				$donateCCfilter = donateCCWBLUserImageCollect($g_aiDonatePixel[0], $g_aiDonatePixel[1])
			EndIf

			;reset every run
			$bDonate = False ; donate only for one request at a time
			$g_bSkipDonTroops = False
			$g_bSkipDonSpells = False


			;Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell And $donateCCfilter Then
				If $g_bChkExtraAlphabets Then
					; Chat Request using "coc-latin-cyr" xml: Latin + Cyrillic derived alphabets / three paragraphs
					Setlog("Using OCR to read Latin and Cyrillic derived alphabets..", $COLOR_ACTION)
					$ClanString = ""
					$ClanString = getChatString(30, $g_aiDonatePixel[1] - 50, "coc-latin-cyr")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latin-cyr")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latin-cyr")
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				Else ; default
					; Chat Request using "coc-latinA" xml: only Latin derived alphabets / three paragraphs
					Setlog("Using OCR to read Latin derived alphabets..", $COLOR_ACTION)
					$ClanString = ""
					$ClanString = getChatString(30, $g_aiDonatePixel[1] - 50, "coc-latinA")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latinA")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latinA")
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; Chat Request using IMGLOC: Chinese alphabet / one paragraph
				If $g_bChkExtraChinese Then
					Setlog("Using OCR to read the Chinese alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringChinese(30, $g_aiDonatePixel[1] - 24)
					Else
						$ClanString &= " " & getChatStringChinese(30, $g_aiDonatePixel[1] - 24)
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; Chat Request using IMGLOC: Korean alphabet / one paragraph
				If $g_bChkExtraKorean Then
					Setlog("Using OCR to read the Korean alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringKorean(30, $g_aiDonatePixel[1] - 24)
					Else
						$ClanString &= " " & getChatStringKorean(30, $g_aiDonatePixel[1] - 24)
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; Chat Request using IMGLOC: Persian alphabet / one paragraph
				If $g_bChkExtraPersian Then
					Setlog("Using OCR to read the Persian alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringPersian(30, $g_aiDonatePixel[1] - 31)
					Else
						$ClanString &= " " & getChatStringPersian(30, $g_aiDonatePixel[1] - 31)
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf

				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_ERROR)
					$bDonate = True
					$y = $g_aiDonatePixel[1] + 50
					DonateWindow($bClose)
					ContinueLoop
				Else
					If $g_bChkExtraAlphabets Then
						ClipPut($ClanString)
						Local $tempClip = ClipGet()
						SetLog("Chat Request: " & $tempClip)
					Else
						SetLog("Chat Request: " & $ClanString)
					EndIf
				EndIf
			ElseIf (($bDonateAllTroop And $bDonateAllSpell) Or ($bDonateAllTroop And Not $bDonateSpell) Or (Not $bDonateTroop And $bDonateAllSpell)) And $donateCCfilter Then
				SetLog("Skip reading chat requests. Donate all is enabled!", $COLOR_ACTION)
			EndIf

			; Get remaining CC capacity of requested troops from your ClanMates
			RemainingCCcapacity()

;==============image no longer needed==
			GdiDeleteHBitmap($g_hCurrentDonateButtonBitMap)
;=======================================
			If Not $donateCCfilter Then
				Setlog("Skip Donation at this Clan Mate...", $COLOR_ACTION)
				$g_bSkipDonTroops = True
				$g_bSkipDonSpells = True
			Else
				If $g_iTotalDonateCapacity <= 0 Then
					Setlog("Clan Castle troops are full, skip troop donation...", $COLOR_ACTION)
					$g_bSkipDonTroops = True
				EndIf
				If $g_iTotalDonateSpellCapacity = 0 Then
					Setlog("Clan Castle spells are full, skip spell donation...", $COLOR_ACTION)
					$g_bSkipDonSpells = True
				ElseIf $g_iTotalDonateSpellCapacity = -1 Then
					; no message, this CC has no Spell capability
					If $g_iDebugSetlog = 1 Then Setlog("This CC cannot accept spells, skip spell donation...", $COLOR_DEBUG)
					$g_bSkipDonSpells = True
				ElseIf $g_iSpellFactorySize = 0 Then
					If $g_iDebugSetlog = 1 Then Setlog("No spells available, skip spell donation...", $COLOR_DEBUG) ;Debug
					Setlog("No spells available, skip spell donation...", $COLOR_ORANGE)
					$g_bSkipDonSpells = True
				EndIf

			EndIf

			If $g_bSkipDonTroops And $g_bSkipDonSpells Then
				$bDonate = True
				$y = $g_aiDonatePixel[1] + 50
				DonateWindow($bClose)
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf



			If $bDonateTroop Or $bDonateSpell Then
				If $g_iDebugSetlog = 1 Then Setlog("Troop/Spell checkpoint.", $COLOR_DEBUG)

				; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
				DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
				If $g_bSkipDonTroops And $g_bSkipDonSpells Then
					DonateWindow($bClose)
					$bDonate = True
					$y = $g_aiDonatePixel[1] + 50
					If _Sleep($DELAYDONATECC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				If $bDonateTroop = 1 And $g_bSkipDonTroops = False Then
					If $g_iDebugSetlog = 1 Then Setlog("Troop checkpoint.", $COLOR_DEBUG)

					;;; Custom Combination Donate by ChiefM3, edited by MonkeyHunter
					If $g_abChkDonateTroop[$eCustomA] And CheckDonateTroop(99, $g_asTxtDonateTroop[$eCustomA], $g_asTxtBlacklistTroop[$eCustomA], $ClanString) Then
						For $i = 0 To 2
							If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
								$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
								$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($g_aiDonateCustomTrpNumA[$i][0], $g_aiDonateCustomTrpNumA[$i][1], $g_abChkDonateTroop[$eCustomA]) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf

					If $g_abChkDonateTroop[$eCustomB] And CheckDonateTroop(99, $g_asTxtDonateTroop[$eCustomB], $g_asTxtBlacklistTroop[$eCustomB], $ClanString) Then
						For $i = 0 To 2
							If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
								$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
								$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($g_aiDonateCustomTrpNumB[$i][0], $g_aiDonateCustomTrpNumB[$i][1], $g_abChkDonateTroop[$eCustomB]) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf

					If Not $g_bSkipDonTroops Then
						For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
							Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
							If $g_abChkDonateTroop[$iTroopIndex] Then
								If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString) Then
									DonateTroopType($iTroopIndex)
								EndIf
							EndIf
						Next
					EndIf

				EndIf

				If $bDonateSpell = 1 And Not $g_bSkipDonSpells Then
					If $g_iDebugSetlog = 1 Then Setlog("Spell checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
						Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
						If $g_abChkDonateSpell[$iSpellIndex] Then
							If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString) Then
								DonateSpellType($iSpellIndex)
							EndIf
						EndIf
					Next
				EndIf

			EndIf

			If $bDonateAllTroop Or $bDonateAllSpell Then
				If $g_iDebugSetlog = 1 Then Setlog("Troop/Spell All checkpoint.", $COLOR_DEBUG) ;Debug
				$g_bDonateAllRespectBlk = True

				If $bDonateAllTroop And Not $g_bSkipDonTroops Then
					; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
					DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
					If $g_bSkipDonTroops And $g_bSkipDonSpells Then
						DonateWindow($bClose)
						$bDonate = True
						$y = $g_aiDonatePixel[1] + 50
						If _Sleep($DELAYDONATECC2) Then ExitLoop
						ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
					EndIf
					If $g_iDebugSetlog = 1 Then Setlog("Troop All checkpoint.", $COLOR_DEBUG)
					Select
						Case $g_abChkDonateAllTroop[$eCustomA]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumA[$i][0], $g_aiDonateCustomTrpNumA[$i][1], $g_abChkDonateAllTroop[$eCustomA], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next

						Case $g_abChkDonateAllTroop[$eCustomB]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumB[$i][0], $g_aiDonateCustomTrpNumB[$i][1], $g_abChkDonateAllTroop[$eCustomB], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next

						Case Else
							For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
								Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
								If $g_abChkDonateAllTroop[$iTroopIndex] Then
									If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString) Then
										DonateTroopType($iTroopIndex, 0, False, $bDonateAllTroop)
									EndIf
									ExitLoop
								EndIf
							Next

					EndSelect
				EndIf

				If $bDonateAllSpell And Not $g_bSkipDonSpells Then
					If $g_iDebugSetlog = 1 Then Setlog("Spell All checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
						Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
						If $g_abChkDonateAllSpell[$iSpellIndex] Then
							If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString) Then
								DonateSpellType($iSpellIndex, 0, False, $bDonateAllSpell)
							EndIf
							ExitLoop
						EndIf
					Next
				EndIf
				$g_bDonateAllRespectBlk = False
			EndIf

			;close Donate Window
			DonateWindow($bClose)
			$bDonate = True
			$y = $g_aiDonatePixel[1] + 50
			If _Sleep($DELAYDONATECC2) Then ExitLoop
		EndIf

		;ck for more donate buttons
;		ForceCaptureRegion()
		$g_aiDonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $g_iBottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 20)
		If IsArray($g_aiDonatePixel) Then
			If $g_iDebugSetlog = 1 Then Setlog("More Donate buttons found, new $g_aiDonatePixel: (" & $g_aiDonatePixel[0] & "," & $g_aiDonatePixel[1] & ")", $COLOR_DEBUG)
			ContinueLoop
		Else
			If $g_iDebugSetlog = 1 Then Setlog("No more Donate buttons found, closing chat ($y=" & $y & ")", $COLOR_DEBUG)

		; Scroll Down
			$Scroll = _PixelSearch(293, 687 - 30, 295, 693 - 30, Hex(0xFFFFFF, 6), 20)
			If IsArray($Scroll) Then
				$bDonate = True
				Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
				$y = 600
				If _Sleep($DELAYDONATECC2) Then ExitLoop
				ContinueLoop
			EndIf

			;train Donate only; Stay in Donate for a time Waiting for more requests
				; Conditions to leave
					;Train timer < 1 min

			If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) Then
				If $g_bSetlogOnlyOnce = 0 Then SetLog ( "Train Donate Only - Waiting for more requests")

				;Timer diff for Last Activity
				If TimerDiff($g_hTimerPreventTimeOut) >= (60000 * 2.5) Then
					;click somewhere in benign space
					Click( 150, 700)
					$g_hTimerPreventTimeOut = TimerInit()
				EndIf

				;TimerDiff for Train Troop Time
				$TimerDiff = 0
				$TimerDiff = int( ( TimerDiff($g_hTrainTimeLeft) / 1000) / 60 ) ; Convert to Mins
				$iReturntoTrainTime = ($g_aiTimeTrain[0] - 1) - $TimerDiff ; Allows for a 1min buffer on train
				If $iReturntoTrainTime <= 0 Then $iReturntoTrainTime = 0
				If $g_bSetlogOnlyOnce = 0 Then SetLog ( "Donate will Return to Train in " & $iReturntoTrainTime & " Min's")
				$g_bSetlogOnlyOnce = 1 ; Value is Reset to zero after a Donated Troop/Spell Click
				If $iReturntoTrainTime > 0 Then
					$y = 400 ; 400 approx bottom half - 570 bottom last space need for a donate.
					ContinueLoop
				Else
					SetLog ( "Returning to Check on Troop Training")
					ExitLoop
				EndIf
			EndIf
		EndIf

		$bDonate = False
	WEnd

	$i = 0


; Close the chat with the chat thing.... May need to covert to imloc...sometimes get error...
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat thing
			ExitLoop
		Else
			If _Sleep(100) Then Return
			$i += 1
			If $i > 30 Then
				SetLog("Error finding Clan Tab to close...", $COLOR_ERROR)
				AndroidPageError("DonateCC")
				ExitLoop
			EndIf
		EndIf
	WEnd

	UpdateStats()

	If _Sleep($DELAYDONATECC2) Then Return

EndFunc   ;==>DonateCC

Func CheckDonateTroop(Const $iTroopIndex, Const $sDonateTroopString, Const $sBlacklistTroopString, Const $sClanString)
	Local $sName = ($iTroopIndex = 99 ? "Custom" : $g_asTroopNames[$iTroopIndex])
	Return CheckDonate($sName, $sDonateTroopString, $sBlacklistTroopString, $sClanString)
EndFunc   ;==>CheckDonateTroop

Func CheckDonateSpell(Const $iSpellIndex, Const $sDonateSpellString, Const $sBlacklistSpellString, Const $sClanString)
	Local $sName = $g_asSpellNames[$iSpellIndex]
	Return CheckDonate($sName, $sDonateSpellString, $sBlacklistSpellString, $sClanString)
EndFunc   ;==>CheckDonateSpell

Func CheckDonate(Const $sName, Const $sDonateString, Const $sBlacklistString, Const $sClanString)
	Local $asSplitDonate = StringSplit($sDonateString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitBlacklist = StringSplit($sBlacklistString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitGeneralBlacklist = StringSplit($g_sTxtGeneralBlacklist, @CRLF, $STR_ENTIRESPLIT)

	For $i = 1 To UBound($asSplitGeneralBlacklist) - 1
		If CheckDonateString($asSplitGeneralBlacklist[$i], $sClanString) Then
			SetLog("General Blacklist Keyword found: " & $asSplitGeneralBlacklist[$i], $COLOR_ERROR)
			Return False
		EndIf
	Next

	For $i = 1 To UBound($asSplitBlacklist) - 1
		If CheckDonateString($asSplitBlacklist[$i], $sClanString) Then
			SetLog($sName & " Blacklist Keyword found: " & $asSplitBlacklist[$i], $COLOR_ERROR)
			Return False
		EndIf
	Next

	If Not $g_bDonateAllRespectBlk Then
		For $i = 1 To UBound($asSplitDonate) - 1
			If CheckDonateString($asSplitDonate[$i], $sClanString) Then
				Setlog($sName & " Keyword found: " & $asSplitDonate[$i], $COLOR_SUCCESS)
				Return True
			EndIf
		Next
	EndIf

	If $g_bDonateAllRespectBlk Then Return True

	If $g_iDebugSetlog = 1 Then Setlog("Bad call of CheckDonateTroop: " & $sName, $COLOR_DEBUG)
	Return False
EndFunc   ;==>CheckDonate

Func CheckDonateString($String, $ClanString) ;Checks if exact
	Local $Contains = StringMid($String, 1, 1) & StringMid($String, StringLen($String), 1)

	If $Contains = "[]" Then
		If $ClanString = StringMid($String, 2, StringLen($String) - 2) Then
			Return True
		Else
			Return False
		EndIf
	Else
		If StringInStr($ClanString, $String, 2) Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc   ;==>CheckDonateString

Func DonateTroopType(Const $iTroopIndex, $Quant = 0, Const $Custom = False, Const $bDonateAll = False)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $sTextToAll = ""

	If $g_iTotalDonateCapacity = 0 Then Return
	If $g_iDebugSetlog = 1 Then Setlog("$DonateTroopType Start: " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)

	; Space to donate troop?  Added Ezeck 6-14-2017 If Requested Troop dont fit in av. space, top off with Archers.. Cause everyone has an archer or two
	$g_iDonTroopsQuantityAv = Floor($g_iTotalDonateCapacity / $g_aiTroopSpace[$iTroopIndex])

	If $g_iDonTroopsQuantityAv < 1 Then
		Setlog("Sorry Chief! " & $g_asTroopNamesPlural[$iTroopIndex] & " don't fit in the remaining space!")
			If $g_asTroopNames[$iTroopIndex] = "Archer" Then ; Prevents endless loops
				Return
			Else
				Setlog("Changing Troop Type to Archers")
				DonateTroopType(1, 0, False, False)
			EndIf
	EndIf

	If $g_iDonTroopsQuantityAv >= $g_iDonTroopsLimit Then
		$g_iDonTroopsQuantity = $g_iDonTroopsLimit
	Else
		$g_iDonTroopsQuantity = $g_iDonTroopsQuantityAv
	EndIf


	; Detect the Troops Slot
	If $g_iDebugOCRdonate = 1 Then
		Local $oldDebugOcr = $g_iDebugOcr
		$g_iDebugOcr = 1
	EndIf

	$Slot = DetectSlotTroop($iTroopIndex)
	$detectedSlot = $Slot
	If $g_iDebugSetlog = 1 Then setlog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_iDebugOCRdonate = 1 Then $g_iDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	; figure out row/position
	If $Slot < 0 Or $Slot > 11 Then
		setlog("Invalid slot # found = " & $Slot & " for " & $g_asTroopNames[$iTroopIndex], $COLOR_ERROR)
		Return
	EndIf
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 6 And $Slot <= 11 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 6
		$donateposinrow = $Slot
		$YComp = 88 ; correct 860x780
	EndIf

	; Verify if the type of troop to donate exists
	SetLog("Troops Condition Matched", $COLOR_ORANGE)
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

		If $Custom Then
			If $bDonateAll Then $sTextToAll = " (to all requests)"
			SetLog("Donating " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & $sTextToAll, $COLOR_SUCCESS)

			If $g_iDebugOCRdonate = 1 Then
				Setlog("donate", $COLOR_ERROR)
				Setlog("row: " & $donaterow, $COLOR_ERROR)
				Setlog("pos in row: " & $donateposinrow, $COLOR_ERROR)
				setlog("coordinate: " & 365 + ($Slot * 68) & "," & $g_iDonationWindowY + 57 + $YComp, $COLOR_ERROR)
				debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
			EndIf

			If $g_iDebugOCRdonate = 0 Then
				; Use slow click when the Train system is Quicktrain
				If $g_bQuickTrainEnable Then
					Local $icount = 0
					For $x = 0 To $Quant
						If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

							Click(365 + ($Slot * 68), $g_iDonationWindowY + 57 + $YComp, 1, $DELAYDONATECC3, "#0175")
							$g_bSetlogOnlyOnce = 0
							$g_hTimerPreventTimeOut = TimerInit()
							If $g_iCommandStop = 3 Then
								$g_iCommandStop = 0
								$g_bFullArmy = False
							EndIf
							If _Sleep(1000) Then Return
							$icount += 1
						EndIf
					Next
					$Quant = $icount ; Count Troops Donated Clicks
					$g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
				Else
					If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

						Click(365 + ($Slot * 68), $g_iDonationWindowY + 57 + $YComp, $Quant, $DELAYDONATECC3, "#0175")
						$g_bSetlogOnlyOnce = 0
						$g_hTimerPreventTimeOut = TimerInit()
						$g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
						If $g_iCommandStop = 3 Then
							$g_iCommandStop = 0
							$g_bFullArmy = False
						EndIf
					EndIf
				EndIf

				; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
				If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopBowler Then
					;Reduce iTotalDonateCapacity by troops donated
					$g_iTotalDonateCapacity -= ($Quant * $g_aiTroopSpace[$iTroopIndex])
					;If donated max allowed troop qty set $g_bSkipDonTroops = True
					If $g_iDonTroopsLimit = $Quant Then
						$g_bSkipDonTroops = True
					EndIf
				EndIf
			EndIf

		Else
			If $g_iDebugOCRdonate = 1 Then
				Setlog("donate", $color_RED)
				Setlog("row: " & $donaterow, $color_RED)
				Setlog("pos in row: " & $donateposinrow, $color_red)
				setlog("coordinate: " & 365 + ($Slot * 68) & "," & $g_iDonationWindowY + 57 + $YComp, $color_red)
				debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
			EndIf
			If $g_iDebugOCRdonate = 0 Then
				; Use slow click when the Train system is Quicktrain
				If $g_bQuickTrainEnable = True Then
					Local $icount = 0
					For $x = 0 To $g_iDonTroopsQuantity
						If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

							Click(365 + ($Slot * 68), $g_iDonationWindowY + 57 + $YComp, 1, $DELAYDONATECC3, "#0175")
							$g_bSetlogOnlyOnce = 0
							$g_hTimerPreventTimeOut = TimerInit()
							$icount += 1
							If $g_iCommandStop = 3 Then
								$g_iCommandStop = 0
								$g_bFullArmy = False
							EndIf
							If _Sleep(1000) Then Return
						EndIf
					Next
					$g_iDonTroopsQuantity = $icount ; Count Troops Donated Clicks
					$g_aiDonateStatsTroops[$iTroopIndex][0] += $g_iDonTroopsQuantity
				Else
					If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

						;add a verify if donate window still open to prevent extra click closing the chat window
						For $x = 0 To $g_iDonTroopsQuantity
							If _ColorCheck(_GetPixelColor(331, $g_aiDonatePixel[1], True, "DonateWindow"), Hex(0xffffff, 6), 0) = True Then ; Verify if open, otherwise do nothing
								Click(365 + ($Slot * 68), $g_iDonationWindowY + 57 + $YComp, 1, $DELAYDONATECC3, "#0175") ; delay is 50
							EndIf
						Next

						$g_bSetlogOnlyOnce = 0
						$g_hTimerPreventTimeOut = TimerInit()
						$g_aiDonateStatsTroops[$iTroopIndex][0] += $g_iDonTroopsQuantity
						If $g_iCommandStop = 3 Then
							$g_iCommandStop = 0
							$g_bFullArmy = False
						EndIf
					EndIf
				EndIf

				If $bDonateAll Then $sTextToAll = " (to all requests)"
				SetLog("Donating " & $g_iDonTroopsQuantity & " " & ($g_iDonTroopsQuantity > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & _
						$sTextToAll, $COLOR_GREEN)

				; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
				If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopBowler Then
					;Reduce iTotalDonateCapacity by troops donated
					$g_iTotalDonateCapacity -= ($g_iDonTroopsQuantity * $g_aiTroopSpace[$iTroopIndex])
					;If donated max allowed troop qty set $g_bSkipDonTroops = True
					If $g_iDonTroopsLimit = $g_iDonTroopsQuantity Then
						$g_bSkipDonTroops = True
					EndIf

				EndIf
			EndIf
		EndIf

		; Assign the donated quantity troops to train : $Don $g_asTroopName

		If $Custom Then
			$g_aiDonateTroops[$iTroopIndex] += $Quant
		Else
			$g_aiDonateTroops[$iTroopIndex] += $g_iDonTroopsQuantity
		EndIf

	ElseIf $g_aiDonatePixel[1] - 5 + $YComp > 675 Then
		Setlog("Unable to donate " & $g_asTroopNames[$iTroopIndex] & ". Donate screen not visible, will retry next run.", $COLOR_ERROR)
	Else
		SetLog("No " & $g_asTroopNames[$iTroopIndex] & " available to donate..", $COLOR_ERROR)
	EndIf
EndFunc   ;==>DonateTroopType

Func DonateSpellType(Const $iSpellIndex, $Quant = 0, Const $Custom = False, Const $bDonateAll = False)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	;Local $sTextToAll = ""

	If $g_iTotalDonateSpellCapacity = 0 Then Return
	If $g_iDebugSetlog = 1 Then Setlog("DonateSpellType Start: " & $g_asSpellNames[$iSpellIndex], $COLOR_DEBUG)

	; Space to donate spell?
	$g_iDonSpellsQuantityAv = Floor($g_iTotalDonateSpellCapacity / $g_aiSpellSpace[$iSpellIndex])
	If $g_iDonSpellsQuantityAv < 1 Then
		Setlog("Sorry Chief! " & $g_asSpellNames[$iSpellIndex] & " spells don't fit in the remaining space!")
		Return
	EndIf

	If $g_iDonSpellsQuantityAv >= $iDonSpellsLimit Then
		$g_iDonSpellsQuantity = $iDonSpellsLimit
	Else
		$g_iDonSpellsQuantity = $g_iDonSpellsQuantityAv
	EndIf

	; Detect the Spells Slot
	If $g_iDebugOCRdonate = 1 Then
		Local $oldDebugOcr = $g_iDebugOcr
		$g_iDebugOcr = 1
	EndIf

	$Slot = DetectSlotSpell($iSpellIndex)
	$detectedSlot = $Slot
	If $g_iDebugSetlog = 1 Then setlog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_iDebugOCRdonate = 1 Then $g_iDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	; figure out row/position
	If $Slot < 12 Or $Slot > 17 Then
		setlog("Invalid slot # found = " & $Slot & " for " & $g_asSpellNames[$iSpellIndex], $COLOR_ERROR)
		Return
	EndIf
	$donaterow = 3 ;row of spells
	$Slot = $Slot - 12
	$donateposinrow = $Slot
	$YComp = 203 ; correct 860x780

	SetLog("Spells Condition Matched", $COLOR_ORANGE)
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
			_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
			_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x6038B0, 6), 20) Then ; check for 'purple'

		;If $bDonateAll Then $sTextToAll = " (to all requests)"
		;SetLog("Else Spell Colors Conditions Matched ALSO", $COLOR_ORANGE)
		;SetLog("Donating " & $g_iDonSpellsQuantity & " " & $g_asSpellNames[$iSpellIndex] & $sTextToAll, $COLOR_GREEN)
		;Setlog("click donate")
		If $g_iDebugOCRdonate = 1 Then
			Setlog("donate", $COLOR_ERROR)
			Setlog("row: " & $donaterow, $COLOR_ERROR)
			Setlog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			setlog("coordinate: " & 365 + ($Slot * 68) & "," & $g_iDonationWindowY + 100 + $YComp, $COLOR_ERROR)
			debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSpellNames[$iSpellIndex] & "_")
		EndIf
		If $g_iDebugOCRdonate = 0 Then
			Click(365 + ($Slot * 68), $g_iDonationWindowY + 100 + $YComp, $g_iDonSpellsQuantity, $DELAYDONATECC3, "#0600")
			$g_bSetlogOnlyOnce = 0
			$g_bFullArmySpells = False
			$g_bFullArmy = False
			$g_aiDonateSpells[$iSpellIndex] += 1

			If $g_iCommandStop = 3 Then
				$g_iCommandStop = 0
				$g_bFullArmySpells = False
			EndIf
			; DonatedSpell($iSpellIndex, $g_iDonSpellsQuantity)
			$g_aiDonateStatsSpells[$iSpellIndex][0] += $g_iDonSpellsQuantity
		EndIf

		; Assign the donated quantity Spells to train : $Don $g_asSpellName
		; need to implement assign $DonPoison etc later

	ElseIf $g_aiDonatePixel[1] - 5 + $YComp > 675 Then
		Setlog("Unable to donate " & $g_asSpellNames[$iSpellIndex] & ". Donate screen not visible, will retry next run.", $COLOR_ERROR)
	Else
		SetLog("No " & $g_asSpellNames[$iSpellIndex] & " available to donate..", $COLOR_ERROR)
	EndIf

EndFunc   ;==>DonateSpellType
#cs
	Func DragSpellDonWindow()
	If Not $g_bRunState Then Return
	If _ColorCheck(_GetPixelColor(350 ,$g_iDonationWindowY, True), Hex(0xFFFFFF, 6), 20) Then
	ClickDrag(715, $g_iDonationWindowY + 303, 580, $g_iDonationWindowY + 303, 50)
	If $g_iDebugSetlog = 1 Then SetLog("Dragged Spell Window successfully", $COLOR_ACTION)
	Else
	If $g_iDebugSetlog = 1 Then SetLog("Couldn't drag the Spell Window because the Donation Window is not open!", $COLOR_ERROR)
	Return
	EndIf
	If _Sleep(800) Then Return
	EndFunc
#ce
Func DonateWindow($Open = True)
	If $g_iDebugSetlog = 1 And $Open = True Then Setlog("DonateWindow Open Start", $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 And $Open = False Then Setlog("DonateWindow Close Start", $COLOR_DEBUG)

	If $Open = False Then ; close window and exit
		If _Sleep($DELAYDONATEWINDOW1 * 3 ) Then Return ; $DELAYDONATEWINDOW1 = 250
		setlog("closeing donatewindow")
		If _ColorCheck(_GetPixelColor(331, $g_aiDonatePixel[1], True, "DonateWindow"), Hex(0xffffff, 6), 0) = True Then ; Verify if open, otherwise do nothing
			setlog("DonateWindow Found Open - Closing window")
			ClickP($aAway, 1, 0, "#0176")
			If _Sleep($DELAYDONATEWINDOW1) Then Return
			If $g_iDebugSetlog = 1 Then Setlog("DonateWindow Close Exit", $COLOR_DEBUG)
			$g_hTimerPreventTimeOut = TimerInit ( )
			Return
		Else
			SetLog("DonateWindow Found Close - Doing nothing")
			Return
		EndIf

	EndIf

	; Click on Donate Button and wait for the window - old Ezeck 6 15 17
#cs
	Local $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $i
	For $i = 0 To UBound($aChatDonateBtnColors) - 1
		If $aChatDonateBtnColors[$i][1] < $iLeft Then $iLeft = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][1] > $iRight Then $iRight = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][2] < $iTop Then $iTop = $aChatDonateBtnColors[$i][2]
		If $aChatDonateBtnColors[$i][2] > $iBottom Then $iBottom = $aChatDonateBtnColors[$i][2]
	Next
	$iLeft += $g_aiDonatePixel[0]
	$iTop += $g_aiDonatePixel[1]
	$iRight += $g_aiDonatePixel[0] + 1
	$iBottom += $g_aiDonatePixel[1] + 1
	ForceCaptureRegion()
	Local $g_aiDonatePixelCheck = _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
	If IsArray($g_aiDonatePixelCheck) Then
		Click($g_aiDonatePixel[0] + 50, $g_aiDonatePixel[1] + 10, 1, 0, "#0174")
		$g_hTimerPreventTimeOut = TimerInit()
	Else
		If $g_iDebugSetlog = 1 Then SetLog("Could not find the Donate Button!", $COLOR_DEBUG)
		Return False
	EndIf
#ce
	; Click on Donate Button and wait for the window - New Ezeck 6 15 17
	;Removed Double ck on button location.. since button is clicked right after being found...Button should not have a chance to scroll

	Click($g_aiDonatePixel[0] + 50, $g_aiDonatePixel[1] + 10, 1, 0, "#0174")
	$g_hTimerPreventTimeOut = TimerInit()
;	Local $SpeedTest = TimerDiff($g_hTimerSpeedTest)
;	Setlog("Time from Button find to Click - " & $SpeedTest & " milliseconds")

	If _Sleep($DELAYDONATEWINDOW1 * 3 ) Then Return ; longer delay to ensure white donate troop window fully open

	;_CaptureRegion(0, 0, 320 + $g_iMidOffsetY, $g_aiDonatePixel[1] + 30 + $YComp)
	Local $icount = 0
	While Not (_ColorCheck(_GetPixelColor(331, $g_aiDonatePixel[1], True, "DonateWindow"), Hex(0xffffff, 6), 0))
		If _Sleep($DELAYDONATEWINDOW1) Then Return
		;_CaptureRegion(0, 0, 320 + $g_iMidOffsetY, $g_aiDonatePixel[1] + 30 + $YComp)
		$icount += 1
		If $icount = 20 Then ExitLoop
	WEnd

	; Determinate the right position of the new Donation Window
	; Will search in $Y column = 410 for the first pure white color and determinate that position the $DonationWindowTemp
	;Local $aDonWinOffColors[3][3] = [[0xFFFFFF, 0, 1], [0xFFFFFF, 0, 31], [0xABABA8, 0, 32]]
	;Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

	$g_iDonationWindowY = 0
	Local $aDonWinOffColors[1][3] = [[0xFFFFFF, 0, 2]];, [0xEBEBE9, 0, 208]] ; may 2017 update
	Local $aDonationWindow = _MultiPixelSearch(628, 0, 630, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10) ; moved to new column to look for top white pixel of window

	If IsArray($aDonationWindow) Then
		$g_iDonationWindowY = $aDonationWindow[1]
		If _Sleep($DELAYDONATEWINDOW1) Then Return
		If $g_iDebugSetlog = 1 Then Setlog("$g_iDonationWindowY: " & $g_iDonationWindowY, $COLOR_DEBUG)
	Else
		SetLog("Could not find the Donate Window!", $COLOR_ERROR)
		Return False
	EndIf

	If $g_iDebugSetlog = 1 Then Setlog("DonateWindow Open Exit", $COLOR_DEBUG)
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $g_bSkipDonTroops, ByRef $g_bSkipDonSpells)
	If $g_iDebugSetlog = 1 Then Setlog("DonateCapWindow Start", $COLOR_DEBUG)
	;read troops capacity
	If $g_bSkipDonTroops = False Then
		Local $sReadCCTroopsCap = getCastleDonateCap(427, $g_iDonationWindowY + 12) ; use OCR to get donated/total capacity
		If $g_iDebugSetlog = 1 Then Setlog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG)

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
		If $aTempReadCCTroopsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_iDebugSetlog = 1 Then Setlog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_DEBUG)
			If $aTempReadCCTroopsCap[2] > 0 Then
				$g_iDonTroopsAv = $aTempReadCCTroopsCap[1]
				$g_iDonTroopsLimit = $aTempReadCCTroopsCap[2]
				Setlog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit) ; may 2017 added for more info in log on donate troop count
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_ERROR) ; log if there is read error
			$g_iDonTroopsAv = 0
			$g_iDonTroopsLimit = 0
		EndIf
	EndIf

	If $g_bSkipDonSpells = False Then
		Local $sReadCCSpellsCap = getCastleDonateCap(420, $g_iDonationWindowY + 218) ; use OCR to get donated/total capacity
		If $g_iDebugSetlog = 1 Then Setlog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_DEBUG)
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#")
		If $aTempReadCCSpellsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_iDebugSetlog = 1 Then Setlog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[1] & "/" & $aTempReadCCSpellsCap[2], $COLOR_DEBUG)
			If $aTempReadCCSpellsCap[2] > 0 Then
				$g_iDonSpellsAv = $aTempReadCCSpellsCap[1]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[2]
				;Setlog("Donate Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Spells Capacity...", $COLOR_ERROR) ; log if there is read error
			$g_iDonSpellsAv = 0
			$iDonSpellsLimit = 0
		EndIf
	EndIf

	If $g_iDonTroopsAv = $g_iDonTroopsLimit Then
		$g_bSkipDonTroops = True
		SetLog("Donate Troop Limit Reached")
	EndIf
	If $g_iDonSpellsAv = $iDonSpellsLimit Then
		$g_bSkipDonSpells = True
		SetLog("Donate Spell Limit Reached")
	EndIf

	If $g_bSkipDonTroops = True And $g_bSkipDonSpells = True And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit Then
		Setlog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit & ", Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)
	EndIf
	If $g_bSkipDonSpells = False And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv = $iDonSpellsLimit Then Setlog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
	If $g_bSkipDonTroops = False And $g_iDonTroopsAv = $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit Then Setlog("Donate Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)

	If $g_iDebugSetlog = 1 Then Setlog("$g_bSkipDonTroops: " & $g_bSkipDonTroops, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then Setlog("$g_bSkipDonSpells: " & $g_bSkipDonSpells, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then Setlog("DonateCapWindow End", $COLOR_DEBUG)
EndFunc   ;==>DonateWindowCap

Func RemainingCCcapacity()
	; Remaining CC capacity of requested troops from your ClanMates
	; Will return the $g_iTotalDonateCapacity with that capacity for use in donation logic.

	Local $aCapTroops = "", $aTempCapTroops = "", $aCapSpells = "", $aTempCapSpells
	Local $iDonatedTroops = 0, $iDonatedSpells = 0
	Local $iCapTroopsTotal = 0, $iCapSpellsTotal = 0

	$g_iTotalDonateCapacity = -1
	$g_iTotalDonateSpellCapacity = -1

	; Verify with OCR the Donation Clan Castle capacity
	If $g_iDebugSetlog = 1 Then Setlog("Started dual getOcrSpaceCastleDonate", $COLOR_DEBUG)
	$aCapTroops = getOcrSpaceCastleDonate(49, $g_aiDonatePixel[1]) ; when the request is troops+spell
	$aCapSpells = getOcrSpaceCastleDonate(154, $g_aiDonatePixel[1]) ; when the request is troops+spell

	If $g_iDebugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then Setlog("$aCapSpells :" & $aCapSpells, $COLOR_DEBUG)

	If Not (StringInStr($aCapTroops, "#") Or StringInStr($aCapSpells, "#")) Then ; verify if the string is valid or it is just a number from request without spell
		If $g_iDebugSetlog = 1 Then Setlog("Started single getOcrSpaceCastleDonate", $COLOR_DEBUG)
		$aCapTroops = getOcrSpaceCastleDonate(78, $g_aiDonatePixel[1]) ; when the Request don't have Spell

		If $g_iDebugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_DEBUG)
		$aCapSpells = -1
	EndIf

	If $aCapTroops <> "" Then
		; Splitting the XX/XX
		$aTempCapTroops = StringSplit($aCapTroops, "#")

		; Local Variables to use
		If $aTempCapTroops[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_iDebugSetlog = 1 Then Setlog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_DEBUG)
			If $aTempCapTroops[2] >= 0 Then ; may 2017 added '=' to for ocr correction when 30 is read as just zero
				$iDonatedTroops = $aTempCapTroops[1]
				$iCapTroopsTotal = $aTempCapTroops[2]
				If $iCapTroopsTotal = 0 Then
					$iCapTroopsTotal = 30
				EndIf
				If $iCapTroopsTotal = 5 Then
					$iCapTroopsTotal = 35
				EndIf
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_ERROR) ; log if there is read error
			$iDonatedTroops = 0
			$iCapTroopsTotal = 0
		EndIf
	Else
		Setlog("Error reading the Castle Troop Capacity...", $COLOR_ERROR) ; log if there is read error
		$iDonatedTroops = 0
		$iCapTroopsTotal = 0
	EndIf

	If $aCapSpells <> -1 Then
		If $aCapSpells <> "" Then
			; Splitting the XX/XX
			$aTempCapSpells = StringSplit($aCapSpells, "#")

			; Local Variables to use
			If $aTempCapSpells[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $g_iDebugSetlog = 1 Then Setlog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_DEBUG)
				If $aTempCapSpells[2] > 0 Then
					$iDonatedSpells = $aTempCapSpells[1]
					$iCapSpellsTotal = $aTempCapSpells[2]
				EndIf
			Else
				Setlog("Error reading the Castle Spell Capacity...", $COLOR_ERROR) ; log if there is read error
				$iDonatedSpells = 0
				$iCapSpellsTotal = 0
			EndIf
		Else
			Setlog("Error reading the Castle Spell Capacity...", $COLOR_ERROR) ; log if there is read error
			$iDonatedSpells = 0
			$iCapSpellsTotal = 0
		EndIf
	EndIf


	; $g_iTotalDonateCapacity it will be use to determinate the quantity of kind troop to donate
	$g_iTotalDonateCapacity = ($iCapTroopsTotal - $iDonatedTroops)
	If $aCapSpells <> -1 Then $g_iTotalDonateSpellCapacity = ($iCapSpellsTotal - $iDonatedSpells)

	If $g_iTotalDonateCapacity < 0 Then
		SetLog("Unable to read Castle Capacity!", $COLOR_ERROR)
	Else
		If $aCapSpells <> -1 Then
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal & ", Spells: " & $iDonatedSpells & "/" & $iCapSpellsTotal)
		Else
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal)
		EndIf
	EndIf

	;;Return $g_iTotalDonateCapacity

EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop(Const $iTroopIndex)
	Local $FullTemp

	For $Slot = 0 To 5
		Local $x = 343 + (68 * $Slot)
		Local $y = $g_iDonationWindowY + 37
		Local $x1 = $x + 75
		Local $y1 = $y + 43

		$FullTemp = SearchImgloc(@ScriptDir & "\imgxml\DonateCC\Troops\", $x, $y, $x1, $y1)
		If $g_iDebugSetlog = 1 Then Setlog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)
;===============================================================
;=========Fix for when first troop in donate window is grayed but color troops appear after
;=========Pre fix first gray troop would return empty and never donate available troops
;==============================================================

		 If StringInStr($FullTemp[0] & " ", "empty") <= 0 Then  ; Updated may 2017 from exitloop
			If $FullTemp[0] <> "" Then
				For $i = $eTroopBarbarian To $eTroopBowler
					Local $sTmp = StringStripWS(StringLeft($g_asTroopNames[$i], 4), $STR_STRIPTRAILING)
					;If $g_iDebugSetlog = 1 Then Setlog($g_asTroopNames[$i] & " = " & $sTmp, $COLOR_DEBUG)
					If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
						If $g_iDebugSetlog = 1 Then Setlog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
						If $iTroopIndex = $i Then Return $Slot
						ExitLoop
					EndIf
					If $i = $eTroopBowler Then ; detection failed
						If $g_iDebugSetlog = 1 Then Setlog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
					EndIf
				Next
			EndIf
		EndIf
     Next
;============End Fix==========

	For $Slot = 6 To 11
		Local $x = 343 + (68 * ($Slot - 6))
		Local $y = $g_iDonationWindowY + 124
		Local $x1 = $x + 75
		Local $y1 = $y + 43

		$FullTemp = SearchImgloc(@ScriptDir & "\imgxml\DonateCC\Troops\", $x, $y, $x1, $y1)
		If $g_iDebugSetlog = 1 Then Setlog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

;===================================same fix but for second row ============================
;=========Fix for when first troop in donate window is grayed but color troops appear after
;=========Pre fix first gray troop would return empty and never donate available troops
;==============================================================

		 If StringInStr($FullTemp[0] & " ", "empty") <= 0 Then  ; Updated may 2017 from exitloop
			If $FullTemp[0] <> "" Then
				For $i = $eTroopBalloon To $eTroopBowler
					Local $sTmp = StringStripWS(StringLeft($g_asTroopNames[$i], 4), $STR_STRIPTRAILING)
					;If $g_iDebugSetlog = 1 Then Setlog($g_asTroopNames[$i] & " = " & $sTmp, $COLOR_DEBUG)
					If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
						If $g_iDebugSetlog = 1 Then Setlog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
						If $iTroopIndex = $i Then Return $Slot
						ExitLoop
					EndIf
					If $i = $eTroopBowler Then ; detection failed
						If $g_iDebugSetlog = 1 Then Setlog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
					EndIf
				Next
			EndIf
		EndIf
	Next

;============End Fix==========


	Return -1

EndFunc   ;==>DetectSlotTroop

Func DetectSlotSpell(Const $iSpellIndex)
	Local $FullTemp

	For $Slot = 12 To 17
		Local $x = 343 + (68 * ($Slot - 12))
		Local $y = $g_iDonationWindowY + 241
		Local $x1 = $x + 75
		Local $y1 = $y + 43

		$FullTemp = SearchImgloc(@ScriptDir & "\imgxml\DonateCC\Spells\", $x, $y, $x1, $y1)
		If $g_iDebugSetlog = 1 Then Setlog("Spell Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eSpellLightning To $eSpellSkeleton
				Local $sTmp = StringLeft($g_asSpellNames[$i], 4)
				;If $g_iDebugSetlog = 1 Then Setlog($g_asSpellNames[$i] & " = " & $sTmp, $COLOR_DEBUG)
				If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					If $g_iDebugSetlog = 1 Then Setlog("Detected " & $g_asSpellNames[$i], $COLOR_DEBUG)
					If $iSpellIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eSpellSkeleton Then ; detection failed
					If $g_iDebugSetlog = 1 Then Setlog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	Return -1

EndFunc   ;==>DetectSlotSpell

Func SkipDonateNearFullTroops($bSetLog = False, $aHeroResult = Default)

	If $g_iCommandStop = 0 And $g_iCommandStop = 3 Then Return False ; IF is halt Attack and Train/Donate ....Enable the donation ; works better with command stop 3 ; Must be first. if train donate mode.. Should over ride all other settings.
		; had issues of train donate only mode stop donating after the camps fill
	If Not $g_bDonationEnabled Then Return True ; will disable the donation

	If Not $g_bDonateSkipNearFullEnable Then Return False ; will enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then Return True ; will disable the donation

	If $g_bDonateSkipNearFullEnable Then
		If $g_iArmyCapacity > $g_iDonateSkipNearFullPercent Then
			Local $rIsWaitforHeroesActive = IsWaitforHeroesActive()
			If $rIsWaitforHeroesActive Then
				If $aHeroResult = Default Or Not IsArray($aHeroResult) Then
					If Not OpenArmyWindow() Then Return False ; Return False if failed to Open Army Window
					$aHeroResult = getArmyHeroTime("all")
				EndIf
				If @error Or UBound($aHeroResult) < 3 Then
					Setlog("getArmyHeroTime return error: #" & @error & "|IA:" & IsArray($aHeroResult) & "," & UBound($aHeroResult) & ", exit SkipDonateNearFullTroops!", $COLOR_ERROR)
					Return False ; if error, then quit SkipDonateNearFullTroops enable the donation
				EndIf
				If $g_iDebugSetlog = 1 Then SetLog("getArmyHeroTime returned: " & $aHeroResult[0] & ":" & $aHeroResult[1] & ":" & $aHeroResult[2], $COLOR_DEBUG)
				Local $iActiveHero = 0
				Local $iHighestTime = -1
				For $pTroopType = $eKing To $eWarden ; check all 3 hero
					For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
						$iActiveHero = -1
						If IsSearchModeActiveMini($pMatchMode) And IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) And $g_iHeroUpgrading[$pTroopType - $eKing] <> 1 And $g_iHeroWaitAttackNoBit[$pMatchMode][$pTroopType - $eKing] = 1 Then
							$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
						EndIf
						;SetLog("$iActiveHero = " & $iActiveHero, $COLOR_DEBUG)
						If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
							If $aHeroResult[$iActiveHero] > $iHighestTime Then ; Is the time higher than indexed time?
								$iHighestTime = $aHeroResult[$iActiveHero]
							EndIf
						EndIf
					Next
					If _Sleep($DELAYRESPOND) Then Return
				Next
				If $g_iDebugSetlog = 1 Then SetLog("$iHighestTime = " & $iHighestTime & "|" & String($iHighestTime > 5), $COLOR_DEBUG)
				If $iHighestTime > 5 Then
					If $bSetLog Then Setlog("Donations enabled, Heroes recover time is long", $COLOR_INFO)
					Return False
				Else
					If $bSetLog Then Setlog("Donation disabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
					Return True ; troops camps% > limit
				EndIf
			Else
				If $bSetLog Then Setlog("Donation disabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
				Return True ; troops camps% > limit
			EndIf
		Else
			If $bSetLog Then Setlog("Donations enabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
			Return False ; troops camps% into limits
		EndIf
	Else
		Return False ; feature disabled
	EndIf
EndFunc   ;==>SkipDonateNearFullTroops

Func BalanceDonRec($bSetlog = False)

	If Not $g_bDonationEnabled Then Return False ; Will disable donation
	If Not $g_bUseCCBalanced Then Return True ; will enable the donation
	If $g_iCommandStop = 0 And $g_bTrainEnabled Then Return True ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then Return False ; will disable the donation


	If $g_bUseCCBalanced Then
		If $g_iTroopsDonated = 0 And $g_iTroopsReceived = 0 Then ProfileReport()
		If Number($g_iTroopsReceived) <> 0 Then
			If Number(Number($g_iTroopsDonated) / Number($g_iTroopsReceived)) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
				;Stop Donating
				If $bSetlog Then SetLog("Skipping Donation because Donate/Recieve Ratio is not " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
				Return False
			Else
				; Continue
				Return True
			EndIf
		EndIf
	Else
		Return True
	EndIf
EndFunc   ;==>BalanceDonRec

Func SearchImgloc($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0)

	; Setup arrays, including default return values for $return
	Local $aResult[1], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i] = RetrieveImglocProperty($aKeys[$i], "objectname")
		Next
		Return $aResult
	EndIf
	$aResult[0] = "queued"
	Return $aResult
EndFunc   ;==>SearchImgloc
