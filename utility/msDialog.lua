msDialog = {}

msDialog.location = 0
msDialog.alignment = LM.GUI.ALIGN_LEFT
msDialog.layout = 0
msDialog.dialog = 0
msDialog.cancelled = false

function msDialog:Display(moho, dialogType)
	local dialog = dialogType:new(moho)
	return dialog:DoModal()
	-- if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		-- self.cancelled = true
	-- end
end

function msDialog:SimpleDialog(title, subclass)
	self.dialog = LM.GUI.SimpleDialog(title, subclass)
	self.layout = self.dialog:GetLayout()
	return self.dialog, self.layout
end

function msDialog:SetLocalizationLocation(location)
	msHelper:Debug("Init location " ..location)
	self.location = location
end

function msDialog:Localize(value, label)
	msHelper:Debug(value)
	msHelper:Debug(label)
	return MOHO.Localize(self.location..value.."="..label)
end

function msDialog:Control(componentFunction, value, label)
	local control = componentFunction(self:Localize(value, label))
	self.layout:AddChild(control, self.alignment)
	return control
end

--Just a label
function msDialog:AddText(label)
	self.layout:AddChild(LM.GUI.StaticText(label), self.alignment)
end

function msDialog:AddTextBox(label)
	local control
	self.layout:PushH(self.alignment)
	msDialog:AddText(label)
	control = msDialog:AddTextControl(0, "This is the layer name", 0, LM.GUI.FIELD_TEXT)
	self.layout:Pop()
	return control
end

function msDialog:AddCheckBox(label)
	local control = LM.GUI.CheckBox(label)
	self.layout:AddChild(control,self.alignment)
	return control
end


function msDialog:AddFloat(label)
	local control
	self.layout:PushH(self.alignment)
	msDialog:AddText(label)
	control = msDialog:AddTextControl(0, "1.0000", 0, LM.GUI.FIELD_FLOAT)
	self.layout:Pop()
	return control
end

function msDialog:AddTextControl(width, text, message, type)
	local control = LM.GUI.TextControl(width, text, message, type)
	self.layout:AddChild(control, self.alignment)
	return control
end


function msDialog:MakePopup(menu)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	self.layout:AddChild(popup)
end


function msDialog:CreateDropDownMenu(title, list, msgBase)
	self.layout:PushH(self.alignment)
		msDialog:AddText(title)
		local menu = LM.GUI.Menu(title)

		if msgBase == nil then
			msgBase = MOHO.MSG_BASE
		end
		menu.msgBase = msgBase

		for index,value in ipairs(list) do
			menu:AddItem(value, 0, msgBase + index -1)
		end

		self:MakePopup(menu)
	self.layout:Pop()
	return menu
end

function msDialog:CreateLayerDropDownMenuFromList(moho, title, layerList, msgBase)
	self.layout:PushH(self.alignment)
		msDialog:AddText(title)
		local menu = LM.GUI.Menu(title)

		if msgBase == nil then
			msgBase = MOHO.MSG_BASE
		end
		menu.msgBase = msgBase


		for k,layer in ipairs(layerList) do
			menu:AddItem(layer:Name(), 0, msgBase + k -1)
		end
		
		menu:SetChecked(MOHO.MSG_BASE, true)
		self:MakePopup(menu)
	self.layout:Pop()
	return menu
end

function msDialog:CreateBoneLayerDropDownMenu(moho, title, msgBase, groupLayerName)
	return self:CreateLayerDropDownMenu(moho, title, msgBase, MOHO.LT_BONE, groupLayerName)
end

function msDialog:CreateVectorLayerDropDownMenu(moho, title, msgBase, groupLayerName)
	return self:CreateLayerDropDownMenu(moho, title, msgBase, MOHO.LT_VECTOR, groupLayerName)
end

function msDialog:CreateLayerDropDownMenu(moho, title, msgBase, layerType, groupLayerName)
	self.layout:PushH(self.alignment)
		msDialog:AddText(title)
		local menu = LM.GUI.Menu(title)

		if msgBase == nil then
			msgBase = MOHO.MSG_BASE
		end
		menu.msgBase = msgBase

		local parentLayer = nil
		if groupLayerName == nil then
			parentLayer = moho.document
		else
			local groupLayer = moho.document:LayerByName(groupLayerName)
			if not groupLayer:IsGroupType()then
				print("layer ", groupLayerName, " needs to be a group type or nil")
			else
				parentLayer = moho:LayerAsGroup(groupLayer)
			end
		end
		
		local msg = 0
		for i = parentLayer:CountLayers()-1,0,-1 do
			local layer = parentLayer:Layer(i)
			if layerType == nil then
				menu:AddItem(layer:Name(), 0, msgBase + msg)
				msg = msg + 1
			elseif (layer:LayerType() == layerType) then
				menu:AddItem(layer:Name(), 0, msgBase + msg)
				msg = msg + 1
			end
		end
		
		self:MakePopup(menu)
	self.layout:Pop()
	return menu
end

function msDialog:CreateSelectedLayerDropDownMenu(moho, title, msgBase)
	self.layout:PushH(self.alignment)
		self:AddText(title)
		local menu = LM.GUI.Menu(title)
		if msgBase == nil then
			msgBase = MOHO.MSG_BASE
		end
		menu.msgBase = msgBase
		-- use msg to align with CreateLayerDropDownMenu which
		-- can have missing layers and the fact that we want 
		-- to always start the menu at 0		
		local msg = 0
		for i = moho.document:CountSelectedLayers()-1,0,-1 do
			local layer = moho.document:GetSelectedLayer(i)
			menu:AddItem(layer:Name(), 0, msgBase + msg)
			msg = msg +1
		end
		
		self:MakePopup(menu)
	self.layout:Pop()
	return menu
end

function msDialog:SetMenuByLabel(menu,layerLabel)
	menu:UncheckAll()
	if layerLabel ~= nil then
		menu:SetCheckedLabel(layerLabel, true)
	else 
		menu:SetChecked(menu.msgBase,true)
	end
end


function msDialog:AudioDropdown(moho, value, label,initialLayer)
	local menu = LM.GUI.Menu(self:Localize(value, label))

	for i = 0, moho:CountAudioLayers() - 1 do
		local audioLayer = moho:GetAudioLayer(i)
		menu:AddItem(audioLayer:Name(), 0, MOHO.MSG_BASE + i)
	end
	
	menu:SetChecked(MOHO.MSG_BASE + initialLayer, true)
	self:MakePopup(menu)
	return menu
end

