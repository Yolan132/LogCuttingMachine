
TYPE
	InitProcessTyp : 
		(
		INIT := 0,
		POWER := 1,
		HOME := 2,
		DONE := 3
		);
	WorkProcessTyp : 
		(
		WAIT := 0,
		RUN := 1,
		UPDATE
		);
	MenagementTyp : 
		(
		IDLE := 0,
		WARMUP := 1,
		WORK_M := 2,
		WORK_A := 3
		);
END_TYPE
