
PROGRAM _INIT
	MpAxisParallel.Enable := TRUE;
	MpAxisParallel.MpLink := ADR(gParallelAxis);
	MpAxisParallel.Parameters := ADR(MpParallelPar);
	
	SMachine := INIT;
	 
END_PROGRAM

PROGRAM _CYCLIC
	MpAxisParallel();
	
	CASE SMachine OF
		INIT:
		
		POWER:
		
		HOME:
		
		WAIT:
		
		RUNL:
		
		RUNR:
		  

	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

