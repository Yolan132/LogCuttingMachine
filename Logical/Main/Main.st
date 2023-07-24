
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
			
			IF gParallelSettings.doReadyToWork AND gPerpendicularSettings.doReadyToWork AND gConveyorSettings.doReadyToWork THEN
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
			gConveyorSettings.aiSpeed := (ConveyorSpeed / 100);
	
			gParallelSettings.diLeft := SawLeft;
			gParallelSettings.diRight := SawRight;
			gParallelSettings.aiParallelStep := ParallelStep;
			
			gPerpendicularSettings.diForward := SawForward;
			gPerpendicularSettings.diBackward := SawBackward;
			gPerpendicularSettings.aiPerpendicularStep := PerpendicularStep;
			
			IF SawOn THEN
				gSawOn := TRUE;
			END_IF;
			
			IF SawOff THEN
	  			gSawOn := FALSE;
			END_IF;
			
			IF ConveyorOn THEN
	  			gConveyorSettings.diRun := TRUE;
			END_IF;
			
			IF ConveyorOff THEN
				gConveyorSettings.diRun := FALSE;
			END_IF;
	
			Saw_SimOutputs.doSawOn := gSawOn;
			
		AUTO:
		
		
		ERROR:
		
		WAIT_FOR_INIT:
			IF EDGEPOS(InitializeMachine) THEN
	  			SMachine := INIT;
			END_IF;
		  

	END_CASE;
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

