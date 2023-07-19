
PROGRAM _INIT
	MpAxisPerpendicular.Enable := TRUE;
	MpAxisPerpendicular.MpLink := ADR(gPerpendicularAxis);
	MpAxisPerpendicular.Parameters := ADR(MpPerpendicularPar);
	
	SMachine := INIT;
	
	
END_PROGRAM

PROGRAM _CYCLIC
	
	MpAxisPerpendicular();
	
	CASE SMachine OF
		INIT:
			MpAxisPerpendicular.Power := FALSE;
			MpAxisPerpendicular.Home := FALSE;
			
			IF EDGEPOS(gPerpendicularAxisSettings.diRunAxis) AND MpAxisPerpendicular.Info.ReadyToPowerOn THEN
	  			SMachine := POWER;
			END_IF;
			
		POWER:
			MpAxisPerpendicular.Power := TRUE;
			
			IF MpAxisPerpendicular.PowerOn THEN
	  			SMachine := HOME;
			END_IF;
			
		HOME:
			IF NOT(MpAxisPerpendicular.IsHomed) THEN
				MpAxisPerpendicular.Home := TRUE;
			END_IF;
			
			IF MpAxisPerpendicular.IsHomed THEN
				SMachine := WAIT;
			END_IF;
			
		WAIT:
			MpAxisPerpendicular.MoveAbsolute := FALSE;
			
			IF EDGEPOS(gPerpendicularAxisSettings.diBackward) AND NOT(Saw_SimInputs.diDriveCutAtBack) THEN
				MpPerpendicularPar.Position := MpAxisPerpendicular.Position - gPerpendicularAxisSettings.aiPerpendicularStep;
				Saw_SimOutputs.aoDriveCutPosition := Saw_SimOutputs.aoDriveCutPosition - gPerpendicularAxisSettings.aiPerpendicularStep;
				
				SMachine := RUNB;
			END_IF;
		
			IF EDGEPOS(gPerpendicularAxisSettings.diForward) AND NOT(Saw_SimInputs.diDriveCutAtFront) THEN
				MpPerpendicularPar.Position := MpAxisPerpendicular.Position + gPerpendicularAxisSettings.aiPerpendicularStep;
				Saw_SimOutputs.aoDriveCutPosition := Saw_SimOutputs.aoDriveCutPosition + gPerpendicularAxisSettings.aiPerpendicularStep;
				
				SMachine := RUNF;
			END_IF;
			
			IF NOT(gPerpendicularAxisSettings.diRunAxis) THEN
				SMachine := INIT;
			END_IF;
		
		RUNB:
			MpAxisPerpendicular.MoveAbsolute := TRUE;
			
			IF MpAxisPerpendicular.MoveDone THEN
				SMachine := WAIT;
			END_IF;
			
		RUNF:
			MpAxisPerpendicular.MoveAbsolute := TRUE;
			
			IF MpAxisPerpendicular.MoveDone THEN				
				SMachine := WAIT;
			END_IF;
			

	END_CASE;
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

