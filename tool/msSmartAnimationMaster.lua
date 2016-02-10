ScriptName = "msSmartAnimationMaster"
msSmartAnimationMaster = {}
msSmartAnimationMaster.BASE_STR = 2530

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
			l:AddChild(LM.GUI.StaticText("Action"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Start Frame"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("End Frame"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("enterIngressFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("enterOvershootScale"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("enterResolveFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("exitFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopInIngressFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopInResolveFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopInScale"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopOutFrames"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopOutBounceCount"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("plopOutScale"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("borderScale"),LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.StaticText("minScale"),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Action")
			d.startFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.startFrame)
			d.endFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.endFrame)
            d.enterIngressFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.enterIngressFrames)
            d.enterOvershootScale = 1.0LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.enterOvershootScale)
            d.enterResolveFrames = 1LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.enterResolveFrames)
            d.exitFrames = 2LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.exitFrames)
            d.plopInIngressFrames = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.plopInIngressFrames)
            d.plopInResolveFrames = 1LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.plopInResolveFrames)
            d.plopInScale = .LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.plopInScale)
            d.plopOutFrames = 2LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.plopOutFrames)
            d.plopOutBounceCount = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.plopOutBounceCount)
            d.plopOutScale = .LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.plopOutScale)
            d.borderScale = 1.LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.borderScale)
            d.minScale = .0LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.minScale)
		l:Pop()
	l:Pop()
	return d
end

function msSmartAnimationMasterDialog:OnValidate()
	return true
end

function msSmartAnimationMasterDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE, true)
	self.startFrame:SetValue(self.moho.frame)
	self.endFrame:SetValue(msSmartAnimation.endFrame)
    self..enterIngressFrames:SetValue(msSmartAnimation.enterIngressFrames)
    self..enterOvershootScale:SetValue(msSmartAnimation.enterOvershootScale)
    self..enterResolveFrames:SetValue(msSmartAnimation.enterResolveFrames)
    self..exitFrames:SetValue(msSmartAnimation.exitFrames)
    self..plopInIngressFrames:SetValue(msSmartAnimation.plopInIngressFrames)
    self..plopInResolveFrames:SetValue(msSmartAnimation.plopInResolveFrames)
    self..plopInScale:SetValue(msSmartAnimation.plopInScale)
    self..plopOutFrames:SetValue(msSmartAnimation.plopOutFrames)
    self..plopOutBounceCount:SetValue(msSmartAnimation.plopOutBounceCount)
    self..plopOutScale:SetValue(msSmartAnimation.plopOutScale)
    self..borderScale:SetValue(msSmartAnimation.borderScale)
    self..minScale:SetValue(msSmartAnimation.minScale)
end


function msSmartAnimationMasterDialog:OnOK()
    msSmartAnimationMaster.action = self.menu:FirstChecked()
	msSmartAnimation.startFrame = self.startFrame:FloatValue()
	msSmartAnimation.endFrame = self.endFrame:FloatValue()
    msSmartAnimation.enterIngressFrames = self.enterIngressFrames:FloatValue()
    msSmartAnimation.enterOvershootScale = self.enterOvershootScale:FloatValue()
    msSmartAnimation.enterResolveFrames = self.enterResolveFrames:FloatValue()
    msSmartAnimation.exitFrames = self.exitFrames:FloatValue()
    msSmartAnimation.plopInIngressFrames = self.plopInIngressFrames:FloatValue()
    msSmartAnimation.plopInResolveFrames = self.plopInResolveFrames:FloatValue()
    msSmartAnimation.plopInScale = self.plopInScale:FloatValue()
    msSmartAnimation.plopOutFrames = self.plopOutFrames:FloatValue()
    msSmartAnimation.plopOutBounceCount = self.plopOutBounceCount:FloatValue()
    msSmartAnimation.plopOutScale = self.plopOutScale:FloatValue()
    msSmartAnimation.borderScale = self.borderScale:FloatValue()
    msSmartAnimation.minScale = self.minScale:FloatValue()

end


function msSmartAnimationMasterDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("SAVE", 0, MOHO.MSG_BASE)
	menu:AddItem("ENTER LEFT", 0, MOHO.MSG_BASE)
	menu:AddItem("ENTER RIGHT", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("ENTER TOP", 0, MOHO.MSG_BASE + 2)
	menu:AddItem("ENTER BOTTOM", 0, MOHO.MSG_BASE + 3)
	menu:AddItem("EXIT LEFT", 0, MOHO.MSG_BASE + 4)
	menu:AddItem("EXIT RIGHT", 0, MOHO.MSG_BASE + 5)
	menu:AddItem("EXIT TOP", 0, MOHO.MSG_BASE + 6)
	menu:AddItem("EXIT BOTTOM", 0, MOHO.MSG_BASE + 7)
	menu:AddItem("PLOP IN", 0, MOHO.MSG_BASE + 8)
	menu:AddItem("PLOP OUT", 0, MOHO.MSG_BASE + 9)


	menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msSmartAnimationMaster:Run(moho)
	local dlog = msSmartAnimationMasterDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

    if(self.action == 1) then
        //Save
    end


	
end
