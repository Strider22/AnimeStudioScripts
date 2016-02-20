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
	-- l:PushH(LM.GUI.ALIGN_LEFT)
		-- l:PushV(LM.GUI.ALIGN_LEFT)
			-- msDialog:AddText("Select Base Animation Layer")
			-- msDialog:AddText("Offset Start frame")
		-- l:Pop()
		-- l:PushV(LM.GUI.ALIGN_LEFT)
			-- self.menu = self:CreateDropDownMenu(moho, l, "Select Layer")
			-- self.offsetStartFrame = msDialog:AddTextControl(0, "1.0000", 0, LM.GUI.FIELD_FLOAT)
		-- l:Pop()
	-- l:Pop()

    -- self.skipToStart = LM.GUI.CheckBox("Skip to Start Frame")
	-- l:AddChild(self.skipToStart,LM.GUI.ALIGN_LEFT)
	self.offsetStartFrame = msDialog:AddFloat("Offset Start Frame")

	return self
end




function msDialogSimpleDialog:UpdateWidgets()
	-- self.menu:SetChecked(MOHO.MSG_BASE + msDialogSimple.srcLayer, true)
	self.offsetStartFrame:SetValue(self.moho.frame)
	self.skipToStart:SetValue(msDialogSimple.skipToStart)
end


function msDialogSimpleDialog:OnOK()
	-- msDialogSimple.srcLayer = self.menu:FirstChecked()
	msDialogSimple.offsetStartFrame = self.offsetStartFrame:FloatValue()
	msDialogSimple.skipToStart = self.skipToStart:Value()
end


function msDialogSimpleDialog:CreateDropDownMenu(moho, layout, title)
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

function msDialogSimple:Run(moho)

	msDialog:Display(moho, msDialogSimpleDialog)

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

end
