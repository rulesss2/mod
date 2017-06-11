; #FUNCTION# ====================================================================================================================
; Name ..........: Alternative SendText
; Description ...: A function to send unicode characters through ADB while typing text
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti (06-2017)
; Modified ......: ---
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func sendUnicodeText($sTextToSend) ; call the DLL and send text directly
	Local $result = DllCall(@ScriptDir & "\lib\Pico_SendUnicodeText.dll", "str", "SendUnicodeText", "str", $g_sAndroidAdbDevice, "wstr", $sTextToSend)
	SetLog($result[0], $COLOR_INFO)
	Return $result[0]
EndFunc   ;==>sendUnicodeText

Func prepareAndroidForUnicodeText()
	Local $bNeedToReboot = False, $bNeedToModifyEmulator = False

	SetLog("Preparing Emulator to be used with Unicode Send Text...", $COLOR_INFO)
	If _Sleep(100) Then return

	; install the keyboard
	Local $KeyboardInit = DllCall(@ScriptDir & "\lib\Pico_SendUnicodeText.dll", "str", "InitializeKeyboard", "str", $g_sAndroidAdbDevice)
	SetLog($KeyboardInit[0], $COLOR_INFO)
	; if keyboard has been installed or ADB updated, necessary to reboot emulator
	If StringInStr($KeyboardInit[0], "Reboot needed") Then $bNeedToReboot = True

	; need to disable the physical keyboard, if was enabled, reoot the emulator
	If Not checkVirtualKeyboardState() Then
		$bNeedToReboot = True
		$bNeedToModifyEmulator = True
	EndIf

	; reboot phase
	If $bNeedToReboot = True Then
		CloseAndroid("sendUnicodeText")
		; modify the Android physical keyboard settings when emulator is Off
		If $bNeedToModifyEmulator = True Then
			Local $vkeyboard_mode = Run(Chr(34) & $__VBoxManage_Path & Chr(34) & " guestproperty set " & $g_sAndroidInstance & " vkeyboard_mode 2", "", @SW_HIDE)
			ProcessWaitClose($vkeyboard_mode)
		EndIf
		; restart Android
		StartAndroidCoC()
	EndIf

	If StringInStr($KeyboardInit[0], "Failed") Or StringInStr($KeyboardInit[0], "Copycat") Then
		; if any error, prevent BOT to use Unicode Keyboard
		$bCanUseUnicodeKeyboard = False
		SetLog("Unicode Send Text setup failed... BOT will use ASCII Send Text...", $COLOR_SUCCESS)
	Else
		; anything is OK
		$bCanUseUnicodeKeyboard = True
		SetLog("MEmu is ready to be used with Unicode Send Text !", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>prepareAndroidForUnicodeText

Func checkVirtualKeyboardState()
	; call VBoxManage to check the virtual keyboard state
	Local $vkeyboard_mode = Run(Chr(34) & $__VBoxManage_Path & Chr(34) & " guestproperty get " & $g_sAndroidInstance & " vkeyboard_mode", "", @SW_HIDE, $STDOUT_CHILD)
	ProcessWaitClose($vkeyboard_mode)
	Local $stdOut = StdoutRead($vkeyboard_mode)

	; if not enabled, return false
	If StringInStr($stdOut, "2") = 0 Then
		SetLog("Emulator Virtual Keyboard enabled ! Reboot needed !", $COLOR_INFO)
		Return False
	Else
		SetLog("Emulator Virtual Keyboard already enabled !", $COLOR_INFO)
		Return True
	EndIf
EndFunc   ;==>checkVirtualKeyboardState
