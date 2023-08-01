
PROGRAM _INIT
	gRecipe1M.SawFeedRate := gRecipe1M.SawFeedRate;
	gRecipe2M.SawFeedRate := gRecipe2M.SawFeedRate;
	gRecipe3M.SawFeedRate := gRecipe3M.SawFeedRate;
	
	gPerpendicularSettings.AutoReady := gPerpendicularSettings.AutoReady;
	
	MpRecipeXml_0(MpLink := ADR(gRecipeXml), Enable := TRUE, DeviceName := ADR('USER'), FileName := ADR('Recipe1m'));
	MpRecipeRegPar_0(MpLink := ADR(gRecipeXml), Enable := TRUE, PVName := ADR('gRecipe1M'));
	
	MpRecipeXml_1(MpLink := ADR(gRecipeXml_1), Enable := TRUE, DeviceName := ADR('USER'), FileName := ADR('Recipe2m'));
	MpRecipeRegPar_1(MpLink := ADR(gRecipeXml_1), Enable := TRUE, PVName := ADR('gRecipe2M'));
	
	MpRecipeXml_2(MpLink := ADR(gRecipeXml_2), Enable := TRUE, DeviceName := ADR('USER'), FileName := ADR('Recipe3m'));
	MpRecipeRegPar_2(MpLink := ADR(gRecipeXml_2), Enable := TRUE, PVName := ADR('gRecipe3M'));
	
END_PROGRAM

PROGRAM _CYCLIC
	MpRecipeXml_0.Save := gRecipeMenagement.Save1M;
	MpRecipeXml_0.Load := gRecipeMenagement.Load1M;
	
	MpRecipeXml_1.Save := gRecipeMenagement.Save2M;
	MpRecipeXml_1.Load := gRecipeMenagement.Load2M;
	
	MpRecipeXml_2.Save := gRecipeMenagement.Save3M;
	MpRecipeXml_2.Load := gRecipeMenagement.Load3M;
	
	
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	
	MpRecipeXml_1();
	MpRecipeRegPar_1();
	
	MpRecipeXml_2();
	MpRecipeRegPar_2();
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

