
PROGRAM _INIT
	MpParallelPar.Homing.Mode := 140;
	MpParallelPar.Velocity := 0.2;
	
	MpAxisParallel.Enable := TRUE;
	MpAxisParallel.MpLink := ADR(gParallelAxis);
	MpAxisParallel.Parameters := ADR(MpParallelPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	 
END_PROGRAM

PROGRAM _CYCLIC
	MpAxisParallel();
	MenageMachine := gStateSetter;
	
	CASE MenageMachine OF
		WARMUP:
			CASE InitMachine OF
				INIT:
					IF MpAxisParallel.Info.ReadyToPowerOn THEN
						InitMachine := POWER;
					END_IF;
		
				POWER:
					MpAxisParallel.Power := TRUE;
			
					IF MpAxisParallel.PowerOn THEN
						InitMachine := HOME;
					END_IF;
		
				HOME:
					MpAxisParallel.Home := TRUE;
					Saw_SimOutputs.aoDriveParallelPosition := LREAL_TO_REAL(MpAxisParallel.Position);
					IF MpAxisParallel.IsHomed THEN
						
						InitMachine := DONE;
					END_IF;
		
				DONE:
					gParallelSettings.doReadyToWork := TRUE;

			END_CASE;
			
		WORK_M:
			CASE WorkManMachine OF
				WAIT:
					MpAxisParallel.MoveAbsolute := FALSE;
					
					IF EDGEPOS(gParallelSettings.diLeft) AND NOT(Saw_SimInputs.diDriveParallelAtFront) THEN
						MpParallelPar.Position := MpAxisParallel.Position + gParallelSettings.aiParallelStep;
				
						WorkManMachine := RUN;
					END_IF;
			
					IF EDGEPOS(gParallelSettings.diRight) AND NOT(Saw_SimInputs.diDriveParallelAtBack) THEN
						MpParallelPar.Position := MpAxisParallel.Position - gParallelSettings.aiParallelStep;
				
						WorkManMachine := RUN;
					END_IF;
			
					IF EDGEPOS(gOperatingPanel.diStop) THEN
						gStateSetter := 0;
					END_IF;
					
				RUN:
					MpAxisParallel.MoveAbsolute := TRUE;
					Saw_SimOutputs.aoDriveParallelPosition := LREAL_TO_REAL(MpAxisParallel.Position);
					IF MpAxisParallel.MoveDone THEN
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

