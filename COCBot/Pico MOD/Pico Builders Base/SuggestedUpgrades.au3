; #FUNCTION# ====================================================================================================================
; Name ..........: SuggestedUpgrades()
; Description ...: Goes to Builders Island and Upgrades buildings with 'suggested upgrades window'.
; Syntax ........: SuggestedUpgrades()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; coc-armycamp ---> OCR the values on Builder suggested updates
; coc-build ----> building names and levels [ needs some work on 'u' and 'e' ]  getNameBuilding(

; Zoomout
; If Suggested Upgrade window is open [IMAGE] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\IsSuggestedWindowOpened_0_92.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Gold_0_89.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Elixir_0_89.png

; Buider Icon position Blue[i] [Check color] [360, 11, 0x7cbdde, 10]
; Suggested Upgrade window position [Imgloc] [380, 59, 100, 20]
; Zone to search for Gold / Elixir icons and values [445, 100, 90, 85 ]
; Gold offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7   [17]
; Elixir offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7 [17]
; Buider Name OCR ::::: BuildingInfo(242, 580)
; Button Upgrade position [275, 670, 300, 30]  -> UpgradeButton_0_89.png
; Button OK position Check Pixel [430, 540, 0x6dbd1d, 10] and CLICK

; Draft
; 01 - Verify if we are on Builder island [Boolean]
; 01.1 - Verify available builder [ OCR - coc-Builders ] [410 , 23 , 40 ]
; 02 - Click on Builder [i] icon [Check color]
; 03 - Verify if the window opened [Boolean]
; 04 - Detect Gold and Exlir icons [Point] by a dynamic Y [ignore list]
; 05 - With the previous positiosn and a offset , proceeds with OCR : [WHITE] OK , [salmon] Not enough resources will return "" [strings] convert to [integer]
; 06 - Make maths , IF the Gold is selected on GUI , if Elixir is Selected on GUI , and the resources values and min to safe [Boolean]
; 07 - Click on he correct ICon on Suggested Upgrades window [Point]
; 08 - Verify buttons to upgrade [Point] - Detect the Builder name [OCR]
; 09 - Verify the button to upgrade window [point]  -> [Boolean] ->[check pixel][imgloc]
; 10 - Builder Base report
; 11 - DONE

; GUI
; Check Box to enable the function
; Ignore Gold , Ignore Elixir
; Ignore building names
; Setlog

Global $g_ichkBBSuggestedUpgrades = 0, $g_ichkBBSuggestedUpgradesIgnoreGold = 0, $g_ichkBBSuggestedUpgradesIgnoreElixir = 0, $g_ichkBBSuggestedUpgradesIgnoreHall = 0

#Region GUI control Event [Update values and State]
Func chkActivateBBSuggestedUpgrades()
	; CheckBox Enable Suggested Upgrades [Update values][Update GUI State]
	If GUICtrlRead($g_chkBBSuggestedUpgrades) = $GUI_CHECKED Then
		$g_ichkBBSuggestedUpgrades = 1
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
	Else
		$g_ichkBBSuggestedUpgrades = 0
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
EndFunc   ;==>chkActivateBBSuggestedUpgrades

Func chkActivateBBSuggestedUpgradesGold()
	; Ignore Upgrade Building with Gold [Update values]
	$g_ichkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_chkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
	; If Gold is Selected Than we can disable the Builder Hall [is gold]
	If $g_ichkBBSuggestedUpgradesIgnoreGold = 0 Then
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreHall, $GUI_DISABLE)
	EndIf

	; Ignore Upgrade Builder Hall [Update values]
	$g_ichkBBSuggestedUpgradesIgnoreHall = (GUICtrlRead($g_chkBBSuggestedUpgradesIgnoreHall) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesGold

Func chkActivateBBSuggestedUpgradesElixir()
	; Ignore Upgrade Building with Elixir [Update values]
	$g_ichkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_chkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
	If $g_ichkBBSuggestedUpgradesIgnoreElixir = 0 Then
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		$g_ichkBBSuggestedUpgradesIgnoreGold = 0
	EndIf
EndFunc   ;==>chkActivateBBSuggestedUpgradesElixir
#EndRegion GUI control Event [Update values and State]

#Region Main Function

; MAIN CODE
Func MainSuggestedUpgradeCode()

	; If is not selected return
	If $g_ichkBBSuggestedUpgrades = 0 Then Return
	Local $sCoinDirectory = @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\Gold"
	Local $sElixirDirectory = @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\Elixir"
	Local $bDebug = False
	Local $bScreencap = True
	Local $b_ReturnNow = False

	; Check if you are on Builder island
	If isOnBuilderIsland(True) Then
		; Will Open the Suggested Window and check if is OK
		If ClickOnBuilder() Then
			Setlog(" - Upg Window Opened successfully", $COLOR_INFO)
			Local $y = 102, $y1 = 210, $step = 25, $x = 400, $x1 = 540
			If $g_ichkBBSuggestedUpgradesIgnoreElixir = 0 Then
				; Proceeds with Elixir icon detection
				; Only 3 possible Icons appears on Window
				For $i = 0 To 2
					; Just a small amount to keep
					If  $g_iElixirBB < 250 then ExitLoop
					Local $aResult = GetIconPosition($x, $y, $x1, $y1, $sElixirDirectory, "Elixir", $bScreencap, $bDebug)
					If $aResult[2] = "Elixir" Then
						Click($aResult[0], $aResult[1], 1)
						If _Sleep(2000) Then Return
						If GetUpgradeButton($aResult[2], $bDebug) Then
							$b_ReturnNow = True
							ExitLoop
						EndIf
					EndIf
					If $aResult[2] = "New" Then Setlog("[" & $i + 1 & "]" & " New Building detected, continuing...", $COLOR_INFO)
					$y += $step
				Next
			EndIf
			; Restore the Y to search with Gold Coin
			If $y <> 102 Then $y = 102
			; If $b_ReturnNow = True then the upgrade was Done and no Builder available
			If $g_ichkBBSuggestedUpgradesIgnoreGold = 0 And $b_ReturnNow = False Then
				; Proceeds with Gold coin detection
				; Only 3 possible Icons appears on Window
				For $i = 0 To 2
					; Just a small amount to keep
					If  $g_iGoldBB < 250 then ExitLoop
					Local $aResult = GetIconPosition($x, $y, $x1, $y1, $sCoinDirectory, "Gold", $bScreencap, $bDebug)
					If $aResult[2] = "Gold" Then
						Click($aResult[0], $aResult[1], 1)
						If _Sleep(2000) Then Return
						If GetUpgradeButton($aResult[2], $bDebug) Then
							ExitLoop
						EndIf
					EndIf
					If $aResult[2] = "New" Then Setlog("[" & $i + 1 & "]" & " New Building detected, continuing...", $COLOR_INFO)
					$y += $step
				Next
			EndIf
		EndIf
	EndIf
	ClickP($aAway, 1, 0, "#0121")
EndFunc   ;==>MainSuggestedUpgradeCode

; This fucntion will Open the Suggested Window and check if is OK
Func ClickOnBuilder()

	; Master Builder Check pixel [i] icon
	Local Const $aMasterBuilder[4] = [360, 11, 0x7cbdde, 10]
	; Debug Stuff
	Local $sDebugText = ""
	Local Const $Debug = False
	Local Const $Screencap = True

	; Master Builder is not available return
	If $g_aBuilder[0] = 0 Then Setlog("No Master Builder available! [" & $g_aBuilder[0] & "/" & $g_aBuilder[1] & "]", $COLOR_INFO)

	; Master Builder available
	If $g_aBuilder[0] = 1 Then
		; Check the Color and click
		If _CheckPixel($aMasterBuilder, True) Then
			; Click on Builder
			Click($aMasterBuilder[0], $aMasterBuilder[1], 1)
			If _Sleep(2000) Then Return
			; Let's verify if the Suggested Window open
			If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\Window", 330, 85, 550, 145, $Screencap, $Debug) Then
				Return True
			Else
				$sDebugText = "Window didn't opened"
			EndIf
		Else
			$sDebugText = "BB Pixel problem"
		EndIf
	EndIf
	If $sDebugText <> "" Then Setlog("Problem on Suggested Upg Window: [" & $sDebugText & "]", $COLOR_ERROR)
	Return False
EndFunc   ;==>ClickOnBuilder

Func GetIconPosition($x, $y, $x1, $y1, $directory, $Name = "Elixir", $Screencap = True, $Debug = False)
	; [0] = x position , [1] y postion , [2] Gold or Elixir
	Local $aResult[3] = [-1, -1, ""]
	Local $sNew_Directory = @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\New"

	If QuickMIS("BC1", $directory, $x, $y, $x1, $y1, $Screencap, $Debug) Then
		; Correct positions to Check Green 'New' Building word
		Local $iYoffset =  $y + $g_iQuickMISY - 15, $iY1offset = $y + $g_iQuickMISY + 7
		Local $iX = 300, $iX1 = $g_iQuickMISX + $x
		; Store the values
		$aResult[0] = $g_iQuickMISX + $x
		$aResult[1] = $g_iQuickMISY + $y
		$aResult[2] = $Name
		; Proceeds with 'New' detection
		If QuickMIS("BC1", $sNew_Directory, $iX, $iYoffset, $iX1, $iY1offset, True, $Debug) Then
			; Store new values
			$aResult[0] = $g_iQuickMISX + $iX
			$aResult[1] = $g_iQuickMISY + $iYoffset
			$aResult[2] = "New"
		EndIf
	EndIf

	Return $aResult
EndFunc   ;==>GetIconPosition

Func GetUpgradeButton($sUpgButtom = "", $Debug = False)

	If $sUpgButtom = "" Then Return
	If $sUpgButtom = "Elixir" Then $sUpgButtom = @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\ButtonUpg\Elixir"
	If $sUpgButtom = "Gold" Then $sUpgButtom = @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\ButtonUpg\Gold"
	Local $sUpgButtom_Directory = @ScriptDir & "\imgxml\Resources\PicoBuildersBase\AutoUpgrade\Upgrade"

	If QuickMIS("BC1", $sUpgButtom_Directory, 300, 650, 600, 720, True, $Debug) Then
		Local $sBuildingName = getNameBuilding(242, 584)
		If _Sleep(500) Then Return
		Setlog("Building: " & $sBuildingName, $COLOR_INFO)
		; Verify if is Builder Hall and If is to Upgrade
		If StringInStr($sBuildingName, "Hall") > 0 And $g_ichkBBSuggestedUpgradesIgnoreHall Then
			Setlog("Uppss!! Builder Hall is not to Upgrade!!", $COLOR_ERROR)
			Return False
		EndIf
		Click($g_iQuickMISX + 300, $g_iQuickMISY + 650, 1)
		If _Sleep(1500) Then Return
		If QuickMIS("BC1", $sUpgButtom, 360, 500, 540, 550, True, $Debug) Then
			Click($g_iQuickMISX + 360, $g_iQuickMISY + 500, 1)
			Setlog($sBuildingName & " Upgrading!", $COLOR_INFO)
			ClickP($aAway, 1, 0, "#0121")
			Return True
		Else
			ClickP($aAway, 1, 0, "#0121")
			Setlog("Not Enought Resources to Upgrade!!", $COLOR_ERROR)
		EndIf

	EndIf

	Return False
EndFunc   ;==>GetUpgradeButton



#EndRegion Main Function

