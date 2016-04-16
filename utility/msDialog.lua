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

function msDialog:AddText(label)
	self.layout:AddChild(LM.GUI.StaticText(label), self.alignment)
end

function msDialog:AddFloat(label)
	local control
	self.layout:PushH(self.alignment)
		msDialog:AddText(label)
		control = msDialog:AddTextControl(0, "1.0000", 0, LM.GUI.FIELD_FLOAT)
	self.layout:Pop()
	return control
end

function msDialog:AddCheckBox(label)
	local control = LM.GUI.CheckBox(label)
	self.layout:AddChild(control,self.alignment)
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


function msDialog:CreateDropDownMenu(title, list)
	local menu = LM.GUI.Menu(title)
	for index,value in ipairs(list) do
		menu:AddItem(value, 0, MOHO.MSG_BASE + index -1)
	end

	self:MakePopup(menu)
	return menu
end

function msDialog:CreateBoneLayerDropDownMenu(moho, title)
	return self:CreateLayerDropDownMenu(moho, title, MOHO.LT_BONE)
end

function msDialog:CreateVectorLayerDropDownMenu(moho, title)
	return self:CreateLayerDropDownMenu(moho, title, MOHO.LT_VECTOR)
end


function msDialog:CreateLayerDropDownMenu(moho, title, layerType)
	self.layout:PushH(self.alignment)
		msDialog:AddText(title)
		local menu = LM.GUI.Menu(title)

		for i = 0, moho.document:CountLayers()-1 do
			local layer = moho.document:Layer(i)
			if (layer:LayerType() == layerType) then
				menu:AddItem(layer:Name(), 0, MOHO.MSG_BASE + i)
			end
		end
		
		menu:SetCheckedLabel(moho.document:Layer(0):Name(), true)
		self:MakePopup(menu)
	self.layout:Pop()
	return menu
end

function msDialog:CreateSelectedLayerDropDownMenu(moho, title)
	local menu = LM.GUI.Menu(title)

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		menu:AddItem(layer:Name(), 0, MOHO.MSG_BASE + i)
	end

	menu:SetChecked(MOHO.MSG_BASE, true)
	self:MakePopup(menu)
	return menu
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

