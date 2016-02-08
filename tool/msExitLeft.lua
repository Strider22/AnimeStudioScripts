ScriptName = "msExitLeft"
msExitLeft = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msExitLeft:Name()
	return "Exit Left ..."
end

function msExitLeft:Version()
	return "1.1"
end

function msExitLeft:Description()
	return "Cause layer to exit to the Left."
end

function msExitLeft:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msExitLeft:UILabel()
	return "Exit Left ..."
end

function msExitLeft:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:Init(moho)
	msSmartAnimation:Exit(layer, moho.frame, msSmartAnimation.LEFT)
end
