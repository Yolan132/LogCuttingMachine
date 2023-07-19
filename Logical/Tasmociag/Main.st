
PROGRAM _INIT
	MpAxisConveyor.Enable := TRUE;
	MpAxisConveyor.MpLink := ADR(gConveyorAxis);
	MpAxisConveyor.Parameters := ADR(MpConveyorPar);
	
	SMachine := INIT;
	
END_PROGRAM

PROGRAM _CYCLIC	
	MpAxisConveyor();
	MpConveyorPar.Velocity := gConveyorSettings.aiSpeed;
	
	CASE SMachine OF
		INIT:
			MpAxisConveyor.Power := FALSE;
			MpAxisConveyor.Home := FALSE;
			MpAxisConveyor.MoveVelocity := FALSE;
			
			IF EDGEPOS(gConveyorSettings.diActive) AND MpAxisConveyor.Info.ReadyToPowerOn THEN
	  			SMachine := POWER;
			END_IF;
			
		POWER:
			MpAxisConveyor.Power := TRUE;
			
			IF MpAxisConveyor.PowerOn THEN
	  			SMachine := HOME;
			END_IF;
		HOME:
			IF NOT(MpAxisConveyor.IsHomed) THEN
				MpAxisConveyor.Home := TRUE;
			END_IF;
			
			IF MpAxisConveyor.IsHomed THEN
	  			SMachine := RUN;
			END_IF;
			
		RUN:
			MpAxisConveyor.MoveVelocity := TRUE;
			
			IF MpAxisConveyor.InVelocity THEN
	  			Saw_SimOutputs.aoTreeVelocity := MpAxisConveyor.Velocity;
			END_IF;
		
			IF NOT(gConveyorSettings.diActive) THEN
				Saw_SimOutputs.aoTreeVelocity := 0;
				SMachine := INIT;
			END_IF;

	END_CASE;
	
	

END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

