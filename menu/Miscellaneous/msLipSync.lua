ScriptName = "msLipSync"
msLipSync = {}
msLipSync.BASE_STR = 2530

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msLipSync:Description()
	return MOHO.Localize("/Scripts/Menu/LipSync/Description=Converts text into switch keys for a mouth layer.")
end

function msLipSync:Name()
	return "Mouth Wiggle"
end

function msLipSync:Version()
	return "1.0"
end
function msLipSync:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************

function msLipSync:UILabel()
	return(MOHO.Localize("/Scripts/Menu/LipSync/LayerLipSync=LipSync..."))
end

-- **************************************************
-- Recurring values
-- **************************************************
msLipSync.stepSize = 1
msLipSync.startFrame = 0
msLipSync.endFrame = 0
msLipSync.lastMouth = 0
msLipSync.switch = nil
msLipSync.cancel = false
msLipSync.restAtEnd = true
msLipSync.minimizeMouthSwitches = true

-- **************************************************
-- LipSync dialog
-- **************************************************

local msLipSyncDialog = {}

function msLipSyncDialog:new(moho)
	local dialog = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/LipSync/Title=Lip Sync"), msLipSyncDialog)
	local layout = dialog:GetLayout()

	msEditSpan:Init(dialog,LipSync)
	msDialog:Init("/Scripts/Menu/LipSync/", dialog, layout)

	dialog.moho = moho

	msDialog:AddText("help", "See Dialog constructor for explanations")
	
	-- Should the rest mouth be put at the end of the audio section
	dialog.restAtEnd = msDialog:Control(LM.GUI.CheckBox, "Rest", "Rest at end")
	dialog.minimizeMouthSwitches = msDialog:Control(LM.GUI.CheckBox, "Minimize", "Minimize Mouth Wiggle")
	dialog.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msLipSyncDialog:UpdateWidgets()
	self.restAtEnd:SetValue(msLipSync.restAtEnd)
	self.startFrame:SetValue(msAudioLayer.startFrame)
	self.endFrame:SetValue(msAudioLayer.endFrame)
	self.minimizeMouthSwitches:SetValue(msLipSync.minimizeMouthSwitches)
	self.debug:SetValue(msHelper.debug)
end

-- **************************************************
-- Validate user choices
-- **************************************************

-- **************************************************
-- Set values from dialog
-- **************************************************
function msLipSyncDialog:OnOK()
	msLipSync.restAtEnd = self.restAtEnd:Value()
	msLipSync.minimizeMouthSwitches = self.minimizeMouthSwitches:Value()
	msHelper.debug = self.debug:Value()
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msLipSync:DeleteKeys()
	for frame = self.startFrame, self.endFrame do
		self.switch:DeleteKey(frame)
	end
end

function msLipSync:CalculateStepSize(mouthPositions)
	self.stepSize = math.floor((self.endFrame - self.startFrame)/table.maxn(mouthPositions))
end

function msLipSync:SetMouthSwitchKeys(mouthPositions)
	local frame = self.startFrame
	for k,v in ipairs(mouthPositions) do
		if (v ~= self.lastMouth) then
			switch:SetValue(frame, v)
			self.lastMouth = v
		end
		frame = frame + self.stepSize
	end
end

function msLipSync:IsEnabled(moho)
	if (moho.layer:LayerType() ~= MOHO.LT_SWITCH) then
		return false
	end
	return true
end

function msLipSync:Run(moho)
	msDialog:Display(moho, msLipSyncDialog)
	if(msDialog.cancelled) then return end

	self.moho = moho
    local switchLayer = moho:LayerAsSwitch(moho.layer)
    self.switch = switchLayer:SwitchValues()

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	local mouthPositions = {"AI", "AI", "E", "MBP", "MBP", "AI"}
	self:DeleteKeys()

	self:CalculateStepSize(mouthPositions)
	self:SetMouthSwitchKeys(mouthPositions)
	if msLipSync.cancel then
		return
	end

--	if self.restAtEnd then
--	   self.switch:SetValue(msAudioLayer.endFrame,"rest")
--	end
end
