
PROGRAM _INIT
	MpPerpendicularPar.Homing.Mode := 140;
	MpPerpendicularPar.Velocity := 0.2;
	
	MpAxisPerpendicular.Enable := TRUE;
	MpAxisPerpendicular.MpLink := ADR(gPerpendicularAxis);
	MpAxisPerpendicular.Parameters := ADR(MpPerpendicularPar);
	
	InitMachine := INIT;
	WorkManMachine := WAIT;
	WorkAutoMachine := START_POSITION;
	
	SequencePar.CamSequence.Data.DataAddress := ADR(McAcpCamPar);
	SequencePar.CamSequence.Data.DataSize := SIZEOF(McAcpCamPar);
	
	SequencePar.CamSequence.Set.Command := mcSET_UPDATE_FROM_ADR;
	SequencePar.CamSequence.Set.Mode := mcAXIS_CAM_SEQ_SET_ON_UPDATE;
	SequencePar.CamSequence.Get.Command := mcGET_PAR_ACTUAL;
	SequencePar.CamSequence.Get.GetOnEnable := TRUE;
	
	gPerpendicularSettings.AccTorque := 10;
	gPerpendicularSettings.FeedRate := 3;
	gPerpendicularSettings.WoodLogLength := 1;
	 
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
					
					IF gOperatingPanel.LoadRecipe1M THEN
						RecipeLoadedStationaryFlag := TRUE;
						gPerpendicularSettings.AutoReady := FALSE;
						
						WorkAutoMachine := LOAD_1M;
					END_IF;
					
					IF gOperatingPanel.LoadRecipe2M THEN
						RecipeLoadedStationaryFlag := TRUE;
						gPerpendicularSettings.AutoReady := FALSE;
						
						WorkAutoMachine := LOAD_2M;
					END_IF;
					
					IF gOperatingPanel.LoadRecipe3M THEN
						RecipeLoadedStationaryFlag := TRUE;
						gPerpendicularSettings.AutoReady := FALSE;
						
						WorkAutoMachine := LOAD_3M;
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
					MpPerpendicularPar.Position := 0.4;
					MpAxisPerpendicular.MoveAbsolute := TRUE;
					
					IF MpAxisPerpendicular.MoveDone THEN
						MpAxisPerpendicular.MoveAbsolute := FALSE;
						gPerpendicularSettings.ReadyToChange := TRUE;
						gSawOn := FALSE;
						
						WorkAutoMachine := READY;
					END_IF;	
				
				LOAD_1M:
					gRecipeMenagement.Load1M := TRUE;
					gPerpendicularSettings.AccTorque := gRecipe1M.AccTorqueLimit;
					gPerpendicularSettings.FeedRate := gRecipe1M.SawFeedRate;
					gPerpendicularSettings.WoodLogLength := gRecipe1M.WoodLogLength;
					
					McAcpCamPar.State[1].MasterFactor := 125;
					McAcpCamPar.State[1].SlaveFactor := 300;
					McAcpCamPar.State[1].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[1].CompensationParameters.MasterCompDistance := 0.125;
					McAcpCamPar.State[1].CompensationParameters.SlaveCompDistance := 0.2;		
					
					McAcpCamPar.State[2].MasterFactor := 125;
					McAcpCamPar.State[2].SlaveFactor := -300;
					McAcpCamPar.State[2].CompensationMode := mcCOMP_BETWEEN_CAMS_DIRECT;
					McAcpCamPar.State[2].CompensationParameters.MasterCompDistance := 0.125;
					McAcpCamPar.State[2].CompensationParameters.SlaveCompDistance := -0.2;
					
					McAcpCamPar.State[3].MasterFactor := 500;
					McAcpCamPar.State[3].SlaveFactor := 0;
					McAcpCamPar.State[3].CompensationMode := mcCOMP_OFF;
			
					SequencerPerpendicular.Update := TRUE;
					
					IF SequencerPerpendicular.UpdateDone THEN
						SequencerPerpendicular.Update := FALSE;
						gRecipeMenagement.Load1M := FALSE;
						
						IF RecipeLoadedStationaryFlag THEN
							RecipeLoadedStationaryFlag := FALSE;
							WorkAutoMachine := READY;
						ELSE
							WorkAutoMachine := RETURN_SQ;
						END_IF;
					END_IF;
				
				LOAD_2M:
					gRecipeMenagement.Load2M := TRUE;
					gPerpendicularSettings.AccTorque := gRecipe2M.AccTorqueLimit;
					gPerpendicularSettings.FeedRate := gRecipe2M.SawFeedRate;
					gPerpendicularSettings.WoodLogLength := gRecipe2M.WoodLogLength;
					
					McAcpCamPar.State[1].MasterFactor := 125;
					McAcpCamPar.State[1].SlaveFactor := 300;
					McAcpCamPar.State[1].CompensationParameters.MasterCompDistance := 0.125;
					McAcpCamPar.State[1].CompensationParameters.SlaveCompDistance := 0.2;
				
					McAcpCamPar.State[2].MasterFactor := 125;
					McAcpCamPar.State[2].SlaveFactor := -300;
					McAcpCamPar.State[2].CompensationParameters.MasterCompDistance := 0.125;
					McAcpCamPar.State[2].CompensationParameters.SlaveCompDistance := -0.2;
				
					McAcpCamPar.State[3].MasterFactor := 1500;
					McAcpCamPar.State[3].SlaveFactor := 0;
					McAcpCamPar.State[3].CompensationMode := mcCOMP_OFF;
				
					SequencerPerpendicular.Update := TRUE;
					
					IF SequencerPerpendicular.UpdateDone THEN
						SequencerPerpendicular.Update := FALSE;
						gRecipeMenagement.Load2M := FALSE;
						
						IF RecipeLoadedStationaryFlag THEN
							RecipeLoadedStationaryFlag := FALSE;
							WorkAutoMachine := READY;
						ELSE
							WorkAutoMachine := RETURN_SQ;
						END_IF;
					END_IF;
				
				LOAD_3M:
					gRecipeMenagement.Load3M := TRUE;
					gPerpendicularSettings.AccTorque := gRecipe3M.AccTorqueLimit;
					gPerpendicularSettings.FeedRate := gRecipe3M.SawFeedRate;
					gPerpendicularSettings.WoodLogLength := gRecipe3M.WoodLogLength;
					
					McAcpCamPar.State[1].MasterFactor := 125;
					McAcpCamPar.State[1].SlaveFactor := 200;
					McAcpCamPar.State[1].CompensationParameters.MasterCompDistance := 0.125;
					McAcpCamPar.State[1].CompensationParameters.SlaveCompDistance := 0.3;
				
					McAcpCamPar.State[2].MasterFactor := 125;
					McAcpCamPar.State[2].SlaveFactor := -200;
					McAcpCamPar.State[2].CompensationParameters.MasterCompDistance := 0.125;
					McAcpCamPar.State[2].CompensationParameters.SlaveCompDistance := -0.3;
				
					McAcpCamPar.State[3].MasterFactor := 2500;
					McAcpCamPar.State[3].SlaveFactor := 0;
					McAcpCamPar.State[3].CompensationMode := mcCOMP_OFF;
				
					SequencerPerpendicular.Update := TRUE;
					
					IF SequencerPerpendicular.UpdateDone THEN
						SequencerPerpendicular.Update := FALSE;
						gRecipeMenagement.Load3M := FALSE;
						
						IF RecipeLoadedStationaryFlag THEN
							RecipeLoadedStationaryFlag := FALSE;
							WorkAutoMachine := READY;
						ELSE
							WorkAutoMachine := RETURN_SQ;
						END_IF;
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

