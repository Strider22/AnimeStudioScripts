-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_MitchelAlert"

-- **************************************************
-- General information about this script
-- **************************************************

MS_MitchelAlert = {}

function MS_MitchelAlert:Name()
	return "Mitchel Alert"
end

function MS_MitchelAlert:Version()
	return "6.0"
end

function MS_MitchelAlert:Description()
	return MOHO.Localize("/Scripts/Menu/Alert/Description=Mitchel Alert test script")
end

function MS_MitchelAlert:Creator()
	return "Mitchel Soltys"
end

function MS_MitchelAlert:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Alert/Alert=Mitchel Alert"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function MS_MitchelAlert:Run()
	LM.GUI.Alert(LM.GUI.ALERT_INFO,
		MOHO.Localize("/Scripts/Menu/Alert/ScriptsCanDisplayAlertBoxes=Mitchel's Test Alert"),
		nil,
		nil,
		MOHO.Localize("/Scripts/OK=OK"),
		nil,
		nil)
end
