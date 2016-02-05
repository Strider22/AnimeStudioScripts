-- *********************************************************************
--
-- Reorder Frame By Frame Layers 
--
-- Frame by frame layers will be reordered in a sequential order, increasing 
-- from bottom to top. Layer will start at 0 because a frame is always placed
-- at frame 0 in Anime Studio Frame By Frame.
--
-- *********************************************************************

ScriptName = "msInsertInGroup"
msInsertInGroup = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msInsertInGroup:Name()
	return "Insert Layers in Group"
end

function msInsertInGroup:Version()
	return "1.0"
end

function msInsertInGroup:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Selected layers will be placed in group layers.")
end

function msInsertInGroup:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msInsertInGroup:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/InsertInGroup/InsertInGroup=Insert layers into groups"))
end

-- Order switch layers from bottom to top using the keyframes
-- as the order. Frames not referenced in a key are put at the top
function msInsertInGroup:ReorderSwitchLayers(moho, uniqueKeyOrderList)
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


function msInsertInGroup:InsertLayerInGroup(layer)
	local groupLayer = self.moho:CreateNewLayer(MOHO.LT_GROUP, true)
	groupLayer:SetName(layer:Name())
	self.moho:PlaceLayerInGroup(layer, groupLayer, true,true)
end



-- **************************************************
-- The guts of this script
-- **************************************************

function msInsertInGroup:Run(moho)
	self.moho = moho
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
        self:InsertLayerInGroup(layer)
	end
end
