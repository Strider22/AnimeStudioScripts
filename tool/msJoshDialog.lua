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
msLipSync.switch = nil
msLipSync.skel = nil
msLipSync.cancel = false
msLipSync.phonemeToBonesMap = {}
msLipSync.phonetic = true
msLipSync.openCloseName = "Open/Close"
msLipSync.squashStretchName = "Squash/Stretch"
msLipSync.firstChecked = 0

-- **************************************************
-- LipSync dialog
-- **************************************************
-- From left, right, up, down
-- overshoot
-- ingress frames
-- elastic in frames
-- leaving frames

-- Plop
-- numFrames
-- in num bounces
-- out num bounces


local msLipSyncDialog = {}

function msLipSyncDialog:new(moho)
	msHelper:Debug("in sync dialog ")

	local dialog = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/LipSync/Title=Lip Sync"), msLipSyncDialog)
	local layout = dialog:GetLayout()

	--the place where things should be
	--print("userappdir " .. moho:UserAppDir())
	msDialog:Init("/Scripts/Menu/LipSync/", dialog, layout)

	dialog.moho = moho
    msLipSync.myPhonemes = msPhonemes.new()
	msLipSync.myPhonemes.BuildPhonemeMap(moho:AppDir().."/scripts/utility/lipSync.txt")
	--myPhonemes.dump(myPhonemes.boneMaps)
	msHelper:Debug("after buildPhonememap  ")

    dialog.isBoneLayer = false
	if (msLipSync.moho.layer:LayerType() == MOHO.LT_BONE) then
		dialog.syncMenu = LM.GUI.Menu(msDialog:Localize("SyncStyle",
				"LipSync Style:"))
		dialog.isBoneLayer = true
	  --msPhonemes:dump(msPhonemes.boneMaps)
		local numMaps = 0
		for k,v in pairs(msLipSync.myPhonemes.boneMaps) do
			if numMaps == 0 then msLipSync.myPhonemes.setBoneMap(k) end
			dialog.syncMenu:AddItem(k, 0, MOHO.MSG_BASE + numMaps)
			numMaps = numMaps + 1
		end
		msDialog:MakePopup(dialog.syncMenu)
     end		
	
--print("first checked label " .. dialog.syncMenu:FirstCheckedLabel())
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
	if self.isBoneLayer then 
		self.syncMenu:SetChecked(MOHO.MSG_BASE + msLipSync.firstChecked, true)
		msLipSync.firstChecked = self.syncMenu:FirstChecked()
	end
end

-- **************************************************
-- Validate user choices
-- **************************************************

-- **************************************************
-- Set values from dialog
-- **************************************************
function msLipSyncDialog:OnOK()
	msHelper:Debug("in sync OnOK  ")

	msLipSync.startFrame =	self.startFrame:FloatValue()
    msLipSync.endFrame = self.endFrame:FloatValue()
    msLipSync.text = self.text:Value()
    msLipSync.phonetic = self.phonetic:Value()
	msHelper.debug = self.debug:Value()
	if self.isBoneLayer then 
	    msHelper:Debug("this is a Bonelayer ")
		msHelper:Debug("in lipsyncdialog:OnOK - bone map  " .. self.syncMenu:FirstCheckedLabel())
		msLipSync.boneMapName = self.syncMenu:FirstCheckedLabel()
		msLipSync.myPhonemes.setBoneMap(msLipSync.boneMapName)
		msLipSync.firstChecked = self.syncMenu:FirstChecked()
	end
	msHelper:Debug("leaving sync OnOK  ")

	--msLipSync.boneMap = msPhonemes.boneMaps[1]
	--msPhonemes.dump(msLipSync.boneMap)
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
  local numVowels, numConsonants = self.myPhonemes.countPhonemes(phonemeList)
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


function msLipSync:SetMouthValues(phonemeList,type)
	local frame = self.startFrame
	local numBones = 0
	local lastMouth = 0
	if type ~= "switch" then
		numBones = self.myPhonemes.numBones()
		msHelper:Debug("numBones " .. numBones)
	end
    msHelper:Debug("in setMouthValues type is " .. type)
	for k,v in ipairs(phonemeList) do
		local mouth = v[1]
		msHelper:Debug("mouth is  " .. mouth)
		msHelper:Debug("frame " .. frame)
		if (mouth ~= lastMouth) then
			if(type == "switch") then
				self.switch:SetValue(math.floor(frame), mouth)
			else
				for i = 1, numBones, 1 do
					msHelper:Debug("bone name " .. self.myPhonemes.boneName(i))
					msHelper:Debug("bone angle " .. self.myPhonemes.boneAngle(i,mouth))
					local bone = self.skel:BoneByName(self.myPhonemes.boneName(i))
					if (bone == nil) then 
						print("The bone '" .. self.myPhonemes.boneName(i) .. "' is not found.")
						print("Make sure " .. msLipSync.boneMapName .. " is the correct bone map to use.")
						return
					end
					bone.fAnimAngle:SetValue(frame,self.myPhonemes.boneAngleRad(i, mouth))
				end
			end
			lastMouth = mouth
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
	msDialog.cancelled = false
	msHelper:Debug("in run before dialog  ")
	msDialog:Display(moho, msLipSyncDialog)
	msHelper:Debug("in run after dialog  ")
	
	if(msDialog.cancelled) then 
		msHelper:Debug("msDialog is cancelled" )
		return 
	end


	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	
	-- self:DeleteKeys()
	local phonemeList = {}
	msHelper:Debug("phrase to speak " .. self.text)
	self.myPhonemes.buildPhonemeListFromPhrase(self.text, phonemeList, self.phonetic)
	self:CalculateStepSize(phonemeList)
    msHelper:Debug("after size calculation")
	
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
