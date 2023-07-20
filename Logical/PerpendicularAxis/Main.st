
PROGRAM _INIT
	MpPerpendicularPar.Homing.Mode := 140;
	MpPerpendicularPar.Velocity := 0.2;
	
	MpAxisPerpendicular.Enable := TRUE;
	MpAxisPerpendicular.MpLink := ADR(gPerpendicularAxis);
	MpAxisPerpendicular.Parameters := ADR(MpPerpendicularPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	 
END_PROGRAM

PROGRAM _CYCLIC
	MpAxisPerpendicular();
	MenageMachine := gStateSetter;
	
	CASE MenageMachine OF
		WARMUP:
			CASE InitMachine OF
				INIT:
					IF MpAxisPerpendicular.Info.ReadyToPowerOn THEN
						InitMachine := POWER;
					END_IF;
		
				POWER:
					MpAxisPerpendicular.Power := TRUE;
			
					IF MpAxisPerpendicular.PowerOn THEN
						InitMachine := HOME;
					END_IF;
		
				HOME:
					MpAxisPerpendicular.Home := TRUE;
					Saw_SimOutputs.aoDriveCutPosition := LREAL_TO_REAL(MpAxisPerpendicular.Position);
					IF MpAxisPerpendicular.IsHomed THEN
						
						InitMachine := DONE;
					END_IF;
		
				DONE:
					gPerpendicularSettings.doReadyToWork := TRUE;

			END_CASE;
			
		WORK_M:
			CASE WorkManMachine OF
				WAIT:
					MpAxisPerpendicular.MoveAbsolute := FALSE;
					
					IF EDGEPOS(gPerpendicularSettings.diForward) AND NOT(Saw_SimInputs.diDriveCutAtFront) THEN
						MpPerpendicularPar.Position := MpAxisPerpendicular.Position + gPerpendicularSettings.aiPerpendicularStep;
				
						WorkManMachine := RUN;
					END_IF;
			
					IF EDGEPOS(gPerpendicularSettings.diBackward) AND NOT(Saw_SimInputs.diDriveCutAtBack) THEN
						MpPerpendicularPar.Position := MpAxisPerpendicular.Position - gPerpendicularSettings.aiPerpendicularStep;
				
						WorkManMachine := RUN;
					END_IF;
			
					IF EDGEPOS(gOperatingPanel.diStop) THEN
						gStateSetter := 0;
					END_IF;
					
				RUN:
					MpAxisPerpendicular.MoveAbsolute := TRUE;
					Saw_SimOutputs.aoDriveCutPosition := LREAL_TO_REAL(MpAxisPerpendicular.Position);
					
					IF MpAxisPerpendicular.MoveDone THEN
						WorkManMachine := WAIT;
					END_IF;

			END_CASE;
			
		WORK_A:
			
		
		IDLE:

		

	END_CASE;
	
	
	

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

