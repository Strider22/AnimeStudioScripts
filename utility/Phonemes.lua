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


Phonemes = {}

--[[First element shows mouth position
--second element shows length of time
 -- c - only one frame
 -- v - multiple frames
 ]]
Phonemes.phonemeMap = {
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
    U = { "O", "v" },
    O = { "O", "v" },
    R = { "O", "v" }
}

Phonemes.phonemeSpecials = { wha = { { "WQ", "v" }, { "U", "v" } }, out = { { "AI", "v" }, { "O", "v" }, { "etc", "c" } } }

function Phonemes:findPhonemeInList(phrase, len, stringList)
    return stringList[phrase:sub(1, len)]
end


function Phonemes:findNextPhoneme(word)
    local wordLen = word:len()
    if wordLen < 1 then return nil, nil end
    local len = 4
    if wordLen < len then len = wordLen end
    for i = len, 1, -1 do
        local phrase, remainder = self:splitStringByCount(word, i)
        local phoneme = self:findPhonemeInList(phrase, i, self.phonemeMap)
        if phoneme ~= nil then
            return phoneme, remainder
        end
    end
    -- if the phoneme is not found, assume it's punctuation and return etc
    print("word " .. word .. " not found")
    return "etc", remainder
end

function Phonemes:splitStringByCount(myString, count)
    return myString:sub(1, count), myString:sub(count + 1)
end

function Phonemes:dump(table)
    for k, v in pairs(table) do
        if (type(v) == "table") then
            self:dump(v)
        else
            print("key " .. k .. " value " .. v)
        end
    end
end

function Phonemes:addPhonemesInWordToList(word, phonemeList)
    local phoneme
    while (word ~= "") and (word ~= nil) do
        phoneme, word = self:findNextPhoneme(word)
        table.insert(phonemeList, phoneme)
        --print("phoneme " .. phoneme .. " remainder " .. word)
        --print("phoneme " .. phoneme)
    end
end

function Phonemes:buildPhonemeListFromPhrase(phrase, phonemeList)
    for word in (string.gmatch(phrase, "%S+")) do
        self:addPhonemesInWordToList(word, phonemeList)
    end
end

function Phonemes:countPhonemes(phonemeList)
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
