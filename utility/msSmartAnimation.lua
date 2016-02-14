msSmartAnimation = {}

msSmartAnimation.settingsLoaded = false
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
	self.moho = moho

	if(not self.settingsLoaded) then
		self.settingsLoaded = true
		self:SetDefaultValues()
		self:LoadSettings()
	end
end

function msSmartAnimation:SetDefaultValues()
	-- how many liner frames when entering
	msSmartAnimation.enterIngressFrames = 8
	-- what ratio of the total travel on Ingress
	msSmartAnimation.enterOvershootScale = 1.03
	-- how many elastic frames on enter
	msSmartAnimation.enterResolveFrames = 17
	msSmartAnimation.exitFrames = 20
	-- how many frames in plopIn
	msSmartAnimation.plopInIngressFrames = 5
	msSmartAnimation.plopInResolveFrames = 15
	msSmartAnimation.plopInScale = .5
	-- how many frames in plopOut
	msSmartAnimation.plopOutFrames = 30
	msSmartAnimation.plopOutEndFrames = 15
	msSmartAnimation.plopOutBounceCount = 2
	msSmartAnimation.plopOutScale = .5

	--how much further than the screen do we move the object
	msSmartAnimation.borderScale = 1.6
	msSmartAnimation.minScale = .02
end

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
	self:VisibilityOff(layer, visibilityOffFrame, frame - self.enterIngressFrames)

	-- FINAL POSITION
	self:SetLocation(channel, frame + self.enterResolveFrames, location, MOHO.INTERP_SMOOTH)

	-- BOUNCE POSITION
	if((direction == msSmartAnimation.LEFT) or (direction == msSmartAnimation.RIGHT))then
		location.x = startValue + (travelDistance * self.enterOvershootScale)
	else 
		location.y = startValue + (travelDistance * self.enterOvershootScale)
	end
	self:SetLocation(channel, frame, location, MOHO.INTERP_ELASTIC)

	-- START POSITION
	if((direction == msSmartAnimation.LEFT) or (direction == msSmartAnimation.RIGHT))then
		location.x = startValue
	else 
		location.y = startValue
	end
	self:SetLocation(channel, frame - self.enterIngressFrames, location, MOHO.INTERP_LINEAR)
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
	channel:SetValue(frame - self.plopOutEndFrames,scale)
	channel:SetKeyInterp(frame - self.plopOutEndFrames, MOHO.INTERP_SMOOTH, 0, 0)	
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

function msSmartAnimation:LoadSettings()
	--print("userappdir " .. moho:UserAppDir())
	local path = self.moho:AppDir().."/scripts/utility/smartAnimationSettings.txt"
	local f = io.open(path, "r")
	if (f == nil) then
		return
	end

	--Read the first line of the file
	local name
	name, msSmartAnimation.enterIngressFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.enterOvershootScale  = self:splitStringByWord(f:read())
	name, msSmartAnimation.enterResolveFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.exitFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopInIngressFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopInResolveFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopInScale = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopOutFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopOutEndFrames = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopOutBounceCount = self:splitStringByWord(f:read())
	name, msSmartAnimation.plopOutScale = self:splitStringByWord(f:read())
	name, msSmartAnimation.borderScale = self:splitStringByWord(f:read())
	name, msSmartAnimation.minScale = self:splitStringByWord(f:read())
	f:close()
end

function msSmartAnimation:SaveSettings()
	-- local path = self.moho:UserAppDir().."/scripts/utility/smartAnimationSettings.txt"
	local path = self.moho:AppDir().."/scripts/utility/smartAnimationSettings.txt"
	local f = io.open(path, "w")
	if (f == nil) then
		print("smartAnimationSettings cannot write file to: " .. path)
		return
	end
	f:write("enterIngressFrames ".. msSmartAnimation.enterIngressFrames .. "\n")
	f:write("enterOvershootScale ".. msSmartAnimation.enterOvershootScale  .. "\n")
	f:write("enterResolveFrames ".. msSmartAnimation.enterResolveFrames .. "\n")
	f:write("exitFrames ".. msSmartAnimation.exitFrames .. "\n")
	f:write("plopInIngressFrames ".. msSmartAnimation.plopInIngressFrames .. "\n")
	f:write("plopInResolveFrames ".. msSmartAnimation.plopInResolveFrames .. "\n")
	f:write("plopInScale ".. msSmartAnimation.plopInScale .. "\n")
	f:write("plopOutFrames ".. msSmartAnimation.plopOutFrames .. "\n")
	f:write("plopOutEndFrames ".. msSmartAnimation.plopOutEndFrames .. "\n")
	f:write("plopOutBounceCount ".. msSmartAnimation.plopOutBounceCount .. "\n")
	f:write("plopOutScale ".. msSmartAnimation.plopOutScale .. "\n")
	f:write("borderScale ".. msSmartAnimation.borderScale .. "\n")
	f:write("minScale ".. msSmartAnimation.minScale .. "\n")
	f:close()
end

function msSmartAnimation:splitStringByWord(myString)
	local s, e = string.find(myString, "%S+")
	
	return string.sub(myString,s,e), string.sub(myString, e + 1)
end
	-- numBones = tonumber(numBones)
