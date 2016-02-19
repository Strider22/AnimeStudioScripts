-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msMouthWiggle"

-- **************************************************
-- General information about this script
-- **************************************************

msMouthWiggle = {}

msMouthWiggle.BASE_STR = 2530

function msMouthWiggle:Name()
	return "Mouth Wiggle"
end

function msMouthWiggle:Version()
	return "6.0"
end

function msMouthWiggle:Description()
	return MOHO.Localize("/Scripts/Menu/MouthWiggle/Description=Uses a sound file to control a mouth's switch layer.")
end

function msMouthWiggle:Creator()
	return "Mitchel Soltys"
end

function msMouthWiggle:UILabel()
	return(MOHO.Localize("/Scripts/Menu/MouthWiggle/LayerMouthWiggle=Mouth Wiggle..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

msMouthWiggle.audioLayer = 0
msMouthWiggle.interpolationStyle = 1
msMouthWiggle.AI = .3
msMouthWiggle.E = .1
msMouthWiggle.etc = .05
msMouthWiggle.stepSize = 1
msMouthWiggle.startFrame = 0
msMouthWiggle.endFrame = 0
msMouthWiggle.minMaxTolerancePercent = .05
msMouthWiggle.minMaxTolerance = 0
msMouthWiggle.lastMouth = 0
msMouthWiggle.lastMouthAmplitude = 0
msMouthWiggle.switch = nil
msMouthWiggle.frameAdjust = 0
msMouthWiggle.cancel = false
msMouthWiggle.restAtEnd = true
msMouthWiggle.minimizeMouthSwitches = true
msMouthWiggle.MBPlowest = false

-- **************************************************
-- Mouth Wiggle dialog
-- **************************************************

local msMouthWiggleDialog = {}

function msMouthWiggleDialog:new(moho)
	local dialog, layout = msDialog:SimpleDialog("Mouth Wiggle", msMouthWiggleDialog)

	msEditSpan:Init(dialog,mouthWiggle)

	dialog.moho = moho


	msDialog:AddText("help", "See Dialog constructor for explanations")
	
	layout:PushH(LM.GUI.ALIGN_CENTER)
		-- add labels
		layout:PushV()
			-- Select the audio layer to use
			msDialog:AddText("Audio layer:")
			-- How much wiggle do you ignore? 
			msDialog:AddText("Tolerance Percentage (.005 .05)")
			-- Which style of interpolation will you use
			msDialog:AddText("Interpolation Style:")
			-- Values for determining what the actual mouth values will be
			-- used to be difficult to determine for multiple voices, because
			-- the value was not based on local of the span being edited. So 
			-- if a soft voice was mixed with a loud voice, the soft voice would
			-- not have any mouth values
			msDialog:AddText("AI level (.03 .3)")
			msDialog:AddText("E level (.01 .1)")
			msDialog:AddText("etc level (.005 .05)")
			-- step size. Should almost always be one. 
			msDialog:AddText("Step size")
		layout:Pop()
		-- add controls to the right
		layout:PushV()
			dialog.menu = msDialog:AudioDropdown(moho, "SelectAudioLayer", 
				"Select audio layer",msMouthWiggle.audioLayer)
			dialog.minMaxTolerancePercent = msDialog:AddTextControl(0, "0.0000", 0,
				LM.GUI.FIELD_FLOAT)
			dialog.interpMenu = LM.GUI.Menu(msDialog:Localize("InterpStyle",
				"Interpolation Style:"))
			--	- Min Max big change -	put switch values only at min max values
			--			calculated by big change. Actual value is based on 
			--			percentage of span max
			dialog.interpMenu:AddItem("Min Max Big Change", 0, MOHO.MSG_BASE )
			--	- Min Max turn -	put switch values only at min max values 
			--			calculated the new way. Actual value is based on 
			--			percentage of span max
			dialog.interpMenu:AddItem("Min Max Turn", 0, MOHO.MSG_BASE + 1)
			--	- AutoWiggle -	 Set value based calculated min max of range
			dialog.interpMenu:AddItem("AutoWiggle", 0, MOHO.MSG_BASE + 2)
			--  - PercentageWiggle2  -	set value at each frame based on percentage
			--      	of span max
			dialog.interpMenu:AddItem("PercentageWiggle2", 0, MOHO.MSG_BASE + 3)
			--	- AbsoluteWiggle2 -	 Set value based on actual amplitude
			dialog.interpMenu:AddItem("AbsoluteWiggle2", 0, MOHO.MSG_BASE + 4)
			--  - Percentage of max -	OLD set value at each frame based on percentage
			--      	of span max
			dialog.interpMenu:AddItem("Percentage of Max", 0, MOHO.MSG_BASE + 5)
			--	- Min Max old -	put switch values only at min max values calculated
			--          the old fashioned way. Actual value is based on 
			--			percentage of span max
			dialog.interpMenu:AddItem("Min Max Old", 0, MOHO.MSG_BASE + 6)
			--	- Raw Value -	probably not very good. held just in case. Set value
			--          based on actual amplitude
			dialog.interpMenu:AddItem("Raw Value", 0, MOHO.MSG_BASE + 7)
			--	- BigChange2 -	
			dialog.interpMenu:AddItem("Big Change 2", 0, MOHO.MSG_BASE + 8)
			--	- TrueMinMax -	
			dialog.interpMenu:AddItem("True min max", 0, MOHO.MSG_BASE + 9)
			dialog.interpMenu:SetChecked(MOHO.MSG_BASE + msMouthWiggle.interpolationStyle, true)
			msDialog:MakePopup(dialog.interpMenu)

			dialog.AI = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.E = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.etc = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.stepSize = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
		layout:Pop()
	layout:Pop()
	
	-- Allow control over frames specified by the user
	msEditSpan:AddComponents(layout)

	-- Should the rest mouth be put at the end of the audio section
	dialog.restAtEnd = msDialog:Control(LM.GUI.CheckBox, "Rest", "Rest at end")
	dialog.minimizeMouthSwitches = msDialog:Control(LM.GUI.CheckBox, "Minimize", "Minimize Mouth Wiggle")
	dialog.MBPlowest = msDialog:Control(LM.GUI.CheckBox, "MBPlowest", "Is MBP lowest")
	dialog.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msMouthWiggleDialog:UpdateWidgets()
	self.AI:SetValue(msMouthWiggle.AI)
	self.E:SetValue(msMouthWiggle.E)
	self.etc:SetValue(msMouthWiggle.etc)
	self.stepSize:SetValue(msMouthWiggle.stepSize)
	self.minMaxTolerancePercent:SetValue(msMouthWiggle.minMaxTolerancePercent)
	self.restAtEnd:SetValue(msMouthWiggle.restAtEnd)
	self.startFrame:SetValue(msAudioLayer.startFrame)
	self.endFrame:SetValue(msAudioLayer.endFrame)
	self.useAllFrames:SetValue(msAudioLayer.useAllFrames)
	self.minimizeMouthSwitches:SetValue(msMouthWiggle.minimizeMouthSwitches)
	self.MBPlowest:SetValue(msMouthWiggle.MBPlowest)
	self.debug:SetValue(msHelper.debug)
end

-- **************************************************
-- Validate user choices
-- **************************************************
function msMouthWiggleDialog:OnValidate()
	local b = true
	if (not self:Validate(self.AI, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.E, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.etc, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.minMaxTolerancePercent, 0, 1)) then
		b = false
	end
	if (not self:Validate(self.stepSize, 1, 1000)) then
		b = false
	end
	return b
end

-- **************************************************
-- Set values from dialog
-- **************************************************
function msMouthWiggleDialog:OnOK()
	msMouthWiggle.audioLayer = self.menu:FirstChecked()
	msMouthWiggle.interpolationStyle = self.interpMenu:FirstChecked()
	msMouthWiggle.AI = self.AI:FloatValue()
	msMouthWiggle.E = self.E:FloatValue()
	msMouthWiggle.etc = self.etc:FloatValue()
	msMouthWiggle.stepSize = self.stepSize:FloatValue()
	msMouthWiggle.minMaxTolerancePercent = self.minMaxTolerancePercent:FloatValue()
	msMouthWiggle.restAtEnd = self.restAtEnd:Value()
	msMouthWiggle.minimizeMouthSwitches = self.minimizeMouthSwitches:Value()
	msMouthWiggle.MBPlowest = self.MBPlowest:Value()
	msHelper.debug = self.debug:Value()
	
	if msMouthWiggle.stepSize ~= 1 then
		print("Step size should be 1. I may soon deprecate this control.")
	end
	msAudioLayer:Init(self.moho,
			self.moho:GetAudioLayer(self.menu:FirstChecked()),
			self.useAllFrames:Value(),
			self.startFrame:FloatValue(),
			self.endFrame:FloatValue(),
			self.stepSize:FloatValue(),
			.3)

end

-- **************************************************
-- The guts of this script
-- **************************************************
function msMouthWiggle:DeleteKeys()
	for frame = msAudioLayer.startFrame + mouthWiggle.frameAdjust,
		msAudioLayer.endFrame + mouthWiggle.frameAdjust do
		self.switch:DeleteKey(frame)
	end
end

function msMouthWiggle:SetMouth(frame,amp, AI, E, etc)
	-- adjust frame to account for layer shifting
	frame = frame + msMouthWiggle.frameAdjust
	if(self.minimizeMouthSwitches) then
		self:SetMouthMinimizeSwitches(frame,amp, AI, E, etc)
	else
		self:SetMouthAllSwitches(frame,amp, AI, E, etc)
	end
end

function msMouthWiggle:SetMouthMinimizeSwitches(frame,amp, AI, E, etc)
	local direction = 0
	if (amp - self.lastMouthAmplitude) > self.minMaxTolerance then
		direction = 1
	elseif (self.lastMouthAmplitude - amp) > self.minMaxTolerance then
		direction = -1
	else
		return
	end
	if (amp > AI) then
		if (self.lastMouth == 4)then
			if direction < 0 then
				self:SetMouthSwitch(frame,amp,3)
			end
		else
			self:SetMouthSwitch(frame,amp,4)
		end
	elseif (amp > E) then
		if (self.lastMouth == 3) then 
			if direction > 0 then
				self:SetMouthSwitch(frame,amp,4)
			else
				self:SetMouthSwitch(frame,amp,2)
			end
		else
			self:SetMouthSwitch(frame,amp,3)
		end
	elseif (amp > etc) then
		if (self.lastMouth == 2) then 
			if direction > 0 then
				self:SetMouthSwitch(frame,amp,3)
			else
				self:SetMouthSwitch(frame,amp,1)
			end
		else
			self:SetMouthSwitch(frame,amp,2)
		end
	else
		if (lastMouth == 1) then 
			if direction > 0 then
				self:SetMouthSwitch(frame,amp,2)
			end
		else
			self:SetMouthSwitch(frame,amp,1)
		end
	end
end

function msMouthWiggle:SetMouthAllSwitches(frame,amp, AI, E, etc)
	if (amp > AI) then
		msHelper:Debug("Set Mouth at frame " .. frame - msMouthWiggle.frameAdjust .. " AI")
		self.switch:SetValue(frame, "AI")
	elseif (amp > E) then
		msHelper:Debug("Set Mouth at frame " .. frame - msMouthWiggle.frameAdjust .. " E")
		self.switch:SetValue(frame, "E")
	elseif (amp > etc) then
		msHelper:Debug("Set Mouth at frame " .. frame - msMouthWiggle.frameAdjust .. " etc")
		self.switch:SetValue(frame, "etc")
	else
		msHelper:Debug("Set Mouth at frame " .. frame - msMouthWiggle.frameAdjust .. " MBP")
		self.switch:SetValue(frame, "MBP")
	end
end


function msMouthWiggle:SetMouthSwitch(frame, amp, value)
	self.lastMouth = value
	self.lastMouthAmplitude = amp
	msHelper:Debug("Set Mouth at frame " .. frame - msMouthWiggle.frameAdjust .. " value " .. value)
	if value == 4 then
		self.switch:SetValue(frame, "AI")
	elseif value == 3 then
		self.switch:SetValue(frame, "E")
	elseif value == 2 then
		self.switch:SetValue(frame, "etc")
	else 
		self.switch:SetValue(frame, "MBP")
	end
end


function msMouthWiggle:TrueMinMax()
	local minMaxList, maxAmp = msAudioLayer:GetTrueMinMaxList()
	self:AmplitudeWiggle4(self.MBPlowest,minMaxList)
end

function msMouthWiggle:BigChange2()
	msHelper:Debug("In MinMaxBigChangeWiggle")
	local minMaxList, maxAmp = msAudioLayer:GetMinMaxListBigChange2()
	self:AmplitudeWiggle4(self.MBPlowest,minMaxList)
end

function msMouthWiggle:MinMaxBigChangeWiggle()
	msHelper:Debug("In MinMaxBigChangeWiggle")
	local minMaxList, maxAmp = msAudioLayer:GetMinMaxListBigChange()
	msAudioLayer:DumpMinMaxList(minMaxList);
	self:AmplitudeWiggle(minMaxList, maxAmp)
end

function msMouthWiggle:MinMaxTurnWiggle()
	msHelper:Debug("In MinMaxBigTurnWiggle")
	local minMaxList, maxAmp = msAudioLayer:GetMinMaxListTurn()
	self:AmplitudeWiggle(minMaxList, maxAmp)
end

function msMouthWiggle:PercentageWiggle2()
	msHelper:Debug("In PercentageWiggle2")
	msAudioLayer:BuildAmplitudeList();
	self:AmplitudeWiggle(msAudioLayer.amplitudeList, msAudioLayer.maxAmp)
end

function msMouthWiggle:AbsoluteWiggle2()
	msHelper:Debug("In AbsoluteWiggle2")
	msAudioLayer:BuildAmplitudeList();
	self:AmplitudeWiggle2(msAudioLayer.amplitudeList, msAudioLayer.maxAmp,
		self.AI, self.E, self.etc)
end

function msMouthWiggle:AutoWiggle()
	msHelper:Debug("In AutoWiggle")
	msAudioLayer:BuildAmplitudeList();
	self:AmplitudeWiggle3(self.MBPlowest)
end

function msMouthWiggle:AmplitudeWiggle(amplitudeList, maxAmp)
	self:AmplitudeWiggle2(amplitudeList, maxAmp, 
		maxAmp.amp * self.AI,
		maxAmp.amp * self.E,
		maxAmp.amp * self.etc)
end

function msMouthWiggle:AmplitudeWiggle2(amplitudeList, maxAmp,AI,E,etc)
    self.minMaxTolerance = self.minMaxTolerancePercent * maxAmp.amp

	for k,v in ipairs(amplitudeList) do
		self:SetMouth(v.frame, v.amp, AI, E, etc)
	end
end

-- Requires that BuildAmplituteList was called prior to calling this
-- MBPlowest is the lowest mouth position (if false assumes etc)
function msMouthWiggle:AmplitudeWiggle3(MBPlowest)
	local ampDiff = msAudioLayer.maxAmp.amp - msAudioLayer.minAmp.amp
	local lastPosition = 0
	local lastAmp = 0
	local potentialPosition = 0
	local audioStep
	local numSteps
	
	if(MBPlowest) then
		audioStep = ampDiff/4
		numSteps = 3
	else
		audioStep = ampDiff/3
		numSteps = 2
	end
	msHelper:Debug("ampDiff ".. ampDiff .. " audioStep " .. audioStep)
	
	for k,v in ipairs(msAudioLayer.amplitudeList) do
		local amp = v.amp
		local frame = v.frame + msMouthWiggle.frameAdjust
		potentialPosition = self:PotentialPosition(amp, msAudioLayer.minAmp.amp,
				audioStep, numSteps)
		msHelper:Debug("Potential position " .. potentialPosition)	
		if potentialPosition ~= lastPosition then
			msHelper:Debug("diff " .. math.abs(amp - lastAmp) .. " step " ..(audioStep/2))
			if math.abs(amp - lastAmp) > (audioStep/2) then
				self.switch:SetValue(frame, potentialPosition)
				lastPosition = potentialPosition
				lastAmp = amp
			end
		end
	end
end

function msMouthWiggle:AmplitudeWiggle4(MBPlowest, amplitudeList)
	local ampDiff = msAudioLayer.maxAmp.amp - msAudioLayer.minAmp.amp
	local audioStep
	local numSteps
	
	if(MBPlowest) then
		audioStep = ampDiff/4
		numSteps = 3
	else
		audioStep = ampDiff/3
		numSteps = 2
	end
	msHelper:Debug("ampDiff ".. ampDiff .. " audioStep " .. audioStep)
	
	for k,v in ipairs(amplitudeList) do
		local amp = v.amp
		local frame = v.frame + msMouthWiggle.frameAdjust
		local mouthPosition = self:PotentialPosition(amp, msAudioLayer.minAmp.amp,
				audioStep, numSteps)
		self.switch:SetValue(frame, mouthPosition)
	end
end

function msMouthWiggle:PotentialPosition(amp, ampBase, audioStep, numSteps)
	if amp > (ampBase + numSteps*audioStep) then
		return "AI"
	elseif amp > (ampBase + (numSteps - 1) *audioStep) then
		return "E" 
	elseif amp > (ampBase + (numSteps - 2) *audioStep) then
		return "etc"
	else 
		return "MBP"
	end
end



function msMouthWiggle:OutDatedWarning()
	msMouthWiggle.cancel = LM.GUI.Alert(LM.GUI.ALERT_WARNING, 
		"This routine has not been updated to work with new audio layer.", 
		"Switch values will be off if the layer is shifted.", nil, 
		"CONTINUE", "CANCEL", nil) == 1
end


-- **************************************************
--  Wiggle functions
-- **************************************************
function msMouthWiggle:PercentageWiggle(moho, audioLayer, audioDuration)
	self:OutDatedWarning()
	if msMouthWiggle.cancel then
		return
	end
	-- TotalTimingOffset is the distance of the first frame to 
	-- the animation origin. Thus if a layer is shifted right
	-- the offset will be negative.
	-- We want to start the frames at 1 so we add 1
	local frame = 1 - audioLayer:TotalTimingOffset()
	local layerTimingOffset = moho.layer:TotalTimingOffset()
	local currentTime = 0
	local frameDuration = 1 / moho.document:Fps()
	local maxAmp = audioLayer:MaxAmplitude()
	local AI = maxAmp * self.AI
	local E = maxAmp * self.E
	local etc = maxAmp * self.etc
    self.minMaxTolerance = self.minMaxTolerancePercent * maxAmp
	
	frame = frame + layerTimingOffset
	-- All durations are in terms of seconds
	while (currentTime < audioDuration) do
		local amp = audioLayer:GetRMSAmplitude(currentTime, frameDuration)
		if frame > 0 then
			self:SetMouth(frame, amp, AI, E, etc)
		end

		currentTime = currentTime + frameDuration
		frame = frame + self.stepSize
	end
end


function msMouthWiggle:MinMaxOldWiggle(moho, audioLayer, audioDuration)
	self:OutDatedWarning()
	if msMouthWiggle.cancel then
		return
	end
	-- TotalTimingOffset is the distance of the first frame to 
	-- the animation origin. Thus if a layer is shifted right
	-- the offset will be negative.
	-- We want to start the frames at 1 so we add 1
	local frame = 1 - audioLayer:TotalTimingOffset()
	local layerTimingOffset = moho.layer:TotalTimingOffset()
	local currentTime = 0
	local frameDuration = 1 / moho.document:Fps()
	local amp 
	local direction = -1
	local watermark = 0
	local watermarkFrame = 0
	local maxAmp = audioLayer:MaxAmplitude()
	local AI = maxAmp * self.AI
	local E = maxAmp * self.E
	local etc = maxAmp * self.etc
    self.minMaxTolerance = self.minMaxTolerancePercent * maxAmp
		

	frame = frame + layerTimingOffset
	-- All durations are in terms of seconds
	while (currentTime < audioDuration) do
		amp = audioLayer:GetRMSAmplitude(currentTime, frameDuration)
		if (direction == 1) then
			if amp > watermark then 
				watermark = amp
				watermarkFrame = frame
			elseif amp < watermark then
				self:SetMouth(watermarkFrame, watermark, AI, E, etc)
				watermarkFrame = frame
				watermark = amp
				direction = -1
			end
		else
			if amp < watermark then 
				watermark = amp
				watermarkFrame = frame
			elseif amp  >  watermark then
				self:SetMouth(watermarkFrame, watermark, AI, E, etc)
				watermarkFrame = frame
				watermark = amp
				direction = 1
			end
		end

		currentTime = currentTime + frameDuration
		frame = frame + 1
	end
end

function msMouthWiggle:AbsoluteWiggle(moho, audioLayer, audioDuration)
	self:OutDatedWarning()
	if msMouthWiggle.cancel then
		return
	end
	-- TotalTimingOffset is the distance of the first frame to 
	-- the animation origin. Thus if a layer is shifted right
	-- the offset will be negative.
	-- We want to start the frames at 1 so we add 1
	local frame = 1 - audioLayer:TotalTimingOffset()
	local layerTimingOffset = moho.layer:TotalTimingOffset()
	local currentTime = 0
	local frameDuration = 1 / moho.document:Fps()
    self.minMaxTolerance = self.minMaxTolerancePercent * maxAmp
	
	frame = frame + layerTimingOffset
	-- All durations are in terms of seconds
	while (currentTime < audioDuration) do
		local amp = audioLayer:GetRMSAmplitude(currentTime, frameDuration)
		if frame > 0 then
    		self:SetMouth(watermarkFrame, watermark, self.AI, self.E, self.etc)
		end

		currentTime = currentTime + frameDuration
		frame = frame + self.stepSize
	end
end

function msMouthWiggle:IsEnabled(moho)
	if (moho.layer:LayerType() ~= MOHO.LT_SWITCH) then
		return false
	end
	if (moho:CountAudioLayers() < 1) then
		return false
	end
	return true
end

function msMouthWiggle:Run(moho)
	msDialog:Display(moho, msMouthWiggleDialog)
	if(msDialog.cancelled) then return end

	self.moho = moho
    local switchLayer = moho:LayerAsSwitch(moho.layer)
    self.switch = switchLayer:SwitchValues()
	self.frameAdjust = moho.layer:TotalTimingOffset();

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	msAudioLayer:DeleteAssociatedKeys(switchLayer)

	if self.interpolationStyle == 0 then
		self:MinMaxBigChangeWiggle()
	elseif self.interpolationStyle == 1 then
		self:MinMaxTurnWiggle()
	elseif self.interpolationStyle == 2 then
		self:AutoWiggle()
	elseif self.interpolationStyle == 3 then
		self:PercentageWiggle2()
	elseif self.interpolationStyle == 4 then
		self:AbsoluteWiggle2()
	elseif self.interpolationStyle == 5 then
		self:PercentageWiggle(moho, msAudioLayer.audioLayer, msAudioLayer:SpanTime())
	elseif self.interpolationStyle == 6 then
		self:MinMaxOldWiggle(moho, msAudioLayer.audioLayer, msAudioLayer:SpanTime())
	elseif self.interpolationStyle == 7 then
		self:AbsoluteWiggle(moho, msAudioLayer.audioLayer, msAudioLayer:SpanTime())
	elseif self.interpolationStyle == 8 then
		self:BigChange2(moho, msAudioLayer.audioLayer, msAudioLayer:SpanTime())
	elseif self.interpolationStyle == 9 then
		self:TrueMinMax(moho, msAudioLayer.audioLayer, msAudioLayer:SpanTime())
	end

	if msMouthWiggle.cancel then
		return
	end

	if self.restAtEnd then
	   self.switch:SetValue(msAudioLayer.endFrame,"rest")
	end
end
