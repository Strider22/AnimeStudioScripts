msSmartAnimation = {}

--how much further than the screen do we move the object
msSmartAnimation.borderScale = 1.6
-- how many liner frames in enter
msSmartAnimation.ingressFrames = 8
-- how many elastic frames on enter
msSmartAnimation.resolveFrames = 17
-- what ratio of the total travel on ingress 
msSmartAnimation.bounceScale = 1.03
-- what frame should visiblity start at
msSmartAnimation.visibilityStart = 1
msSmartAnimation.aspectRatio = 1

function msSmartAnimation:Creator()
	return "Mitchel Soltys"
end

function msSmartAnimation:Init(moho)
	self.aspectRatio = moho.document:AspectRatio()
end

function msSmartAnimation:SetDefaults(ingressFrames, resolveFrames, bounceScale, visibilityStart, moho)
	self:Init(moho)
	self.ingressFrames = ingressFrames
	self.resolveFrames = resolveFrames
	self.bounceScale = bounceScale
	self.visibilityStart = visibilityStart
end

function msSmartAnimation:EnterFromLeft(layer, visibilityOffFrame, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	local border = self.aspectRatio * self.borderScale
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local startValue = -border - bounds.fMax.x 
	local travelDistance = location.x - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - self.ingressFrames) 

	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.x = startValue + (travelDistance * self.bounceScale)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.x = startValue
	self:SetLocation(channel, startFrame - self.ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromRight(layer, visibilityOffFrame, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	local border = self.aspectRatio * self.borderScale
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local startValue = border - bounds.fMin.x 
	local travelDistance = location.x - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - self.ingressFrames) 

	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.x = startValue + (travelDistance * self.bounceScale)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.x = startValue
	self:SetLocation(channel, startFrame - self.ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromTop(layer, visibilityOffFrame, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local border = self.borderScale
	local startValue = border - bounds.fMin.y 
	local travelDistance = location.y - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - self.ingressFrames) 

	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.y = startValue + (travelDistance * self.bounceScale)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.y = startValue
	self:SetLocation(channel, startFrame - self.ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromBottom(layer, visibilityOffFrame, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local border = self.borderScale
	local startValue = -border - bounds.fMax.y 
	local travelDistance = location.y - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - self.ingressFrames) 

	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.y = startValue + (travelDistance * self.bounceScale)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.y = startValue
	self:SetLocation(channel, startFrame - self.ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:ExitRight(layer, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	local border = self.aspectRatio * self.borderScale
	location = channel:GetValue(startFrame)

	local finalValue = border - bounds.fMin.x 

	layer.fVisibility:SetValue(startFrame + self.resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitLeft(layer, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	local border = self.aspectRatio * self.borderScale
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local finalValue = -border - bounds.fMax.x 

	layer.fVisibility:SetValue(startFrame + self.resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitUp(layer, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local border = self.borderScale
	local finalValue = border - bounds.fMin.y 

	layer.fVisibility:SetValue(startFrame + self.resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.y = finalValue
	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitDown(layer, startFrame)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local border = self.borderScale
	local finalValue = -border - bounds.fMax.y

	layer.fVisibility:SetValue(startFrame + self.resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.y = finalValue
	self:SetLocation(channel, startFrame + self.resolveFrames, location, MOHO.INTERP_SMOOTH)
end


function msSmartAnimation:SetLocation(channel, frame, location, interp)
	channel:SetValue(frame,location)
	channel:SetKeyInterp(frame,interp, 0, 0)	
end

function msSmartAnimation:VisibilityOff(layer, startFrame, endFrame)
		layer.fVisibility:SetValue(endFrame, true)
		layer.fVisibility:SetValue(startFrame, false)
end

