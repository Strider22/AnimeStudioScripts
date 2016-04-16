ScriptName = "msDialogExperiment"
msDialogExperiment = {}

function msDialogExperiment:Description()
	return "Dialog for experimenting."
end


msDialogExperiment.BASE_STR = 2540

function msDialogExperiment:Name()
	return "DialogBasicASP"
end

function msDialogExperiment:Version()
	return "1.0"
end

function msDialogExperiment:Creator()
	return "Mitchel Soltys"
end

function msDialogExperiment:UILabel()
	return "Dialog Experiment ..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msDialogExperiment.srcLayer = 0
msDialogExperiment.offsetStartFrame = 1
msDialogExperiment.skipToStart = true


-- **************************************************
-- DialogExample dialog
-- **************************************************
local msCheckBoxDialog  ={}

function msCheckBoxDialog:new(moho)
	local d = LM.GUI.SimpleDialog("DialogExperiment", msCheckBoxDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Offset Start frame"),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.offsetStartFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.offsetStartFrame)
		l:Pop()
	l:Pop()

    d.skipToStart = LM.GUI.CheckBox("Skip to Start Frame")
	l:AddChild(d.skipToStart,LM.GUI.ALIGN_LEFT)

	return d
end
function msCheckBoxDialog:UpdateWidgets()
end


function msCheckBoxDialog:OnOK()
end



local msDialogExperimentDialog = {}
msDialogExperimentDialog.UPDATE = MOHO.MSG_BASE

function msDialogExperimentDialog:new(moho)
	local d = LM.GUI.SimpleDialog("DialogExperiment", msDialogExperimentDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:AddChild(LM.GUI.Button("Button",msDialogExperimentDialog.UPDATE),LM.GUI.ALIGN_LEFT)
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

function msDialogExperimentDialog:OnValidate()
	return true
end

function msDialogExperimentDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE + msDialogExperiment.srcLayer, true)
	self.offsetStartFrame:SetValue(self.moho.frame)
	self.skipToStart:SetValue(msDialogExperiment.skipToStart)
end


function msDialogExperimentDialog:OnOK()
	msDialogExperiment.srcLayer = self.menu:FirstChecked()
	msDialogExperiment.offsetStartFrame = self.offsetStartFrame:FloatValue()
	msDialogExperiment.skipToStart = self.skipToStart:Value()
end

function msDialogExperimentDialog:HandleMessage(what)
	if (what == self.UPDATE) then
		local dialog = msCheckBoxDialog:new(moho)
		if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
			return
		end
	end
end

function msDialogExperimentDialog:CreateDropDownMenu(moho, layout, title)
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

function msDialogExperiment:Run(moho)
	local dialog = msDialogExperimentDialog:new(moho)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

end
