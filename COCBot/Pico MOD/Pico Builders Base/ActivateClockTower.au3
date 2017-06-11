; #FUNCTION# ====================================================================================================================
; Name ..........: ActivateClockTower()
; Description ...: Activate Clock Tower to accelerate village when it's available
; Syntax ........: ActivateClockTower()
; Parameters ....:
; Return values .: None
; Author ........: RoroTiti (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ActivateClockTower()

	SetLog("Activating Clock Tower...", $COLOR_INFO)
	If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\ClockTower", 53, 65, 750, 640) Then
		Click($g_iQuickMISX + 53, $g_iQuickMISY + 65)
		If _Sleep(1500) Then Return

		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\BoostButton", 300, 600, 600, 700) Then
			Click($g_iQuickMISX + 300, $g_iQuickMISY + 600)
			If _Sleep(1000) Then Return

			If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\PicoBuildersBase\ConfirmBoost", 350, 400, 500, 480) Then
				Click($g_iQuickMISX + 350, $g_iQuickMISY + 400)

				ClickP($aAway, 1, 0, "#0121")
				If _Sleep(250) Then Return
				SetLog("Village Boosted successfully !", $COLOR_SUCCESS)
			Else
				SetLog("Error when trying to find Confirm Boost button... skipping...", $COLOR_ERROR)
			EndIf
		Else
			SetLog("Error when trying to find Boost button... skipping...", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Humm, I didn't found Clock Tower, maybe you didn't unlocked it yet... skipping...", $COLOR_WARNING)
	EndIf

	ClickP($aAway, 1, 0, "#0121")
	If _Sleep(250) Then Return

EndFunc   ;==>ActivateClockTower

Func chkActivateClockTower()
	If GUICtrlRead($g_chkActivateClockTower) = $GUI_CHECKED Then
		$g_ichkActivateClockTower = 1
	Else
		$g_ichkActivateClockTower = 0
	EndIf
EndFunc   ;==>chkActivateClockTower
