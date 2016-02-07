-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_Test2"

-- **************************************************
-- General information about this script
-- **************************************************

LM_Test2 = {}

function LM_Test2:Name()
	return "Alert Test"
end

function LM_Test2:Version()
	return "6.0"
end

function LM_Test2:Description()
	return MOHO.Localize("/Scripts/Menu/Test2/Description=Alert box test script")
end

function LM_Test2:Creator()
	return "Smith Micro Software, Inc."
end

function LM_Test2:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Test2/AlertTest=Alert Test"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_Test2:Run()
	LM.GUI.Alert(LM.GUI.ALERT_INFO,
		MOHO.Localize("/Scripts/Menu/Test2/ScriptsCanDisplayAlertBoxes=Scripts can display alert boxes."),
		nil,
		nil,
		MOHO.Localize("/Scripts/OK=OK"),
		nil,
		nil)
end
