; #FUNCTION# ====================================================================================================================
; Name ..........: Drop Order
; Description ...: This file Read/Save/Apply Pico MODs settings
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: Kychera
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ---
; ===============================================================================================================================

; ================================================== WINDOW PART ================================================== ;

Global $hGUI_Order

Func CustonDropOrder()
	; prevent user to open a second window impossible to close...
	GUICtrlSetState($g_BtnCustonDropOrderDB, $GUI_DISABLE)
	GUICtrlSetState($g_BtnCustonDropOrderAB, $GUI_DISABLE)

	$hGUI_Order = GUICreate("Attack Custom Drop Order", 452, 437, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)

	; Create a button control.
	Local $idClose = GUICtrlCreateButton("Close", 350, 370, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCustonDropOrder")

	Local $x = 25, $y = 25
	GUICtrlCreateGroup(GetTranslated(641, 58, "Custom dropping order"), $x - 20, $y - 20, 320, 380)
	$x += 10
	$y += 20

	$g_hChkCustomTrainDropOrderEnable = GUICtrlCreateCheckbox(GetTranslated(641, 59, "Enable troops order drop"), $x - 10, $y - 20, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslated(641, 60, "Enable to select a custom troop dropping order") & @CRLF & _
			GetTranslated(641, 61, "Changing drop order can NOT be used with CSV scripted attack! For a standard attack. Live and dead bases. Consistency - all troops"))
	GUICtrlSetOnEvent(-1, "chkTroopDropOrder")

	; Create translated list of Troops for combo box
	Local $sComboData = ""
	For $j = 0 To UBound($g_asTroopDropList) - 1
		$sComboData &= $g_asTroopDropList[$j] & "|"
	Next
	$y += 5
	For $p = 0 To $eTroopCountDrop - 1
		If $p < 10 Then
			GUICtrlCreateLabel($p + 1 & ":", $x - 19, $y + 2, -1, 18)
			$cmbDropTroops[$p] = GUICtrlCreateCombo("", $x, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIDropOrder")
			GUICtrlSetData(-1, $sComboData, "")

			;_GUICtrlSetTip(-1, $txtTroopOrder & $p + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgTroopDropOrder[$p] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 96, $y + 1, 18, 18)
			$y += 25 ; move down to next combobox location
		Else
			If $p = 10 Then
				$x += 128
				$y = 49
			EndIf
			GUICtrlCreateLabel($p + 1 & ":", $x - 5, $y + 2, -1, 18)
			$cmbDropTroops[$p] = GUICtrlCreateCombo("", $x + 20, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIDropOrder")
			GUICtrlSetData(-1, $sComboData, "")

			;_GUICtrlSetTip(-1, $txtTroopOrder & $p + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgTroopDropOrder[$p] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 120, $y + 1, 18, 18)
			$y += 25 ; move down to next combobox location
		EndIf
	Next

	$x = 25
	$y = 350
	; Create push button to set training order once completed
	$g_hBtnTroopOrderSet2 = GUICtrlCreateButton(GetTranslated(641, 62, "Apply New Order"), $x, $y, 100, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_ENABLE))
	_GUICtrlSetTip(-1, GetTranslated(641, 63, "Push button when finished selecting custom troops dropping order") & @CRLF & _
			GetTranslated(641, 65, "When not all troop slots are filled, will use random troop order in empty slots!"))
	GUICtrlSetOnEvent(-1, "btnTroopDropSet")
	;$g_ahImgTroopOrderSet = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 226, $y + 2, 18, 18)
	$x += 150
	$g_hBtnRemoveTroops2 = GUICtrlCreateButton(GetTranslated(641, 66, "Empty drop list"), $x, $y, 110, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslated(641, 67, "Push button to remove all troops from list and start over"))
	GUICtrlSetOnEvent(-1, "BtnRemoveDropTroops")
	; *************************************
	; Display the GUI.
	GUISetState(@SW_SHOW, $hGUI_Order)
	readConfig()
	applyConfig()

EndFunc   ;==>CustonDropOrder


; ================================================== CLOSE PART ================================================== ;

Func CloseCustonDropOrder()
	; Delete the previous GUI and all controls.

	;applyConfig()
	saveConfig()
	;GUIDelete($hGUI_Order)
	GUISetState(@SW_HIDE, $hGUI_Order)
	GUICtrlSetState($g_BtnCustonDropOrderDB, $GUI_ENABLE)
	GUICtrlSetState($g_BtnCustonDropOrderAB, $GUI_ENABLE)
EndFunc   ;==>CloseCustonDropOrder

; ================= Control =======================
Func chkTroopDropOrder()
	If GUICtrlRead($g_hChkCustomTrainDropOrderEnable) = $GUI_CHECKED Then
		$g_bCustomTrainDropOrderEnable = True
		GUICtrlSetBkColor($g_BtnCustonDropOrderDB, $COLOR_GREEN)
		GUICtrlSetBkColor($g_BtnCustonDropOrderAB, $COLOR_GREEN)
		GUICtrlSetState($g_hBtnTroopOrderSet2, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnRemoveTroops2, $GUI_ENABLE)
		For $i = 0 To UBound($cmbDropTroops) - 1
			GUICtrlSetState($cmbDropTroops[$i], $GUI_ENABLE)
		Next
		If IsUseCustomDropOrder() = True Then GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
	Else
		$g_bCustomTrainDropOrderEnable = False
		GUICtrlSetBkColor($g_BtnCustonDropOrderDB, $COLOR_RED)
		GUICtrlSetBkColor($g_BtnCustonDropOrderAB, $COLOR_RED)
		GUICtrlSetState($g_hBtnTroopOrderSet2, $GUI_DISABLE) ; disable button
		GUICtrlSetState($g_hBtnRemoveTroops2, $GUI_DISABLE)
		For $i = 0 To UBound($cmbDropTroops) - 1
			GUICtrlSetState($cmbDropTroops[$i], $GUI_DISABLE) ; disable combo boxes
		Next
	EndIf
EndFunc   ;==>chkTroopDropOrder


Func GUIDropOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $g_ahImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	GUICtrlSetImage($iCtrlIdImage, $g_sLibIconPath, $g_aiTroopOrderDropIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($cmbDropTroops) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $cmbDropTroops[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($cmbDropTroops[$i]) Then
			GUICtrlSetImage($g_ahImgTroopDropOrder[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($cmbDropTroops[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate Then
		GUICtrlSetState($g_hBtnTroopOrderSet2, $GUI_ENABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($g_hBtnTroopOrderSet2, $GUI_ENABLE) ; enable button to apply new order
		GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUIDropOrder

Func BtnRemoveDropTroops()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnRemoveDropTroops")
	Local $sComboData = ""
	For $j = 0 To UBound($g_asTroopDropList) - 1
		$sComboData &= $g_asTroopDropList[$j] & "|"
	Next
	For $i = $eTroopBarbarian To $eTroopCountDrop - 1
		$icmbDropTroops[$i] = -1
		_GUICtrlComboBox_ResetContent($icmbDropTroops[$i])
		GUICtrlSetData($cmbDropTroops[$i], $sComboData, "")
		GUICtrlSetImage($g_ahImgTroopDropOrder[$i], $g_sLibIconPath, $eIcnOptions)
	Next
	GUICtrlSetImage($g_ahImgTroopDropOrderSet, $g_sLibIconPath, $eIcnSilverStar)
	SetDefaultTroopGroup(False)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnRemoveDropTroops")
EndFunc   ;==>BtnRemoveDropTroops

Func btnTroopDropSet()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "btnTroopDropSet")
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewDropList = ""

	Local $bMissingTroop = False ; flag for when troops are not assigned by user
	Local $aiUsedTroop[$eTroopCountDrop] = [ _
			$eTroopBarbarianS, $eTroopArcherS, $eTroopGiantS, $eTroopGoblinS, $eTroopWallBreakerS, $eTroopBalloonS, $eTroopWizardS, _
			$eTroopHealerS, $eTroopDragonS, $eTroopPekkaS, $eTroopBabyDragonS, $eTroopMinerS, $eTroopMinionS, $eTroopHogRiderS, _
			$eTroopValkyrieS, $eTroopGolemS, $eTroopWitchS, $eTroopLavaHoundS, $eTroopBowlerS, $eHeroeS, $eCCS]

	; check for duplicate combobox index and take action
	For $i = 0 To UBound($cmbDropTroops) - 1
		For $j = 0 To UBound($cmbDropTroops) - 1
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($cmbDropTroops[$i]) <> -1 And _
					_GUICtrlComboBox_GetCurSel($cmbDropTroops[$i]) = _GUICtrlComboBox_GetCurSel($cmbDropTroops[$j]) Then
				_GUICtrlComboBox_SetCurSel($cmbDropTroops[$j], -1)
				GUICtrlSetImage($g_ahImgTroopDropOrder[$j], $g_sLibIconPath, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($cmbDropTroops[$j], $COLOR_BLACK)
			EndIf
		Next
		; update combo array variable with new value
		$icmbDropTroops[$i] = _GUICtrlComboBox_GetCurSel($cmbDropTroops[$i])
		If $icmbDropTroops[$i] = -1 Then $bMissingTroop = True ; check if combo box slot that is not assigned a troop
	Next

	; Automatic random fill missing troops
	If $bReady And $bMissingTroop Then
		; 1st update $aiUsedTroop array with troops not used in $g_aiCmbCustomTrainOrder
		For $i = 0 To UBound($icmbDropTroops) - 1
			For $j = 0 To UBound($aiUsedTroop) - 1
				If $icmbDropTroops[$i] = $j Then
					$aiUsedTroop[$j] = -1 ; if troop is used, replace enum value with -1
					ExitLoop
				EndIf
			Next
		Next
		_ArrayShuffle($aiUsedTroop) ; make missing training order assignment random
		For $i = 0 To UBound($icmbDropTroops) - 1
			If $icmbDropTroops[$i] = -1 Then ; check if custom order index is not set
				For $j = 0 To UBound($aiUsedTroop) - 1
					If $aiUsedTroop[$j] <> -1 Then ; loop till find a valid troop enum
						$icmbDropTroops[$i] = $aiUsedTroop[$j] ; assign unused troop
						_GUICtrlComboBox_SetCurSel($cmbDropTroops[$i], $aiUsedTroop[$j])
						GUICtrlSetImage($g_ahImgTroopDropOrder[$i], $g_sLibIconPath, $g_aiTroopOrderDropIcon[$icmbDropTroops[$i] + 1])
						$aiUsedTroop[$j] = -1 ; remove unused troop from array
						ExitLoop
					EndIf
				Next
			EndIf
		Next
	EndIf

	If $bReady Then
		ChangeTroopDropOrder() ; code function to record new training order

		If @error Then
			Switch @error
				Case 1
					Setlog("Code problem, can not continue till fixed!", $COLOR_ERROR)
				Case 2
					Setlog("Bad Combobox selections, please fix!", $COLOR_ERROR)
				Case 3
					Setlog("Unable to Change Troop Drop Order due bad change count!", $COLOR_ERROR)
				Case Else
					Setlog("Monkey ate bad banana, something wrong with ChangeTroopTrainOrder() code!", $COLOR_ERROR)
			EndSwitch
			GUICtrlSetImage($g_ahImgTroopDropOrderSet, $g_sLibIconPath, $eIcnRedLight)
		Else
			Setlog("Troop droping order changed successfully!", $COLOR_SUCCESS)
			For $i = 0 To $eTroopCountDrop - 1
				$sNewDropList &= $g_asTroopNamesPluralDrop[$icmbDropTroops[$i]] & ", "
			Next
			$sNewDropList = StringTrimRight($sNewDropList, 2)
			Setlog("Troop drop order= " & $sNewDropList, $COLOR_INFO)

		EndIf
	Else
		Setlog("Must use all troops and No duplicate troop names!", $COLOR_ERROR)
		GUICtrlSetImage($g_ahImgTroopDropOrderSet, $g_sLibIconPath, $eIcnRedLight)
	EndIf
	GUICtrlSetState($g_hBtnTroopOrderSet2, $GUI_DISABLE)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "btnTroopDropSet")
EndFunc   ;==>btnTroopDropSet

Func IsUseCustomDropOrder()
	For $i = 0 To UBound($icmbDropTroops) - 1 ; Check if custom train order has been used, to select log message
		If $icmbDropTroops[$i] = -1 Then
			;If $g_iDebugSetlogTrain = 1 Then Setlog("Custom drop order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	;If $g_iDebugSetlogTrain = 1 Then Setlog("Custom drop order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomDropOrder

Func ChangeTroopDropOrder()

	If $g_iDebugSetlog = 1 Then Setlog("Begin Func ChangeTroopDropOrder()", $COLOR_DEBUG) ;Debug

	Local $NewTroopDrop[$eTroopCountDrop]
	Local $iUpdateCount = 0

	If Not IsUseCustomDropOrder() Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	; Look for match of combobox text to troopgroup and create new train order
	For $i = 0 To UBound($cmbDropTroops) - 1
		Local $sComboText = GUICtrlRead($cmbDropTroops[$i])
		For $j = 0 To UBound($g_asTroopDropList) - 1
			If $sComboText = $g_asTroopDropList[$j] Then
				$NewTroopDrop[$i] = $j - 1
				$iUpdateCount += 1
				ExitLoop
			EndIf
		Next
	Next

	If $iUpdateCount = $eTroopCountDrop Then ; safety check that all troops properly assigned to new array.
		For $i = 0 To $eTroopCountDrop - 1
			$icmbDropTroops[$i] = $NewTroopDrop[$i]
		Next
		GUICtrlSetImage($g_ahImgTroopDropOrderSet, $g_sLibIconPath, $eIcnGreenLight)
	Else
		Setlog($iUpdateCount & "|" & $eTroopCountDrop & " - Error - Bad troop assignment in ChangeTroopDropOrder()", $COLOR_ERROR)
		;SetError(3, 0, False)
		Return
	EndIf

	Return True
EndFunc   ;==>ChangeTroopDropOrder
