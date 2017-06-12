; #FUNCTION# ====================================================================================================================
; Name ..........: Chat GUI Design
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: rulesss, Kychera
; Modified ......: Team AiO & RK MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $chatIni = ""
Global $cmblang = 0,  $icmblang = 0
Global $chkGlobalChat = 0,$chkGlobalScramble = 0,$chkSwitchLang = 0,$chkchatdelay = 0,$ichkchatdelay = 0,$ChatbotChatDelayLabel = "",$chatdelaycount = 0,$chkClanChat = 0
Global $chkUseResponses = 0,$chkUseGeneric = 0,$chkChatPushbullet = 0,$chkPbSendNewChats = 0
Global $editGlobalMessages1 = "", $editGlobalMessages2 = "",$editGlobalMessages3 = "",$editGlobalMessages4 = ""
Global $editResponses = 0,$editGeneric = 0,$ChatbotQueuedChats[0],$ChatbotReadQueued = False,$ChatbotReadInterval = 0,$ChatbotIsOnInterval = False,$TmpResp

Func ChatbotGUI()
$36 = GUICtrlCreatePic($g_sImagePath & $g_sImageBg, 2, 23, 442, 410, $WS_CLIPCHILDREN)
   ChatbotReadSettings()

	Local $x = 25, $y = 47

   GUICtrlCreateGroup("Global Chat", $x - 20, $y - 20, 215, 360)
    $y -= 5
   $chkGlobalChat = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkGlobalChat, "Use global chat to send messages")
   GUICtrlSetState($chkGlobalChat, $ChatbotChatGlobal)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
	GUICtrlCreateLabel("Advertise in global", $x + 7, $y, -1, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
   $y += 18
   $chkGlobalScramble = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkGlobalScramble, "Scramble the message pieces defined in the textboxes below to be in a random order")
   GUICtrlSetState($chkGlobalScramble, $ChatbotScrambleGlobal)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
	GUICtrlCreateLabel("Scramble global chats", $x + 7, $y, -1, -1)
   $y += 18
   $chkSwitchLang = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkSwitchLang, "Switch languages after spamming for a new global chatroom")
   GUICtrlSetState($chkSwitchLang, $ChatbotSwitchLang)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
	GUICtrlCreateLabel("Switch languages"), $x + 7, $y, -1, -1)
	;======kychera===========
   $cmbLang = GUICtrlCreateCombo("", $x + 120, $y - 3, 45, 45, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, "FR|DE|ES|IT|NL|NO|PR|TR|RU", "RU")
   ;==========================
   $y += 20
   $editGlobalMessages1 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages1, @CRLF), $x - 15, $y, 202, 65)
   GUICtrlSetTip($editGlobalMessages1, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   $editGlobalMessages2 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages2, @CRLF), $x - 15, $y, 202, 65)
   GUICtrlSetTip($editGlobalMessages2, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   $editGlobalMessages3 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages3, @CRLF), $x - 15, $y, 202, 65)
   GUICtrlSetTip($editGlobalMessages3, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   $editGlobalMessages4 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages4, @CRLF), $x - 15, $y, 202, 55)
   GUICtrlSetTip($editGlobalMessages4, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 65
   GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 245, $y = 47

   GUICtrlCreateGroup("Clan Chat"), $x - 20, $y - 20, 218, 360)
   $y -= 5
   $chkClanChat = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
	_GUICtrlSetTip($chkClanChat, "Use clan chat to send messages")
   GUICtrlSetState($chkClanChat, $ChatbotChatClan)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
	GUICtrlCreateLabel("Chat in clan chat" & ":", $x + 7, $y, -1, -1)
   $y += 22
   $chkUseResponses = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13);GUICtrlCreateCheckbox(GetTranslated(106,18,"Use custom responses"), $x - 10, $y)
   GUICtrlSetTip($chkUseResponses, "Use the keywords and responses defined below")
   GUICtrlSetState($chkUseResponses, $ChatbotClanUseResponses)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   GUICtrlCreateLabel("Use custom responses", $x + 7, $y, -1, -1)
   $y += 22
   $chkUseGeneric = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkUseGeneric, "Use generic chats if reading the latest chat failed or there are no new chats")
   GUICtrlSetState($chkUseGeneric, $ChatbotClanAlwaysMsg)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   GUICtrlCreateLabel("Use generic chats", $x + 7, $y, -1, -1)
   $y += 22
   $chkChatPushbullet = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkChatPushbullet, "Send and recieve chats via pushbullet or telegram." & @CRLF &  "Use BOT <myvillage> GETCHATS <interval|NOW|STOP> to get the latest clan" & @CRLF &  "chat as an image, and BOT <myvillage> SENDCHAT <chat message> to send a chat to your clan" & @CRLF &)
   GUICtrlSetState($chkChatPushbullet, $ChatbotUsePushbullet)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   GUICtrlCreateLabel("Use remote for chatting", $x + 7, $y, -1, -1)
   $y += 22
   $chkPbSendNewChats = GUICtrlCreateCheckbox("", $x - 10, $y, 13, 13)
   GUICtrlSetTip($chkPbSendNewChats, "Will send an image of your clan chat via pushbullet & telegram when a new chat is detected. Not guaranteed to be 100% accurate.")
   GUICtrlSetState($chkPbSendNewChats, $ChatbotPbSendNew)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   GUICtrlCreateLabel("Notify me new clan chat", $x + 7, $y, -1, -1)
   $y += 25

   $editResponses = GUICtrlCreateEdit(_ArrayToString($ClanResponses, ":", -1, -1, @CRLF), $x - 15, $y, 206, 80)
   GUICtrlSetTip($editResponses, "Look for the specified keywords in clan messages and respond with the responses. One item per line, in the format keyword:response")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 92
   $editGeneric = GUICtrlCreateEdit(_ArrayToString($ClanMessages, @CRLF), $x - 15, $y, 206, 80)
   GUICtrlSetTip($editGeneric, "Generic messages to send, one per line")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")

   ChatGuicheckboxUpdateAT()
EndFunc