-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msPuppetDance"

-- **************************************************
-- General information about this script
-- **************************************************

msPuppetDance = {}

msPuppetDance.BASE_STR = 2530

function msPuppetDance:Name()
	return "Layer Sound"
end

function msPuppetDance:Version()
	return "6.0"
end

function msPuppetDance:Description()
	return MOHO.Localize("/Scripts/Menu/PuppetDance/Description=Uses a sound file to control a layer's position.")
end

function msPuppetDance:Creator()
	return "Mitchel Soltys"
end

function msPuppetDance:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PuppetDance/LayerAudioWiggle=Puppet Dance"))
end

-- **************************************************
-- Recurring values
-- **************************************************

msPuppetDance.audioLayer = 0
msPuppetDance.multiplier = 0.2
msPuppetDance.angle = .1
msPuppetDance.stepSize = 3
msPuppetDance.useAmp = true
msPuppetDance.moho = 0
msPuppetDance.frameAdjust = 0

-- **************************************************
-- Bone Sound dialog
-- **************************************************

local msPuppetDanceDialog = {}

function msPuppetDanceDialog:new(moho)
	local d, l = msDialog:SimpleDialog("Layer Audio Wiggle", msPuppedDanceDialog)

	-- msHelper.debug = true
	msEditSpan:Init(d,msPuppetDance)
	msDialog:Init("/Scripts/Menu/PuppetDance/", d, l)
	
	d.moho = moho


	l:PushH(LM.GUI.ALIGN_CENTER)
		l:PushV()
			msDialog:AddText("Select audio layer")
			msDialog:AddText("Multiplier")
			msDialog:AddText("Angle")
			msDialog:AddText("Frame step")
		l:Pop()
		l:PushV()
			d.menu = msDialog:AudioDropdown(moho, "SelectAudioLayer", 
				"Select audio layer",msPuppetDance.audioLayer)
			d.multiplier = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			d.angle = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			d.stepSize = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
		l:Pop()
	l:Pop()

	msEditSpan:AddComponents(l)
	d.useAmp = msDialog:Control(LM.GUI.CheckBox, "Amp","Multiply times amplitude")
	d.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

	return d
end

function msPuppetDanceDialog:UpdateWidgets()
	self.multiplier:SetValue(msPuppetDance.multiplier)
	self.angle:SetValue(msPuppetDance.angle)
	self.stepSize:SetValue(msPuppetDance.stepSize)
	self.startFrame:SetValue(msAudioLayer.startFrame)
	self.endFrame:SetValue(msAudioLayer.endFrame)
	self.useAllFrames:SetValue(msAudioLayer.useAllFrames)
	self.useAmp:SetValue(msPuppetDance.useAmp)
	self.debug:SetValue(msHelper.debug)
end

function msPuppetDanceDialog:OnValidate()
	local b = true
	if (not self:Validate(self.multiplier, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.angle, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.stepSize, 1, 1000)) then
		b = false
	end
	return b
end

function msPuppetDanceDialog:OnOK()
	msPuppetDance.audioLayer = self.menu:FirstChecked()
	msPuppetDance.multiplier = self.multiplier:FloatValue()
	msPuppetDance.angle = self.angle:FloatValue()
	msPuppetDance.stepSize = self.stepSize:FloatValue()
	msPuppetDance.useAmp = self.useAmp:Value()
	msHelper.debug = self.debug:Value()

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

function msPuppetDance:IsEnabled(moho)
	if (moho:CountAudioLayers() < 1) then
		return false
	end
	return true
end

-- **************************************************
-- Wiggle Layer
-- Wiggle to be done at each frame of interest
-- **************************************************
function msPuppetDance:Wiggle(frame, amplitude)
	local baseOffset = msPuppetDance.moho.layer.fTranslation.value
	local newOffset = LM.Vector3:new_local()
	local angle = msPuppetDance.angle
	if msPuppetDance.useAmp then
		angle = angle * amplitude
	end
	angle = MOHO.RandomRange(-1, 1) * angle
	newOffset:Set(baseOffset)
	newOffset.y = newOffset.y + amp * msPuppetDance.multiplier
	msHelper:Debug("frame " .. frame .. " y " .. newOffset.y .. " angle " .. angle)
	frame = frame + msPuppetDance.frameAdjust
	msPuppetDance.moho.layer.fTranslation:SetValue(frame, newOffset)
	msPuppetDance.moho.layer.fRotationZ:SetValue(frame, angle)
end

function msPuppetDance:Run(moho)
	msDialog:Display(moho, msPuppetDanceDialog)
	if(msDialog.cancelled) then return end
	self.moho = moho
	

	msHelper:PrepUndo(moho)
	self.frameAdjust = moho.layer:TotalTimingOffset();

	-- Not deleting keys, because they can have many other
	-- attributes associated with them like visibility
	-- msAudioLayer:DeleteLayerKeys()
	msAudioLayer:ProcessAudio(msPuppetDance.Wiggle)
	
end
