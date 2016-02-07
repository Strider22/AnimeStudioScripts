ScriptName = "msExitRight"
msExitRight = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msExitRight:Name()
	return "Exit Right ..."
end

function msExitRight:Version()
	return "1.1"
end

function msExitRight:Description()
	return "Cause layer to exit to the right."
end

function msExitRight:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msExitRight:UILabel()
	return "Exit Right ..."
end

function msExitRight:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:Init(moho)
	msSmartAnimation:ExitRight(layer, moho.frame)
end
