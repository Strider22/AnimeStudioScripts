-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_BoneSound"

-- **************************************************
-- General information about this script
-- **************************************************

LM_BoneSound = {}

LM_BoneSound.BASE_STR = 2530

function LM_BoneSound:Name()
	return "Bone Sound"
end

function LM_BoneSound:Version()
	return "6.0"
end

function LM_BoneSound:Description()
	return MOHO.Localize("/Scripts/Menu/BoneSound/Description=Uses a sound file to control a bone's movement.")
end

function LM_BoneSound:Creator()
	return "Smith Micro Software, Inc."
end

function LM_BoneSound:UILabel()
	return(MOHO.Localize("/Scripts/Menu/BoneSound/BoneAudioWiggle=Bone Audio Wiggle..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

LM_BoneSound.audioLayer = 0
LM_BoneSound.magnitude = 90
LM_BoneSound.stepSize = 2

-- **************************************************
-- Bone Sound dialog
-- **************************************************

local LM_BoneSoundDialog = {}

function LM_BoneSoundDialog:new(moho)
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/BoneSound/Title=Bone Audio Wiggle"), LM_BoneSoundDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/BoneSound/SelectAudioLayer=Select audio layer:")), LM.GUI.ALIGN_LEFT)
	d.menu = LM.GUI.Menu(MOHO.Localize("/Scripts/Menu/BoneSound/SelectAudioLayer=Select audio layer:"))
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
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/BoneSound/MaxAngle=Max angle")), LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/BoneSound/FrameStep=Frame step")), LM.GUI.ALIGN_LEFT)
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

function LM_BoneSoundDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE, true)
	self.magnitude:SetValue(LM_BoneSound.magnitude)
	self.stepSize:SetValue(LM_BoneSound.stepSize)
end

function LM_BoneSoundDialog:OnValidate()
	local b = true
	if (not self:Validate(self.magnitude, -3600, 3600)) then
		b = false
	end
	if (not self:Validate(self.stepSize, 1, 1000)) then
		b = false
	end
	return b
end

function LM_BoneSoundDialog:OnOK()
	LM_BoneSound.audioLayer = self.menu:FirstChecked()
	LM_BoneSound.magnitude = self.magnitude:FloatValue()
	LM_BoneSound.stepSize = self.stepSize:FloatValue()
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_BoneSound:IsEnabled(moho)
	if (moho.layer:LayerType() ~= MOHO.LT_BONE) then
		return false
	end
	if (moho:CountSelectedBones() < 1) then
		return false
	end
	if (moho:CountAudioLayers() < 1) then
		return false
	end
	return true
end

function LM_BoneSound:Run(moho)
	local skel = moho:Skeleton()
	if (skel == nil) then
		return
	end

	-- ask user for the angle offset magnitude
	local dlog = LM_BoneSoundDialog:new(moho)
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
	local boneTimingOffset = moho.layer:TotalTimingOffset()
	local boneFrame = frame + boneTimingOffset
	local baseAngle = {}
	local magnitude = math.rad(self.magnitude)
	local audioTime = 0
	local frameDuration = self.stepSize / moho.document:Fps()

	for i = 0, skel:CountBones() - 1 do
		table.insert(baseAngle, skel:Bone(i).fAnimAngle:GetValue(boneFrame))
	end

	while (audioTime < audioDuration) do
		local amp = audioLayer:GetAmplitude(audioTime, frameDuration)

		boneFrame = frame + boneTimingOffset
		if (boneFrame > 0) then
			for i = 0, skel:CountBones() - 1 do
				local bone = skel:Bone(i)
				if (bone.fSelected) then
					local angle = baseAngle[i + 1] + amp * magnitude
					bone.fAnimAngle:SetValue(boneFrame, angle)
				end
			end
		end

		audioTime = audioTime + frameDuration
		frame = frame + self.stepSize
	end
end
