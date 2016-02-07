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
	return "Enter From Right ..."
end

function msExitRight:Run(moho)
	self.frame =  moho.frame
	self.moho = moho
	self.borderScale = 1.6
	self.ingressFrames = 10
	self.resolveFrames = 20
	self.bounceScale = 1.05
	self.visibilityStart = 1
	msSmartAnimation:SetBorder(moho.document:AspectRatio() * self.borderScale)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer

	msSmartAnimation:ExitRight(layer,self.frame, self.resolveFrames)
end
