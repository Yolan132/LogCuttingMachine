
TYPE
	gOperatingPanelTyp : 	STRUCT 
		diStart : BOOL;
		diHomeParallel : BOOL;
		diHomePerpendicular : BOOL;
		StartSequence : BOOL;
		StopSequence : BOOL;
		SwitchModeToAuto : USINT;
		SwitchModeToMan : BOOL;
	END_STRUCT;
	gConvoyerSettingsType : 	STRUCT 
		doReadyToWork : BOOL;
		diRun : BOOL;
		aiSpeed : REAL;
	END_STRUCT;
	gParallelSettingsType : 	STRUCT 
		doReadyToWork : BOOL;
		aiParallelStep : REAL;
		diRight : BOOL;
		diLeft : BOOL;
		AutoReady : BOOL;
		ReadyToChange : BOOL;
		AfterSwitchFlag : BOOL;
	END_STRUCT;
	gPerpendicularSettingsType : 	STRUCT 
		doReadyToWork : BOOL;
		aiPerpendicularStep : REAL;
		diForward : BOOL;
		diBackward : BOOL;
		AutoReady : BOOL;
		ReadyToChange : BOOL;
		AfterSwitchFlag : BOOL;
	END_STRUCT;
END_TYPE
