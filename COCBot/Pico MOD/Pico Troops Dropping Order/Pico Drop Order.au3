; #FUNCTION# ====================================================================================================================
; Name ..........: Custom troops drop
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Kychera 05/2017
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MatchTroopDropName($Num)
	Switch _GUICtrlComboBox_GetCurSel($cmbDropTroops[$Num])
		Case 0
			Return $eBarb
		Case 1
			Return $eArch
		Case 2
			Return $eGiant
		Case 3
			Return $eGobl
		Case 4
			Return $eWall
		Case 5
			Return $eBall
		Case 6
			Return $eWiza
		Case 7
			Return $eHeal
		Case 8
			Return $eDrag
		Case 9
			Return $ePekk
		Case 10
			Return $eBabyD
		Case 11
			Return $eMine
		Case 12
			Return $eMini
		Case 13
			Return $eHogs
		Case 14
			Return $eValk
		Case 15
			Return $eGole
		Case 16
			Return $eWitc
		Case 17
			Return $eLava
		Case 18
			Return $eBowl
		Case 19
			Return "CC"
		Case 20
			Return "HEROES"
	EndSwitch
EndFunc   ;==>MatchTroopDropName

Func MatchSlotsPerEdge($Num)
	Switch _GUICtrlComboBox_GetCurSel($cmbDropTroops[$Num])
		Case 0 ;$eBarb
			Return 0
		Case 1 ;$eArch
			Return 0
		Case 2 ;$eGiants
			Return $g_iSlotsGiants
		Case 3 ;$eGobl
			Return 0
		Case 4 ;$eWall
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 5 ;$eBall
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 6 ;$eWiza
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 7 ;$eHeal
			Return 1
		Case 8 ;$eDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 9 ;$ePekk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 10 ;$eBabyD
			Return 1
		Case 11 ;$eMine
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 1
			EndIf
		Case 12 ;$eMini
			Return 0
		Case 13 ;$eHogs
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 14 ;$eValk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 15 ;$eGole
			Return 2
		Case 16 ;$eWitc
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 17 ;$eLava
			Return 2
		Case 18 ;$eBowl
			Return 0
		Case 19 ;CC
			Return 1
		Case 20 ;HEROES
			Return 1
	EndSwitch
EndFunc   ;==>MatchSlotsPerEdge

Func MatchSidesDrop($Num)
	Switch _GUICtrlComboBox_GetCurSel($cmbDropTroops[$Num])
		Case 0 To 18 ;$eBarb to $eBowl
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 0 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 1 Then Return 2
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 2 Then Return 3
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 3 Then Return 4
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 4 Then Return 4
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 5 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 6 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 7 Then Return 1	
		Case 19
			Return 1 ;CC
		Case 20
			Return 1 ;HEROES
	EndSwitch
EndFunc   ;==>MatchSidesDrop

Func MatchTroopWaveNb($Num)
	Return 1
EndFunc   ;==>MatchTroopWaveNb
