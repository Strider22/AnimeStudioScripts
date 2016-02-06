
ScriptName = "msSmartAnimation"
msSmartAnimation = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msSmartAnimation:Name()
	return "Smart Animation ..."
end

function msSmartAnimation:Version()
	return "1.1"
end

function msSmartAnimation:Description()
	return "Utility for creating smart animations."
end

function msSmartAnimation:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msSmartAnimation:UILabel()
	return "Smart Animation ..."
end


function msSmartAnimation:EnterFromLeft(layer, visibilityOffFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local startValue = -self.border - bounds.fMax.x 
	local travelDistance = location.x - startValue

	self:VisibilityOff(layer, visibilityOffFrame, self.frame - ingressFrames) 

	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.x = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, self.frame, location, MOHO.INTERP_ELASTIC)
    location.x = startValue
	self:SetLocation(channel, self.frame - ingressFrames, location, MOHO.INTERP_LINEAR)
end


function msSmartAnimation:EnterFromRight(layer, visibilityOffFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local startValue = self.border - bounds.fMin.x 
	local travelDistance = location.x - startValue

	self:VisibilityOff(layer, visibilityOffFrame, self.frame - ingressFrames) 

	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.x = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, self.frame, location, MOHO.INTERP_ELASTIC)
    location.x = startValue
	self:SetLocation(channel, self.frame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromTop(layer, visibilityOffFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local startValue = self.border - bounds.fMin.y 
	local travelDistance = location.y - startValue

	self:VisibilityOff(layer, visibilityOffFrame, self.frame - ingressFrames) 

	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.y = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, self.frame, location, MOHO.INTERP_ELASTIC)
    location.y = startValue
	self:SetLocation(channel, self.frame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromBottom(layer, visibilityOffFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local startValue = -self.border - bounds.fMax.y 
	local travelDistance = location.y - startValue

	self:VisibilityOff(layer, visibilityOffFrame, self.frame - ingressFrames) 

	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.y = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, self.frame, location, MOHO.INTERP_ELASTIC)
    location.y = startValue
	self:SetLocation(channel, self.frame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:ExitRight(layer, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	location.x = self.startX
	local finalValue = self.border - bounds.fMin.x 

	layer.fVisibility:SetValue(self.frame + 100 + resolveFrames, false)

	self:SetLocation(channel, self.frame + 100, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, self.frame + 100 + resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitLeft(layer, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local finalValue = -self.border - bounds.fMax.x 

	layer.fVisibility:SetValue(self.frame + resolveFrames, false)

	self:SetLocation(channel, self.frame, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitUp(layer, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local finalValue = self.border - bounds.fMin.y 

	layer.fVisibility:SetValue(self.frame + resolveFrames, false)

	self:SetLocation(channel, self.frame, location, MOHO.INTERP_SMOOTH)
	location.y = finalValue
	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitDown(layer, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(self.frame)
	location = channel:GetValue(self.frame)
	local finalValue = -self.border - bounds.fMax.y

	layer.fVisibility:SetValue(self.frame + resolveFrames, false)

	self:SetLocation(channel, self.frame, location, MOHO.INTERP_SMOOTH)
	location.y = finalValue
	self:SetLocation(channel, self.frame + resolveFrames, location, MOHO.INTERP_SMOOTH)
end


function msSmartAnimation:SetLocation(channel, frame, location, interp)
	channel:SetValue(frame,location)
	channel:SetKeyInterp(frame,interp, 0, 0)	
end

function msSmartAnimation:VisibilityOff(layer, startFrame, endFrame)
		layer.fVisibility:SetValue(endFrame, true)
		layer.fVisibility:SetValue(startFrame, false)
end

-- **************************************************
-- The guts of this script
-- **************************************************
-- 2.5 hrs
-- 

function msSmartAnimation:Run(moho)
	self.frame =  moho.frame
	self.moho = moho
	self.borderScale = 1.6
	self.ingressFrames = 10
	self.resolveFrames = 20
	self.bounceScale = 1.05
	self.visibilityStart = 1
	self.border = moho.document:AspectRatio() * self.borderScale
	-- self.border = self.bordesrScale
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local layer = moho.layer
	
	self.startX = layer.fTranslation:GetValue(self.frame).x

	-- print("Layer location x ".. layerLocation.x .. " y " .. layerLocation.y)
	-- print("aspect ratio " .. moho.document:AspectRatio())
	--Translate layer
	-- print(moho.document:Width())
	self:EnterFromRight(layer,self.visibilityStart, self.ingressFrames, self.resolveFrames, self.bounceScale)
	self:ExitRight(layer,self.resolveFrames)
end
