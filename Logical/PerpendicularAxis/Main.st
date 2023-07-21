
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
					
					IF MpAxisPerpendicular.IsHomed THEN
						MpAxisPerpendicular.Home := FALSE;
						InitMachine := DONE;
					END_IF;
		
				DONE:
					gPerpendicularSettings.doReadyToWork := TRUE;
					MpAxisPerpendicular.Home := FALSE;

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
					
					IF EDGEPOS(gOperatingPanel.diHomePerpendicular) THEN
						WorkManMachine := HOMEAGAIN;
					END_IF;
					
				RUN:
					MpAxisPerpendicular.MoveAbsolute := TRUE;
					
					IF MpAxisPerpendicular.MoveDone THEN
						WorkManMachine := WAIT;
					END_IF;
				
				HOMEAGAIN:
					MpAxisPerpendicular.Home := TRUE;
					Saw_SimOutputs.aoDriveCutPosition := LREAL_TO_REAL(MpAxisPerpendicular.Position);
					
					IF MpAxisPerpendicular.IsHomed THEN
						WorkManMachine := WAIT;
					END_IF;


			END_CASE;
			
		WORK_A:
			
		
		IDLE:

		

	END_CASE;
	
	Saw_SimOutputs.aoDriveCutPosition := LREAL_TO_REAL(MpAxisPerpendicular.Position);
	MpAxisPerpendicular();

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

