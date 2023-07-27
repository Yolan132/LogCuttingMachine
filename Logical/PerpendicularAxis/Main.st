
PROGRAM _INIT
	MpPerpendicularPar.Homing.Mode := 140;
	MpPerpendicularPar.Velocity := 0.2;
	
	MpAxisPerpendicular.Enable := TRUE;
	MpAxisPerpendicular.MpLink := ADR(gPerpendicularAxis);
	MpAxisPerpendicular.Parameters := ADR(MpPerpendicularPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	WorkAutoMachine := START_POSITION;
	 
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

			END_CASE;
			
		WORK_M:
			CASE WorkManMachine OF
				WAIT:
					MpAxisPerpendicular.MoveAbsolute := FALSE;
					gPerpendicularSettings.ReadyToChange := TRUE;
					
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
					gPerpendicularSettings.ReadyToChange := FALSE;
					
					IF MpAxisPerpendicular.MoveDone THEN
						WorkManMachine := WAIT;
					END_IF;
					
					IF EDGENEG(MpAxisPerpendicular.Error) THEN
						WorkManMachine := WAIT;
					END_IF;
				
				HOMEAGAIN:
					MpAxisPerpendicular.Home := TRUE;
					gPerpendicularSettings.ReadyToChange := FALSE;
					
					IF EDGEPOS(MpAxisPerpendicular.IsHomed) THEN
						MpAxisPerpendicular.Home := FALSE;
						WorkManMachine := WAIT;
					END_IF;

			END_CASE;
			
		WORK_A:
			CASE WorkAutoMachine OF
				START_POSITION:			
					MpPerpendicularPar.Position := 0.4;
					MpAxisPerpendicular.MoveAbsolute := TRUE;
					
					IF MpAxisPerpendicular.MoveDone THEN
						MpAxisPerpendicular.MoveAbsolute := FALSE;
						WorkAutoMachine := READY;
						
					END_IF;
					
				READY:
					IF gPerpendicularSettings.AfterSwitchFlag THEN
						gPerpendicularSettings.AfterSwitchFlag := FALSE;
						WorkAutoMachine := START_POSITION;
					END_IF;
					
					gPerpendicularSettings.AutoReady := TRUE;
					
					IF gOperatingPanel.StartSequence THEN
						gSawOn := TRUE;
						WorkAutoMachine := CUT_SQ;
							
					END_IF;
				
				CUT_SQ:
					SequencerPerpendicular.StartSequence := TRUE;
					
					IF SequencerPerpendicular.InCam THEN
	  					WorkAutoMachine := RETURN_SQ;
					END_IF;
					
				RETURN_SQ:
					SequencerPerpendicular.Continue := FALSE;
					
					IF gOperatingPanel.StopSequence THEN
	  					StopSequence := TRUE;
					END_IF;
					
					SequencerPerpendicular.Signal1 := StopSequence;
					
					IF StopSequence THEN
						StopSequence := FALSE;
						SequencerPerpendicular.StartSequence := FALSE;
						
						WorkAutoMachine := SWITCH_MODE;
					END_IF;
				
				SWITCH_MODE:
					MpPerpendicularPar.Position := 0.4;
					MpAxisPerpendicular.MoveAbsolute := TRUE;
					
					IF MpAxisPerpendicular.MoveDone THEN
						MpAxisPerpendicular.MoveAbsolute := FALSE;
						gPerpendicularSettings.ReadyToChange := TRUE;
						gSawOn := FALSE;
						
						WorkAutoMachine := READY;
					END_IF;	
				
			END_CASE;
		
		IDLE:

		

	END_CASE;
	
	SequencerPerpendicular(MpLink := ADR(gPerpendicularAxis), Enable := TRUE, Parameters := ADR(SequencePar), MpLinkMaster := ADR(gConveyorAxis));
	
	MpAxisPerpendicular.ErrorReset := gResetErrors;
	
	Saw_SimOutputs.aoDriveCutPosition := LREAL_TO_REAL(MpAxisPerpendicular.Position);
	MpAxisPerpendicular();

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

