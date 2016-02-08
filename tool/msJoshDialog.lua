ScriptName = "msJoshDialog"
msJoshDialog = {}
msJoshDialog.BASE_STR = 2530

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msJoshDialog:Description()
	return "Dialog Example."
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
	return"JoshDialog..."
end

-- **************************************************
-- Recurring values
-- **************************************************
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
-- From left, right, up, down
-- overshoot
-- ingress frames
-- elastic in frames
-- leaving frames

-- Plop
-- numFrames
-- in num bounces
-- out num bounces


local msJoshDialogDialog = {}

function msJoshDialogDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Copy Animation", msJoshDialogDialog)
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

function msJoshDialogDialog:OnValidate()
	if (not self:Validate(self.frameOffset, 0, 1000)) then
		return false
	end
	return true
end

function msJoshDialogDialog:UpdateWidgets()
	self.frameOffset:SetValue(msJoshDialog.frameOffset)
	self.skipToStart:SetValue(msJoshDialog.skipToStart)
	self.randomize:SetValue(msJoshDialog.randomize)
	self.accumulateOffsets:SetValue(msJoshDialog.accumulateOffsets)
	self.copyToGroups:SetValue(msJoshDialog.copyToGroups)
	self.offsetStartFrame:SetValue(self.moho.frame)
end


function msJoshDialogDialog:OnOK()
	msJoshDialog.srcLayerName = self.menu:FirstCheckedLabel()
	msJoshDialog.frameOffset = self.frameOffset:FloatValue()
	msJoshDialog.skipToStart = self.skipToStart:Value()
	msJoshDialog.randomize = self.randomize:Value()
	msJoshDialog.accumulateOffsets = self.accumulateOffsets:Value()
	msJoshDialog.copyToGroups = self.copyToGroups:Value()
	msJoshDialog.offsetStartFrame = self.offsetStartFrame:FloatValue()
end


function msJoshDialogDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("LEFT", 0, MOHO.MSG_BASE)
	menu:AddItem("RIGHT", 0, MOHO.MSG_BASE + 1)

	menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msJoshDialog:Run(moho)
	local dlog = msJoshDialogDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	
end
