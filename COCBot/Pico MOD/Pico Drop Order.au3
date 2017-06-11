; #FUNCTION# ====================================================================================================================
; Name ..........: Drop Order
; Description ...: This file Read/Save/Apply Pico MODs settings
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ProMac
; Modified ......: 06/2017
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

	; HERE WE WILL MAKE THE ICONS ETC ETC
	; *************************************










	; *************************************

	; Display the GUI.
	GUISetState(@SW_SHOW, $hGUI_Order)
EndFunc   ;==>CustonDropOrderDB


; ================================================== CLOSE PART ================================================== ;

Func CloseCustonDropOrder()
	; Delete the previous GUI and all controls.
	GUIDelete($hGUI_Order)

	GUICtrlSetState($g_BtnCustonDropOrderDB, $GUI_ENABLE)
	GUICtrlSetState($g_BtnCustonDropOrderAB, $GUI_ENABLE)
EndFunc
