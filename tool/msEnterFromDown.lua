ScriptName = "msEnterFromBottom"
msEnterFromBottom = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromBottom:Name()
	return "Smart Animation ..."
end

function msEnterFromBottom:Version()
	return "1.1"
end

function msEnterFromBottom:Description()
	return "Cause layer to enter from the Bottom."
end

function msEnterFromBottom:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromBottom:UILabel()
	return "Enter From Bottom ..."
end

-- 15 minutes

function msEnterFromBottom:Run(moho)
	self.frame =  moho.frame
	self.moho = moho
	self.borderScale = 1.6
	self.ingressFrames = 10
	self.resolveFrames = 20
	self.bounceScale = 1.05
	self.visibilityStart = 1
	-- msSmartAnimation:SetBorder(moho.document:AspectRatio() * self.borderScale)
	msSmartAnimation:SetBorder(self.borderScale)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	-- self.startX = layer.fTranslation:GetValue(self.frame).x
	msSmartAnimation:EnterFromBottom(layer,self.visibilityStart, self.frame, self.ingressFrames, self.resolveFrames, self.bounceScale)
end
