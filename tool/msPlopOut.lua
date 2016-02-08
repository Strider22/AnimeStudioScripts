ScriptName = "msPlopOut"
msPlopOut = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPlopOut:Name()
	return "PlopOut an image ..."
end

function msPlopOut:Version()
	return "1.1"
end

function msPlopOut:Description()
	return "Cause layer to visually PlopOut."
end

function msPlopOut:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPlopOut:UILabel()
	return "PlopOut ..."
end

function msPlopOut:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:PlopOut(layer, moho.frame)
end
