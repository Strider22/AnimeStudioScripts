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
msLipSync.skel = nil
msLipSync.cancel = false
msLipSync.phonemeToBonesMap = {}
msLipSync.openCloseName = "Open/Close"
msLipSync.squashStretchName = "Squash/Stretch"

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
	msLipSync:BuildPhonemeMap()
	if (msLipSync.moho.layer:LayerType() == MOHO.LT_BONE) then
		dialog.syncMenu = LM.GUI.Menu(msDialog:Localize("SyncStyle",
				"LipSync Style:"))
	--for i = 0, moho:CountAudioLayers() - 1 do
		-- local audioLayer = moho:GetAudioLayer(i)
		dialog.syncMenu:AddItem("Scarlett", 0, MOHO.MSG_BASE)
		dialog.syncMenu:AddItem("Switch", 0, MOHO.MSG_BASE + 1)
		dialog.syncMenu:SetChecked(MOHO.MSG_BASE, true)
		msDialog:MakePopup(dialog.syncMenu)
			-- end
	-- d.menu:SetChecked(MOHO.MSG_BASE, true)
	end

	layout:PushH(LM.GUI.ALIGN_CENTER)
		-- add labels
		layout:PushV()
			msDialog:AddText("Start Frame", "Start Frame:")
			msDialog:AddText("End Frame", "End Frame:")
			msDialog:AddText("Text", "Text String:")
	
	-- Should the rest mouth be put at the end of the audio section
	dialog.phonetic = msDialog:Control(LM.GUI.CheckBox, "Phonetic","Phonetic spelling")
	dialog.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

		layout:Pop()
		-- add controls to the right
		layout:PushV()
			dialog.startFrame = msDialog:AddTextControl(0, "1.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.endFrame = msDialog:AddTextControl(0, "100.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.text = msDialog:AddTextControl(0,"What are you saying", 0, LM.GUI.FIELD_TEXT)
		layout:Pop()
	layout:Pop()
	
	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msLipSyncDialog:UpdateWidgets()
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
	msLipSync.startFrame =	self.startFrame:FloatValue()
  msLipSync.endFrame = self.endFrame:FloatValue()
    msLipSync.text = self.text:Value()
    msLipSync.phonetic = self.phonetic:Value()
	msHelper.debug = self.debug:Value()
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msLipSync:DeleteKeys()
	for frame = self.startFrame, self.endFrame do
		-- self.switch:DeleteKey(frame)
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

function msLipSync:dump(table)
    for k, v in pairs(table) do
        if (type(v) == "table") then
            self:dump(v)
        else
            print("key " .. k .. " value " .. v)
        end
    end
end

function msLipSync:getBoneNames(line)
	local s, e = string.find(line, "%S+")
	self.openCloseName = string.sub(line,s,e)
	line = string.sub(line,e+2)
	s,e = string.find(line, "%S+")
	self.squashStretchName = string.sub(line,s,e)
end

function msLipSync:addPhonemeBones(line)
    local bones = {}
	local s, e = string.find(line, "%a+")
	local phoneme = string.sub(line,s,e)
	line = string.sub(line,e+2)
	s,e = string.find(line, "%d+")
	bones[self.openCloseName] = string.sub(line,s,e)
	line = string.sub(line,e+2)
	s,e = string.find(line, "%d+")
	bones[self.squashStretchName] = string.sub(line,s,e)
	local phonemeBones = {}
	self.phonemeToBonesMap[phoneme] = bones
end

function msLipSync:BuildPhonemeMap()
	local f = io.open(".\\lipSync.txt", "r")
	if (f == nil) then
		return
	end

	--Read the first line of the file
	local line = f:read()
	line = f:read()
	self:getBoneNames(line)
	line = f:read()
	while (line ~= nil) do
		self:addPhonemeBones(line)
		line = f:read()
	end
	f:close()

	
end

function msLipSync:SetMouthValues(phonemeList,type)
	local frame = self.startFrame
	for k,v in ipairs(phonemeList) do
    local mouth = v[1]
		if (mouth ~= self.lastMouth) then
			if(type == "switch") then
				self.switch:SetValue(math.floor(frame), mouth)
			else
				self.skel:BoneByName(self.openCloseName).fAnimAngle:SetValue(frame,math.rad(PhonemeBoneMaps.scarlet[mouth][1]))
				self.skel:BoneByName(self.squashStretchName).fAnimAngle:SetValue(frame,math.rad(PhonemeBoneMaps.scarlet[mouth][2]))
			end
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
	if ((moho.layer:LayerType() ~= MOHO.LT_SWITCH) and (moho.layer:LayerType() ~= MOHO.LT_BONE)) then
		return false
	end
	return true
end

function msLipSync:Run(moho)
	self.moho = moho
	msDialog:Display(moho, msLipSyncDialog)
	if(msDialog.cancelled) then return end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

--	self:dump(self.phonemeToBonesMap)
--self:dump(PhonemeBoneMaps.scarlet)
	
	-- self:DeleteKeys()
	local phonemeList = {}
	msHelper:Debug("text " .. self.text)
	Phonemes:buildPhonemeListFromPhrase(self.text, phonemeList)
	self:CalculateStepSize(phonemeList)
	
	if (moho.layer:LayerType() == MOHO.LT_SWITCH) then 
		local switchLayer = moho:LayerAsSwitch(moho.layer)
		self.switch = switchLayer:SwitchValues()
		self:SetMouthValues(phonemeList,"switch")
	else 
		self.skel = moho:Skeleton()
		if (skel == nil) then
			return
		end
		self:SetMouthValues(phonemeList,"bone")
	end
	
end
