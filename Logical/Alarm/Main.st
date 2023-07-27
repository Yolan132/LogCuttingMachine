
PROGRAM _INIT
	(* Insert code here *)
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);
	
	MpAlarmXListUI_0.Enable := TRUE;
	MpAlarmXListUI_0.MpLink := ADR(gAlarmXCore);
	
	MpAlarmXHistory_0.Enable := TRUE;
	MpAlarmXHistory_0.MpLink := ADR(gAlarmXHistory);
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAlarmXCore_0();
	MpAlarmXListUI_0();
	
	MpAlarmXHistory_0();
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

