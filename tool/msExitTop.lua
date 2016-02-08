ScriptName = "msExitTop"
msExitTop = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msExitTop:Name()
	return "Exit Top ..."
end

function msExitTop:Version()
	return "1.1"
end

function msExitTop:Description()
	return "Cause layer to exit to the Top."
end

function msExitTop:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msExitTop:UILabel()
	return "Exit Top ..."
end

function msExitTop:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:Init(moho)
	msSmartAnimation:Exit(layer, moho.frame, msSmartAnimation.TOP)
end
