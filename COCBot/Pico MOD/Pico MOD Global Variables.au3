; #FUNCTION# ====================================================================================================================
; Name ..........: Pico MOD Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
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

; ================================================== TREASURY COLLECT PART ================================================== ;

Global $g_ichkEnableTrCollect = 0, $g_ichkForceTrCollect = 0
Global $g_ichkGoldTrCollect = 0, $g_ichkElxTrCollect = 0, $g_ichkDarkTrCollect = 0
Global $g_ichkFullGoldTrCollect = 0, $g_ichkFullElxTrCollect = 0, $g_ichkFullDarkTrCollect = 0
Global $g_itxtMinGoldTrCollect = 150000, $g_itxtMinElxTrCollect = 150000, $g_itxtMinDarkTrCollect = 1500

; ================================================== BOT HUMANIZATION PART ================================================== ;

Global $g_iacmbPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iacmbMaxSpeed[2] = [1, 1]
Global $g_iacmbPause[2] = [0, 0]
Global $g_iahumanMessage[2] = ["Hello !", "Hello !"]
Global $g_ichallengeMessage = "Can you beat my village?"

Global $g_iMinimumPriority, $g_iMaxActionsNumber, $g_iActionToDo
Global $g_aSetActionPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_sFrequenceChain = "Never|Sometimes|Frequently|Often|Very Often"
Global $g_sReplayChain = "1|2|4"
Global $g_ichkUseBotHumanization = 0, $g_ichkUseAltRClick = 0, $g_icmbMaxActionsNumber = 1, $g_ichkCollectAchievements = 0, $g_ichkLookAtRedNotifications = 0

Global $g_aReplayDuration[2] = [0, 0] ; An array, [0] = Minute | [1] = Seconds
Global $g_bOnReplayWindow, $g_iReplayToPause

Global $g_iQuickMISX = 0, $g_iQuickMISY = 0
Global $g_iLastLayout = 0

; ================================================== SWITCH ACCOUNT PART ================================================== ;

Global $g_ichkSwitchAccount = 0

Global $g_bFirstInit = True
Global $g_sSwitchAccountConfig = $g_sProfilePath & "\Profile.ini"
Global $g_sSwitchAccountAtkLog = $g_sProfilePath & "\PicoSwitchAccount_Attack_Report.txt"
Global $g_iachkCanUse[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iachkDonateAccount[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iacmbAccount[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_iaAllAccountsWaitTimeDiff[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ; stored as Milli sec ;Updated time left to train
Global $g_iaAllAccountsWaitTime[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ; Stored as min time ;reported as time needed to train troops
Global $g_iaTimerDiffStart[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ;the start and stop timer counters
Global $g_iaTimerDiffEnd[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ;the start and stop timer counters
Global $g_iCurrentAccountWaitTime = 0

Global $g_iTotalAccountsOnEmu = 0, $g_icmbAccountsQuantity = 0, $g_iCurrentAccount = 0, $g_iCurrentDAccount = 0
Global $g_bMustGoToDonateAccount = 0, $g_iSwitchAccountLoop = 0

Global $g_iSwitchAccountYCoord, $g_iTotalAccountsInUse, $g_iTotalDonateAccountsInUse, $g_iNextAccount, $g_iNextProfile
Global $g_bAlreadyConnected, $g_bIsLoadButton, $g_iSwitchAccountNextStep, $g_sSwitchAccountLastDate = ""

Global $g_iOnAccountSince = 0
Global $g_icmbMaxStayDelay = 2, $g_bForceSwitch = False, $g_icmbMinDelayToSwitch = 2
Global $g_iMaxStayDelay = 0, $g_iMinDelayToSwitch

; ================================================== AUTO UPGRADE PART ================================================== ;

Global $g_ichkAutoUpgrade = 0
Global $g_ichkIgnoreTH = 0, $g_ichkIgnoreKing = 0, $g_ichkIgnoreQueen = 0, $g_ichkIgnoreWarden = 0, $g_ichkIgnoreCC = 0, $g_ichkIgnoreLab = 0
Global $g_ichkIgnoreBarrack = 0, $g_ichkIgnoreDBarrack = 0, $g_ichkIgnoreFactory = 0, $g_ichkIgnoreDFactory = 0
Global $g_ichkIgnoreGColl = 0, $g_ichkIgnoreEColl = 0, $g_ichkIgnoreDColl = 0
Global $g_iSmartMinGold = 150000, $g_iSmartMinElixir = 150000, $g_iSmartMinDark = 1500

Global $g_sBldgText, $g_sBldgLevel
Global $g_aUpgradeName[3] = ["", "", ""]
Global $g_iUpgradeCost
Global $g_sUpgradeResource = 0
Global $g_sUpgradeDuration

; ================================================== CSV SPEED PART ================================================== ;

Global $cmbCSVSpeed[2] = [$LB, $DB]
Global $icmbCSVSpeed[2] = [2, 2]
Global $g_CSVSpeedDivider = 1

; ================================================== BB FEATURES PART ================================================== ;

Global $g_iAttacksAvailable = 0
Global $g_ichkCollectBldGE = 0, $g_ichkCollectBldGems = 0
Global $g_ichkActivateClockTower = 0
Global $g_iGoldBB = 0, $g_iElixirBB = 0, $g_iTrophiesBB = 0, $g_aBuilder[2] = [0,0]

; ================================================== UNICODE SEND TEXT PART ================================================== ;

Global $bCanUseUnicodeKeyboard = False
