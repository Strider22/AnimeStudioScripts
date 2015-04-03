-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_Rocking"

-- **************************************************
-- General information about this script
-- **************************************************

MS_Rocking = {}

MS_Rocking.BASE_STR = 2530

function MS_Rocking:Name()
	return "Layer Sound"
end

function MS_Rocking:Version()
	return "6.0"
end

function MS_Rocking:Description()
	return MOHO.Localize("/Scripts/Menu/Rocking/Description=Uses a sound file to control a layer's position.")
end

function MS_Rocking:Creator()
	return "Smith Micro Software, Inc."
end

function MS_Rocking:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Rocking/LayerAudioWiggle=Rocking"))
end

-- **************************************************
-- Recurring values
-- **************************************************

MS_Rocking.audioLayer = 0
MS_Rocking.magnitude = .1
MS_Rocking.cycleSeconds = 2
MS_Rocking.stepSize = 0

-- **************************************************
-- Bone Sound dialog
-- **************************************************

local MS_RockingDialog = {}

function MS_RockingDialog:new(moho)
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/Rocking/Title=Rocking"), MS_RockingDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/Rocking/SelectAudioLayer=Select audio layer:")), LM.GUI.ALIGN_LEFT)
	d.menu = LM.GUI.Menu(MOHO.Localize("/Scripts/Menu/Rocking/SelectAudioLayer=Select audio layer:"))
	for i = 0, moho:CountAudioLayers() - 1 do
		local audioLayer = moho:GetAudioLayer(i)
		d.menu:AddItem(audioLayer:Name(), 0, MOHO.MSG_BASE + i)
	end
	d.menu:SetChecked(MOHO.MSG_BASE, true)

	d.popup = LM.GUI.PopupMenu(256, true)
	d.popup:SetMenu(d.menu)
	l:AddChild(d.popup)

	l:PushH(LM.GUI.ALIGN_CENTER)
		l:PushV()
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/Rocking/MaxOffset=Max offset")), LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/Rocking/FrameStep=Cycle seconds")), LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV()
			d.magnitude = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			l:AddChild(d.magnitude)
			d.cycleSeconds = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.cycleSeconds)
		l:Pop()
	l:Pop()

	return d
end

function MS_RockingDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE, true)
	self.magnitude:SetValue(MS_Rocking.magnitude)
	self.cycleSeconds:SetValue(MS_Rocking.cycleSeconds)
end

function MS_RockingDialog:OnValidate()
	local b = true
	if (not self:Validate(self.magnitude, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.cycleSeconds, 1, 1000)) then
		b = false
	end
	return b
end

function MS_RockingDialog:OnOK()
	MS_Rocking.audioLayer = self.menu:FirstChecked()
	MS_Rocking.magnitude = self.magnitude:FloatValue()
	MS_Rocking.cycleSeconds = self.cycleSeconds:FloatValue()
end

-- **************************************************
-- The guts of this script
-- **************************************************

function MS_Rocking:IsEnabled(moho)
	if (moho:CountAudioLayers() < 1) then
		return false
	end
	return true
end

function MS_Rocking:Run(moho)
	-- ask user for the angle offset magnitude
	local dlog = MS_RockingDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	-- begin audio extraction
	local audioLayer = moho:GetAudioLayer(self.audioLayer)
	local audioDuration = audioLayer:LayerDuration() / moho.document:Fps()
	if (audioDuration <= 0) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	local frame = 1 - audioLayer:TotalTimingOffset()
	local layerTimingOffset = moho.layer:TotalTimingOffset()
	frame = frame + layerTimingOffset
	local angle = 0
	local audioTime = 0
	self.stepSize = (self.cycleSeconds/2) * moho.document:Fps()
	local frameDuration = self.stepSize / moho.document:Fps()

	while (audioTime < audioDuration) do
		-- local amp = audioLayer:GetAmplitude(audioTime, frameDuration)
		if (frame > 0) then
			moho.layer.fRotationZ:SetValue(frame, angle)
		end

		if (angle == self.magnitude) then
			angle = -self.magnitude
		else
			angle = self.magnitude
		end
		audioTime = audioTime + frameDuration
		frame = frame + self.stepSize
	end
end
