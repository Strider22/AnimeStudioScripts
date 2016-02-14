ScriptName = "msSmartAnimationMaster"
msSmartAnimationMaster = {}
msSmartAnimationMaster.BASE_STR = 2530
msSmartAnimationMaster.action1 = 0
msSmartAnimationMaster.action2 = 0
msSmartAnimationMaster.startFrame = 25
msSmartAnimationMaster.endFrame = 100

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msSmartAnimationMaster:Description()
	return "SmartAnimationMaster."
end

function msSmartAnimationMaster:Name()
	return "SmartAnimationMaster"
end

function msSmartAnimationMaster:Version()
	return "1.0"
end
function msSmartAnimationMaster:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************

function msSmartAnimationMaster:UILabel()
	return"SmartAnimationMaster..."
end

-- **************************************************
-- Recurring values
-- **************************************************


-- **************************************************
-- SmartAnimationMaster dialog
-- **************************************************
local msSmartAnimationMasterDialog = {}

function msSmartAnimationMasterDialog:new(moho)
	local d = LM.GUI.SimpleDialog("SmartAnimationMaster", msSmartAnimationMasterDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Action 1"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Action 2"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Start Frame"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("End Frame"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            l:AddChild(LM.GUI.StaticText("enterIngressFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("enterResolveFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("enterOvershootScale"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            l:AddChild(LM.GUI.StaticText("exitFrames"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            l:AddChild(LM.GUI.StaticText("plopInIngressFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopInResolveFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopInScale"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            l:AddChild(LM.GUI.StaticText("plopOutFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopOutEndFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopOutBounceCount"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopOutScale"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            l:AddChild(LM.GUI.StaticText("borderScale"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("minScale"),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.action1Menu = self:CreateAction1Menu(moho, l, "Action 1")
			d.action2Menu = self:CreateAction2Menu(moho, l, "Action 2")
			d.startFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.startFrame)
			d.endFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.endFrame)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            d.enterIngressFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.enterIngressFrames)
            d.enterResolveFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.enterResolveFrames)
            d.enterOvershootScale = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
            l:AddChild(d.enterOvershootScale)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            d.exitFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.exitFrames)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            d.plopInIngressFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.plopInIngressFrames)
            d.plopInResolveFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.plopInResolveFrames)
            d.plopInScale = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
            l:AddChild(d.plopInScale)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            d.plopOutFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.plopOutFrames)
            d.plopOutEndFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.plopOutEndFrames)
            d.plopOutBounceCount = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            l:AddChild(d.plopOutBounceCount)
            d.plopOutScale = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
            l:AddChild(d.plopOutScale)
			l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            d.borderScale = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
            l:AddChild(d.borderScale)
            d.minScale = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
            l:AddChild(d.minScale)
		l:Pop()
	l:Pop()
	return d
end

function msSmartAnimationMasterDialog:OnValidate()
	return true
end

function msSmartAnimationMasterDialog:UpdateWidgets()
	self.action1Menu:SetChecked(MOHO.MSG_BASE + msSmartAnimationMaster.action1, true)
	self.action2Menu:SetChecked(MOHO.MSG_BASE + msSmartAnimationMaster.action2, true)
	self.startFrame:SetValue(self.moho.frame)
	self.endFrame:SetValue(msSmartAnimationMaster.endFrame)
    self.enterIngressFrames:SetValue(msSmartAnimation.enterIngressFrames)
    self.enterOvershootScale:SetValue(msSmartAnimation.enterOvershootScale)
    self.enterResolveFrames:SetValue(msSmartAnimation.enterResolveFrames)
    self.exitFrames:SetValue(msSmartAnimation.exitFrames)
    self.plopInIngressFrames:SetValue(msSmartAnimation.plopInIngressFrames)
    self.plopInResolveFrames:SetValue(msSmartAnimation.plopInResolveFrames)
    self.plopInScale:SetValue(msSmartAnimation.plopInScale)
    self.plopOutFrames:SetValue(msSmartAnimation.plopOutFrames)
    self.plopOutEndFrames:SetValue(msSmartAnimation.plopOutEndFrames)
    self.plopOutBounceCount:SetValue(msSmartAnimation.plopOutBounceCount)
    self.plopOutScale:SetValue(msSmartAnimation.plopOutScale)
    self.borderScale:SetValue(msSmartAnimation.borderScale)
    self.minScale:SetValue(msSmartAnimation.minScale)
end


function msSmartAnimationMasterDialog:OnOK()
    msSmartAnimationMaster.action1 = self.action1Menu:FirstChecked()
    msSmartAnimationMaster.action2 = self.action2Menu:FirstChecked()
	msSmartAnimationMaster.startFrame = self.startFrame:FloatValue()
	msSmartAnimationMaster.endFrame = self.endFrame:FloatValue()
    msSmartAnimation.enterIngressFrames = self.enterIngressFrames:FloatValue()
    msSmartAnimation.enterOvershootScale = self.enterOvershootScale:FloatValue()
    msSmartAnimation.enterResolveFrames = self.enterResolveFrames:FloatValue()
    msSmartAnimation.exitFrames = self.exitFrames:FloatValue()
    msSmartAnimation.plopInIngressFrames = self.plopInIngressFrames:FloatValue()
    msSmartAnimation.plopInResolveFrames = self.plopInResolveFrames:FloatValue()
    msSmartAnimation.plopInScale = self.plopInScale:FloatValue()
    msSmartAnimation.plopOutFrames = self.plopOutFrames:FloatValue()
    msSmartAnimation.plopOutEndFrames = self.plopOutEndFrames:FloatValue()
    msSmartAnimation.plopOutBounceCount = self.plopOutBounceCount:FloatValue()
    msSmartAnimation.plopOutScale = self.plopOutScale:FloatValue()
    msSmartAnimation.borderScale = self.borderScale:FloatValue()
    msSmartAnimation.minScale = self.minScale:FloatValue()

end


function msSmartAnimationMasterDialog:CreateAction1Menu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("ENTER LEFT", 0, MOHO.MSG_BASE + 0)
	menu:AddItem("ENTER RIGHT", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("ENTER TOP", 0, MOHO.MSG_BASE + 2)
	menu:AddItem("ENTER BOTTOM", 0, MOHO.MSG_BASE + 3)
	menu:AddItem("PLOP IN", 0, MOHO.MSG_BASE + 4)
	menu:AddItem("SAVE", 0, MOHO.MSG_BASE + 5)
	menu:AddItem("RESTORE DEFAULTS", 0, MOHO.MSG_BASE + 6)
	menu:AddItem("NONE", 0, MOHO.MSG_BASE + 7)


	-- menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msSmartAnimationMasterDialog:CreateAction2Menu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("NONE", 0, MOHO.MSG_BASE + 0)
	menu:AddItem("EXIT LEFT", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("EXIT RIGHT", 0, MOHO.MSG_BASE + 2)
	menu:AddItem("EXIT TOP", 0, MOHO.MSG_BASE + 3)
	menu:AddItem("EXIT BOTTOM", 0, MOHO.MSG_BASE + 4)
	menu:AddItem("PLOP OUT", 0, MOHO.MSG_BASE + 5)
	menu:AddItem("SAVE", 0, MOHO.MSG_BASE + 6)


	-- menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msSmartAnimationMaster:Run(moho)
	msSmartAnimation:Init(moho)
	local dlog = msSmartAnimationMasterDialog:new(moho)
	local layer = moho.layer
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

    if(self.action1 == 0) then
		msSmartAnimation:Enter(layer, 1, self.startFrame, msSmartAnimation.LEFT)
    elseif(self.action1 == 1) then
		msSmartAnimation:Enter(layer, 1, self.startFrame, msSmartAnimation.RIGHT)
    elseif(self.action1 == 2) then
		msSmartAnimation:Enter(layer, 1, self.startFrame, msSmartAnimation.TOP)
    elseif(self.action1 == 3) then
		msSmartAnimation:Enter(layer, 1, self.startFrame, msSmartAnimation.BOTTOM)
    elseif(self.action1 == 4) then
		msSmartAnimation:PlopIn(layer, self.startFrame)
    elseif(self.action1 == 5) then
		msSmartAnimation:SaveSettings()
    elseif(self.action1 == 6) then
		msSmartAnimation:SetDefaultValues()
	end
    if(self.action2 == 1) then
		msSmartAnimation:Exit(layer, self.endFrame, msSmartAnimation.LEFT)
    elseif(self.action2 == 2) then
		msSmartAnimation:Exit(layer, self.endFrame, msSmartAnimation.RIGHT)
    elseif(self.action2 == 3) then
		msSmartAnimation:Exit(layer, self.endFrame, msSmartAnimation.TOP)
    elseif(self.action2 == 4) then
		msSmartAnimation:Exit(layer, self.endFrame, msSmartAnimation.BOTTOM)
    elseif(self.action2 == 5) then
		msSmartAnimation:PlopOut(layer, self.endFrame)
    elseif(self.action2 == 6) then
		msSmartAnimation:SaveSettings()
    end

	
end
