ScriptName = "msEnterFromTop"
msEnterFromTop = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEnterFromTop:Name()
	return "Smart Animation ..."
end

function msEnterFromTop:Version()
	return "1.1"
end

function msEnterFromTop:Description()
	return "Cause layer to enter from the Top."
end

function msEnterFromTop:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEnterFromTop:UILabel()
	return "Enter From Top ..."
end

-- 15 minutes

function msEnterFromTop:Run(moho)
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
	msSmartAnimation:EnterFromTop(layer,self.visibilityStart, self.frame, self.ingressFrames, self.resolveFrames, self.bounceScale)
end
