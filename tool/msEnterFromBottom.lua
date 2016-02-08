ScriptName = "msEnterFromBottom"
msEnterFromBottom = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromBottom:Name()
	return "Enter From Bottom ..."
end

function msEnterFromBottom:Version()
	return "1.1"
end

function msEnterFromBottom:Description()
	return "Cause layer to enter from the Bottom."
end

function msEnterFromBottom:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromBottom:UILabel()
	return "Enter From Bottom ..."
end

function msEnterFromBottom:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:Enter(layer, 1, moho.frame, msSmartAnimation.BOTTOM)
end
