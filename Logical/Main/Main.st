
PROGRAM _INIT
	ConveyorSpeed := 1;
	PerpendicularStep := 0.2;
	ParallelStep := 0.2;

END_PROGRAM

PROGRAM _CYCLIC
	gConveyorSettings.diActive := RunConveyor;
	gConveyorSettings.aiSpeed := ConveyorSpeed;
	
	gPerpendicularAxisSettings.diForward := SawForward;
	gPerpendicularAxisSettings.diBackward := SawBackward;
	gPerpendicularAxisSettings.aiPerpendicularStep := PerpendicularStep;
	gPerpendicularAxisSettings.diRunAxis := SawRunAxis;
	
	gParallelAxisSettings.diLeft := SawLeft;
	gParallelAxisSettings.diRight := SawRight;
	gParallelAxisSettings.aiParallelStep := ParallelStep;
	gParallelAxisSettings.diRunAxis := SawRunAxis;
	
	gSawOn := SawOn;
	
	Saw_SimOutputs.doSawOn := gSawOn;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

