ScriptName = "msDialogSimple"
msDialogSimple = {}

function msDialogSimple:Description()
	return "Basic Dialog using msDialog helper routines."
end


msDialogSimple.BASE_STR = 2540

function msDialogSimple:Name()
	return "msDialogSimple"
end

function msDialogSimple:Version()
	return "1.0"
end

function msDialogSimple:Creator()
	return "Mitchel Soltys"
end

function msDialogSimple:UILabel()
	return "DialogSimple ..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msDialogSimple.srcLayer = 0
msDialogSimple.offsetStartFrame = 1
msDialogSimple.skipToStart = true


-- **************************************************
-- DialogExample dialog
-- **************************************************

local msDialogSimpleDialog = {}


function msDialogSimpleDialog:new(moho)
	local self, l = msDialog:SimpleDialog("DialogSimple", self)

	self.moho = moho

	self.menu = msDialog:CreateDropDownMenu("Select Base Animation Layer",{"First Value", "Second Value", "Third Value"})
	self.offsetStartFrame = msDialog:AddFloat("Offset Start Frame")
    self.skipToStart = msDialog:AddCheckBox("Skip to Start Frame")

	return self
end




function msDialogSimpleDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE + msDialogSimple.srcLayer, true)
	self.offsetStartFrame:SetValue(self.moho.frame)
	self.skipToStart:SetValue(msDialogSimple.skipToStart)
end


function msDialogSimpleDialog:OnOK()
	msDialogSimple.srcLayer = self.menu:FirstChecked()
	msDialogSimple.offsetStartFrame = self.offsetStartFrame:FloatValue()
	msDialogSimple.skipToStart = self.skipToStart:Value()
end




-- **************************************************
-- The guts of this script
-- **************************************************

function msDialogSimple:Run(moho)

	msDialog:Display(moho, msDialogSimpleDialog)

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

end
