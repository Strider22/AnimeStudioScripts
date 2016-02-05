-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_Test1"

-- **************************************************
-- General information about this script
-- **************************************************

LM_Test1 = {}

function LM_Test1:Name()
	return "Print Test"
end

function LM_Test1:Version()
	return "6.0"
end

function LM_Test1:Description()
	return MOHO.Localize("/Scripts/Menu/Test1/Description=Printing test script")
end

function LM_Test1:Creator()
	return "Smith Micro Software, Inc."
end

function LM_Test1:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Test1/PrintTest=Print Test"))
end

-- **************************************************
-- Recurring values
-- **************************************************

LM_Test1.runCount = 0

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_Test1:Run(moho)
	LM.GUI.Alert(LM.GUI.ALERT_INFO, MOHO.Localize("/Scripts/Menu/Test1/Alert1=This script shows how to print with Lua."),
		MOHO.Localize("/Scripts/Menu/Test1/Alert2=This can be very useful when debugging scripts."),
		nil,
		MOHO.Localize("/Scripts/OK=OK"),
		nil,
		nil)
	print("*** Print Test ***")
	self.runCount = self.runCount + 1
	print("This script has run " .. self.runCount .. " time(s).")
end
