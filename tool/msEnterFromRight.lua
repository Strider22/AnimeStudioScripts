ScriptName = "msEnterFromRight"
msEnterFromRight = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromRight:Name()
	return "Enter From Right ..."
end

function msEnterFromRight:Version()
	return "1.1"
end

function msEnterFromRight:Description()
	return "Cause layer to enter from the right."
end

function msEnterFromRight:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromRight:UILabel()
	return "Enter From Right ..."
end

function msEnterFromRight:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:EnterFromRight(layer, 1, moho.frame)
end
