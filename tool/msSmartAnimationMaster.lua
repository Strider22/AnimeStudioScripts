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
msSmartAnimationMaster.startFrame = 1
msSmartAnimationMaster.endFrame = 50
-- how many liner frames when entering
msSmartAnimationMaster.enterIngressFrames = 8
-- what ratio of the total travel on ingress
msSmartAnimationMaster.enterIngressScale = 1.03
-- how many elastic frames on enter
msSmartAnimationMaster.enterResolveFrames = 17
msSmartAnimationMaster.exitFrames = 20
-- how many frames in plopIn
msSmartAnimationMaster.plopInIngressFrames = 5
msSmartAnimationMaster.plopInResolveFrames = 15
msSmartAnimationMaster.plopInScale = .5
-- how many frames in plopOut
msSmartAnimationMaster.plopOutFrames = 20
msSmartAnimationMaster.plopOutBounceCount = 2
msSmartAnimationMaster.plopOutScale = .5

--how much further than the screen do we move the object
msSmartAnimationMaster.borderScale = 1.6
msSmartAnimationMaster.minScale = .02


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
            l:AddChild(LM.GUI.StaticText("enterIngressScale"),LM.GUI.ALIGN_LEFT)
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
            d.enterIngressScale = 1.0LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
            lAddChild(d.enterIngressScale)
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
	self.frameOffset:SetValue(msSmartAnimationMaster.frameOffset)
	self.skipToStart:SetValue(msSmartAnimationMaster.skipToStart)
	self.randomize:SetValue(msSmartAnimationMaster.randomize)
	self.accumulateOffsets:SetValue(msSmartAnimationMaster.accumulateOffsets)
	self.copyToGroups:SetValue(msSmartAnimationMaster.copyToGroups)
	self.offsetStartFrame:SetValue(self.moho.frame)
    self..enterIngressFrames:SetValue(msSmartAnimationMaster.enterIngressFrames)
    self..enterIngressScale:SetValue(msSmartAnimationMaster.enterIngressScale)
    self..enterResolveFrames:SetValue(msSmartAnimationMaster.enterResolveFrames)
    self..exitFrames:SetValue(msSmartAnimationMaster.exitFrames)
    self..plopInIngressFrames:SetValue(msSmartAnimationMaster.plopInIngressFrames)
    self..plopInResolveFrames:SetValue(msSmartAnimationMaster.plopInResolveFrames)
    self..plopInScale:SetValue(msSmartAnimationMaster.plopInScale)
    self..plopOutFrames:SetValue(msSmartAnimationMaster.plopOutFrames)
    self..plopOutBounceCount:SetValue(msSmartAnimationMaster.plopOutBounceCount)
    self..plopOutScale:SetValue(msSmartAnimationMaster.plopOutScale)
    self..borderScale:SetValue(msSmartAnimationMaster.borderScale)
    self..minScale:SetValue(msSmartAnimationMaster.minScale)
end


function msSmartAnimationMasterDialog:OnOK()
	msSmartAnimationMaster.srcLayerName = self.menu:FirstCheckedLabel()
	msSmartAnimationMaster.frameOffset = self.frameOffset:FloatValue()
	msSmartAnimationMaster.skipToStart = self.skipToStart:Value()
	msSmartAnimationMaster.randomize = self.randomize:Value()
	msSmartAnimationMaster.accumulateOffsets = self.accumulateOffsets:Value()
	msSmartAnimationMaster.copyToGroups = self.copyToGroups:Value()
	msSmartAnimationMaster.offsetStartFrame = self.offsetStartFrame:FloatValue()
    msSmartAnimationMaster.enterIngressFrames = self.enterIngressFrames:FloatValue()
    msSmartAnimationMaster.enterIngressScale = self.enterIngressScale:FloatValue()
    msSmartAnimationMaster.enterResolveFrames = self.enterResolveFrames:FloatValue()
    msSmartAnimationMaster.exitFrames = self.exitFrames:FloatValue()
    msSmartAnimationMaster.plopInIngressFrames = self.plopInIngressFrames:FloatValue()
    msSmartAnimationMaster.plopInResolveFrames = self.plopInResolveFrames:FloatValue()
    msSmartAnimationMaster.plopInScale = self.plopInScale:FloatValue()
    msSmartAnimationMaster.plopOutFrames = self.plopOutFrames:FloatValue()
    msSmartAnimationMaster.plopOutBounceCount = self.plopOutBounceCount:FloatValue()
    msSmartAnimationMaster.plopOutScale = self.plopOutScale:FloatValue()
    msSmartAnimationMaster.borderScale = self.borderScale:FloatValue()
    msSmartAnimationMaster.minScale = self.minScale:FloatValue()
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

	
end
