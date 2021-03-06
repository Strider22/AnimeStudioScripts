-- STATUS - works
-- Layer Text can be used for append or replace
--  replace will only replace the selected layer, no matter what other setting are
--  append is especially for appending something like "-random" to all selected layers
ScriptName = "msRenameLayers"
msRenameLayers = {}

function msRenameLayers:Description()
	return "Renames layers based on map or by removing whitespace. Can use selected layer or all layers."
end
function msRenameLayers:UILabel()
	return(ScriptName)
end

msRenameLayers.nameMap = {
	["leftlowerarm"] = "left lower arm"
}


function msRenameLayers:Name()
	return ScriptName
end

function msRenameLayers:Version()
	return "1.0"
end

function msRenameLayers:Creator()
	return "Mitchel Soltys"
end

msRenameLayers.appendString = nil
msRenameLayers.renameType = nil
msRenameLayers.selectLayer = nil
msRenameLayers.includeSubLayers = true
msRenameLayers.placeInSwitchGroup = false
msRenameLayers.layerText = ""

local msRenameLayersDialog = {}

function msRenameLayersDialog:new(moho)
	local self, l = msDialog:SimpleDialog("RenameLayers", self)

	self.moho = moho

	self.renameTypeMenu = msDialog:CreateDropDownMenu("Rename Type",{"Remove White Space", "Append", "Rename by Map",
		"Rename by String", "Rename by Incremental String"})
	self.layerTypeMenu = msDialog:CreateDropDownMenu("Layers Type",{"Selected Layers", "All Layers"})
	self.includeSubLayers = msDialog:AddCheckBox("Include Sublayers")
	self.placeInSwitchGroup = msDialog:AddCheckBox("Place in Switch Group")
	self.layerText = msDialog:AddTextBox("Layer Text")

	return self
end

function msRenameLayersDialog:UpdateWidgets()
	msDialog:SetMenuByLabel(self.renameTypeMenu,msRenameLayers.renameType)
	msDialog:SetMenuByLabel(self.layerTypeMenu,msRenameLayers.layerType)

	self.layerText:SetValue(msRenameLayers.layerText)
	self.includeSubLayers:SetValue(msRenameLayers.includeSubLayers)
	self.placeInSwitchGroup:SetValue(msRenameLayers.placeInSwitchGroup)
end


function msRenameLayersDialog:OnOK()
	msRenameLayers.renameType = self.renameTypeMenu:FirstCheckedLabel()
	msRenameLayers.layerType = self.layerTypeMenu:FirstCheckedLabel()

	msRenameLayers.layerText = self.layerText:Value()
	msRenameLayers.includeSubLayers = self.includeSubLayers:Value()
	msRenameLayers.placeInSwitchGroup = self.placeInSwitchGroup:Value()
end


function msRenameLayers:RenameLayerByType(layer, index)
	if self.renameType == "Remove White Space" then
		self:RemoveWhiteSpaceFromLayerName(layer, self.includeSubLayers)
	elseif self.renameType == "Append" then
		self:AppendLayerName(layer, self.includeSubLayers)
	elseif self.renameType == "Rename by Incremental String" then
		self:ReplaceLayerName(layer, self.layerText .. index)
	elseif self.renameType == "Rename by String" then
		self:ReplaceLayerName(layer, self.layerText)
	else
		self:RenameLayerByMap(layer, self.includeSubLayers)
	end
end

function msRenameLayers:ReplaceLayerName(layer, newName)
	layer:SetName(newName)
end

function msRenameLayers:RenameLayerByMap(layer, includeSubLayers)
	local newName = self.nameMap[layer:Name()]
	if newName ~= nil then
		layer:SetName(newName)
	end

	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:RenameLayer(sublayer, includeSubLayers)
		end
	end
end

function msRenameLayers:RemoveWhiteSpaceFromLayerName(layer, includeSubLayers)
	local name = layer:Name():gsub("%s+", "")
	layer:SetName(name)

	if not includeSubLayers then
		return
	end

	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:RemoveWhiteSpaceFromLayerName(sublayer, includeSubLayers)
		end
	end

end

function msRenameLayers:AppendLayerName(layer, includeSubLayers)
	local name = layer:Name() .. " " .. self.layerText
	layer:SetName(name)

	if not includeSubLayers then
		return
	end

	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:AppendLayerName(sublayer, self.layerText, includeSubLayers)
		end
	end

end

function msRenameLayers:RenameAllLayers()
	for i=0,self.moho.document:CountLayers()-1,1 do
		local layer = self.moho.document:LayerByAbsoluteID(i)
		self:RenameLayerByType(layer, i)
	end
end

function msRenameLayers:RenameSelectedLayers()
	local selectedLayers = {}

	for i = 0, self.moho.document:CountSelectedLayers()-1 do
		local layer = self.moho.document:GetSelectedLayer(i)
		selectedLayers[i+1] = layer
		self:RenameLayerByType(layer, i)
	end
	if (self.renameType ~= "Append") and (self.placeInSwitchGroup) then
		self:InsertLayersInSwitchGroup(selectedLayers)
	end
end

function msRenameLayers:RenameLayers()
	if (self.layerType == "Selected Layers") or (self.renameType == "Rename by String") then
		self:RenameSelectedLayers()
	else
		self:RenameAllLayers()
	end
end

function msRenameLayers:InsertLayersInSwitchGroup(selectedLayers)
	local groupLayer = self.moho:CreateNewLayer(MOHO.LT_SWITCH, true)
	groupLayer:SetName(self.layerText)
	for k,v in ipairs(selectedLayers) do
		self.moho:PlaceLayerInGroup(v, groupLayer, true,true)
	end
end



-- **************************************************
-- The guts of this script
-- **************************************************

function msRenameLayers:Run(moho)
	local dialog = msRenameLayersDialog:new(moho)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	self.moho = moho
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:InsertLayerInGroup(layer)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msRenameLayers:Run(moho)
	self.moho = moho
	msDialog:Display(moho, msRenameLayersDialog)
	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

	self:RenameLayers()
end