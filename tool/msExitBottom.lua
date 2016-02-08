ScriptName = "msExitBottom"
msExitBottom = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msExitBottom:Name()
	return "Exit Bottom ..."
end

function msExitBottom:Version()
	return "1.1"
end

function msExitBottom:Description()
	return "Cause layer to exit to the Bottom."
end

function msExitBottom:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msExitBottom:UILabel()
	return "Exit Bottom ..."
end

function msExitBottom:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:Init(moho)
	msSmartAnimation:Exit(layer, moho.frame, msSmartAnimation.BOTTOM)
end
