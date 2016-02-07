ScriptName = "msPlopIn"
msPlopIn = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPlopIn:Name()
	return "Plop In ..."
end

function msPlopIn:Version()
	return "1.1"
end

function msPlopIn:Description()
	return "Cause layer to Plop In."
end

function msPlopIn:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPlopIn:UILabel()
	return "Plop In ..."
end

function msPlopIn:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:Init(moho)
	msSmartAnimation:PlopIn(layer, moho.frame)
end
