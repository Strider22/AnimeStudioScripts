-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msDialogExample"

-- **************************************************
-- General information about this script
-- **************************************************

msDialogExample = {}

<<<<<<< HEAD
msDialogExample.BASE_STR = 2530


-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msDialogExample:Name()
	return "Dialog"
end

function msDialogExample:Version()
	return "6.0"
end

function msDialogExample:Description()
	return MOHO.Localize("/Scripts/Menu/Dialog/Description=Simple example of using a dialog.")
=======
msDialogExample.BASE_STR = 2540

function msDialogExample:Name()
	return "DialogExample"
end

function msDialogExample:Version()
	return "1.0"
end

function msDialogExample:Description()
	return MOHO.Localize("/Scripts/Menu/DialogExample/Description=DialogExample in/out the current layer.")
>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
end

function msDialogExample:Creator()
	return "Mitchel Soltys"
end

function msDialogExample:UILabel()
<<<<<<< HEAD
	return(MOHO.Localize("/Scripts/Menu/Dialog/LayerDialog=Dialog"))
=======
	return(MOHO.Localize("/Scripts/Menu/DialogExample/DialogExample=DialogExample..."))
>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
end

-- **************************************************
-- Recurring values
-- **************************************************

<<<<<<< HEAD
msDialogExample.audioLayer = 0
msDialogExample.interpolationStyle = 1
msDialogExample.AI = .3
msDialogExample.E = .1
msDialogExample.etc = .05
msDialogExample.stepSize = 1
msDialogExample.startFrame = 0
msDialogExample.endFrame = 0
msDialogExample.minMaxTolerancePercent = .05
msDialogExample.minMaxTolerance = 0
msDialogExample.lastMouth = 0
msDialogExample.lastMouthAmplitude = 0
msDialogExample.switch = nil
msDialogExample.frameAdjust = 0
msDialogExample.cancel = false
msDialogExample.restAtEnd = true
msDialogExample.minimizeMouthSwitches = true
msDialogExample.MBPlowest = false

-- **************************************************
-- Dialog dialog
=======
msDialogExample.duration = 12
msDialogExample.blur = 16
msDialogExample.DialogExampleOut = true

-- **************************************************
-- DialogExample dialog
>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
-- **************************************************

local msDialogExampleDialog = {}

function msDialogExampleDialog:new(moho)
<<<<<<< HEAD
	local dialog = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/Dialog/Title=Dialog"), msDialogExampleDialog)
	local layout = dialog:GetLayout()

	msEditSpan:Init(dialog,Dialog)
	msDialogExample:Init("/Scripts/Menu/Dialog/", dialog, layout)

	dialog.moho = moho


	msDialogExample:AddText("help", "See Dialog constructor for explanations")
	
	layout:PushH(LM.GUI.ALIGN_CENTER)
		-- add labels
		layout:PushV()
			-- Select the audio layer to use
			msDialogExample:AddText("AudioLayer", "Audio layer:")
			-- How much wiggle do you ignore? 
			msDialogExample:AddText("Tolerance", "Tolerance Percentage (.005 .05)")
			-- Which style of interpolation will you use
			msDialogExample:AddText("InterpStyle", "Interpolation Style:")
			-- Values for determining what the actual mouth values will be
			-- used to be difficult to determine for multiple voices, because
			-- the value was not based on local of the span being edited. So 
			-- if a soft voice was mixed with a loud voice, the soft voice would
			-- not have any mouth values
			msDialogExample:AddText("AI", "AI level (.03 .3)")
			msDialogExample:AddText("E", "E level (.01 .1)")
			msDialogExample:AddText("etc", "etc level (.005 .05)")
			-- step size. Should almost always be one. 
			msDialogExample:AddText("StepSize", "Step size")
		layout:Pop()
		-- add controls to the right
		layout:PushV()
			dialog.menu = msDialogExample:AudioDropdown(moho, "SelectAudioLayer", 
				"Select audio layer",msDialogExample.audioLayer)
			dialog.minMaxTolerancePercent = msDialogExample:AddTextControl(0, "0.0000", 0,
				LM.GUI.FIELD_FLOAT)
			dialog.interpMenu = LM.GUI.Menu(msDialogExample:Localize("InterpStyle",
				"Interpolation Style:"))
			--	- Min Max big change -	put switch values only at min max values
			--			calculated by big change. Actual value is based on 
			--			percentage of span max
			dialog.interpMenu:AddItem("Min Max Big Change", 0, MOHO.MSG_BASE )
			--	- Min Max turn -	put switch values only at min max values 
			--			calculated the new way. Actual value is based on 
			--			percentage of span max
			dialog.interpMenu:AddItem("Min Max Turn", 0, MOHO.MSG_BASE + 1)
			--	- AutoWiggle -	 Set value based calculated min max of range
			dialog.interpMenu:AddItem("AutoWiggle", 0, MOHO.MSG_BASE + 2)
			--  - PercentageWiggle2  -	set value at each frame based on percentage
			--      	of span max
			dialog.interpMenu:AddItem("PercentageWiggle2", 0, MOHO.MSG_BASE + 3)
			--	- AbsoluteWiggle2 -	 Set value based on actual amplitude
			dialog.interpMenu:AddItem("AbsoluteWiggle2", 0, MOHO.MSG_BASE + 4)
			--  - Percentage of max -	OLD set value at each frame based on percentage
			--      	of span max
			dialog.interpMenu:AddItem("Percentage of Max", 0, MOHO.MSG_BASE + 5)
			--	- Min Max old -	put switch values only at min max values calculated
			--          the old fashioned way. Actual value is based on 
			--			percentage of span max
			dialog.interpMenu:AddItem("Min Max Old", 0, MOHO.MSG_BASE + 6)
			--	- Raw Value -	probably not very good. held just in case. Set value
			--          based on actual amplitude
			dialog.interpMenu:AddItem("Raw Value", 0, MOHO.MSG_BASE + 7)
			--	- BigChange2 -	
			dialog.interpMenu:AddItem("Big Change 2", 0, MOHO.MSG_BASE + 8)
			--	- TrueMinMax -	
			dialog.interpMenu:AddItem("True min max", 0, MOHO.MSG_BASE + 9)
			dialog.interpMenu:SetChecked(MOHO.MSG_BASE + msDialogExample.interpolationStyle, true)
			msDialogExample:MakePopup(dialog.interpMenu)

			dialog.AI = msDialogExample:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.E = msDialogExample:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.etc = msDialogExample:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.stepSize = msDialogExample:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
		layout:Pop()
	layout:Pop()
	
	-- Allow control over frames specified by the user
	msEditSpan:AddComponents(layout)

	-- Should the rest mouth be put at the end of the audio section
	dialog.restAtEnd = msDialogExample:Control(LM.GUI.CheckBox, "Rest", "Rest at end")
	dialog.minimizeMouthSwitches = msDialogExample:Control(LM.GUI.CheckBox, "Minimize", "Minimize Dialog")
	dialog.MBPlowest = msDialogExample:Control(LM.GUI.CheckBox, "MBPlowest", "Is MBP lowest")
	dialog.debug = msDialogExample:Control(LM.GUI.CheckBox, "Debug","Debug")

	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msDialogExampleDialog:UpdateWidgets()
	self.AI:SetValue(msDialogExample.AI)
	self.E:SetValue(msDialogExample.E)
	self.etc:SetValue(msDialogExample.etc)
	self.stepSize:SetValue(msDialogExample.stepSize)
	self.minMaxTolerancePercent:SetValue(msDialogExample.minMaxTolerancePercent)
	self.restAtEnd:SetValue(msDialogExample.restAtEnd)
	self.startFrame:SetValue(msAudioLayer.startFrame)
	self.endFrame:SetValue(msAudioLayer.endFrame)
	self.useAllFrames:SetValue(msAudioLayer.useAllFrames)
	self.minimizeMouthSwitches:SetValue(msDialogExample.minimizeMouthSwitches)
	self.MBPlowest:SetValue(msDialogExample.MBPlowest)
	self.debug:SetValue(msHelper.debug)
end

-- **************************************************
-- Validate user choices
-- **************************************************
function msDialogExampleDialog:OnValidate()
	local b = true
	if (not self:Validate(self.AI, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.E, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.etc, -10, 10)) then
		b = false
	end
	if (not self:Validate(self.minMaxTolerancePercent, 0, 1)) then
		b = false
	end
	if (not self:Validate(self.stepSize, 1, 1000)) then
=======
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
>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
		b = false
	end
	return b
end

<<<<<<< HEAD
-- **************************************************
-- Set values from dialog
-- **************************************************
function msDialogExampleDialog:OnOK()
	msDialogExample.audioLayer = self.menu:FirstChecked()
	msDialogExample.interpolationStyle = self.interpMenu:FirstChecked()
	msDialogExample.AI = self.AI:FloatValue()
	msDialogExample.E = self.E:FloatValue()
	msDialogExample.etc = self.etc:FloatValue()
	msDialogExample.stepSize = self.stepSize:FloatValue()
	msDialogExample.minMaxTolerancePercent = self.minMaxTolerancePercent:FloatValue()
	msDialogExample.restAtEnd = self.restAtEnd:Value()
	msDialogExample.minimizeMouthSwitches = self.minimizeMouthSwitches:Value()
	msDialogExample.MBPlowest = self.MBPlowest:Value()
	msHelper.debug = self.debug:Value()
	
	if msDialogExample.stepSize ~= 1 then
		print("Step size should be 1. I may soon deprecate this control.")
	end
	msAudioLayer:Init(self.moho,
			self.moho:GetAudioLayer(self.menu:FirstChecked()),
			self.useAllFrames:Value(),
			self.startFrame:FloatValue(),
			self.endFrame:FloatValue(),
			self.stepSize:FloatValue(),
			.3)

=======
function msDialogExampleDialog:OnOK()
	msDialogExample.duration = self.duration:IntValue()
	msDialogExample.blur = self.blur:IntValue()
	msDialogExample.DialogExampleOut = self.DialogExampleOut:Value()
>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
end

-- **************************************************
-- The guts of this script
-- **************************************************
<<<<<<< HEAD
function msDialogExample:Run(moho)
	msDialogExample:Display(moho, msDialogExampleDialog)
	if(msDialogExample.cancelled) then return end
=======

function msDialogExample:Run(moho)
	local dlog = msDialogExampleDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

>>>>>>> c62b3588237e107945c4e075ea48e11926e65774
end
