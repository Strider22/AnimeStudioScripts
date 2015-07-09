-- Demonstrates how to the script only if a group layer is selected
ScriptName = "msEx7EnableForGroup"
msEx7EnableForGroup = {}

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

