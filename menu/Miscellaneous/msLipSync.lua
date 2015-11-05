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
msLipSync.startFrame = 1
msLipSync.endFrame = 50
msLipSync.text = ""
msLipSync.lastMouth = 0
msLipSync.switch = nil
msLipSync.cancel = false
msLipSync.restAtEnd = true

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
	
	layout:PushH(LM.GUI.ALIGN_CENTER)
		-- add labels
		layout:PushV()
			msDialog:AddText("Start Frame", "Start Frame:")
			msDialog:AddText("End Frame", "End Frame:")
			msDialog:AddText("Text", "Text String:")
		layout:Pop()
		-- add controls to the right
		layout:PushV()
			dialog.startFrame = msDialog:AddTextControl(0, "1.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.endFrame = msDialog:AddTextControl(0, "100.0000", 0, LM.GUI.FIELD_FLOAT)
      dialog.text = msDialog:AddTextControl(0,"What are you saying", 0, LM.GUI.FIELD_TEXT)
		layout:Pop()
	layout:Pop()
	
	-- Should the rest mouth be put at the end of the audio section
	dialog.phonetic = msDialog:Control(LM.GUI.CheckBox, "Phonetic","Phonetic spelling")
	dialog.restAtEnd = msDialog:Control(LM.GUI.CheckBox, "Rest", "Rest at end")
	dialog.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msLipSyncDialog:UpdateWidgets()
	self.restAtEnd:SetValue(msLipSync.restAtEnd)
	self.startFrame:SetValue(msLipSync.startFrame)
	self.endFrame:SetValue(msLipSync.endFrame)
	self.text:SetValue(msLipSync.text)
	self.phonetic:SetValue(msLipSync.phonetic)
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
  msLipSync.phonetic = self.phonetic:Value()
	msHelper.debug = self.debug:Value()
	msLipSync.startFrame =	self.startFrame:FloatValue()
  msLipSync.endFrame = self.endFrame:FloatValue()
  msLipSync.text = self.text:Value()
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msLipSync:DeleteKeys()
	for frame = self.startFrame, self.endFrame do
		self.switch:DeleteKey(frame)
	end
end

function msLipSync:CalculateStepSize(phonemeList)
  --Phonemes:dump(phonemeList)
  local numVowels, numConsonants = Phonemes:countPhonemes(phonemeList)
	self.stepSize = (self.endFrame - self.startFrame - numConsonants)/numVowels
  if self.stepSize < 1 then self.stepSize = 1 end
  msHelper:Debug("Frames " .. self.startFrame .. " " .. self.endFrame)
  msHelper:Debug("Letters v, c, ss " .. numVowels .. " " .. numConsonants .. " " .. self.stepSize)

end

function msLipSync:SetMouthSwitchKeys(phonemeList)
	local frame = self.startFrame
	for k,v in ipairs(phonemeList) do
    local mouth = v[1]
		if (mouth ~= self.lastMouth) then
			self.switch:SetValue(math.floor(frame), mouth)
			self.lastMouth = mouth
		end
    if v[2] == "c" then 
  		frame = frame + 1
    else
      frame = frame + self.stepSize
    end
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

	self:DeleteKeys()
	

	local phonemeList = {}
  msHelper:Debug("text " .. self.text)
  Phonemes:buildPhonemeListFromPhrase(self.text, phonemeList)
	self:CalculateStepSize(phonemeList)
	self:SetMouthSwitchKeys(phonemeList)
	if msLipSync.cancel then
		return
	end
	
	
	if self.restAtEnd then
	   self.switch:SetValue(msAudioLayer.endFrame,"rest")
	end
end
