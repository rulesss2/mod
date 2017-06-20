; ==========================================================
; Chatbot script fixed by rulesss, kychera
; Made for MyBot <http://mybot.run>
; I cannot be held responsible for what this chatbot says
; See bottom of file for more info
; ==========================================================

#include <Process.au3>
#include <Array.au3>
#include <WinAPIEx.au3>

;Func ChatbotReadSettings()
;	If IniRead($chatIni, "global", "use", "False") = "True" Then $ChatbotChatGlobal = True
;	If IniRead($chatIni, "global", "scramble", "False") = "True" Then $ChatbotScrambleGlobal = True
;	If IniRead($chatIni, "global", "swlang", "False") = "True" Then $ChatbotSwitchLang = True    
;   $icmbLang = IniRead($chatIni, "Lang", "cmbLang", "8")
;   If IniRead($chatIni, "clan", "use", "False") = "True" Then $ChatbotChatClan = True
;	If IniRead($chatIni, "clan", "responses", "False") = "True" Then $ChatbotClanUseResponses = True
;	If IniRead($chatIni, "clan", "always", "False") = "True" Then $ChatbotClanAlwaysMsg = True
;	If IniRead($chatIni, "clan", "pushbullet", "False") = "True" Then $ChatbotUsePushbullet = True
;	If IniRead($chatIni, "clan", "pbsendnew", "False") = "True" Then $ChatbotPbSendNew = True

	$ClanMessages = StringSplit(IniRead($chatIni, "clan", "genericMsg", "Testing on Chat|Hey all"), "|", 2)
	Global $ClanResponses0 = StringSplit(IniRead($chatIni, "clan", "responseMsg", "keyword:Response|hello:Hi, Welcome to the clan|hey:Hey, how's it going?"), "|", 2)
	Global $ClanResponses1[UBound($ClanResponses0)][2] ;
	For $a = 0 To UBound($ClanResponses0) - 1
		$TmpResp = StringSplit($ClanResponses0[$a], ":", 2)
		If UBound($TmpResp) > 0 Then
			$ClanResponses1[$a][0] = $TmpResp[0]
		Else
			$ClanResponses1[$a][0] = "<invalid>"
		EndIf
		If UBound($TmpResp) > 1 Then
			$ClanResponses1[$a][1] = $TmpResp[1]
		Else
			$ClanResponses1[$a][1] = "<undefined>"
		EndIf
	Next

	$ClanResponses = $ClanResponses1

	$GlobalMessages1 = StringSplit(IniRead($chatIni, "global", "globalMsg1", "War Clan Recruiting|Active War Clan accepting applications"), "|", 2)
	$GlobalMessages2 = StringSplit(IniRead($chatIni, "global", "globalMsg2", "Join now|Apply now"), "|", 2)
	$GlobalMessages3 = StringSplit(IniRead($chatIni, "global", "globalMsg3", "250 war stars min|Must have 250 war stars"), "|", 2)
	$GlobalMessages4 = StringSplit(IniRead($chatIni, "global", "globalMsg4", "Adults Only| 18+"), "|", 2)
;EndFunc   ;==>ChatbotReadSettings

;Func ChatGuiCheckboxUpdate()
;	$ChatbotChatGlobal = GUICtrlRead($chkGlobalChat) = $GUI_CHECKED
;	$ChatbotScrambleGlobal = GUICtrlRead($chkGlobalScramble) = $GUI_CHECKED
;	$ChatbotSwitchLang = GUICtrlRead($chkSwitchLang) = $GUI_CHECKED

;	$ChatbotChatClan = GUICtrlRead($chkClanChat) = $GUI_CHECKED
;	$ChatbotClanUseResponses = GUICtrlRead($chkUseResponses) = $GUI_CHECKED
;	$ChatbotClanAlwaysMsg = GUICtrlRead($chkUseGeneric) = $GUI_CHECKED
;	$ChatbotUsePushbullet = GUICtrlRead($chkChatPushbullet) = $GUI_CHECKED
;	$ChatbotPbSendNew = GUICtrlRead($chkPbSendNewChats) = $GUI_CHECKED    
;	$icmbLang = _GUICtrlComboBox_GetCurSel($cmbLang)
;	IniWrite($chatIni, "Lang", "cmbLang", $icmbLang)
;	IniWrite($chatIni, "global", "use", $ChatbotChatGlobal)
;	IniWrite($chatIni, "global", "scramble", $ChatbotScrambleGlobal)
;	IniWrite($chatIni, "global", "swlang", $ChatbotSwitchLang)

;	IniWrite($chatIni, "clan", "use", $ChatbotChatClan)
;	IniWrite($chatIni, "clan", "responses", $ChatbotClanUseResponses)
;	IniWrite($chatIni, "clan", "always", $ChatbotClanAlwaysMsg)
;	IniWrite($chatIni, "clan", "pushbullet", $ChatbotUsePushbullet)
;	IniWrite($chatIni, "clan", "pbsendnew", $ChatbotPbSendNew)   
;	ChatGuiCheckboxUpdateAT()

;EndFunc   ;==>ChatGuiCheckboxUpdate

Func ChatGuiCheckbox()
	If GUICtrlRead($chkGlobalChat) = $GUI_CHECKED Then
		GUICtrlSetState($chkGlobalScramble, $GUI_ENABLE)
		GUICtrlSetState($chkGlobChatTimeDalay, $GUI_ENABLE)
		GUICtrlSetState($chkSwitchLang, $GUI_ENABLE)
		GUICtrlSetState($cmbLang, $GUI_SHOW)
		GUICtrlSetState($editGlobalMessages1, $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages2, $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages3, $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages4, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkGlobalScramble, $GUI_DISABLE)
		GUICtrlSetState($chkGlobChatTimeDalay, $GUI_DISABLE)
		GUICtrlSetState($chkSwitchLang, $GUI_DISABLE)
	    GUICtrlSetState($cmbLang, $GUI_INDETERMINATE)
		GUICtrlSetState($editGlobalMessages1, $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages2, $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages3, $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages4, $GUI_DISABLE)
	EndIf
	If GUICtrlRead($chkClanChat) = $GUI_CHECKED Then
		GUICtrlSetState($chkUseResponses, $GUI_ENABLE)
		GUICtrlSetState($chkUseGeneric, $GUI_ENABLE)
		GUICtrlSetState($chkChatPushbullet, $GUI_ENABLE)
		GUICtrlSetState($chkPbSendNewChats, $GUI_ENABLE)
		GUICtrlSetState($editResponses, $GUI_ENABLE)
		GUICtrlSetState($editGeneric, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkUseResponses, $GUI_DISABLE)
		GUICtrlSetState($chkUseGeneric, $GUI_DISABLE)
		GUICtrlSetState($chkChatPushbullet, $GUI_DISABLE)
		GUICtrlSetState($chkPbSendNewChats, $GUI_DISABLE)
		GUICtrlSetState($editResponses, $GUI_DISABLE)
		GUICtrlSetState($editGeneric, $GUI_DISABLE)
	EndIf
;=====================kychera============
	If  GUICtrlRead($chkGlobalChat) = $GUI_CHECKED And GUICtrlRead($chkSwitchLang) = $GUI_CHECKED Then
	    GUICtrlSetState($cmbLang, $GUI_ENABLE)
	Else
     	GUICtrlSetState($cmbLang, $GUI_DISABLE)
	EndIf	
	_GUICtrlComboBox_SetCurSel($cmbLang, $icmbLang)
	$icmbLang = _GUICtrlComboBox_GetCurSel($cmbLang)
;========================================
EndFunc   ;==>ChatGuiCheckbox

Func ChatGuiCheckboxDisableAT()
	For $i = $chkGlobalChat To $editGeneric ; Save state of all controls on tabs
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
EndFunc   ;==>ChatGuiCheckboxDisableAT
Func ChatGuiCheckboxEnableAT()
	For $i = $chkGlobalChat To $editGeneric ; Save state of all controls on tabs
		GUICtrlSetState($i, $GUI_ENABLE)
	Next
	ChatGuiCheckboxUpdateAT()
EndFunc   ;==>ChatGuiCheckboxEnableAT


Func ChatGuiEditUpdate()
Global $glb1 = GUICtrlRead($editGlobalMessages1)
Global $glb2 = GUICtrlRead($editGlobalMessages2)
Global $glb3 = GUICtrlRead($editGlobalMessages3)
Global $glb4 = GUICtrlRead($editGlobalMessages4)

Global $cResp = GUICtrlRead($editResponses)
Global $cGeneric = GUICtrlRead($editGeneric)

	; how 2 be lazy 101 =======
	$glb1 = StringReplace($glb1, @CRLF, "|")
	$glb2 = StringReplace($glb2, @CRLF, "|")
	$glb3 = StringReplace($glb3, @CRLF, "|")
	$glb4 = StringReplace($glb4, @CRLF, "|")

	$cResp = StringReplace($cResp, @CRLF, "|")
	$cGeneric = StringReplace($cGeneric, @CRLF, "|")

	IniWrite($chatIni, "global", "globalMsg1", $glb1)
	IniWrite($chatIni, "global", "globalMsg2", $glb2)
	IniWrite($chatIni, "global", "globalMsg3", $glb3)
	IniWrite($chatIni, "global", "globalMsg4", $glb4)

	IniWrite($chatIni, "clan", "genericMsg", $cGeneric)
	IniWrite($chatIni, "clan", "responseMsg", $cResp)

	; =========================
EndFunc   ;==>ChatGuiEditUpdate

; FUNCTIONS ================================================
; All of the following return True if the script should
; continue running, and false otherwise
Func ChatbotChatOpen() ; open the chat area
	Click(20, 379, 1) ; open chat
	If _Sleep(1000) Then Return
	Return True
EndFunc   ;==>ChatbotChatOpen

Func ChatbotSelectClanChat() ; select clan tab
	Click(222, 27, 1) ; switch to clan
	If _Sleep(1000) Then Return
	Click(295, 700, 1) ; scroll to top
	If _Sleep(1000) Then Return
	Return True
EndFunc   ;==>ChatbotSelectClanChat

Func ChatbotSelectGlobalChat() ; select global tab
	Click(74, 23, 1) ; switch to global
	If _Sleep(1000) Then Return
	Return True
EndFunc   ;==>ChatbotSelectGlobalChat

Func ChatbotChatClose() ; close chat area
	Click(330, 384, 1) ; close chat
	waitMainScreen()
	Return True
EndFunc   ;==>ChatbotChatClose

Func ChatbotChatClanInput() ; select the textbox for clan chat
	Click(276, 707, 1) ; select the textbox
	If _Sleep(1000) Then Return
	Return True
EndFunc   ;==>ChatbotChatClanInput

Func ChatbotChatGlobalInput() ; select the textbox for global chat
	Click(277, 706, 1) ; select the textbox
	If _Sleep(1000) Then Return
	Return True
EndFunc   ;==>ChatbotChatGlobalInput

;============================================
;+++++++++++++Kychera Modified +++++++++++++++
Func ChatbotChatInput($message)
    If _Sleep(1000) Then Return
	Click(33, 707, 1)	
    SendText($message)	
	Return True
EndFunc   ;==>ChatbotChatInput
;+++++++++++++++++++++++++++++++++++++++++++++
;Support for the Russian language.
;=============================================

Func ChatbotChatSendClan() ; click send
	If _Sleep(1000) Then Return
	Click(827, 709, 1) ; send
	If _Sleep(2000) Then Return
	Return True
EndFunc   ;==>ChatbotChatSendClan

Func ChatbotChatSendGlobal() ; click send
	If _Sleep(1000) Then Return
	Click(827, 709, 1) ; send
	If _Sleep(2000) Then Return
	Return True
EndFunc   ;==>ChatbotChatSendGlobal

Func ChatbotStartTimer()
	$ChatbotStartTime = TimerInit()
EndFunc   ;==>ChatbotStartTimer

Func ChatbotIsInterval()
    Local $Time_Difference = TimerDiff($ChatbotStartTime)
	If $Time_Difference > $ChatbotReadInterval * 1000 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ChatbotIsInterval

Func ChatbotIsLastChatNew() ; returns true if the last chat was not by you, false otherwise
	_CaptureRegion()
	For $x = 38 To 261
		If _ColorCheck(_GetPixelColor($x, 129), Hex(0x78BC10, 6), 5) Then Return True ; detect the green menu button
	Next
	Return False
EndFunc   ;==>ChatbotIsLastChatNew

Func ChatbotPushbulletSendChat()
   If Not $ChatbotUsePushbullet Then Return
   
   Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
   Local $Time = @HOUR & "." & @MIN & "." & @SEC
   _CaptureRegion(0, 0, 320, 675)
   Local $ChatFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
   _GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileLootsPath & $ChatFile)
   _GDIPlus_ImageDispose($g_hBitmap)
   ;push the file
   SetLog("Chatbot: Sent chat image", $COLOR_GREEN)
   ;========Modified Kychera===========   
   NotifyPushFileToBoth($ChatFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | Last Clan Chats" & "\n" & $ChatFile)
   ;===================
   ;wait a second and then delete the file
   If _Sleep($DELAYPUSHMSG2) Then Return
   Local $iDelete = FileDelete($g_sProfileLootsPath & $ChatFile)
   If Not ($iDelete) Then SetLog("Chatbot: Failed to delete temp file", $COLOR_RED)
EndFunc

Func ChatbotPushbulletQueueChat($Chat)
   If Not $ChatbotUsePushbullet Then Return
   _ArrayAdd($ChatbotQueuedChats, $Chat)
EndFunc

Func ChatbotPushbulletQueueChatRead()
   If Not $ChatbotUsePushbullet Then Return
   $ChatbotReadQueued = True
EndFunc

Func ChatbotPushbulletStopChatRead()
   If Not $ChatbotUsePushbullet Then Return
   $ChatbotReadInterval = 0
   $ChatbotIsOnInterval = False
EndFunc

Func ChatbotPushbulletIntervalChatRead($Interval)
   If Not $ChatbotUsePushbullet Then Return
   $ChatbotReadInterval = $Interval
   $ChatbotIsOnInterval = True
   ChatbotStartTimer()
EndFunc

Func ChangeLanguageToEN()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	ClickDrag(775, 180, 775, 440)
	If _Sleep(1000) Then Return
	Click(165, 180, 1) ;English
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 42, "Chatbot: Switching language EN"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToEN

Func ChangeLanguageToFRA()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 230, 1) ;Franch
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 53, "Chatbot: Switching language FRA"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToFra
;===========Modified Kychera================
Func ChangeLanguageToRU()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(173, 607, 1) ;Russian
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 61, "Chatbot: Switching language RU"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToRU

Func ChangeLanguageToDE()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 273, 1) ;DEUTCH
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 54, "Chatbot: Switching language DE"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToDE

Func ChangeLanguageToES()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 325, 1) ;Ispanol
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 55, "Chatbot: Switching language ES"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToES

Func ChangeLanguageToITA()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 375, 1) ;ITALYA
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 56, "Chatbot: Switching language ITA"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToITA

Func ChangeLanguageToNL()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 425, 1) ;NL
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 57, "Chatbot: Switching language NL"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToNL

Func ChangeLanguageToNO()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 475, 1) ;NORSK
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 58, "Chatbot: Switching language NO"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToNO

Func ChangeLanguageToPR()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 525, 1) ;PORTUGAL
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 59, "Chatbot: Switching language PR"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToPR

Func ChangeLanguageToTR()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 575, 1) ;TURK
	If _Sleep(500) Then Return
	SetLog(GetTranslated(106, 60, "Chatbot: Switching language TR"), $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToTR
;========================================
; MAIN SCRIPT ==============================================

Func ChatbotMessage() ; run the chatbot

    Local $sendGlobalChat = chatTimer($startGlobChatTimer, "GLOBAL")
	
	If $ChatbotChatGlobal Then
		SetLog(GetTranslated(106, 37, "Chatbot: Sending some chats"), $COLOR_GREEN)
	ElseIf $ChatbotChatClan Then
		SetLog(GetTranslated(106, 38, "Chatbot: Sending some chats"), $COLOR_GREEN)
	EndIf
	If $ChatbotChatGlobal = 1 And $sendGlobalChat Then
	   $startGlobChatTimer = TimerInit()	
;========================Kychera modified==========================================
		If $ChatbotSwitchLang = 1 Then
		Switch GUICtrlRead($cmbLang)
		        Case "FR"
			ChangeLanguageToFRA()
		        Case "DE"
		    ChangeLanguageToDE()
		        Case "ES"
		    ChangeLanguageToES()
		        Case "IT"
		    ChangeLanguageToITA()
		        Case "NL"
		    ChangeLanguageToNL()
		        Case "NO"
		    ChangeLanguageToNO()
		        Case "PR"
		    ChangeLanguageToPR()
		        Case "TR"
		    ChangeLanguageToTR()
		        Case "RU"
		    ChangeLanguageToRU()
              EndSwitch
			Sleep(3000)  
			waitMainScreen()
			Sleep(3000)
		EndIf
;======================================================================================
		If Not ChatbotChatOpen() Then Return
		SetLog(GetTranslated(106, 41, "Chatbot: Sending chats to global"), $COLOR_GREEN)
		; assemble a message
		Global $message[4]
		$message[0] = $GlobalMessages1[Random(0, UBound($GlobalMessages1) - 1, 1)]
		$message[1] = $GlobalMessages2[Random(0, UBound($GlobalMessages2) - 1, 1)]
		$message[2] = $GlobalMessages3[Random(0, UBound($GlobalMessages3) - 1, 1)]
		$message[3] = $GlobalMessages4[Random(0, UBound($GlobalMessages4) - 1, 1)]
		If $ChatbotScrambleGlobal Then
			_ArrayShuffle($message)
		EndIf
		; Send the message
		If Not ChatbotSelectGlobalChat() Then Return
		If Not ChatbotChatGlobalInput() Then Return
		If Not ChatbotChatInput(_ArrayToString($message, " ")) Then Return
		If Not ChatbotChatSendGlobal() Then Return
		If Not ChatbotChatClose() Then Return
;==================kychera modified===============================================
		If $ChatbotSwitchLang = 1 Then
			ChangeLanguageToEN()
			   Sleep(3000)
			waitMainScreen()
			   Sleep(3000)
		EndIf
;=================================================================================
	EndIf

	If $ChatbotChatClan Then
		If Not ChatbotChatOpen() Then Return
		SetLog(GetTranslated(106, 43, "Chatbot: Sending chats to clan"), $COLOR_GREEN)
		If Not ChatbotSelectClanChat() Then Return

		Local $SentClanChat = False
          Sleep(2000)
		If $ChatbotReadQueued Then
			ChatbotPushbulletSendChat()
			$ChatbotReadQueued = False
			$SentClanChat = True
		ElseIf $ChatbotIsOnInterval Then
			If ChatbotIsInterval() Then
				ChatbotStartTimer()
				ChatbotPushbulletSendChat()
				$SentClanChat = True
			EndIf
		EndIf

		If UBound($ChatbotQueuedChats) > 0 Then
			SetLog(GetTranslated(106, 44, "Chatbot: Sending pushbullet chats"), $COLOR_GREEN)

			For $a = 0 To UBound($ChatbotQueuedChats) - 1
			Local $ChatToSend = $ChatbotQueuedChats[$a]
				If Not ChatbotChatClanInput() Then Return
				;===Modified Kychera=====
				If Not ChatbotChatInput(_Encoding_JavaUnicodeDecode($ChatToSend)) Then Return
				;========================
				If Not ChatbotChatSendClan() Then Return
			Next

			Dim $Tmp[0] ; clear queue
			$ChatbotQueuedChats = $Tmp
             _sleep(2000)
			ChatbotPushbulletSendChat()

			If Not ChatbotChatClose() Then Return
			SetLog(GetTranslated(106, 45, "Chatbot: Done"), $COLOR_GREEN)
			Return
		EndIf

		If ChatbotIsLastChatNew() Then
			; get text of the latest message
			Local $ChatMsg = StringStripWS(getOcrAndCapture("coc-latinA", 30, 148, 270, 13, False), 7)
			SetLog(GetTranslated(106, 46, "Found chat message: ") & $ChatMsg, $COLOR_GREEN)
			Local $SentMessage = False

			If $ChatMsg = "" Or $ChatMsg = " " Then
				If $ChatbotClanAlwaysMsg Then
					If Not ChatbotChatClanInput() Then Return
					If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
					If Not ChatbotChatSendClan() Then Return
					$SentMessage = True
				EndIf
			EndIf

			If $ChatbotClanUseResponses And Not $SentMessage Then
				For $a = 0 To UBound($ClanResponses) - 1
					If StringInStr($ChatMsg, $ClanResponses[$a][0]) Then
						Local $Response = $ClanResponses[$a][1]
						SetLog(GetTranslated(106, 47, "Sending response: ") & $Response, $COLOR_GREEN)
						If Not ChatbotChatClanInput() Then Return
						If Not ChatbotChatInput($Response) Then Return
						If Not ChatbotChatSendClan() Then Return
						$SentMessage = True
						ExitLoop
					EndIf
				Next
			EndIf

			If Not $SentMessage Then
				If $ChatbotClanAlwaysMsg Then
					If Not ChatbotChatClanInput() Then Return
					If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
					If Not ChatbotChatSendClan() Then Return
				EndIf
			EndIf

			; send it via pushbullet if it's new
			; putting the code here makes sure the (cleverbot, specifically) response is sent as well :P
			If $ChatbotUsePushbullet And $ChatbotPbSendNew Then
				If Not $SentClanChat Then ChatbotPushbulletSendChat()
			EndIf
		ElseIf $ChatbotClanAlwaysMsg Then
			If Not ChatbotChatClanInput() Then Return
			If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
			If Not ChatbotChatSendClan() Then Return
		EndIf

		If Not ChatbotChatClose() Then Return
	EndIf
	If $ChatbotChatGlobal Then
		SetLog(GetTranslated(106, 49, "Chatbot: Done chatting"), $COLOR_GREEN)
	ElseIf $ChatbotChatClan Then
		SetLog(GetTranslated(106, 50, "Chatbot: Done chatting"), $COLOR_GREEN)
	EndIf
EndFunc   ;==>ChatbotMessage

#cs ----------------------------------------------------------------------------
	Author:         ChrisDuh
    ; Chatbot script fixed by rulesss, Kychera
	Script Function: Sends chat messages in global and clan chat; 11.2016 switching lang global chat - Kychera
#ce ----------------------------------------------------------------------------
;===========Addied kychera=================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Encoding_JavaUnicodeDecode
; Description ...: Decode string from Java Unicode format.
; Syntax ........: _Encoding_JavaUnicodeDecode($sString)
; Parameters ....: $sString             - String to decode.
; Return values .: Decoded string.
; Author ........: amel27
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Encoding_JavaUnicodeDecode($sString)
	Local $iOld_Opt_EVS = Opt('ExpandVarStrings', 0)
	Local $iOld_Opt_EES = Opt('ExpandEnvStrings', 0)

	Local $sOut = "", $aString = StringRegExp($sString, "(\\\\|\\'|\\u[[:xdigit:]]{4}|[[:ascii:]])", 3)

	For $i = 0 To UBound($aString) - 1
		Switch StringLen($aString[$i])
			Case 1
				$sOut &= $aString[$i]
			Case 2
				$sOut &= StringRight($aString[$i], 1)
			Case 6
				$sOut &= ChrW(Dec(StringRight($aString[$i], 4)))
		EndSwitch
	Next

	Opt('ExpandVarStrings', $iOld_Opt_EVS)
	Opt('ExpandEnvStrings', $iOld_Opt_EES)

	Return $sOut
EndFunc ;==>_Encoding_JavaUnicodeDecode
;============================================

;Timer for global chat(Time Delay)
Func chatTimer($startTimer, $chatType)
    Local $timeDiff = TimerDiff($startTimer) / 1000
    If $chatType = "GLOBAL" Then
 	   If $timeDiff > $globChatTimeDalay Then
 		  Return True
 	   Else
 		  SetLog("Skip sending chats to global chat", $COLOR_RED)
 		  SetLog("Time Delay : [" & $globChatTimeDalay - $timeDiff & "]")
 		  Return False
 	   EndIf
    EndIf
EndFunc
