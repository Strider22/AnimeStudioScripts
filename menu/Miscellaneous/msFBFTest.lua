ScriptName = "msFBFTest"
msFBFTest = {}

function msFBFTest:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/FBFTest/FBFTest=FBFTest"))
end


-- return a list of keys associated with a switch layer
-- the list is 0 indexed
function msFBFTest:GetKeyList(moho)
    local list = {}
	if moho.layer:LayerType() == MOHO.LT_SWITCH then
		-- the animChannel is the set of key values, the animation, for the
		-- animationType associated with the layer
		local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
		local numKeys = animChannel:CountKeys()
		-- print("numKeys " .. numKeys)
		for id = 0, numKeys-1 do
		--    print("id " .. id) 
			list[id] = {frame = animChannel:GetKeyWhen(id), value = animChannel:GetValueByID(id)}
		end
	else 
		print ("Layer is not a switch layer")
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


function msFBFTest:MoveLayerToBottom(moho)
	moho:PlaceLayerInGroup(moho:LayerAsGroup(moho.layer):Layer(0), moho.layer, false)
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



function msFBFTest:RenameSwitchLayersByID(layer)
	if layer:LayerType() == MOHO.LT_SWITCH then
		local layerCount = moho.layer:CountLayers()
		for i=0,layerCount-1,1 do
			moho.layer:Layer(i):SetName("Layer ".. i)
		end
	else 
		print ("The selected layer is not a switch layer")
	end
end

	
	
	
-- **************************************************
-- The guts of this script
-- **************************************************

function msFBFTest:Run(moho)
--	self:ListSwitchLayers(moho.layer)

	-- local keyList = self:GetKeyList(moho)
	-- self:PrintKeyList(keyList)
	-- local layerList = self:GetLayerList(moho)
	-- self:PrintLayerList(layerList)
	
	-- self:MoveTopLayerToBottom(moho)
    self:GroupMoveBottomLayerToTop(moho)
end

