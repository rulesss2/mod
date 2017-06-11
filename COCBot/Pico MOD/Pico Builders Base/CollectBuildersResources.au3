; #FUNCTION# ====================================================================================================================
; Name ..........: CollectBuildersResources()
; Description ...: Collect Resources of Builders Base
; Syntax ........: CollectBuildersResources()
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

Func CollectBuildersResources()

	If $g_ichkCollectBldGE = 0 and $g_ichkCollectBldGems = 0 then Return

	If $g_ichkCollectBldGE = 1 Then
		SetLog("Collecting Gold and Elixir...", $COLOR_INFO)
		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\Resources\Gold", 53, 65, 750, 640) Then
			Click($g_iQuickMISX + 53, $g_iQuickMISY + 65)
			If _Sleep(100) Then Return
		EndIf
		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\Resources\Elixir", 53, 65, 750, 640) Then
			Click($g_iQuickMISX + 53, $g_iQuickMISY + 65)
			If _Sleep(100) Then Return
		EndIf
	EndIf

	If $g_ichkCollectBldGems = 1 Then
		SetLog("Collecting Gems...", $COLOR_INFO)
		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\Resources\Gems", 53, 65, 750, 640) Then
			Click($g_iQuickMISX + 53, $g_iQuickMISY + 65)
			If _Sleep(100) Then Return
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0121")
	If _Sleep(250) Then Return
	SetLog("Collect finished !", $COLOR_SUCCESS)

EndFunc   ;==>CollectBuildersResources

Func chkCollectBldGE()
	If GUICtrlRead($g_chkCollectBldGE) = $GUI_CHECKED Then
		$g_ichkCollectBldGE = 1
	Else
		$g_ichkCollectBldGE = 0
	EndIf
EndFunc   ;==>chkCollectBldGE

Func chkCollectBldGems()
	If GUICtrlRead($g_chkCollectBldGems) = $GUI_CHECKED Then
		$g_ichkCollectBldGems = 1
	Else
		$g_ichkCollectBldGems = 0
	EndIf
EndFunc   ;==>chkCollectBldGems
