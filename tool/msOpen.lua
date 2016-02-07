ScriptName = "msOpen"
msOpen = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msOpen:Name()
	return "Open ..."
end

function msOpen:Version()
	return "1.1"
end

function msOpen:Description()
	return "Cause layer to Open."
end

function msOpen:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msOpen:UILabel()
	return "Open ..."
end

function msOpen:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:Init(moho)
	msSmartAnimation:Open(layer, moho.frame)
end
