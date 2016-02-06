ScriptName = "msEnterFromRight"
msEnterFromRight = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromRight:Name()
	return "Smart Animation ..."
end

function msEnterFromRight:Version()
	return "1.1"
end

function msEnterFromRight:Description()
	return "Cause layer to enter from the Right."
end

function msEnterFromRight:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromRight:UILabel()
	return "Enter From Right ..."
end

-- 15 minutes

function msEnterFromRight:Run(moho)
	self.frame =  moho.frame
	self.moho = moho
	self.borderScale = 1.6
	self.ingressFrames = 10
	self.resolveFrames = 20
	self.bounceScale = 1.05
	self.visibilityStart = 1
	msSmartAnimation:SetBorder(moho.document:AspectRatio() * self.borderScale)
	-- msSmartAnimation:SetBorder(self.borderScale)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	-- self.startX = layer.fTranslation:GetValue(self.frame).x
	msSmartAnimation:EnterFromRight(layer,self.visibilityStart, self.frame, self.ingressFrames, self.resolveFrames, self.bounceScale)
end
