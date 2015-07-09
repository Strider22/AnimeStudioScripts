-- Demonstrates how to move layers within a group
-- The script is not enabled unless a group layer is selected

ScriptName = "msMoveGroupLayers"
msMoveGroupLayers = {}

function msMoveGroupLayers:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/MoveGroupLayers/MoveGroupLayers=Move Group Layers"))
end

-- Only enable the script if a group layer is selected
function msMoveGroupLayers:IsEnabled(moho)
	if moho.layer:IsGroupType() then
		return true
	end
	return false
end

-- This is another way to move a layer. It's best if you want to 
-- move to some postion other than the top, because it places
-- the layer behind/below an identified layer
-- function msMoveGroupLayers:MoveTopLayerToBottom(moho)
	-- local layerCount = moho.layer:CountLayers()
	-- if layerCount < 2 then return end
	-- moho:PlaceLayerBehindAnother(moho.layer:Layer(layerCount-1), moho.layer:Layer(0))
-- end

-- This works even if the group only has one layer. 
function msMoveGroupLayers:GroupMoveBottomLayerToTop(moho)
	-- Arguments are layer to move, group, to top?
	moho:PlaceLayerInGroup(moho:LayerAsGroup(moho.layer):Layer(0), moho.layer, true)
end

	
-- **************************************************
-- The guts of this script
-- **************************************************

function msMoveGroupLayers:Run(moho)
	-- self:MoveTopLayerToBottom(moho)
    self:GroupMoveBottomLayerToTop(moho)
end

