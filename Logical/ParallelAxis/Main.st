
PROGRAM _INIT
	MpParallelPar.Homing.Mode := 140;
	MpParallelPar.Velocity := 0.2;
	
	MpAxisParallel.Enable := TRUE;
	MpAxisParallel.MpLink := ADR(gParallelAxis);
	MpAxisParallel.Parameters := ADR(MpParallelPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	WorkAutoMachine := START_POSITION;
	
	SequencePar.CamSequence.Data.DataAddress := ADR(McAcpCamPar);
	SequencePar.CamSequence.Data.DataSize := SIZEOF(McAcpCamPar);
	
	SequencePar.CamSequence.Set.Command := mcSET_UPDATE_FROM_ADR;
	SequencePar.CamSequence.Set.Mode := mcAXIS_CAM_SEQ_SET_ON_UPDATE;
	SequencePar.CamSequence.Get.Command := mcGET_PAR_ACTUAL;
	SequencePar.CamSequence.Get.GetOnEnable := TRUE;
		 
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
					
					IF gOperatingPanel.LoadRecipe1M THEN
	  					WorkAutoMachine := LOAD_1M;
					END_IF;
					
					IF gOperatingPanel.LoadRecipe2M THEN
						WorkAutoMachine := LOAD_2M;
					END_IF;
					
					IF gOperatingPanel.LoadRecipe3M THEN
	  					WorkAutoMachine := LOAD_3M;
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
				
				LOAD_1M:					
					McAcpCamPar.State[1].MasterFactor := 300;
					McAcpCamPar.State[1].SlaveFactor := 300;
				
					McAcpCamPar.State[1].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[1].CompensationParameters.MasterCompDistance := 0.2;
					McAcpCamPar.State[1].CompensationParameters.SlaveCompDistance := 0.2;
				
					
					McAcpCamPar.State[2].MasterFactor := 300;
					McAcpCamPar.State[2].SlaveFactor := -300;
					
					McAcpCamPar.State[2].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[2].CompensationParameters.MasterCompDistance := 0.2;
					McAcpCamPar.State[2].CompensationParameters.SlaveCompDistance := -0.2;
					

					
					SequencerParallel.Update := TRUE;
					
					IF SequencerParallel.UpdateDone THEN
						SequencerParallel.Update := FALSE;
						
						WorkAutoMachine := RETURN_SQ;
					END_IF;
				
				LOAD_2M:
					McAcpCamPar.State[1].MasterFactor := 300;
					McAcpCamPar.State[1].SlaveFactor := 300;
					
					McAcpCamPar.State[1].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[1].CompensationParameters.MasterCompDistance := 0.2;
					McAcpCamPar.State[1].CompensationParameters.SlaveCompDistance := 0.2;
				
					
					McAcpCamPar.State[2].MasterFactor := 1200;
					McAcpCamPar.State[2].SlaveFactor := -300;
				
					McAcpCamPar.State[2].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[2].CompensationParameters.MasterCompDistance := 0.3;
					McAcpCamPar.State[2].CompensationParameters.SlaveCompDistance := -0.2;
					

					
					SequencerParallel.Update := TRUE;
					
					IF SequencerParallel.UpdateDone THEN
						SequencerParallel.Update := FALSE;
						
						WorkAutoMachine := RETURN_SQ;
					END_IF;
				
				LOAD_3M:
					McAcpCamPar.State[1].MasterFactor := 300;
					McAcpCamPar.State[1].SlaveFactor := 300;
					
					McAcpCamPar.State[1].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[1].CompensationParameters.MasterCompDistance := 0.2;
					McAcpCamPar.State[1].CompensationParameters.SlaveCompDistance := 0.2;
				
					
					McAcpCamPar.State[2].MasterFactor := 2200;
					McAcpCamPar.State[2].SlaveFactor := -300;
				
					McAcpCamPar.State[2].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[2].CompensationParameters.MasterCompDistance := 0.3;
					McAcpCamPar.State[2].CompensationParameters.SlaveCompDistance := -0.2;
					
					SequencerParallel.Update := TRUE;
					
					IF SequencerParallel.UpdateDone THEN
						SequencerParallel.Update := FALSE;
						
						WorkAutoMachine := RETURN_SQ;
					END_IF;
			END_CASE;

		
		IDLE:

		

	END_CASE;
	
	SequencerParallel(MpLink := ADR(gParallelAxis), Enable := TRUE, Parameters := ADR(SequencePar), MpLinkMaster := ADR(gConveyorAxis));
	//MpAxisCamSequencer_0(MpLink := , Enable := , ErrorReset := , Parameters := , Update := , MpLinkMaster := , Signal1 := , Signal2 := , Signal3 := , Signal4 := , StartSequence := , Continue := , EndSequence := , GetSequence := , ParLock := , OffsetShift := , PhaseShift := , CamPrepare := , Recovery := );
	
	MpAxisParallel.ErrorReset := gResetErrors;
	
	Saw_SimOutputs.aoDriveParallelPosition := LREAL_TO_REAL(MpAxisParallel.Position);
	MpAxisParallel();
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

