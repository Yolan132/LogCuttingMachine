
TYPE
	WorkAutoProcessTyp : 
		(
		START_POSITION := 0,
		READY := 1,
		CUT_SQ := 2,
		RETURN_SQ := 3,
		SWITCH_MODE := 4,
		END_POSITION
		);
	InitProcessTyp : 
		(
		INIT := 0,
		POWER := 1,
		HOME := 2,
		DONE := 3
		);
	WorkManProcessTyp : 
		(
		WAIT := 0,
		RUN := 1,
		HOMEAGAIN := 2
		);
	MenagementTyp : 
		(
		IDLE := 0,
		WARMUP := 1,
		WORK_M := 2,
		WORK_A := 3
		);
END_TYPE
