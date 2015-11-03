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
msLipSync.startFrame = 18
msLipSync.endFrame = 40
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
	
	-- Should the rest mouth be put at the end of the audio section
	dialog.restAtEnd = msDialog:Control(LM.GUI.CheckBox, "Rest", "Rest at end")
	dialog.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msLipSyncDialog:UpdateWidgets()
	self.restAtEnd:SetValue(msLipSync.restAtEnd)
	-- self.startFrame:SetValue(msLipSync.startFrame)
	-- self.endFrame:SetValue(msLipSync.endFrame)
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

function msLipSync:CalculateStepSize(phonemeList)
    
	self.stepSize = math.floor((self.endFrame - self.startFrame)/numKeys(phonemeList))
end

function msLipSync:SetMouthSwitchKeys(phonemeList)
	local frame = self.startFrame
	for k,v in ipairs(phonemeList) do
		if (v ~= self.lastMouth) then
			self.switch:SetValue(frame, v)
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


local phrase = "If God is good and created the universe why is there such trouble in the world"



local textToPhoneme = {igh="AI", ee="E", ea="E", oo="U", oa="O" }
local test={a=5}

--set default case to etc. It will naturally include
-- letters a
-- phonemes ai e etc mbp o u qw fv l th
function readLine(file)
    local f = io.open(file,"r")
    local line = f:read("*l")
    f:close()
    return line;
end

local angleLookup = {m=5, r=7, z=6, e=22, o=12,l=15, a=35, w=21, u=25, t=36, f=-23 }
function printAngle(line)
    for i=1,line:len(),1 do
        print(angleLookup[line:sub(i,i)])
    end
end

-- ignore e at the end of a word
-- long if only one consonant between
-- y at end i


local phonemeMap = {}
phonemeMap[1] = {
    a = "AI",
    b = "MBP",
    c = "etc",
    d = "etc",
    e = "E",
    f = "FV",
    g = "etc",
    h = "etc",
    i = "E",
    j = "etc",
    k = "etc",
    l = "l",
    m = "MBP",
    n = "etc",
    o = "O",
    p = "MBP",
    q = "QW",
    r = "etc",
    s = "etc",
    t = "etc",
    u = "U",
    v = "FV",
    w = "QW",
    x = "etc",
    y = "etc",
    z = "etc"
}
phonemeMap[2] = { oo = "U", oa = "O", ee = "E", ea = "E", ch = "etc", th = "etc", gh = "FV", ou = "U", wh="QW"}
phonemeMap[3] = { igh = "AI" }
phonemeMap[4] = { eigh = "AI" }

phonemeSpecials = {wha={"QW","U"}, out={"AI","O","etc"}, }

function findPhonemeInList(phrase, len, stringList)
    return stringList[phrase:sub(1,len)]
end



function findNextPhoneme(word)
    word = string.lower(word)
    local wordLen = word:len()
    if wordLen < 1 then return nil, nil end
    local len = 4
    if wordLen < len then len = wordLen end
    for i=len,1,-1 do
      local phrase, remainder = splitStringByCount(word,i)
      local phoneme = findPhonemeInList(phrase,i,phonemeMap[i])
      if phoneme ~= nil then 
        return phoneme, remainder
      end
    end
    -- if the phoneme is not found, assume it's punctuation and return etc
    print("word " .. word .. " not found")
    return "etc", remainder
end

function splitStringByCount(myString,count)
    return myString:sub(1,count), myString:sub(count+1)
end

function printPhonemes(phrase)
    local answer
    local strLen = phrase.len()
end

function dump(table)
    for k,v in pairs(table) do
        print("key " .. k .. " value " .. v)
    end
end

function addPhonemesInWordToList(word, phonemeList)
  local phoneme
  while (word ~= "") and (word ~=nil) do
    phoneme, word = findNextPhoneme(word)
    table.insert(phonemeList, phoneme)
    --print("phoneme " .. phoneme .. " remainder " .. word)
    --print("phoneme " .. phoneme)
  end
end

function buildPhonemeListFromPhrase(phrase,phonemeList)
    for word in (string.gmatch(phrase, "%S+")) do
        addPhonemesInWordToList(word,phonemeList)
    end
end

function numKeys(list)
	numItems = 0
	for k,v in pairs(list) do
		numItems = numItems + 1
	end
	return numItems
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
    buildPhonemeListFromPhrase("If God is good", phonemeList)
	self:CalculateStepSize(phonemeList)
	self:SetMouthSwitchKeys(phonemeList)
	if msLipSync.cancel then
		return
	end
	
	
--	if self.restAtEnd then
--	   self.switch:SetValue(msAudioLayer.endFrame,"rest")
--	end
end
