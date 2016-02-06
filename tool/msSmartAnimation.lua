msSmartAnimation = {}

msSmartAnimation.borderScale = 1.6
msSmartAnimation.ingressFrames = 10
msSmartAnimation.resolveFrames = 20
msSmartAnimation.bounceScale = 1.05
msSmartAnimation.visibilityStart = 1


function msSmartAnimation:Creator()
	return "Mitchel Soltys"
end

function msSmartAnimation:EnterFromLeft(layer, visibilityOffFrame, startFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local startValue = -self.border - bounds.fMax.x 
	local travelDistance = location.x - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - ingressFrames) 

	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.x = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.x = startValue
	self:SetLocation(channel, startFrame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:SetBorder(border)
	self.border = border
end

function msSmartAnimation:EnterFromRight(layer, visibilityOffFrame, startFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local startValue = self.border - bounds.fMin.x 
	local travelDistance = location.x - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - ingressFrames) 

	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.x = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.x = startValue
	self:SetLocation(channel, startFrame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromTop(layer, visibilityOffFrame, startFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local startValue = self.border - bounds.fMin.y 
	local travelDistance = location.y - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - ingressFrames) 

	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.y = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.y = startValue
	self:SetLocation(channel, startFrame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:EnterFromBottom(layer, visibilityOffFrame, startFrame, ingressFrames, resolveFrames, overshoot)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local startValue = -self.border - bounds.fMax.y 
	local travelDistance = location.y - startValue

	self:VisibilityOff(layer, visibilityOffFrame, startFrame - ingressFrames) 

	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
	location.y = startValue + (travelDistance * overshoot)
	self:SetLocation(channel, startFrame, location, MOHO.INTERP_ELASTIC)
    location.y = startValue
	self:SetLocation(channel, startFrame - ingressFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:ExitRight(layer, startFrame, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)

	local finalValue = self.border - bounds.fMin.x 

<<<<<<< HEAD
	layer.fVisibility:SetValue(startFrame + 100 + resolveFrames, false)

	self:SetLocation(channel, startFrame + 100, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, startFrame + 100 + resolveFrames, location, MOHO.INTERP_SMOOTH)
=======
	layer.fVisibility:SetValue(startFrame + resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
end

function msSmartAnimation:ExitLeft(layer, startFrame, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local finalValue = -self.border - bounds.fMax.x 

	layer.fVisibility:SetValue(startFrame + resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.x = finalValue
	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitUp(layer, startFrame, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local finalValue = self.border - bounds.fMin.y 

	layer.fVisibility:SetValue(startFrame + resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.y = finalValue
	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:ExitDown(layer, startFrame, resolveFrames)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	bounds = layer:Bounds(startFrame)
	location = channel:GetValue(startFrame)
	local finalValue = -self.border - bounds.fMax.y

	layer.fVisibility:SetValue(startFrame + resolveFrames, false)

	self:SetLocation(channel, startFrame, location, MOHO.INTERP_SMOOTH)
	location.y = finalValue
	self:SetLocation(channel, startFrame + resolveFrames, location, MOHO.INTERP_SMOOTH)
end


function msSmartAnimation:SetLocation(channel, frame, location, interp)
	channel:SetValue(frame,location)
	channel:SetKeyInterp(frame,interp, 0, 0)	
end

function msSmartAnimation:VisibilityOff(layer, startFrame, endFrame)
		layer.fVisibility:SetValue(endFrame, true)
		layer.fVisibility:SetValue(startFrame, false)
end

