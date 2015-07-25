-- Demonstrates how to enable the script only if a group layer is selected
ScriptName = "msEx7EnableForGroup"
msEx7EnableForGroup = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEx7EnableForGroup:Name()
	return "7) Enable For Group Layers"
end

function msEx7EnableForGroup:Version()
	return "1.0"
end

function msEx7EnableForGroup:Description()
	return MOHO.Localize("/Scripts/Menu/Ex7EnableForGroup/Description=Demonstrates how to enable the script only if a group layer is selected.")
end

function msEx7EnableForGroup:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEx7EnableForGroup:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/Ex7EnableForGroup/Ex7EnableForGroup=7) Enable For Group Layers"))
end

-- Only enable the script if a group layer is selected
function msEx7EnableForGroup:IsEnabled(moho)
	if moho.layer:IsGroupType() then
		return true
	end
	return false
end

	
-- **************************************************
-- The guts of this script
-- **************************************************

function msEx7EnableForGroup:Run(moho)
	print("A group layer was selected")
end

