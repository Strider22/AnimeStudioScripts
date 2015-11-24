ScriptName = "msPhonemes"
-- utility scripts cannot be in the menu directory
--[[
--Class for generating phonemes from strings.
 -- Originally written to support lipSync in Anime Studio
 ]]
-- next steps
-- turn phoneme list into switch frames, removing duplicates as needed (space out frames
-- remove silent e
-- special case handling (what - qw u etc; about - u mpb ai o etc)
-- ignore e at the end of a word
-- long if only one consonant between
-- y at end i


-- IO library http://www.lua.org/pil/21.html


msPhonemes = {}
--[[First element shows mouth position
--second element shows length of time
 -- c - only one frame
 -- v - multiple frames
 ]]
msPhonemes.phonemeMap = {
    a = { "AI", "v" },
    b = { "MBP", "c" },
    c = { "etc", "c" },
    d = { "etc", "c" },
    e = { "E", "v" },
    f = { "FV", "v" },
    g = { "etc", "c" },
    h = { "etc", "c" },
    i = { "E", "v" },
    j = { "etc", "c" },
    k = { "etc", "c" },
    l = { "L", "v" },
    m = { "MBP", "v" },
    n = { "etc", "v" },
    o = { "O", "v" },
    p = { "MBP", "c" },
    q = { "WQ", "c" },
    r = { "etc", "v" },
    s = { "etc", "v" },
    t = { "etc", "c" },
    u = { "U", "v" },
    v = { "FV", "v" },
    w = { "WQ", "v" },
    x = { "etc", "v" },
    y = { "etc", "v" },
    z = { "etc", "v" },
    oo = { "U", "v" },
    oa = { "O", "v" },
    ee = { "E", "v" },
    ea = { "E", "v" },
    ch = { "etc", "c" },
    th = { "etc", "v" },
    gh = { "FV", "v" },
    ou = { "U", "v" },
    wh = { "WQ", "v" },
    igh = { "AI", "v" },
    eigh = { "AI", "v" },
    A = { "AI", "v" },
    E = { "E", "v" },
    I = { "AI", "v" },
    U = { "U", "v" },
    O = { "O", "v" },
    R = { "O", "v" },
	["-"] = { "rest","c"}
}

msPhonemes.phonemeSpecials = { wha = { { "WQ", "v" }, { "U", "v" } }, out = { { "AI", "v" }, { "O", "v" }, { "etc", "c" } } }

function msPhonemes.new()
    -- private variables
    local self = {}
	self.boneMaps = {}
	self.boneMap = nil
	
	function self.BuildPhonemeMap(path)
		local f = io.open(path, "r")
		if (f == nil) then
			print("lipSync File not found in: " .. path)
			return
		end

		--Read the first line of the file
		local line = f:read()
		local name, numBones = self.splitStringByWord(line)
		while (string.upper(name) ~= "END") do
			--print("name " .. name)
			numBones = tonumber(numBones)
			self.addBoneMap(name, numBones)
			self.getBoneNames(name,numBones, f:read())
			for i = 1, 10, 1 do
				 self.addPhonemeBones(name,numBones, f:read())
			end
			line = f:read()
			name, numBones = self.splitStringByWord(line)
		end
		f:close()
	end

	function self.addBoneMap(name,numBones)
		self.boneMaps[name] = {}
		self.boneMaps[name]["numBones"] = numBones
	end
	
	function self.getBoneNames(name,numBones,line)
	    for i = 1, numBones, 1 do
			self.boneMaps[name][i], line = self.splitStringByWord(line)
		end
	end

	-- call this before calling any of the bone map specific functions
	function self.setBoneMap(name)
		self.boneMap = self.boneMaps[name]
		if self.boneMap == nil then print("boneMap " .. name .. " does not exist") end
	end
	
	function self.numBones()
		if self.boneMap == nil then print("bone has not been set") end
		return self.boneMap["numBones"]
	end

	function self.boneName(id)
		if self.boneMap == nil then print("bone has not been set") end
		return self.boneMap[id]
	end

	function self.boneAngle(id, mouth)
		if self.boneMap == nil then print("bone has not been set") end
		return self.boneMap[mouth][self.boneName(id)]
	end
	
	function self.boneAngleRad(id, mouth)
		return math.rad(self.boneAngle(id,mouth))
	end

	function self.addPhonemeBones(name,numBones, line)
		local bones = {}
		local phoneme = ""
		phoneme, line = self.splitStringByWord(line)
	    for i = 1, numBones, 1 do
			bones[self.boneMaps[name][i]], line = self.splitStringByWord(line)
		end
		local phonemeBones = {}
		self.boneMaps[name][phoneme] = bones
	end

	function self.dump(table)
		for k, v in pairs(table) do
			if (type(v) == "table") then
				print("table key " .. k)
				self.dump(v)
			else
				print("key " .. k .. " value " .. v)
			end
		end
	end

	
	function self.splitStringByWord(myString)
		local s, e = string.find(myString, "%S+")
		
		return string.sub(myString,s,e), string.sub(myString, e + 1)
	end

	function self.splitStringByCount(myString, count)
		return myString:sub(1, count), myString:sub(count + 1)
	end

	function self.countPhonemes(phonemeList)
		local numConsonants = 0
		local numVowels = 0
		for k, v in pairs(phonemeList) do
			if v[2] == "v" then
				numVowels = numVowels+1
			else
				numConsonants = numConsonants + 1
			end
		end
		return numVowels, numConsonants
	end

	function self.findPhonemeInList(phrase, len, stringList)
		return stringList[phrase:sub(1, len)]
	end


	function self.addPhonemesFromWordPhonetically(word, phonemeList)
		msHelper:Debug("splitting word phonetically")
		local wordLen = word:len()
		if wordLen < 1 then return nil, nil end
		for i = 1,wordLen, 1 do
			local letter = word:sub(i, i)
			msHelper:Debug("letter " ..letter)
			if letter:match("%a-") == nil then
				msHelper:Debug(letter .. " is not a letter, setting phoneme to rest")
				msHelper:Debug("rest is '" .. msPhonemes.phonemeMap["-"][1] .. "'  ")
				table.insert(phonemeList, msPhonemes.phonemeMap["-"])
			elseif string.match(letter,"[^AEIOUR]") then
				letter = letter:lower()
			end
			local phoneme = msPhonemes.phonemeMap[letter]
			if phoneme == nil then
				msHelper:Debug(letter .. " not understood, setting phoneme to rest")
				msHelper:Debug("rest is '" .. msPhonemes.phonemeMap["-"][1] .. "'  ")
				table.insert(phonemeList, msPhonemes.phonemeMap["-"])
			else
				msHelper:Debug(" phoneme " .. phoneme[1])
				table.insert(phonemeList, phoneme)
			end
		end
	end

	function self.findNextNonphoneticPhoneme(word)
		msHelper:Debug("splitting word non-phonetically")
		local wordLen = word:len()
		-- nonPhonetic match needs to be lower case
		word = word:lower()
		if wordLen < 1 then return nil, nil end
		local len = 4
		if wordLen < len then len = wordLen end
		for i = len, 1, -1 do
			local phrase, remainder = self.splitStringByCount(word, i)
			if i == 1 then 
				if string.match(phrase, "%a") == nil then
					msHelper:Debug(phrase .. " is not a letter, setting phoneme to rest")
					return msPhonemes.phonemeMap["-"], remainder
				end
			end
			local phoneme = self.findPhonemeInList(phrase, i, msPhonemes.phonemeMap)
			if phoneme ~= nil then
				return phoneme, remainder
			else
			end
		end
		-- if the phoneme is not found, assume it's punctuation and return etc
		msHelper:Debug("word " .. word .. " not found. Setting phoneme to etc")
		return msPhonemes.phonemeMap["etc"], remainder
	end


	function self.addPhonemesInWordToList(word, phonemeList, splitPhonetically)
		local phoneme
		if splitPhonetically then 
			self.addPhonemesFromWordPhonetically(word, phonemeList)
		else
			while (word ~= "") and (word ~= nil) do
				phoneme, word = self.findNextNonphoneticPhoneme(word)
				table.insert(phonemeList, phoneme)
				--print("phoneme " .. phoneme .. " remainder " .. word)
				--print("phoneme " .. phoneme)
			end
		end
	end

	function self.buildPhonemeListFromPhrase(phrase, phonemeList, splitPhonetically)
	
		for word in (string.gmatch(phrase, "%S+")) do
			self.addPhonemesInWordToList(word, phonemeList, splitPhonetically)
		end
	end

    return self

end






