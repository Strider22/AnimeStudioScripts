ScriptName = "msEnterFromLeft"
msEnterFromLeft = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromLeft:Name()
	return "Smart Animation ..."
end

function msEnterFromLeft:Version()
	return "1.1"
end

function msEnterFromLeft:Description()
	return "Cause layer to enter from the Left."
end

function msEnterFromLeft:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromLeft:UILabel()
	return "Enter From Left ..."
end

-- 15 minutes

function msEnterFromLeft:Run(moho)
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
	msSmartAnimation:EnterFromLeft(layer,self.visibilityStart, self.frame, self.ingressFrames, self.resolveFrames, self.bounceScale)
end
