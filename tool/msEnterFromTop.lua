ScriptName = "msEnterFromTop"
msEnterFromTop = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromTop:Name()
	return "Enter From Top ..."
end

function msEnterFromTop:Version()
	return "1.1"
end

function msEnterFromTop:Description()
	return "Cause layer to enter from the Top."
end

function msEnterFromTop:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromTop:UILabel()
	return "Enter From Top ..."
end

function msEnterFromTop:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:Enter(layer, 1, moho.frame, msSmartAnimation.TOP)
end
