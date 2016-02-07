-- This script intentionally contains a syntax error.
-- The purpose is to show what an error looks like in the Lua console window.

-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_Test3"

-- **************************************************
-- General information about this script
-- **************************************************

LM_Test3 = {}

function LM_Test3:Name()
	return "Error Test"
end

function LM_Test3:Version()
	return "6.0"
end

function LM_Test3:Description()
	return MOHO.Localize("/Scripts/Menu/Test3/Description=This script intentionally causes a runtime error.")
end

function LM_Test3:Creator()
	return "Smith Micro Software, Inc."
end

function LM_Test3:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Test3/ErrorTest=Error Test"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_Test3:Run()
	LM.GUI.Alert(LM.GUI.ALERT_INFO,
		MOHO.Localize("/Scripts/Menu/Test3/Alert1=This script is about to produce"),
		MOHO.Localize("/Scripts/Menu/Test3/Alert2=an intentional error."),
		MOHO.Localize("/Scripts/Menu/Test3/Alert3=The error will appear in the Lua console."),
		MOHO.Localize("/Scripts/OK=OK"),
		nil,
		nil)
	foo:Bar()
end
