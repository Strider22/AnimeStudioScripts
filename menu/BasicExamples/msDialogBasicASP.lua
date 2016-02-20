ScriptName = "msDialogBasicASP"
msDialogBasicASP = {}

function msDialogBasicASP:Description()
	return "Basic Dialog using native ASP syntax."
end


msDialogBasicASP.BASE_STR = 2540

function msDialogBasicASP:Name()
	return "DialogBasicASP"
end

function msDialogBasicASP:Version()
	return "1.0"
end

function msDialogBasicASP:Creator()
	return "Mitchel Soltys"
end

function msDialogBasicASP:UILabel()
	return "DialogBasicASP ..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msDialogBasicASP.srcLayer = 0
msDialogBasicASP.offsetStartFrame = 1
msDialogBasicASP.skipToStart = true


-- **************************************************
-- DialogExample dialog
-- **************************************************

local msDialogBasicASPDialog = {}


function msDialogBasicASPDialog:new(moho)
	local d = LM.GUI.SimpleDialog("DialogBasicASP", msDialogBasicASPDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Select Base Animation Layer"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Offset Start frame"),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Select Layer")
			d.offsetStartFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.offsetStartFrame)
		l:Pop()
	l:Pop()

    d.skipToStart = LM.GUI.CheckBox("Skip to Start Frame")
	l:AddChild(d.skipToStart,LM.GUI.ALIGN_LEFT)

	return d
end

function msDialogBasicASPDialog:OnValidate()
	return true
end

function msDialogBasicASPDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE + msDialogBasicASP.srcLayer, true)
	self.offsetStartFrame:SetValue(self.moho.frame)
	self.skipToStart:SetValue(msDialogBasicASP.skipToStart)
end


function msDialogBasicASPDialog:OnOK()
	msDialogBasicASP.srcLayer = self.menu:FirstChecked()
	msDialogBasicASP.offsetStartFrame = self.offsetStartFrame:FloatValue()
	msDialogBasicASP.skipToStart = self.skipToStart:Value()
end


function msDialogBasicASPDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("First Value", 0, MOHO.MSG_BASE + 0)
	menu:AddItem("Second Value", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("Third Value", 0, MOHO.MSG_BASE + 2)

	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msDialogBasicASP:Run(moho)
	local dialog = msDialogBasicASPDialog:new(moho)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

end
