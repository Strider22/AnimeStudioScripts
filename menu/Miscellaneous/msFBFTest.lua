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

function msFBFTest:CreateSet (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

--Run through the key frames and add each unique
--layers to the list, in the order of their appearance
function msFBFTest:CreateUniqueKeyOrderList(moho)
	local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
	local numKeys = animChannel:CountKeys()
	local uniqueKeyOrderList = {}
	local orderSet = self:CreateSet(uniqueKeyOrderList)

	for id = 0, numKeys-1 do
		local value = animChannel:GetValueByID(id)
		if not orderSet[value] then
			table.insert(uniqueKeyOrderList,value)
		end
	end
	return uniqueKeyOrderList
end

function msFBFTest:ReorderSwitchLayers(moho, uniqueKeyOrderList)
	local group = moho:LayerAsGroup(moho.layer)

	--Order switch layers that are found in key frames
    -- based on their order in the key frames
	for _,v in ipairs(uniqueKeyOrderList) do
		moho:PlaceLayerInGroup(group:LayerByName(v), moho.layer, true)
	end

	-- Move layers, not found in keys, to top
    while group:Layer(0) ~= uniqueKeyOrderList[0] do
		moho:PlaceLayerInGroup(group:Layer(0), moho.layer, true)
	end
end

local nameMap = {}
function msFBFTest:RenameLayers(moho)
	local layerCount = moho.layer:CountLayers()
	for i=0,layerCount-1,1 do
		nameMap[moho.layer:Layer(i):Name()] = "Layer " .. i
		moho.layer:Layer(i):SetName("Layer ".. i)
	end
end

-- return a list of keys associated with a switch layer
-- the list is 0 indexed
function msFBFTest:RenameKeys(moho)
	local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
	local numKeys = animChannel:CountKeys()
	-- print("numKeys " .. numKeys)
	for id = 0, numKeys-1 do
		--    print("id " .. id)
		animChannel:SetValueByID(id, nameMap[animChannel:GetValueByID(id)])
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msFBFTest:Run(moho)
    local uniqueKeyOrderList = self:CreateUniqueKeyOrderList(moho)
    self:PrintList(uniqueKeyOrderList)
	-- local keyList = self:GetKeyList(moho)
	-- self:PrintKeyList(keyList)
	-- local layerList = self:GetLayerList(moho)
	-- self:PrintLayerList(layerList)
	
	-- self:MoveTopLayerToBottom(moho)
    --self:GroupMoveBottomLayerToTop(moho)
end

--local switchLayers = {"feet", "legs", "body", "shoulders", "head"}
--local keyFrames = {"shoulders", "body", "shoulders", "legs"}
--
--for k,v in ipairs(switchLayers) do
--	print("layer " .. k .. " value " .. v)
--end
--for k,v in ipairs(keyFrames) do
--	print("keyframe " .. k .. " value " .. v)
--end
--
--local i = 1
--local renameMap = {}
--for k,v in ipairs(switchLayers) do
--	switchLayers[k] = "Layer " .. i
--	renameMap[v] = "Layer " .. i
--	i =i+1
--end
--
--print("renamemap")
--for k,v in pairs(renameMap) do
--	print("layer " .. k .. " value " .. v)
--end
--
--for k,v in pairs(keyFrames) do
--	keyFrames[k] = renameMap[v]
--end
--
--
--print("After renaming ")
--for k,v in ipairs(switchLayers) do
--	print("layer " .. k .. " value " .. v)
--end
--for k,v in ipairs(keyFrames) do
--	print("keyframe " .. k .. " value " .. v)
--end
