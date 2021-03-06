ScriptName = "msEnterFromLeft"
msEnterFromLeft = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromLeft:Name()
	return "Enter From Left ..."
end

function msEnterFromLeft:Version()
	return "1.1"
end

function msEnterFromLeft:Description()
	return "Cause layer to enter from the Left."
end

function msEnterFromLeft:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromLeft:UILabel()
	return "Enter From Left ..."
end

function msEnterFromLeft:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:Enter(layer, 1, moho.frame, msSmartAnimation.LEFT)
end
