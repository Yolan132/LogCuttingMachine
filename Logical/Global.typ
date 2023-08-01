
TYPE
	gRecipeMenagmentType : 	STRUCT 
		Load1M : BOOL;
		Save1M : BOOL;
		Save2M : BOOL;
		Load2M : BOOL;
		Save3M : BOOL;
		Load3M : BOOL;
	END_STRUCT;
	gConvoyerSettingsType : 	STRUCT 
		doReadyToWork : BOOL;
		diRun : BOOL;
		aiSpeed : REAL;
	END_STRUCT;
	gOperatingPanelTyp : 	STRUCT 
		diStart : BOOL;
		diHomeParallel : BOOL;
		diHomePerpendicular : BOOL;
		StartSequence : BOOL;
		StopSequence : BOOL;
		SwitchModeToAuto : BOOL;
		SwitchModeToMan : BOOL;
		LoadRecipe1M : BOOL;
		LoadRecipe2M : BOOL;
		LoadRecipe3M : BOOL;
		SaveRecipe1M : BOOL;
		SaveRecipe2M : BOOL;
		SaveRecipe3M : BOOL;
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
		AccTorque : REAL;
		WoodLogLength : REAL;
		FeedRate : REAL;
	END_STRUCT;
	gRecipe1MTyp : 	STRUCT 
		WoodLogLength : REAL := 1;
		AccTorqueLimit : REAL := 10;
		SawFeedRate : REAL := 3;
	END_STRUCT;
	gRecipe2MTyp : 	STRUCT 
		WoodLogLength : REAL := 2;
		AccTorqueLimit : REAL := 10;
		SawFeedRate : REAL := 3;
	END_STRUCT;
	gRecipe3MTyp : 	STRUCT 
		WoodLogLength : REAL := 3;
		AccTorqueLimit : REAL := 10;
		SawFeedRate : REAL := 3;
	END_STRUCT;
END_TYPE
