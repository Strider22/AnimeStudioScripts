ScriptName = "msJoshDialog"
msJoshDialog = {}
msJoshDialog.BASE_STR = 2530

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msJoshDialog:Description()
	return "Converts text into switch keys for a mouth layer."
end

function msJoshDialog:Name()
	return "Mouth Wiggle"
end

function msJoshDialog:Version()
	return "1.0"
end
function msJoshDialog:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************

function msJoshDialog:UILabel()
	return "JoshDialog..."
end

-- **************************************************
-- Recurring values
-- **************************************************
-- From left, right, up, down
-- overshoot
-- ingress frames
-- elastic in frames
-- leaving frames

-- Plop
-- numFrames
-- in num bounces
-- out num bounces

msJoshDialog.stepSize = 1
msJoshDialog.startFrame = 1
msJoshDialog.endFrame = 50
msJoshDialog.text = ""
msJoshDialog.switch = nil
msJoshDialog.skel = nil
msJoshDialog.cancel = false
msJoshDialog.phonemeToBonesMap = {}
msJoshDialog.phonetic = true
msJoshDialog.openCloseName = "Open/Close"
msJoshDialog.squashStretchName = "Squash/Stretch"
msJoshDialog.firstChecked = 0

-- **************************************************
-- JoshDialog dialog
-- **************************************************



local msJoshDialogDialog = {}

function msJoshDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Smart Animation", msJoshDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Select Base Animation Layer"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Offset Amount"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Offset Start frame"),LM.GUI.ALIGN_LEFT)
		    d.skipToStart = LM.GUI.CheckBox("Skip to Start Frame")
			l:AddChild(d.skipToStart,LM.GUI.ALIGN_LEFT)
		    d.randomize = LM.GUI.CheckBox("Randomize Offsets")
			l:AddChild(d.randomize,LM.GUI.ALIGN_LEFT)
		    d.copyToGroups = LM.GUI.CheckBox("Copy to/from groups")
			l:AddChild(d.copyToGroups,LM.GUI.ALIGN_LEFT)
		    d.accumulateOffsets = LM.GUI.CheckBox("Accumulate Offsets")
			l:AddChild(d.accumulateOffsets,LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Select Layer")
			d.frameOffset = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.frameOffset)
			d.offsetStartFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.offsetStartFrame)
		l:Pop()
	l:Pop()
	return d
end

function msCopyAnimationDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("Left", 0, MOHO.MSG_BASE)
	menu:AddItem("Right", 0, MOHO.MSG_BASE + 1)

	menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msJoshDialog:OnValidate()
	if (not self:Validate(self.frameOffset, 0, 1000)) then
		return false
	end
	return true
end

function msJoshDialog:UpdateWidgets()
	self.frameOffset:SetValue(msCopyAnimation.frameOffset)
	self.skipToStart:SetValue(msCopyAnimation.skipToStart)
	self.randomize:SetValue(msCopyAnimation.randomize)
	self.accumulateOffsets:SetValue(msCopyAnimation.accumulateOffsets)
	self.copyToGroups:SetValue(msCopyAnimation.copyToGroups)
	self.offsetStartFrame:SetValue(self.moho.frame)
end


function msJoshDialog:OnOK()
	msCopyAnimation.srcLayerName = self.menu:FirstCheckedLabel()
	msCopyAnimation.frameOffset = self.frameOffset:FloatValue()
	msCopyAnimation.skipToStart = self.skipToStart:Value()
	msCopyAnimation.randomize = self.randomize:Value()
	msCopyAnimation.accumulateOffsets = self.accumulateOffsets:Value()
	msCopyAnimation.copyToGroups = self.copyToGroups:Value()
	msCopyAnimation.offsetStartFrame = self.offsetStartFrame:FloatValue()
end



function msJoshDialog:Run(moho)
	local layer = moho.layer
	self.moho = moho
	local dlog = msJoshDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end


	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	
end
