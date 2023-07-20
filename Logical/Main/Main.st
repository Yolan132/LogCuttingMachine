
PROGRAM _INIT
	ConveyorSpeed := 1;
	PerpendicularStep := 0.2;
	ParallelStep := 0.2;
	
	OperatingMode := 0;
	
	gStateSetter := 0;
	SMachine := WAIT_FOR_INIT;

END_PROGRAM

PROGRAM _CYCLIC
	
	CASE SMachine OF
		INIT:
			gStateSetter := 1;
			
			IF gParallelSettings.doReadyToWork AND gPerpendicularSettings.doReadyToWork THEN
	  			SMachine := READY;
			END_IF;
		
		READY:		
			IF EDGEPOS(gOperatingPanel.diStart) THEN
				IF OperatingMode = 1 THEN
					gStateSetter := 2;
					SMachine := MANUAL;
				END_IF;
				
				IF OperatingMode = 2 THEN
					gStateSetter := 3;
	  				SMachine := AUTO;
				END_IF;
			END_IF;
			
		MANUAL:
			gConveyorSettings.diActive := RunConveyor;
			gConveyorSettings.aiSpeed := ConveyorSpeed;
	
			gParallelSettings.diLeft := SawLeft;
			gParallelSettings.diRight := SawRight;
			gParallelSettings.aiParallelStep := ParallelStep;
			
			gPerpendicularSettings.diForward := SawForward;
			gPerpendicularSettings.diBackward := SawBackward;
			gPerpendicularSettings.aiPerpendicularStep := PerpendicularStep;
	
			gSawOn := SawOn;
	
			Saw_SimOutputs.doSawOn := gSawOn;
			
		AUTO:
		
		
		ERROR:
		
		WAIT_FOR_INIT:
			IF EDGEPOS(diInit) THEN
	  			SMachine := INIT;
			END_IF;
		  

	END_CASE;
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

