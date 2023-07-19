
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
			MpAxisParallel.Power := FALSE;
			MpAxisParallel.Home := FALSE;
			
			IF EDGEPOS(gParallelAxisSettings.diRunAxis) AND MpAxisParallel.Info.ReadyToPowerOn THEN
	  			SMachine := POWER;
			END_IF;
			
		POWER:
			MpAxisParallel.Power := TRUE;
			
			IF MpAxisParallel.PowerOn THEN
	  			SMachine := HOME;
			END_IF;
			
		HOME:
			IF NOT(MpAxisParallel.IsHomed) THEN
				MpAxisParallel.Home := TRUE;
			END_IF;
			
			IF MpAxisParallel.IsHomed THEN
				SMachine := WAIT;
			END_IF;	
			
		WAIT:
			MpAxisParallel.MoveAbsolute := FALSE;
			
			IF EDGEPOS(gParallelAxisSettings.diLeft) AND NOT(Saw_SimInputs.diDriveParallelAtFront) THEN
				MpParallelPar.Position := MpAxisParallel.Position + gParallelAxisSettings.aiParallelStep;
				Saw_SimOutputs.aoDriveParallelPosition := Saw_SimOutputs.aoDriveParallelPosition + gParallelAxisSettings.aiParallelStep;
				
				SMachine := RUNL;
			END_IF;
			
			IF EDGEPOS(gParallelAxisSettings.diRight) AND NOT(Saw_SimInputs.diDriveParallelAtBack) THEN
				MpParallelPar.Position := MpAxisParallel.Position - gParallelAxisSettings.aiParallelStep;
				Saw_SimOutputs.aoDriveParallelPosition := Saw_SimOutputs.aoDriveParallelPosition - gParallelAxisSettings.aiParallelStep;
				
				SMachine := RUNR;
			END_IF;
			
			IF NOT(gParallelAxisSettings.diRunAxis) THEN
				SMachine := INIT;
			END_IF;
			
		RUNL:
			MpAxisParallel.MoveAbsolute := TRUE;
			
			IF MpAxisParallel.MoveDone THEN
				SMachine := WAIT;
			END_IF;
			
		RUNR:
			MpAxisParallel.MoveAbsolute := TRUE;
			
			IF MpAxisParallel.MoveDone THEN
				SMachine := WAIT;
			END_IF;

	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

