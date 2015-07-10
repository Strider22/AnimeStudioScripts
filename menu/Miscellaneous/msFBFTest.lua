ScriptName = "msFBFTest"
msFBFTest = {}

function msFBFTest:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/FBFTest/FBFTest=FBFTest"))
end

function msFBFTest:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end

-- return a list of keys associated with a switch layer
-- the list is 0 indexed
function msFBFTest:GetKeyList(moho)
    local list = {}
		local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
		local numKeys = animChannel:CountKeys()
		-- print("numKeys " .. numKeys)
		for id = 0, numKeys-1 do
		--    print("id " .. id) 
			list[id] = {frame = animChannel:GetKeyWhen(id), value = animChannel:GetValueByID(id)}
		end
	return list
end

-- #keyList is the max index of the list, not the size of the list
-- the size of the list is #keyList + 1, because we're 0 indexed
function msFBFTest:PrintKeyList(keyList)
	print("Key list " .. #keyList+1)
	for id = 0, #keyList do
		print("key ".. id .. " frame " .. keyList[id].frame .. " value " .. keyList[id].value)
	end
end


function msFBFTest:GetLayerList(moho)
	local layerCount = moho.layer:CountLayers()
	local list = {}
	for i=0,layerCount-1,1 do
		list[i] = moho.layer:Layer(i):Name()
	end
	return list
end

-- #layerList is the max index of the list, not the size of the list
-- the size of the list is #layerList + 1, because we're 0 indexed
function msFBFTest:PrintLayerList(layerList)
	print("Layers " .. #layerList +1)
	for id = 0, #layerList do
		print("layer ".. id .. " name " .. layerList[id])
	end
end

function msFBFTest:PrintList(list)
    for k,v in ipairs(list) do
        print("key is " .. k .. " value " .. v)
    end
end

function msFBFTest:InList (list, value)
    for _,v in ipairs(list) do
        if v == value then return true end
    end
	return false
end

--Run through the key frames and add each unique
--layers to the list, in the order of their appearance
function msFBFTest:CreateUniqueKeyOrderList(moho)
	local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
	local numKeys = animChannel:CountKeys()
	local uniqueKeyOrderList = {}

	for id = 0, numKeys-1 do
		local value = animChannel:GetValueByID(id)
		if not self:InList(uniqueKeyOrderList, value) then
			table.insert(uniqueKeyOrderList,value)
		end
	end
	return uniqueKeyOrderList
end

function msFBFTest:ReorderSwitchLayers(moho, uniqueKeyOrderList)
	local group = moho:LayerAsGroup(moho.layer)
	-- use layerCount to prevent accidental infinite loop 
	-- if something unexpected happens
    local layerCount = moho.layer:CountLayers()
	
	--Order switch layers that are found in key frames
    -- based on their order in the key frames
	for _,v in ipairs(uniqueKeyOrderList) do
		moho:PlaceLayerInGroup(group:LayerByName(v), moho.layer, true)
	end

	-- Move layers, not found in keys, to top
	local i = 0
    while group:Layer(0):Name() ~= uniqueKeyOrderList[1] do
		moho:PlaceLayerInGroup(group:Layer(0), moho.layer, true)
		-- make sure we don't run into an infinite loop 
		i = i + 1
		if i == layerCount then break end
	end
end

local nameMap = {}
function msFBFTest:RenameLayers(moho)
	local layerCount = moho.layer:CountLayers()
	local group = moho:LayerAsGroup(moho.layer)
	-- print("moho.layer:Layer(i):Name()" .. group:Layer(0):Name())
	for i=0,layerCount-1,1 do
		nameMap[group:Layer(i):Name()] = "Layer " .. i
		group:Layer(i):SetName("Layer ".. i)
	end
	
end

-- return a list of keys associated with a switch layer
-- the list is 0 indexed
function msFBFTest:RenameKeys(moho)
	local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
	local numKeys = animChannel:CountKeys()
	print("numKeys " .. numKeys)
	for id = 0, numKeys-1 do
		   print("id " .. id)
		animChannel:SetValueByID(id, nameMap[animChannel:GetValueByID(id)])
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msFBFTest:Run(moho)
    local uniqueKeyOrderList = self:CreateUniqueKeyOrderList(moho)
    -- self:PrintList(uniqueKeyOrderList)
	self:ReorderSwitchLayers(moho, uniqueKeyOrderList)
	self:RenameLayers(moho)
	self:PrintList(nameMap)
	-- self:RenameKeys(moho)
end
