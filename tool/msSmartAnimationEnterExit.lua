ScriptName = "msSmartAnimationEnterExit"
msSmartAnimationEnterExit = {}
msSmartAnimationEnterExit.BASE_STR = 2530

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msSmartAnimationEnterExit:Description()
	return "SmartAnimationEnterExit."
end

function msSmartAnimationEnterExit:Name()
	return "SmartAnimationEnterExit"
end

function msSmartAnimationEnterExit:Version()
	return "1.0"
end
function msSmartAnimationEnterExit:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************

function msSmartAnimationEnterExit:UILabel()
	return"SmartAnimationEnterExit..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msSmartAnimationEnterExit.startFrame = 1
msSmartAnimationEnterExit.endFrame = 50
msSmartAnimationEnterExit.enterAction = 1
msSmartAnimationEnterExit.exitAction = 1


-- **************************************************
-- SmartAnimationEnterExit dialog
-- **************************************************
local msSmartAnimationEnterExitDialog = {}

function msSmartAnimationEnterExitDialog:new(moho)
	local d = LM.GUI.SimpleDialog("SmartAnimationEnterExit", msSmartAnimationEnterExitDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Enter Action"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Exit Action"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Start Frame"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("End Frame"),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.enterMenu = self:CreateEnterMenu(moho, l, "Enter Action")
			d.exitMenu = self:CreateExitMenu(moho, l, "Exit Action")
			d.startFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.startFrame)
			d.endFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.endFrame)
		l:Pop()
	l:Pop()
	return d
end

function msSmartAnimationEnterExitDialog:OnValidate()
	return true
end

function msSmartAnimationEnterExitDialog:UpdateWidgets()
    self.enterAction:SetValue(msSmartAnimationEnterExit.enterAction)
    self.exitAction:SetValue(msSmartAnimationEnterExit.exitAction)
    self.startFrame:SetValue(msSmartAnimationEnterExit.startFrame)
    self.endFrame:SetValue(msSmartAnimationEnterExit.endFrame)
end


function msSmartAnimationEnterExitDialog:OnOK()
    msSmartAnimationEnterExit.enterAction = self.enterAction:FloatValue()
    msSmartAnimationEnterExit.exitAction = SetValue(self.exitAction:FloatValue()
    msSmartAnimationEnterExit.startFrame = SetValue(self.startFrame:FloatValue()
    msSmartAnimationEnterExit.endFrame = self.endFrame:FloatValue()
end


function msSmartAnimationEnterExitDialog:CreateEnterMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("ENTER LEFT", 0, MOHO.MSG_BASE)
	menu:AddItem("ENTER RIGHT", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("ENTER TOP", 0, MOHO.MSG_BASE + 2)
	menu:AddItem("ENTER BOTTOM", 0, MOHO.MSG_BASE + 3)
	menu:AddItem("PLOP IN", 0, MOHO.MSG_BASE + 4)


	menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msSmartAnimationEnterExitDialog:CreateExitMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("EXIT LEFT", 0, MOHO.MSG_BASE)
	menu:AddItem("EXIT RIGHT", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("EXIT TOP", 0, MOHO.MSG_BASE + 2)
	menu:AddItem("EXIT BOTTOM", 0, MOHO.MSG_BASE + 3)
	menu:AddItem("PLOP OUT", 0, MOHO.MSG_BASE + 4)


	menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msSmartAnimationEnterExit:Run(moho)
	local dlog = msSmartAnimationEnterExitDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	
end
