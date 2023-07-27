
PROGRAM _INIT
	MpParallelPar.Homing.Mode := 140;
	MpParallelPar.Velocity := 0.2;
	
	MpAxisParallel.Enable := TRUE;
	MpAxisParallel.MpLink := ADR(gParallelAxis);
	MpAxisParallel.Parameters := ADR(MpParallelPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	WorkAutoMachine := START_POSITION;
	
	//SequencerParallel(MpLink := ADR(gParallelAxis), Enable := TRUE, Parameters := ADR(SequencePar), MpLinkMaster := ADR(gConveyorAxis));
	 
END_PROGRAM

PROGRAM _CYCLIC
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
					
					IF MpAxisParallel.IsHomed THEN
						MpAxisParallel.Home := FALSE;
						InitMachine := DONE;
					END_IF;
		
				DONE:
					gParallelSettings.doReadyToWork := TRUE;
					
			END_CASE;
			
		WORK_M:
			CASE WorkManMachine OF
				WAIT:
					MpAxisParallel.MoveAbsolute := FALSE;
					gParallelSettings.ReadyToChange := TRUE;
					
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
					
					IF EDGEPOS(gOperatingPanel.diHomeParallel) THEN
						WorkManMachine := HOMEAGAIN;
					END_IF;
					
				RUN:
					MpAxisParallel.MoveAbsolute := TRUE;
					gParallelSettings.ReadyToChange := FALSE;
					
					IF MpAxisParallel.MoveDone THEN
						WorkManMachine := WAIT;
					END_IF;
					
					IF EDGENEG(MpAxisParallel.Error) THEN
	  					WorkManMachine := WAIT;
					END_IF;
				
				HOMEAGAIN:
					MpAxisParallel.Home := TRUE;
					gParallelSettings.ReadyToChange := FALSE;
					
					IF EDGEPOS(MpAxisParallel.IsHomed) THEN
						MpAxisParallel.Home := FALSE;
						WorkManMachine := WAIT;
					END_IF;

			END_CASE;
			
		WORK_A:	
			CASE WorkAutoMachine OF
				START_POSITION:				
					MpParallelPar.Position := -0.25;
					MpAxisParallel.MoveAbsolute := TRUE;
					
					IF MpAxisParallel.MoveDone THEN
						MpAxisParallel.MoveAbsolute := FALSE;
						WorkAutoMachine := READY;
						
					END_IF;
					
				READY:
					IF gParallelSettings.AfterSwitchFlag THEN
						gParallelSettings.AfterSwitchFlag := FALSE;
						WorkAutoMachine := START_POSITION;
					END_IF;
					
					gParallelSettings.AutoReady := TRUE;
					
					IF gOperatingPanel.StartSequence THEN
						WorkAutoMachine := CUT_SQ;
							
					END_IF;
				
				CUT_SQ:
					SequencerParallel.StartSequence := TRUE;
					
					IF SequencerParallel.InCam THEN
	  					WorkAutoMachine := RETURN_SQ;
					END_IF;
					
				RETURN_SQ:
					IF gOperatingPanel.StopSequence THEN
						StopSequence := TRUE;
					END_IF;
					
					SequencerParallel.Signal1 := StopSequence;
					
					IF StopSequence THEN
						StopSequence := FALSE;
						SequencerParallel.StartSequence := FALSE;
						
						WorkAutoMachine := SWITCH_MODE;
					END_IF;
				
				SWITCH_MODE:
					IF gPerpendicularSettings.ReadyToChange THEN
						MpParallelPar.Position := -0.25;
						MpAxisParallel.MoveAbsolute := TRUE;
					
						IF MpAxisParallel.MoveDone THEN
							MpAxisParallel.MoveAbsolute := FALSE;										
							gParallelSettings.ReadyToChange := TRUE;
							
							WorkAutoMachine := READY;
						END_IF;	
					END_IF;		  

			END_CASE;

		
		IDLE:

		

	END_CASE;
	
	SequencerParallel(MpLink := ADR(gParallelAxis), Enable := TRUE, Parameters := ADR(SequencePar), MpLinkMaster := ADR(gConveyorAxis));
	
	MpAxisParallel.ErrorReset := gResetErrors;
	
	Saw_SimOutputs.aoDriveParallelPosition := LREAL_TO_REAL(MpAxisParallel.Position);
	MpAxisParallel();
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

