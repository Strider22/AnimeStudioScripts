ScriptName = "msDialogBasicHelper"
msDialogBasicHelper = {}

function msDialogBasicHelper:Description()
	return "Basic Dialog using msDialog helper routines."
end


msDialogBasicHelper.BASE_STR = 2540

function msDialogBasicHelper:Name()
	return "msDialogBasicHelper"
end

function msDialogBasicHelper:Version()
	return "1.0"
end

function msDialogBasicHelper:Creator()
	return "Mitchel Soltys"
end

function msDialogBasicHelper:UILabel()
	return "DialogBasicHelper ..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msDialogBasicHelper.srcLayer = 0
msDialogBasicHelper.offsetStartFrame = 1
msDialogBasicHelper.skipToStart = true


-- **************************************************
-- DialogExample dialog
-- **************************************************

local msDialogBasicHelperDialog = {}


function msDialogBasicHelperDialog:new(moho)
	local self, l = msDialog:SimpleDialog("DialogBasicHelper", self)

	self.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			msDialog:AddText("Select Base Animation Layer")
			msDialog:AddText("Offset Start frame")
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			self.menu = self:CreateDropDownMenu(moho, l, "Select Layer")
			self.offsetStartFrame = msDialog:AddTextControl(0, "1.0000", 0, LM.GUI.FIELD_FLOAT)
		l:Pop()
	l:Pop()

    self.skipToStart = LM.GUI.CheckBox("Skip to Start Frame")
	l:AddChild(self.skipToStart,LM.GUI.ALIGN_LEFT)

	return self
end

function msDialogBasicHelperDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE + msDialogBasicHelper.srcLayer, true)
	self.offsetStartFrame:SetValue(self.moho.frame)
	self.skipToStart:SetValue(msDialogBasicHelper.skipToStart)
end


function msDialogBasicHelperDialog:OnOK()
	msDialogBasicHelper.srcLayer = self.menu:FirstChecked()
	msDialogBasicHelper.offsetStartFrame = self.offsetStartFrame:FloatValue()
	msDialogBasicHelper.skipToStart = self.skipToStart:Value()
end


function msDialogBasicHelperDialog:CreateDropDownMenu(moho, layout, title)
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

function msDialogBasicHelper:Run(moho)

	msDialog:Display(moho, msDialogBasicHelperDialog)

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

end
