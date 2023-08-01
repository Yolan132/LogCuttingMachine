
PROGRAM _INIT
	MpAxisConveyor.Enable := TRUE;
	MpAxisConveyor.MpLink := ADR(gConveyorAxis);
	MpAxisConveyor.Parameters := ADR(MpConveyorPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	WorkAutoMachine := WAIT;
	
END_PROGRAM

PROGRAM _CYCLIC	
	MpAxisConveyor();
	MenageMachine := gStateSetter;
	
	CASE MenageMachine OF
		IDLE:
		
		WARMUP:
			CASE InitMachine OF
				INIT:
					IF MpAxisConveyor.Info.ReadyToPowerOn THEN
						InitMachine := POWER;
					END_IF;
		
				POWER:
					MpAxisConveyor.Power := TRUE;
			
					IF MpAxisConveyor.PowerOn THEN
						InitMachine := HOME;
					END_IF;
		
				HOME:
					MpAxisConveyor.Home := TRUE;
					
					IF MpAxisConveyor.IsHomed THEN
						InitMachine := DONE;
					END_IF;
		
				DONE:
					gConveyorSettings.doReadyToWork := TRUE;

			END_CASE;
			
		WORK_M:
			CASE WorkManMachine OF
				WAIT:
					MpAxisConveyor.MoveVelocity := FALSE;
					
					IF gConveyorSettings.diRun THEN
	  					WorkManMachine := RUN;
					END_IF;
					
				RUN:
					MpAxisConveyor.MoveVelocity := TRUE;
					
					IF NOT(MpConveyorPar.Velocity = gConveyorSettings.aiSpeed) THEN
						WorkManMachine := UPDATE;
					END_IF;
					
					IF NOT(gConveyorSettings.diRun) THEN
						WorkManMachine := WAIT;
					END_IF;
				
				UPDATE:
					MpConveyorPar.Velocity := gConveyorSettings.aiSpeed;
					MpAxisConveyor.Update := TRUE;
				
					IF MpAxisConveyor.UpdateDone THEN
						MpAxisConveyor.Update := FALSE;
	  					WorkManMachine := RUN;
					END_IF;
			END_CASE;
			
		WORK_A:
			CASE WorkAutoMachine OF
				WAIT:
					MpConveyorPar.Velocity := gConveyorSettings.aiSpeed;
					MpAxisConveyor.MoveVelocity := FALSE;
					
					IF gConveyorSettings.diRun THEN
						WorkAutoMachine := RUN;
					END_IF;
				RUN:
					MpAxisConveyor.MoveVelocity := TRUE;
					
					IF NOT(MpConveyorPar.Velocity = gConveyorSettings.aiSpeed) THEN
						WorkAutoMachine := UPDATE;
					END_IF;
					
					IF NOT(gConveyorSettings.diRun) THEN
						MpAxisConveyor.MoveVelocity := FALSE;
						WorkAutoMachine := WAIT;
					END_IF;
					
				UPDATE:
					MpConveyorPar.Velocity := gConveyorSettings.aiSpeed;
					MpAxisConveyor.Update := TRUE;
				
					IF MpAxisConveyor.UpdateDone THEN
						MpAxisConveyor.Update := FALSE;
						WorkAutoMachine := RUN;
					END_IF;

			END_CASE;
	
	END_CASE;

	Saw_SimOutputs.aoTreeVelocity := MpAxisConveyor.Velocity;
	
	MpAxisConveyor.ErrorReset := gResetErrors;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

