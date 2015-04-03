msDialog = {}

msDialog.location = 0
msDialog.alignment = LM.GUI.ALIGN_LEFT
msDialog.layout = 0
msDialog.dialog = 0
msDialog.cancelled = false

function msDialog:Display(moho, dialogType)
	local dialog = dialogType:new(moho)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		self.cancelled = true
	end
end

function msDialog:Init(location, dialog, layout)
	msHelper:Debug("Init location " ..location)
	self.location = location
	self.dialog = dialog
	self.layout = layout
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

function msDialog:AddText(value, label)
	self.layout:AddChild(LM.GUI.StaticText(self:Localize(value, label)),
		self.alignment)
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

