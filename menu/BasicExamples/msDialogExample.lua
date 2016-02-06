-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msDialogExample"

-- **************************************************
-- General information about this script
-- **************************************************

msDialogExample = {}

msDialogExample.BASE_STR = 2540

function msDialogExample:Name()
	return "DialogExample"
end

function msDialogExample:Version()
	return "1.0"
end

function msDialogExample:Description()
	return MOHO.Localize("/Scripts/Menu/DialogExample/Description=DialogExample in/out the current layer.")
end

function msDialogExample:Creator()
	return "Mitchel Soltys"
end

function msDialogExample:UILabel()
	return(MOHO.Localize("/Scripts/Menu/DialogExample/DialogExample=DialogExample..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

msDialogExample.duration = 12
msDialogExample.blur = 16
msDialogExample.DialogExampleOut = true

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msDialogExampleDialog = {}

function msDialogExampleDialog:new(moho)
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/DialogExample/Title=DialogExample"), msDialogExampleDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:PushH()
		l:PushV()
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/DialogExample/Duration=Duration (frames)")), LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/DialogExample/BlurRadius=Blur radius")), LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV()
			d.duration = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.duration)
			d.blur = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.blur)
		l:Pop()
	l:Pop()

	d.DialogExampleIn = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/DialogExample/DialogExampleIn=DialogExample in"))
	l:AddChild(d.DialogExampleIn, LM.GUI.ALIGN_LEFT)
	d.DialogExampleOut = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/DialogExample/DialogExampleOut=DialogExample out"))
	l:AddChild(d.DialogExampleOut, LM.GUI.ALIGN_LEFT)

	return d
end

function msDialogExampleDialog:UpdateWidgets()
	self.duration:SetValue(msDialogExample.duration)
	self.blur:SetValue(msDialogExample.blur)
	self.DialogExampleIn:SetValue(not msDialogExample.DialogExampleOut)
	self.DialogExampleOut:SetValue(msDialogExample.DialogExampleOut)
end

function msDialogExampleDialog:OnValidate()
	local b = true
	if (not self:Validate(self.duration, 2, 1000000)) then
		b = false
	end
	if (not self:Validate(self.blur, 0, 30)) then
		b = false
	end
	return b
end

function msDialogExampleDialog:OnOK()
	msDialogExample.duration = self.duration:IntValue()
	msDialogExample.blur = self.blur:IntValue()
	msDialogExample.DialogExampleOut = self.DialogExampleOut:Value()
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msDialogExample:Run(moho)
	local dlog = msDialogExampleDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

end
