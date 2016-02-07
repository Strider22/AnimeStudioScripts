ScriptName = "msClose"
msClose = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msClose:Name()
	return "Close an image ..."
end

function msClose:Version()
	return "1.1"
end

function msClose:Description()
	return "Cause layer to visually close."
end

function msClose:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msClose:UILabel()
	return "Close ..."
end

function msClose:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:Close(layer, moho.frame)
end
