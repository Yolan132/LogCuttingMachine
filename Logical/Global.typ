
TYPE
	gOperatingPanelTyp : 	STRUCT 
		diStart : BOOL;
		diStop : BOOL;
	END_STRUCT;
	gConvoyerSettingsType : 	STRUCT 
		diActive : BOOL;
		aiSpeed : REAL;
	END_STRUCT;
	gParallelSettingsType : 	STRUCT 
		doReadyToWork : BOOL;
		aiParallelStep : REAL;
		diRight : BOOL;
		diLeft : BOOL;
	END_STRUCT;
	gPerpendicularSettingsType : 	STRUCT 
		doReadyToWork : BOOL;
		aiPerpendicularStep : REAL;
		diForward : BOOL;
		diBackward : BOOL;
	END_STRUCT;
END_TYPE
