-- *********************************************************************
--
-- Reorder Frame By Frame Layers 
--
-- Frame by frame layers will be reordered in a sequential order, increasing 
-- from bottom to top. Layer will start at 0 because a frame is always placed
-- at frame 0 in Anime Studio Frame By Frame.
--
-- *********************************************************************

ScriptName = "msFBFReorder"
msFBFReorder = {}

function msFBFReorder:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/FBFReorder/FBFReorder=Reorder FBF Layers"))
end

function msFBFReorder:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end

function msFBFReorder:GetLayerList(moho)
	local layerCount = moho.layer:CountLayers()
	local list = {}
	for i=0,layerCount-1,1 do
		list[i] = moho.layer:Layer(i):Name()
	end
	return list
end

function msFBFReorder:PrintList(list)
    for k,v in pairs(list) do
        print("key is " .. k .. " value " .. v)
    end
end

function msFBFReorder:InList (list, value)
    for _,v in ipairs(list) do
        if v == value then return true end
    end
	return false
end

-- Run through the key frames and add each unique
-- layers to the list, in the order of their appearance.
-- Unique, so we don't get multiple entries of the same
-- layer, even though multiple key can point to their
-- same layer. 
function msFBFReorder:CreateUniqueKeyOrderList(moho)
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

-- Order switch layers from bottom to top using the keyframes
-- as the order. Frames not referenced in a key are put at the top
function msFBFReorder:ReorderSwitchLayers(moho, uniqueKeyOrderList)
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

-- return a list of keys associated with a switch layer
-- the list is 0 indexed
function msFBFReorder:GetKeyList(moho)
    local list = {}
	local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
	local numKeys = animChannel:CountKeys()
	-- print("numKeys " .. numKeys)
	for id = 0, numKeys-1 do
	--    print("id " .. id) 
		list[id] = animChannel:GetValueByID(id)
	end
	return list
end

-- This is the same looping needed for the RenamingLayers
-- but it needs to be done in a separate step because the renaming 
-- appears to be threaded when it synchronizes the keys, meaning
-- you can rename a single layer and it will update all keys fine, but
-- if you quickly rename multiple layers, it can overlap with the key
-- updates in you get incorrectly named keys
function msFBFReorder:BuildNameMap(moho)
	local layerCount = moho.layer:CountLayers()
	local group = moho:LayerAsGroup(moho.layer)
	local nameMap = {}
	for i=0,layerCount-1,1 do
	    -- print("i " .. i .. " old name " .. group:Layer(i):Name() .. " new name - Layer " .. i)
		nameMap[group:Layer(i):Name()] = "Layer " .. i
	end
	return nameMap
end

-- return a list of keys associated with a switch layer
-- the list is 0 indexed
function msFBFReorder:RenameKeys(moho, keyList, nameMap)
	local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
	local numKeys = animChannel:CountKeys()
    for id,val in pairs(keyList) do
		-- print("id " .. id .. " val ".. val)
		animChannel:SetValueByID(id, nameMap[val])
    end
end

function msFBFReorder:RenameLayers(moho)
	local layerCount = moho.layer:CountLayers()
	local group = moho:LayerAsGroup(moho.layer)
	-- print("count " .. layerCount)
	nameMap = {}
	for i=0,layerCount-1,1 do
	    -- print("i " .. i .. " old name " .. group:Layer(i):Name() .. " new name - Layer " .. i)
		-- nameMap[group:Layer(i):Name()] = "Layer " .. i
		group:Layer(i):SetName("Layer ".. i)
	end
end




function msFBFReorder:Pause()
		LM.GUI.Alert(LM.GUI.ALERT_INFO,
		MOHO.Localize("/Scripts/Menu/FBTest/ScriptsCanDisplayAlertBoxes=Scripts can display alert boxes."),
		nil,
		nil,
		MOHO.Localize("/Scripts/OK=OK"),
		nil,
		nil)
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msFBFReorder:Run(moho)
    local uniqueKeyOrderList = self:CreateUniqueKeyOrderList(moho)
    -- self:PrintList(uniqueKeyOrderList)
	-- self:Pause()
	self:ReorderSwitchLayers(moho, uniqueKeyOrderList)
	-- The order of events is critical due to 
	-- synchronization issues. See BuildNameMap
	-- for more info
	local keyList = self:GetKeyList(moho)
	local nameMap = self:BuildNameMap(moho)
	-- self:Pause()
	self:RenameLayers(moho)
	self:RenameKeys(moho, keyList, nameMap)
	-- print("print name map")
	-- self:PrintList(nameMap)
	--self:RenameKeys(moho)
end
