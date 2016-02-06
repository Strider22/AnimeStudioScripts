ScriptName = "msAdvancedDialog"

-- **************************************************
-- General information about this script
-- **************************************************

msAdvancedDialog = {}

msAdvancedDialog.BASE_STR = 2530


-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msAdvancedDialog:Name()
	return "Dialog"
end

function msAdvancedDialog:Version()
	return "6.0"
end

function msAdvancedDialog:Description()
	return MOHO.Localize("/Scripts/Menu/Dialog/Description=Example of dialog using helper functions.")
end

function msAdvancedDialog:Creator()
	return "Mitchel Soltys"
end

function msAdvancedDialog:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Dialog/LayerDialog=Advanced Dialog"))
end

-- **************************************************
-- Recurring values
-- **************************************************

msAdvancedDialog.audioLayer = 0
msAdvancedDialog.interpolationStyle = 1
msAdvancedDialog.AI = .3
msAdvancedDialog.E = .1
msAdvancedDialog.etc = .05
msAdvancedDialog.stepSize = 1
msAdvancedDialog.startFrame = 0
msAdvancedDialog.endFrame = 0
msAdvancedDialog.minMaxTolerancePercent = .05
msAdvancedDialog.minMaxTolerance = 0
msAdvancedDialog.lastMouth = 0
msAdvancedDialog.lastMouthAmplitude = 0
msAdvancedDialog.switch = nil
msAdvancedDialog.frameAdjust = 0
msAdvancedDialog.cancel = false
msAdvancedDialog.restAtEnd = true
msAdvancedDialog.minimizeMouthSwitches = true
msAdvancedDialog.MBPlowest = false

-- **************************************************
-- Dialog dialog
-- **************************************************

local msAdvancedDialogDialog = {}

function msAdvancedDialogDialog:new(moho)
	local dialog = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/Dialog/Title=Dialog"), msAdvancedDialogDialog)
	local layout = dialog:GetLayout()

	msEditSpan:Init(dialog,Dialog)
	msDialog:Init("/Scripts/Menu/Dialog/", dialog, layout)

	dialog.moho = moho


	msDialog:AddText("help", "See Dialog constructor for explanations")
	
	layout:PushH(LM.GUI.ALIGN_CENTER)
		-- add labels
		layout:PushV()
			-- Select the audio layer to use
			msDialog:AddText("AudioLayer", "Audio layer:")
			-- How much wiggle do you ignore? 
			msDialog:AddText("Tolerance", "Tolerance Percentage (.005 .05)")
			-- Which style of interpolation will you use
			msDialog:AddText("InterpStyle", "Interpolation Style:")
			-- Values for determining what the actual mouth values will be
			-- used to be difficult to determine for multiple voices, because
			-- the value was not based on local of the span being edited. So 
			-- if a soft voice was mixed with a loud voice, the soft voice would
			-- not have any mouth values
			msDialog:AddText("AI", "AI level (.03 .3)")
			msDialog:AddText("E", "E level (.01 .1)")
			msDialog:AddText("etc", "etc level (.005 .05)")
			-- step size. Should almost always be one. 
			msDialog:AddText("StepSize", "Step size")
		layout:Pop()
		-- add controls to the right
		layout:PushV()
			dialog.menu = msDialog:AudioDropdown(moho, "SelectAudioLayer", 
				"Select audio layer",msAdvancedDialog.audioLayer)
			dialog.minMaxTolerancePercent = msDialog:AddTextControl(0, "0.0000", 0,
				LM.GUI.FIELD_FLOAT)
			dialog.interpMenu = LM.GUI.Menu(msDialog:Localize("InterpStyle",
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
			dialog.interpMenu:SetChecked(MOHO.MSG_BASE + msAdvancedDialog.interpolationStyle, true)
			msDialog:MakePopup(dialog.interpMenu)

			dialog.AI = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.E = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.etc = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			dialog.stepSize = msDialog:AddTextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
		layout:Pop()
	layout:Pop()
	
	-- Allow control over frames specified by the user
	msEditSpan:AddComponents(layout)

	-- Should the rest mouth be put at the end of the audio section
	dialog.restAtEnd = msDialog:Control(LM.GUI.CheckBox, "Rest", "Rest at end")
	dialog.minimizeMouthSwitches = msDialog:Control(LM.GUI.CheckBox, "Minimize", "Minimize Dialog")
	dialog.MBPlowest = msDialog:Control(LM.GUI.CheckBox, "MBPlowest", "Is MBP lowest")
	dialog.debug = msDialog:Control(LM.GUI.CheckBox, "Debug","Debug")

	return dialog
end

-- **************************************************
-- Set dialog values
-- **************************************************
function msAdvancedDialogDialog:UpdateWidgets()
	self.AI:SetValue(msAdvancedDialog.AI)
	self.E:SetValue(msAdvancedDialog.E)
	self.etc:SetValue(msAdvancedDialog.etc)
	self.stepSize:SetValue(msAdvancedDialog.stepSize)
	self.minMaxTolerancePercent:SetValue(msAdvancedDialog.minMaxTolerancePercent)
	self.restAtEnd:SetValue(msAdvancedDialog.restAtEnd)
	self.startFrame:SetValue(msAudioLayer.startFrame)
	self.endFrame:SetValue(msAudioLayer.endFrame)
	self.useAllFrames:SetValue(msAudioLayer.useAllFrames)
	self.minimizeMouthSwitches:SetValue(msAdvancedDialog.minimizeMouthSwitches)
	self.MBPlowest:SetValue(msAdvancedDialog.MBPlowest)
	self.debug:SetValue(msHelper.debug)
end

-- **************************************************
-- Validate user choices
-- **************************************************
function msAdvancedDialogDialog:OnValidate()
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
		b = false
	end
	return b
end

-- **************************************************
-- Set values from dialog
-- **************************************************
function msAdvancedDialogDialog:OnOK()
	msAdvancedDialog.audioLayer = self.menu:FirstChecked()
	msAdvancedDialog.interpolationStyle = self.interpMenu:FirstChecked()
	msAdvancedDialog.AI = self.AI:FloatValue()
	msAdvancedDialog.E = self.E:FloatValue()
	msAdvancedDialog.etc = self.etc:FloatValue()
	msAdvancedDialog.stepSize = self.stepSize:FloatValue()
	msAdvancedDialog.minMaxTolerancePercent = self.minMaxTolerancePercent:FloatValue()
	msAdvancedDialog.restAtEnd = self.restAtEnd:Value()
	msAdvancedDialog.minimizeMouthSwitches = self.minimizeMouthSwitches:Value()
	msAdvancedDialog.MBPlowest = self.MBPlowest:Value()
	msHelper.debug = self.debug:Value()
	
	if msAdvancedDialog.stepSize ~= 1 then
		print("Step size should be 1. I may soon deprecate this control.")
	end
	msAudioLayer:Init(self.moho,
			self.moho:GetAudioLayer(self.menu:FirstChecked()),
			self.useAllFrames:Value(),
			self.startFrame:FloatValue(),
			self.endFrame:FloatValue(),
			self.stepSize:FloatValue(),
			.3)

end

-- **************************************************
-- The guts of this script
-- **************************************************
function msAdvancedDialog:Run(moho)
	msDialog:Display(moho, msAdvancedDialogDialog)
	if(msAdvancedDialog.cancelled) then return end
end
