ScriptName = "msPlopOut"
msPlopOut = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPlopOut:Name()
	return "Plop Out ..."
end

function msPlopOut:Version()
	return "1.1"
end

function msPlopOut:Description()
	return "Cause layer to plop out."
end

function msPlopOut:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPlopOut:UILabel()
	return "Plop out ..."
end

function msPlopOut:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	msSmartAnimation:Init(moho)
	msSmartAnimation:PlopOut(layer, moho.frame)
end
