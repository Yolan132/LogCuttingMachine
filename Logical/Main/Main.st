
PROGRAM _INIT
	ConveyorSpeed := 1;
	PerpendicularStep := 0.2;
	ParallelStep := 0.2;
	
	OperatingMode := 0;
	
	gStateSetter := 0;
	SMachine := WAIT_FOR_INIT;
	
	gInitProgressBarValue := 0;

END_PROGRAM

PROGRAM _CYCLIC
	
	CASE SMachine OF
		INIT:
			gStateSetter := 1;
			
			IF gParallelSettings.doReadyToWork THEN
				gInitProgressBarValue := 60;
				
				IF gPerpendicularSettings.doReadyToWork THEN
					gInitProgressBarValue := 130;
					
					IF gConveyorSettings.doReadyToWork THEN
						gInitProgressBarValue := 200;
						
						SMachine := READY;
					END_IF;
				END_IF;
			END_IF;
		
		READY:	
			gInitProgressBarValue := 255;
			
			IF HMIman THEN
	  			OperatingMode := 1;
			END_IF;
			
			IF HMIauto THEN
	  			OperatingMode := 2;
			END_IF;
			
			
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
			IF EDGEPOS(diInitializeMachine) THEN
	  			SMachine := INIT;
			END_IF;
		  

	END_CASE;
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

