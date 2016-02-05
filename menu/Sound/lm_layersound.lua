-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_LayerSound"

-- **************************************************
-- General information about this script
-- **************************************************

LM_LayerSound = {}

LM_LayerSound.BASE_STR = 2530

function LM_LayerSound:Name()
	return "Layer Sound"
end

function LM_LayerSound:Version()
	return "6.0"
end

function LM_LayerSound:Description()
	return MOHO.Localize("/Scripts/Menu/LayerSound/Description=Uses a sound file to control a layer's position.")
end

function LM_LayerSound:Creator()
	return "Smith Micro Software, Inc."
end

function LM_LayerSound:UILabel()
	return(MOHO.Localize("/Scripts/Menu/LayerSound/LayerAudioWiggle=Layer Audio Wiggle..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

LM_LayerSound.audioLayer = 0
LM_LayerSound.magnitude = 0.1
LM_LayerSound.stepSize = 2

-- **************************************************
-- Bone Sound dialog
-- **************************************************

local LM_LayerSoundDialog = {}

function LM_LayerSoundDialog:new(moho)
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/LayerSound/Title=Layer Audio Wiggle"), LM_LayerSoundDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/LayerSound/SelectAudioLayer=Select audio layer:")), LM.GUI.ALIGN_LEFT)
	d.menu = LM.GUI.Menu(MOHO.Localize("/Scripts/Menu/LayerSound/SelectAudioLayer=Select audio layer:"))
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
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/LayerSound/MaxOffset=Max offset")), LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/LayerSound/FrameStep=Frame step")), LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV()
			d.magnitude = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			l:AddChild(d.magnitude)
			d.stepSize = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.stepSize)
		l:Pop()
	l:Pop()

	return d
end

function LM_LayerSoundDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE, true)
	self.magnitude:SetValue(LM_LayerSound.magnitude)
	self.stepSize:SetValue(LM_LayerSound.stepSize)
end

function LM_LayerSoundDialog:OnValidate()
	local b = true
	if (not self:Validate(self.magnitude, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.stepSize, 1, 1000)) then
		b = false
	end
	return b
end

function LM_LayerSoundDialog:OnOK()
	LM_LayerSound.audioLayer = self.menu:FirstChecked()
	LM_LayerSound.magnitude = self.magnitude:FloatValue()
	LM_LayerSound.stepSize = self.stepSize:FloatValue()
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_LayerSound:IsEnabled(moho)
	if (moho:CountAudioLayers() < 1) then
		return false
	end
	return true
end

function LM_LayerSound:Run(moho)
	-- ask user for the angle offset magnitude
	local dlog = LM_LayerSoundDialog:new(moho)
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
	local layerFrame = frame + layerTimingOffset
	local baseOffset = moho.layer.fTranslation.value
	local newOffset = LM.Vector3:new_local()
	local audioTime = 0
	local frameDuration = self.stepSize / moho.document:Fps()

	while (audioTime < audioDuration) do
		local amp = audioLayer:GetAmplitude(audioTime, frameDuration)

		layerFrame = frame + layerTimingOffset
		if (layerFrame > 0) then
			newOffset:Set(baseOffset)
			newOffset.y = newOffset.y + amp * self.magnitude
			moho.layer.fTranslation:SetValue(layerFrame, newOffset)
		end

		audioTime = audioTime + frameDuration
		frame = frame + self.stepSize
	end
end
