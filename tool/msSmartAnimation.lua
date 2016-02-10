msSmartAnimation = {}

msSmartAnimation.startFrame = 10
msSmartAnimation.endFrame = 50
-- how many liner frames when entering
msSmartAnimation.enterIngressFrames = 8
-- what ratio of the total travel on ingress
msSmartAnimation.enterOvershootScale = 1.03
-- how many elastic frames on enter
msSmartAnimation.enterResolveFrames = 17
msSmartAnimation.exitFrames = 20
-- how many frames in plopIn
msSmartAnimation.plopInIngressFrames = 5
msSmartAnimation.plopInResolveFrames = 15
msSmartAnimation.plopInScale = .5
-- how many frames in plopOut
msSmartAnimation.plopOutFrames = 20
msSmartAnimation.plopOutBounceCount = 2
msSmartAnimation.plopOutScale = .5

--how much further than the screen do we move the object
msSmartAnimation.borderScale = 1.6
msSmartAnimation.minScale = .02

-- what frame should visiblity start at
msSmartAnimation.visibilityStart = 1
msSmartAnimation.aspectRatio = 1

-- Enter and Exit Directions
msSmartAnimation.LEFT = 1
msSmartAnimation.RIGHT = 2
msSmartAnimation.TOP = 3
msSmartAnimation.BOTTOM = 4

function msSmartAnimation:Creator()
	return "Mitchel Soltys"
end

function msSmartAnimation:Init(moho)
	self.aspectRatio = moho.document:AspectRatio()
end

-- function msSmartAnimation:SetDefaults(ingressFrames, resolveFrames, bounceScale, visibilityStart, closeFrames, moho)
	-- self:Init(moho)
	-- self.ingressFrames = ingressFrames
	-- self.resolveFrames = resolveFrames
	-- self.bounceScale = bounceScale
	-- self.closeFrames = closeFrames
	-- self.visibilityStart = visibilityStart
-- end


function msSmartAnimation:Enter(layer, visibilityOffFrame, frame, direction)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	local border
	local startValue
	local travelDistance
	bounds = layer:Bounds(frame)
	location = channel:GetValue(frame)

	if(direction == msSmartAnimation.LEFT) then
		border = self.aspectRatio * self.borderScale
		startValue = -border - bounds.fMax.x 
		travelDistance = location.x - startValue
	elseif (direction == msSmartAnimation.RIGHT) then
		border = self.aspectRatio * self.borderScale
		startValue = border - bounds.fMin.x 
		travelDistance = location.x - startValue
	elseif (direction == msSmartAnimation.TOP) then
		border = self.borderScale
		startValue = border - bounds.fMin.y 
		travelDistance = location.y - startValue
	else 
		border = self.borderScale
		startValue = -border - bounds.fMax.y 
		travelDistance = location.y - startValue
	end
	
	
	-- VISIBILITY
	self:VisibilityOff(layer, visibilityOffFrame, frame - self.enterIngresFrames)

	-- FINAL POSITION
	self:SetLocation(channel, frame + self.enterResolveFrames, location, MOHO.INTERP_SMOOTH)

	-- BOUNCE POSITION
	if((direction == msSmartAnimation.LEFT) or (direction == msSmartAnimation.RIGHT))then
		location.x = startValue + (travelDistance * self.bounceScale)
	else 
		location.y = startValue + (travelDistance * self.bounceScale)
	end
	self:SetLocation(channel, frame, location, MOHO.INTERP_ELASTIC)

	-- START POSITION
	if((direction == msSmartAnimation.LEFT) or (direction == msSmartAnimation.RIGHT))then
		location.x = startValue
	else 
		location.y = startValue
	end
	self:SetLocation(channel, frame - self.enterIngresFrames, location, MOHO.INTERP_LINEAR)
end

function msSmartAnimation:Exit(layer, frame, direction)
	local location = LM.Vector3:new_local()
	local bounds = LM.BBox:new_local()
	local channel = layer.fTranslation
	local border
	local finalValue
	
	bounds = layer:Bounds(frame)
	location = channel:GetValue(frame)

	if(direction == msSmartAnimation.LEFT) then
		border = self.aspectRatio * self.borderScale
		finalValue = -border - bounds.fMax.x 
	elseif (direction == msSmartAnimation.RIGHT) then
		border = self.aspectRatio * self.borderScale
		finalValue = border - bounds.fMin.x 
	elseif (direction == msSmartAnimation.TOP) then
		border = self.borderScale
		finalValue = border - bounds.fMin.y 
	else 
		border = self.borderScale
		finalValue = -border - bounds.fMax.y 
	end

	layer.fVisibility:SetValue(frame, false)

	self:SetLocation(channel, frame -  self.exitFrames, location, MOHO.INTERP_SMOOTH)
	if((direction == msSmartAnimation.LEFT) or (direction == msSmartAnimation.RIGHT))then
		location.x = finalValue
	else 
		location.y = finalValue
	end
	self:SetLocation(channel, frame, location, MOHO.INTERP_SMOOTH)
end

function msSmartAnimation:PlopOut(layer, frame)
	local scale = LM.Vector3:new_local()
	local channel = layer.fScale
	scale = channel:GetValue(frame)

	layer.fVisibility:SetValue(frame, false)

	channel:SetValue(frame - self.plopOutFrames,scale)
	channel:SetKeyInterp(frame  - self.plopOutFrames,MOHO.INTERP_ELASTIC, 10000 + msSmartAnimation.plopOutBounceCount, 0.5)
	scale.x = self.minScale
	scale.y = self.minScale
	channel:SetValue(frame,scale)
	channel:SetKeyInterp(frame, MOHO.INTERP_SMOOTH, 0, 0)	
end

function msSmartAnimation:PlopIn(layer, frame)
	local scale = LM.Vector3:new_local()
	local channel = layer.fScale
	scale = channel:GetValue(frame)

	self:VisibilityOff(layer,self.visibilityStart,frame - self.plopInIngressFrames)

	channel:SetValue(frame + self.plopInResolveFrames,scale)
	channel:SetKeyInterp(frame + self.plopInResolveFrames, MOHO.INTERP_SMOOTH, 0, 0)	
	scale.x = self.minScale
	scale.y = self.minScale
	channel:SetValue(frame - self.plopInIngressFrames,scale)
	channel:SetKeyInterp(frame- self.plopInIngressFrames,MOHO.INTERP_ELASTIC, 0 , 0.5)	
end

function msSmartAnimation:SetLocation(channel, frame, location, interp)
	channel:SetValue(frame,location)
	channel:SetKeyInterp(frame,interp, 0, 0)	
end

function msSmartAnimation:VisibilityOff(layer, startFrame, endFrame)
		layer.fVisibility:SetValue(endFrame, true)
		layer.fVisibility:SetValue(startFrame, false)
end

