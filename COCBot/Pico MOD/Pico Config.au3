; #FUNCTION# ====================================================================================================================
; Name ..........: Pico Config
; Description ...: This file Read/Save/Apply Pico MODs settings
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 08/05/2017
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ---
; ===============================================================================================================================

Func ReadConfig_PicoMod()

	; ================================================== SWITCH ACCOUNT PART ================================================== ;

	IniReadS($g_ichkSwitchAccount, $g_sSwitchAccountConfig, "Pico Switch Account", "chkEnableSwitchAccount", $g_ichkSwitchAccount, "Int")
	IniReadS($g_icmbAccountsQuantity, $g_sSwitchAccountConfig, "Pico Switch Account", "cmbAccountsQuantity", $g_icmbAccountsQuantity, "Int")
	For $i = 1 To 8
		IniReadS($g_iachkCanUse[$i], $g_sSwitchAccountConfig, "Pico Switch Account", "chkCanUse[" & $i & "]", $g_iachkCanUse[$i], "Int")
		IniReadS($g_iachkDonateAccount[$i], $g_sSwitchAccountConfig, "Pico Switch Account", "chkDonateAccount[" & $i & "]", $g_iachkDonateAccount[$i], "Int")
		IniReadS($g_iacmbAccount[$i], $g_sSwitchAccountConfig, "Pico Switch Account", "cmbAccount[" & $i & "]", $g_iacmbAccount[$i], "Int")
		If $g_iacmbAccount[$i] = -1 Then $g_iacmbAccount[$i] = 0
	Next
	IniReadS($g_icmbMaxStayDelay, $g_sSwitchAccountConfig, "Pico Switch Account", "cmbMaxStayDelay", $g_icmbMaxStayDelay, "Int")
	IniReadS($g_icmbMinDelayToSwitch, $g_sSwitchAccountConfig, "Pico Switch Account", "cmbMinDelayToSwitch", $g_icmbMinDelayToSwitch, "Int")

	; ================================================== TREASURY COLLECT PART ================================================== ;

	IniReadS($g_ichkEnableTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkEnableTrCollect", $g_ichkEnableTrCollect, "Int")
	IniReadS($g_ichkForceTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkForceTrCollect", $g_ichkForceTrCollect, "Int")
	IniReadS($g_ichkGoldTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkGoldTrCollect", $g_ichkGoldTrCollect, "Int")
	IniReadS($g_ichkElxTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkElxTrCollect", $g_ichkElxTrCollect, "Int")
	IniReadS($g_ichkDarkTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkDarkTrCollect", $g_ichkDarkTrCollect, "Int")
	IniReadS($g_itxtMinGoldTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "txtMinGoldTrCollect", $g_itxtMinGoldTrCollect, "Int")
	IniReadS($g_itxtMinElxTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "txtMinElxTrCollect", $g_itxtMinDarkTrCollect, "Int")
	IniReadS($g_itxtMinDarkTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "txtMinDarkTrCollect", $g_itxtMinDarkTrCollect, "Int")
	IniReadS($g_ichkFullGoldTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkFullGoldTrCollect", $g_ichkFullGoldTrCollect, "Int")
	IniReadS($g_ichkFullElxTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkFullElxTrCollect", $g_ichkFullElxTrCollect, "Int")
	IniReadS($g_ichkFullDarkTrCollect, $g_sProfileConfigPath, "Pico Treasury Collect", "chkFullDarkTrCollect", $g_ichkFullDarkTrCollect, "Int")

	; ================================================== BOT HUMANIZATION PART ================================================== ;

	IniReadS($g_ichkUseBotHumanization, $g_sProfileConfigPath, "Pico Bot Humanization", "chkUseBotHumanization", $g_ichkUseBotHumanization, "Int")
	IniReadS($g_ichkUseAltRClick, $g_sProfileConfigPath, "Pico Bot Humanization", "chkUseAltRClick", $g_ichkUseAltRClick, "Int")
	IniReadS($g_ichkCollectAchievements, $g_sProfileConfigPath, "Pico Bot Humanization", "chkCollectAchievements", $g_ichkCollectAchievements, "Int")
	IniReadS($g_ichkLookAtRedNotifications, $g_sProfileConfigPath, "Pico Bot Humanization", "chkLookAtRedNotifications", $g_ichkLookAtRedNotifications, "Int")
	For $i = 0 To 12
		IniReadS($g_iacmbPriority[$i], $g_sProfileConfigPath, "Pico Bot Humanization", "cmbPriority[" & $i & "]", $g_iacmbPriority[$i], "Int")
	Next
	For $i = 0 To 1
		IniReadS($g_iacmbMaxSpeed[$i], $g_sProfileConfigPath, "Pico Bot Humanization", "cmbMaxSpeed[" & $i & "]", $g_iacmbMaxSpeed[$i], "Int")
	Next
	For $i = 0 To 1
		IniReadS($g_iacmbPause[$i], $g_sProfileConfigPath, "Pico Bot Humanization", "cmbPause[" & $i & "]", $g_iacmbPause[$i], "Int")
	Next
	For $i = 0 To 1
		IniReadS($g_iahumanMessage[$i], $g_sProfileConfigPath, "Pico Bot Humanization", "humanMessage[" & $i & "]", $g_iahumanMessage[$i])
	Next
	IniReadS($g_icmbMaxActionsNumber, $g_sProfileConfigPath, "Pico Bot Humanization", "cmbMaxActionsNumber", $g_icmbMaxActionsNumber, "Int")
	IniReadS($g_ichallengeMessage, $g_sProfileConfigPath, "Pico Bot Humanization", "challengeMessage", $g_ichallengeMessage)

	; ================================================== AUTO UPGRADE PART ================================================== ;

	IniReadS($g_ichkAutoUpgrade, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkAutoUpgrade", $g_ichkAutoUpgrade, "Int")
	IniReadS($g_ichkIgnoreTH, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreTH", $g_ichkIgnoreTH, "Int")
	IniReadS($g_ichkIgnoreKing, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreKing", $g_ichkIgnoreKing, "Int")
	IniReadS($g_ichkIgnoreQueen, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreQueen", $g_ichkIgnoreQueen, "Int")
	IniReadS($g_ichkIgnoreWarden, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreWarden", $g_ichkIgnoreWarden, "Int")
	IniReadS($g_ichkIgnoreCC, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreCC", $g_ichkIgnoreCC, "Int")
	IniReadS($g_ichkIgnoreLab, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreLab", $g_ichkIgnoreLab, "Int")
	IniReadS($g_ichkIgnoreBarrack, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreBarrack", $g_ichkIgnoreBarrack, "Int")
	IniReadS($g_ichkIgnoreDBarrack, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreDBarrack", $g_ichkIgnoreDBarrack, "Int")
	IniReadS($g_ichkIgnoreFactory, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreFactory", $g_ichkIgnoreFactory, "Int")
	IniReadS($g_ichkIgnoreDFactory, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreDFactory", $g_ichkIgnoreDFactory, "Int")
	IniReadS($g_ichkIgnoreGColl, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreGColl", $g_ichkIgnoreGColl, "Int")
	IniReadS($g_ichkIgnoreEColl, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreEColl", $g_ichkIgnoreEColl, "Int")
	IniReadS($g_ichkIgnoreDColl, $g_sProfileConfigPath, "Pico Auto Upgrade", "chkIgnoreDColl", $g_ichkIgnoreDColl, "Int")
	IniReadS($g_iSmartMinGold, $g_sProfileConfigPath, "Pico Auto Upgrade", "SmartMinGold", $g_iSmartMinGold, "Int")
	IniReadS($g_iSmartMinElixir, $g_sProfileConfigPath, "Pico Auto Upgrade", "SmartMinElixir", $g_iSmartMinElixir, "Int")
	IniReadS($g_iSmartMinDark, $g_sProfileConfigPath, "Pico Auto Upgrade", "SmartMinDark", $g_iSmartMinDark, "Int")

	; ================================================== BB FEATURES PART ================================================== ;

	IniReadS($g_ichkCollectBldGE, $g_sProfileConfigPath, "Pico BB Features", "g_chkCollectBldGE", $g_ichkCollectBldGE, "Int")
	IniReadS($g_ichkCollectBldGems, $g_sProfileConfigPath, "Pico BB Features", "g_chkCollectBldGems", $g_ichkCollectBldGems, "Int")
	IniReadS($g_ichkActivateClockTower, $g_sProfileConfigPath, "Pico BB Features", "g_chkActivateClockTower", $g_ichkActivateClockTower, "Int")

	IniReadS($g_ichkBBSuggestedUpgrades, $g_sProfileConfigPath, "Pico BB Features", "g_chkBBSuggestedUpgrades", $g_ichkBBSuggestedUpgrades, "Int")
	IniReadS($g_ichkBBSuggestedUpgradesIgnoreGold, $g_sProfileConfigPath, "Pico BB Features", "g_chkBBSuggestedUpgradesIgnoreGold", $g_ichkBBSuggestedUpgradesIgnoreGold, "Int")
	IniReadS($g_ichkBBSuggestedUpgradesIgnoreElixir, $g_sProfileConfigPath, "Pico BB Features", "g_chkBBSuggestedUpgradesIgnoreElixir", $g_ichkBBSuggestedUpgradesIgnoreElixir, "Int")
	IniReadS($g_ichkBBSuggestedUpgradesIgnoreHall, $g_sProfileConfigPath, "Pico BB Features", "g_chkBBSuggestedUpgradesIgnoreHall", $g_ichkBBSuggestedUpgradesIgnoreHall, "Int")

	; ================================================== CSV SPEED PART ================================================== ;

	IniReadS($icmbCSVSpeed[$LB], $g_sProfileConfigPath, "Pico CSV Speed", "cmbCSVSpeed[LB]", $icmbCSVSpeed[$LB], "Int")
	IniReadS($icmbCSVSpeed[$DB], $g_sProfileConfigPath, "Pico CSV Speed", "cmbCSVSpeed[DB]", $icmbCSVSpeed[$DB], "Int")
	
	; Move the Request CC Troops - Added By rulesss
	$g_bReqCCFirst = (IniRead($g_sProfileConfigPath, "planned", "ReqCCFirst", 0) = 1)
    
	; ================================================== CUSTOM DROP ORDER ================================================== ;kychera
	IniReadS($g_bCustomTrainDropOrderEnable, $g_sProfileConfigPath, "Pico DropOrder", "chkTroopDropOrder", $g_bCustomTrainDropOrderEnable, "Bool")
	For $p = 0 To UBound($icmbDropTroops) - 1
		IniReadS($icmbDropTroops[$p], $g_sProfileConfigPath, "Pico DropOrder", "cmbDropTroops[" & $p & "]", $icmbDropTroops[$p] , "Int")
	Next
	
	
	; Multi Finger (LunaEclipse) - Added by rulesss
	IniReadS($iMultiFingerStyle, $g_sProfileConfigPath, "MultiFinger", "Select", 2, "int")

	; Unit/Wave Factor (rulesss & kychera) - Added by rulesss
	IniReadS($iChkUnitFactor, $g_sProfileConfigPath, "SetSleep", "EnableUnitFactor", 0, "Int")
	IniReadS($iTxtUnitFactor, $g_sProfileConfigPath, "SetSleep", "UnitFactor", 10 ,"Int")

	IniReadS($iChkWaveFactor, $g_sProfileConfigPath, "SetSleep", "EnableWaveFactor", 0, "Int")
	IniReadS($iTxtWaveFactor, $g_sProfileConfigPath, "SetSleep", "WaveFactor", 100 ,"Int")
	
	; ================================================== Forecast PART ================================================== ;
	
	IniReadS($iChkForecastBoost, $g_sProfileConfigPath, "Pico Forecast", "chkForecastBoost", 0, "Int")
	IniReadS($iChkForecastPause, $g_sProfileConfigPath, "Pico Forecast", "chkForecastPause", 0, "Int")
	IniReadS($iTxtForecastBoost, $g_sProfileConfigPath, "Pico Forecast", "txtForecastBoost", 6, "Int")
	IniReadS($iTxtForecastPause, $g_sProfileConfigPath, "Pico Forecast", "txtForecastPause", 2, "Int")
	IniReadS($ichkForecastHopingSwitchMax, $g_sProfileConfigPath, "Pico Forecast", "chkForecastHopingSwitchMax", 0, "Int")
	IniReadS($icmbForecastHopingSwitchMax, $g_sProfileConfigPath, "Pico Forecast", "cmbForecastHopingSwitchMax", 0, "Int")
	IniReadS($itxtForecastHopingSwitchMax, $g_sProfileConfigPath, "Pico Forecast", "txtForecastHopingSwitchMax", 2, "Int")
	IniReadS($ichkForecastHopingSwitchMin, $g_sProfileConfigPath, "Pico Forecast", "chkForecastHopingSwitchMin", 0, "Int")
	IniReadS($icmbForecastHopingSwitchMin, $g_sProfileConfigPath, "Pico Forecast", "cmbForecastHopingSwitchMin", 0, "Int")
	IniReadS($itxtForecastHopingSwitchMin, $g_sProfileConfigPath, "Pico Forecast", "txtForecastHopingSwitchMin", 2, "Int")
	IniReadS($icmbSwLang, $g_sProfileConfigPath, "Pico Forecast", "cmbSwLang", 1, "int")
	
	IniReadS($ChatbotChatGlobal, $g_sProfileConfigPath, "Pico Chatbot", "ChatbotChatGlobal", 0, "Int")
	
EndFunc   ;==>ReadConfig_PicoMod

Func SaveConfig_PicoMod()

	; ================================================== SWITCH ACCOUNT PART ================================================== ;

	IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "chkEnableSwitchAccount", $g_ichkSwitchAccount)
	IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "cmbAccountsQuantity", $g_icmbAccountsQuantity)
	For $i = 1 To 8
		IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "chkCanUse[" & $i & "]", $g_iachkCanUse[$i])
		IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "chkDonateAccount[" & $i & "]", $g_iachkDonateAccount[$i])
		IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "cmbAccount[" & $i & "]", $g_iacmbAccount[$i])
	Next
	IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "cmbMaxStayDelay", $g_icmbMaxStayDelay)
	IniWrite($g_sSwitchAccountConfig, "Pico Switch Account", "cmbMinDelayToSwitch", $g_icmbMinDelayToSwitch)

	; ================================================== TREASURY COLLECT PART ================================================== ;

	_Ini_Add("Pico Treasury Collect", "chkEnableTrCollect", $g_ichkEnableTrCollect)
	_Ini_Add("Pico Treasury Collect", "chkForceTrCollect", $g_ichkForceTrCollect)
	_Ini_Add("Pico Treasury Collect", "chkGoldTrCollect", $g_ichkGoldTrCollect)
	_Ini_Add("Pico Treasury Collect", "chkElxTrCollect", $g_ichkElxTrCollect)
	_Ini_Add("Pico Treasury Collect", "chkDarkTrCollect", $g_ichkDarkTrCollect)
	_Ini_Add("Pico Treasury Collect", "txtMinGoldTrCollect", GUICtrlRead($g_txtMinGoldTrCollect))
	_Ini_Add("Pico Treasury Collect", "txtMinElxTrCollect", GUICtrlRead($g_txtMinElxTrCollect))
	_Ini_Add("Pico Treasury Collect", "txtMinDarkTrCollect", GUICtrlRead($g_txtMinDarkTrCollect))
	_Ini_Add("Pico Treasury Collect", "chkFullGoldTrCollect", $g_ichkFullGoldTrCollect)
	_Ini_Add("Pico Treasury Collect", "chkFullElxTrCollect", $g_ichkFullElxTrCollect)
	_Ini_Add("Pico Treasury Collect", "chkFullDarkTrCollect", $g_ichkFullDarkTrCollect)

	; ================================================== BOT HUMANIZATION PART ================================================== ;

	_Ini_Add("Pico Bot Humanization", "chkUseBotHumanization", $g_ichkUseBotHumanization)
	_Ini_Add("Pico Bot Humanization", "chkUseAltRClick", $g_ichkUseAltRClick)
	_Ini_Add("Pico Bot Humanization", "chkCollectAchievements", $g_ichkCollectAchievements)
	_Ini_Add("Pico Bot Humanization", "chkLookAtRedNotifications", $g_ichkLookAtRedNotifications)
	For $i = 0 To 12
		_Ini_Add("Pico Bot Humanization", "cmbPriority[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i]))
	Next
	For $i = 0 To 1
		_Ini_Add("Pico Bot Humanization", "cmbMaxSpeed[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i]))
	Next
	For $i = 0 To 1
		_Ini_Add("Pico Bot Humanization", "cmbPause[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbPause[$i]))
	Next
	For $i = 0 To 1
		_Ini_Add("Pico Bot Humanization", "humanMessage[" & $i & "]", GUICtrlRead($g_ahumanMessage[$i]))
	Next
	_Ini_Add("Pico Bot Humanization", "cmbMaxActionsNumber", _GUICtrlComboBox_GetCurSel($g_cmbMaxActionsNumber))
	_Ini_Add("Pico Bot Humanization", "challengeMessage", GUICtrlRead($g_challengeMessage))

	; ================================================== AUTO UPGRADE PART ================================================== ;

	_Ini_Add("Pico Auto Upgrade", "chkAutoUpgrade", $g_ichkAutoUpgrade)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreTH", $g_ichkIgnoreTH)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreKing", $g_ichkIgnoreKing)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreQueen", $g_ichkIgnoreQueen)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreWarden", $g_ichkIgnoreWarden)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreCC", $g_ichkIgnoreCC)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreLab", $g_ichkIgnoreLab)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreBarrack", $g_ichkIgnoreBarrack)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreDBarrack", $g_ichkIgnoreDBarrack)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreFactory", $g_ichkIgnoreFactory)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreDFactory", $g_ichkIgnoreDFactory)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreGColl", $g_ichkIgnoreGColl)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreEColl", $g_ichkIgnoreEColl)
	_Ini_Add("Pico Auto Upgrade", "chkIgnoreDColl", $g_ichkIgnoreDColl)
	_Ini_Add("Pico Auto Upgrade", "SmartMinGold", GUICtrlRead($g_SmartMinGold))
	_Ini_Add("Pico Auto Upgrade", "SmartMinElixir", GUICtrlRead($g_SmartMinElixir))
	_Ini_Add("Pico Auto Upgrade", "SmartMinDark", GUICtrlRead($g_SmartMinDark))

	; ================================================== BB FEATURES PART ================================================== ;

	_Ini_Add("Pico BB Features", "g_chkCollectBldGE", $g_ichkCollectBldGE)
	_Ini_Add("Pico BB Features", "g_chkCollectBldGems", $g_ichkCollectBldGems)
	_Ini_Add("Pico BB Features", "g_chkActivateClockTower", $g_ichkActivateClockTower)

	_Ini_Add("Pico BB Features", "g_chkBBSuggestedUpgrades", $g_ichkBBSuggestedUpgrades)
	_Ini_Add("Pico BB Features", "g_chkBBSuggestedUpgradesIgnoreGold", $g_ichkBBSuggestedUpgradesIgnoreGold)
	_Ini_Add("Pico BB Features", "g_chkBBSuggestedUpgradesIgnoreElixir", $g_ichkBBSuggestedUpgradesIgnoreElixir)
	_Ini_Add("Pico BB Features", "g_chkBBSuggestedUpgradesIgnoreHall", $g_ichkBBSuggestedUpgradesIgnoreHall)

	; ================================================== CSV SPEED PART ================================================== ;

	_Ini_Add("Pico CSV Speed", "cmbCSVSpeed[LB]", _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$LB]))
	_Ini_Add("Pico CSV Speed", "cmbCSVSpeed[DB]", _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$DB]))
	
	; Move the Request CC Troops 
	_Ini_Add("planned", "ReqCCFirst", $g_bReqCCFirst ? 1 : 0)
    
	; ================================================== CUSTOM DROP ORDER ================================================== ;kychera
	_Ini_Add("Pico DropOrder", "chkTroopDropOrder", $g_bCustomTrainDropOrderEnable)
	For $p = 0 To UBound($icmbDropTroops) - 1
		_Ini_Add("Pico DropOrder", "cmbDropTroops[" & $p & "]", _GUICtrlComboBox_GetCurSel($cmbDropTroops[$p]))
	Next
	
	; Multi Finger (LunaEclipse) 
	_Ini_Add("MultiFinger", "Select", _GUICtrlComboBox_GetCurSel($CmbDBMultiFinger))

	; Unit/Wave Factor 
	_Ini_Add("SetSleep", "EnableUnitFactor", $iChkUnitFactor ? 1 : 0)
	_Ini_Add("SetSleep", "EnableWaveFactor", $iChkWaveFactor ? 1 : 0)

    _Ini_Add("SetSleep", "UnitFactor", GUICtrlRead($TxtUnitFactor))
	_Ini_Add("SetSleep", "WaveFactor", GUICtrlRead($TxtWaveFactor))
	
	; ================================================== Forecast PART ================================================== ;
	
	_Ini_Add("Pico Forecast", "txtForecastBoost", GUICtrlRead($txtForecastBoost))
	_Ini_Add("Pico Forecast", "txtForecastPause", GUICtrlRead($txtForecastPause))
	_Ini_Add("Pico Forecast", "cmbForecastHopingSwitchMax", _GUICtrlComboBox_GetCurSel($cmbForecastHopingSwitchMax))
	_Ini_Add("Pico Forecast", "txtForecastHopingSwitchMax", GUICtrlRead($txtForecastHopingSwitchMax))
	_Ini_Add("Pico Forecast", "cmbForecastHopingSwitchMin", _GUICtrlComboBox_GetCurSel($cmbForecastHopingSwitchMin))
	_Ini_Add("Pico Forecast", "txtForecastHopingSwitchMin", GUICtrlRead($txtForecastHopingSwitchMin))
	_Ini_Add("Pico Forecast", "chkForecastBoost", $iChkForecastBoost ? 1 : 0)
	_Ini_Add("Pico Forecast", "chkForecastPause", $iChkForecastPause ? 1 : 0)
	_Ini_Add("Pico Forecast", "chkForecastHopingSwitchMax", $ichkForecastHopingSwitchMax ? 1 : 0)
	_Ini_Add("Pico Forecast", "chkForecastHopingSwitchMin", $ichkForecastHopingSwitchMin ? 1 : 0)
	_Ini_Add("Pico Forecast", "cmbSwLang", _GUICtrlComboBox_GetCurSel($cmbSwLang))
	
	_Ini_Add("Pico Chatbot", "ChatbotChatGlobal", $ChatbotChatGlobal ? 1 : 0)

EndFunc   ;==>SaveConfig_PicoMod

Func ApplyConfig_PicoMod($TypeReadSave)

	Switch $TypeReadSave

		Case "Save"

			; ================================================== SWITCH ACCOUNT PART ================================================== ;

			$g_ichkSwitchAccount = GUICtrlRead($chkEnableSwitchAccount) = $GUI_CHECKED ? 1 : 0
			$g_icmbAccountsQuantity = _GUICtrlComboBox_GetCurSel($g_cmbAccountsQuantity)
			For $i = 1 To 8
				$g_iachkCanUse[$i] = GUICtrlRead($g_achkCanUse) = $GUI_CHECKED ? 1 : 0
				$g_iachkDonateAccount[$i] = GUICtrlRead($g_achkDonateAccount) = $GUI_CHECKED ? 1 : 0
				$g_iacmbAccount[$i] = _GUICtrlComboBox_GetCurSel($g_acmbAccount[$i])
			Next
			$g_icmbMaxStayDelay = _GUICtrlComboBox_GetCurSel($g_cmbMaxStayDelay)
			$g_icmbMinDelayToSwitch = _GUICtrlComboBox_GetCurSel($g_cmbMinDelayToSwitch)

			; ================================================== TREASURY COLLECT PART ================================================== ;

			$g_ichkEnableTrCollect = GUICtrlRead($g_chkEnableTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkForceTrCollect = GUICtrlRead($g_chkForceTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkGoldTrCollect = GUICtrlRead($g_chkGoldTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkElxTrCollect = GUICtrlRead($g_chkElxTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkDarkTrCollect = GUICtrlRead($g_chkDarkTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkFullGoldTrCollect = GUICtrlRead($g_chkFullGoldTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkFullElxTrCollect = GUICtrlRead($g_chkFullElxTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkFullDarkTrCollect = GUICtrlRead($g_chkFullDarkTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_itxtMinGoldTrCollect = GUICtrlRead($g_txtMinGoldTrCollect)
			$g_itxtMinElxTrCollect = GUICtrlRead($g_txtMinElxTrCollect)
			$g_itxtMinDarkTrCollect = GUICtrlRead($g_txtMinDarkTrCollect)

			; ================================================== BOT HUMANIZATION PART ================================================== ;

			$g_ichkUseBotHumanization = GUICtrlRead($g_chkUseBotHumanization) = $GUI_CHECKED ? 1 : 0
			$g_ichkUseAltRClick = GUICtrlRead($g_chkUseAltRClick) = $GUI_CHECKED ? 1 : 0
			$g_ichkCollectAchievements = GUICtrlRead($g_chkCollectAchievements) = $GUI_CHECKED ? 1 : 0
			$g_ichkLookAtRedNotifications = GUICtrlRead($g_chkLookAtRedNotifications) = $GUI_CHECKED ? 1 : 0
			For $i = 0 To 12
				$g_iacmbPriority[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i])
			Next
			For $i = 0 To 1
				$g_iacmbMaxSpeed[$i] = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				$g_iacmbPause[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPause[$i])
			Next
			For $i = 0 To 1
				$g_iahumanMessage[$i] = GUICtrlRead($g_ahumanMessage[$i])
			Next
			$g_icmbMaxActionsNumber = _GUICtrlComboBox_GetCurSel($g_icmbMaxActionsNumber)
			$g_ichallengeMessage = GUICtrlRead($g_challengeMessage)

			; ================================================== AUTO UPGRADE PART ================================================== ;

			$g_ichkAutoUpgrade = GUICtrlRead($g_chkAutoUpgrade) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreTH = GUICtrlRead($g_chkIgnoreTH) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreKing = GUICtrlRead($g_chkIgnoreKing) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreQueen = GUICtrlRead($g_chkIgnoreQueen) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreWarden = GUICtrlRead($g_chkIgnoreWarden) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreCC = GUICtrlRead($g_chkIgnoreCC) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreLab = GUICtrlRead($g_chkIgnoreLab) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreBarrack = GUICtrlRead($g_chkIgnoreBarrack) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreDBarrack = GUICtrlRead($g_chkIgnoreDBarrack) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreFactory = GUICtrlRead($g_chkIgnoreFactory) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreDFactory = GUICtrlRead($g_chkIgnoreDFactory) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreGColl = GUICtrlRead($g_chkIgnoreGColl) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreEColl = GUICtrlRead($g_chkIgnoreEColl) = $GUI_CHECKED ? 1 : 0
			$g_ichkIgnoreDColl = GUICtrlRead($g_chkIgnoreDColl) = $GUI_CHECKED ? 1 : 0
			$g_iSmartMinGold = GUICtrlRead($g_SmartMinGold)
			$g_iSmartMinElixir = GUICtrlRead($g_SmartMinElixir)
			$g_iSmartMinDark = GUICtrlRead($g_SmartMinDark)

			; ================================================== BB FEATURES PART ================================================== ;

			$g_ichkCollectBldGE = GUICtrlRead($g_chkCollectBldGE) = $GUI_CHECKED ? 1 : 0
			$g_ichkCollectBldGems = GUICtrlRead($g_chkCollectBldGems) = $GUI_CHECKED ? 1 : 0
			$g_ichkActivateClockTower = GUICtrlRead($g_chkActivateClockTower) = $GUI_CHECKED ? 1 : 0

			$g_ichkBBSuggestedUpgrades = (GUICtrlRead($g_chkBBSuggestedUpgrades) = $GUI_CHECKED) ? 1 : 0
			$g_ichkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_chkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
			$g_ichkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_chkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
			$g_ichkBBSuggestedUpgradesIgnoreHall = (GUICtrlRead($g_chkBBSuggestedUpgradesIgnoreHall) = $GUI_CHECKED) ? 1 : 0

			; ================================================== CSV SPEED PART ================================================== ;

			$icmbCSVSpeed[$LB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$LB])
			$icmbCSVSpeed[$DB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$DB])
            
			;Move the Request CC Troops 
			$g_bReqCCFirst = GUICtrlRead($chkReqCCFirst) = $GUI_CHECKED ? 1 : 0
			
			; ================================================== CUSTOM DROP ORDER ================================================== ;
			$g_bCustomTrainDropOrderEnable = GUICtrlRead($g_hChkCustomTrainDropOrderEnable) = $GUI_CHECKED ? True : False
			For $p = 0 To UBound($icmbDropTroops) - 1
				$icmbDropTroops[$p] = _GUICtrlComboBox_GetCurSel($cmbDropTroops[$p])
			Next
			
		    ; Multi Finger
			$iMultiFingerStyle = _GUICtrlComboBox_GetCurSel($CmbDBMultiFinger)

			; Unit/Wave Factor 
			$iChkUnitFactor = (GUICtrlRead($ChkUnitFactor) = $GUI_CHECKED)
			$iChkWaveFactor = (GUICtrlRead($ChkWaveFactor) = $GUI_CHECKED)
			$iTxtUnitFactor = GUICtrlRead($TxtUnitFactor)
			$iTxtWaveFactor = GUICtrlRead($TxtWaveFactor)
			
			; ================================================== Forecast PART ================================================== ;
			
			$iChkForecastBoost = (GUICtrlRead($chkForecastBoost) = $GUI_UNCHECKED)
			$iTxtForecastBoost = GUICtrlRead($txtForecastBoost)
			$iChkForecastPause = (GUICtrlRead($chkForecastPause) = $GUI_UNCHECKED)
			$iTxtForecastPause = GUICtrlRead($txtForecastPause)
			$ichkForecastHopingSwitchMax = (GUICtrlRead($chkForecastHopingSwitchMax) = $GUI_UNCHECKED)
			$icmbForecastHopingSwitchMax = _GUICtrlComboBox_GetCurSel($cmbForecastHopingSwitchMax)
			$itxtForecastHopingSwitchMax = GUICtrlRead($txtForecastHopingSwitchMax)
			$ichkForecastHopingSwitchMin = (GUICtrlRead($chkForecastHopingSwitchMin) = $GUI_UNCHECKED)
			$icmbForecastHopingSwitchMin = _GUICtrlComboBox_GetCurSel($cmbForecastHopingSwitchMin)
			$itxtForecastHopingSwitchMin = GUICtrlRead($txtForecastHopingSwitchMin)
			$icmbSwLang = _GUICtrlComboBox_GetCurSel($cmbSwLang)
			
			$ChatbotChatGlobal = GUICtrlRead($chkGlobalChat) = $GUI_CHECKED ? 1 : 0
			
		Case "Read"

			; ================================================== SWITCH ACCOUNT PART ================================================== ;

			GUICtrlSetState($chkEnableSwitchAccount, $g_ichkSwitchAccount = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_cmbAccountsQuantity, $g_icmbAccountsQuantity)
			For $i = 1 To 8
				GUICtrlSetState($g_achkCanUse[$i], $g_iachkCanUse[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_achkDonateAccount[$i], $g_iachkDonateAccount[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_acmbAccount[$i], $g_iacmbAccount[$i])
			Next
			_GUICtrlComboBox_SetCurSel($g_cmbMaxStayDelay, $g_icmbMaxStayDelay)
			_GUICtrlComboBox_SetCurSel($g_cmbMinDelayToSwitch, $g_icmbMinDelayToSwitch)
			cmbMaxStayDelay()
			cmbMinDelayToSwitch()
			chkSwitchAccount()

			; ================================================== TREASURY COLLECT PART ================================================== ;

			GUICtrlSetState($g_chkEnableTrCollect, $g_ichkEnableTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkForceTrCollect, $g_ichkForceTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkGoldTrCollect, $g_ichkGoldTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkElxTrCollect, $g_ichkElxTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkDarkTrCollect, $g_ichkDarkTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkFullGoldTrCollect, $g_ichkFullGoldTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkFullElxTrCollect, $g_ichkFullElxTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkFullDarkTrCollect, $g_ichkFullDarkTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_txtMinGoldTrCollect, $g_itxtMinGoldTrCollect)
			GUICtrlSetData($g_txtMinElxTrCollect, $g_itxtMinElxTrCollect)
			GUICtrlSetData($g_txtMinDarkTrCollect, $g_itxtMinDarkTrCollect)
			chkEnableTrCollect()

			; ================================================== BOT HUMANIZATION PART ================================================== ;

			GUICtrlSetState($g_chkUseBotHumanization, $g_ichkUseBotHumanization = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkUseAltRClick, $g_ichkUseAltRClick = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkCollectAchievements, $g_ichkCollectAchievements = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkLookAtRedNotifications, $g_ichkLookAtRedNotifications = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseBotHumanization()
			For $i = 0 To 12
				_GUICtrlComboBox_SetCurSel($g_acmbPriority[$i], $g_iacmbPriority[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbMaxSpeed[$i], $g_iacmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbPause[$i], $g_iacmbPause[$i])
			Next
			For $i = 0 To 1
				GUICtrlSetData($g_ahumanMessage[$i], $g_iahumanMessage[$i])
			Next
			_GUICtrlComboBox_SetCurSel($g_cmbMaxActionsNumber, $g_icmbMaxActionsNumber)
			GUICtrlSetData($g_challengeMessage, $g_ichallengeMessage)
			cmbStandardReplay()
			cmbWarReplay()

			; ================================================== AUTO UPGRADE PART ================================================== ;

			GUICtrlSetState($g_chkAutoUpgrade, $g_ichkAutoUpgrade = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreTH, $g_ichkIgnoreTH = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreKing, $g_ichkIgnoreKing = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreQueen, $g_ichkIgnoreQueen = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreWarden, $g_ichkIgnoreWarden = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreCC, $g_ichkIgnoreCC = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreLab, $g_ichkIgnoreLab = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreBarrack, $g_ichkIgnoreBarrack = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreDBarrack, $g_ichkIgnoreDBarrack = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreFactory, $g_ichkIgnoreFactory = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreDFactory, $g_ichkIgnoreDFactory = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreGColl, $g_ichkIgnoreGColl = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreEColl, $g_ichkIgnoreEColl = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkIgnoreDColl, $g_ichkIgnoreDColl = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_SmartMinGold, $g_iSmartMinGold)
			GUICtrlSetData($g_SmartMinElixir, $g_iSmartMinElixir)
			GUICtrlSetData($g_SmartMinDark, $g_iSmartMinDark)
			chkAutoUpgrade()

			; ================================================== BB FEATURES PART ================================================== ;

			GUICtrlSetState($g_chkCollectBldGE, $g_ichkCollectBldGE = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkCollectBldGems, $g_ichkCollectBldGems = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkActivateClockTower, $g_ichkActivateClockTower = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)

			GUICtrlSetState($g_chkBBSuggestedUpgrades, $g_ichkBBSuggestedUpgrades = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreGold, $g_ichkBBSuggestedUpgradesIgnoreGold = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreElixir, $g_ichkBBSuggestedUpgradesIgnoreElixir = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkBBSuggestedUpgradesIgnoreHall, $g_ichkBBSuggestedUpgradesIgnoreHall = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkActivateBBSuggestedUpgrades()
			chkActivateBBSuggestedUpgradesGold()
			chkActivateBBSuggestedUpgradesElixir()

			; ================================================== CSV SPEED PART ================================================== ;

			_GUICtrlComboBox_SetCurSel($cmbCSVSpeed[$LB], $icmbCSVSpeed[$LB])
			_GUICtrlComboBox_SetCurSel($cmbCSVSpeed[$DB], $icmbCSVSpeed[$DB])
            
			;Move the Request CC Troops 
			GUICtrlSetState($chkReqCCFirst, $g_bReqCCFirst = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			
			; ================================================== CUSTOM DROP ORDER ================================================== ;
			GUICtrlSetState($g_hChkCustomTrainDropOrderEnable, $g_bCustomTrainDropOrderEnable = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			For $p = 0 To UBound($icmbDropTroops) - 1
				_GUICtrlComboBox_SetCurSel($cmbDropTroops[$p], $icmbDropTroops[$p])
				GUICtrlSetImage($g_ahImgTroopDropOrder[$p], $g_sLibIconPath, $g_aiTroopOrderDropIcon[$icmbDropTroops[$p] + 1])
			Next
			; process error
			If $g_bCustomTrainDropOrderEnable = True Then ; only update troop train order if enabled
				If ChangeTroopDropOrder() = False Then ; process error
					;SetDefaultTroopGroup()
					GUICtrlSetState($g_hChkCustomTrainDropOrderEnable, $GUI_UNCHECKED)
					$g_bCustomTrainDropOrderEnable = False
					GUICtrlSetState($g_hBtnTroopOrderSet2, $GUI_DISABLE) ; disable button
					GUICtrlSetState($g_hBtnRemoveTroops2, $GUI_DISABLE)
					For $i = 0 To UBound($cmbDropTroops) - 1
						GUICtrlSetState($cmbDropTroops[$i], $GUI_DISABLE) ; disable combo boxes
					Next
				EndIf
			EndIf
			chkTroopDropOrder()
			
			; Classic Four Finger  & Multi Finger (LunaEclipse) 
			_GUICtrlComboBox_SetCurSel($cmbDBMultiFinger, $iMultiFingerStyle)
			Bridge()			
			; Unit/Wave Factor 
			GUICtrlSetState($ChkUnitFactor, $iChkUnitFactor ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($TxtUnitFactor, $iTxtUnitFactor)
			chkUnitFactor()
			GUICtrlSetState($ChkWaveFactor, $iChkWaveFactor ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($TxtWaveFactor, $iTxtWaveFactor)
			chkWaveFactor()
			
			; ================================================== Forecast PART ================================================== ;
			
			GUICtrlSetState($chkForecastBoost, $iChkForecastBoost = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($txtForecastBoost, $iTxtForecastBoost)
			chkForecastBoost()
			GUICtrlSetState($chkForecastPause, $iChkForecastPause = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($txtForecastPause, $iTxtForecastPause)
			chkForecastPause()
			GUICtrlSetState($chkForecastHopingSwitchMax, $ichkForecastHopingSwitchMax = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($cmbForecastHopingSwitchMax, $icmbForecastHopingSwitchMax)
			GUICtrlSetData($txtForecastHopingSwitchMax, $itxtForecastHopingSwitchMax)
			chkForecastHopingSwitchMax()
			GUICtrlSetState($chkForecastHopingSwitchMin, $ichkForecastHopingSwitchMin = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($cmbForecastHopingSwitchMin, $icmbForecastHopingSwitchMin)
			GUICtrlSetData($txtForecastHopingSwitchMin, $itxtForecastHopingSwitchMin)
			chkForecastHopingSwitchMin()
			_GUICtrlComboBox_SetCurSel($cmbSwLang, $icmbSwLang)
			
			GUICtrlSetState($chkGlobalChat, $ChatbotChatGlobal = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
            chkGlobalChat()
			
	EndSwitch

EndFunc   ;==>ApplyConfig_PicoMod
