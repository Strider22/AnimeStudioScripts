ScriptName = "msDialog"

-- **************************************************
-- General information about this script
-- **************************************************

msDialog = {}

msDialog.BASE_STR = 2530


-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msDialog:Name()
	return "Dialog"
end

function msDialog:Version()
	return "6.0"
end

function msDialog:Description()
	return MOHO.Localize("/Scripts/Menu/Dialog/Description=Simple example of using a dialog.")
end

function msDialog:Creator()
	return "Mitchel Soltys"
end

function msDialog:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Dialog/LayerDialog=Dialog"))
end

-- **************************************************
-- Recurring values
-- **************************************************

msDialog.audioLayer = 0
msDialog.interpolationStyle = 1
msDialog.AI = .3
msDialog.E = .1
msDialog.etc = .05
msDialog.stepSize = 1
msDialog.startFrame = 0
msDialog.endFrame = 0
msDialog.minMaxTolerancePercent = .05
msDialog.minMaxTolerance = 0
msDialog.lastMouth = 0
msDialog.lastMouthAmplitude = 0
msDialog.switch = nil
msDialog.frameAdjust = 0
msDialog.cancel = false
msDialog.restAtEnd = true
msDialog.minimizeMouthSwitches = true
msDialog.MBPlowest = false

-- **************************************************
-- Dialog dialog
-- **************************************************

local msDialogDialog = {}

function msDialogDialog:new(moho)
	local dialog = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/Dialog/Title=Dialog"), msDialogDialog)
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
				"Select audio layer",msDialog.audioLayer)
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
			dialog.interpMenu:SetChecked(MOHO.MSG_BASE + msDialog.interpolationStyle, true)
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
function msDialogDialog:UpdateWidgets()
	self.AI:SetValue(msDialog.AI)
	self.E:SetValue(msDialog.E)
	self.etc:SetValue(msDialog.etc)
	self.stepSize:SetValue(msDialog.stepSize)
	self.minMaxTolerancePercent:SetValue(msDialog.minMaxTolerancePercent)
	self.restAtEnd:SetValue(msDialog.restAtEnd)
	self.startFrame:SetValue(msAudioLayer.startFrame)
	self.endFrame:SetValue(msAudioLayer.endFrame)
	self.useAllFrames:SetValue(msAudioLayer.useAllFrames)
	self.minimizeMouthSwitches:SetValue(msDialog.minimizeMouthSwitches)
	self.MBPlowest:SetValue(msDialog.MBPlowest)
	self.debug:SetValue(msHelper.debug)
end

-- **************************************************
-- Validate user choices
-- **************************************************
function msDialogDialog:OnValidate()
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
function msDialogDialog:OnOK()
	msDialog.audioLayer = self.menu:FirstChecked()
	msDialog.interpolationStyle = self.interpMenu:FirstChecked()
	msDialog.AI = self.AI:FloatValue()
	msDialog.E = self.E:FloatValue()
	msDialog.etc = self.etc:FloatValue()
	msDialog.stepSize = self.stepSize:FloatValue()
	msDialog.minMaxTolerancePercent = self.minMaxTolerancePercent:FloatValue()
	msDialog.restAtEnd = self.restAtEnd:Value()
	msDialog.minimizeMouthSwitches = self.minimizeMouthSwitches:Value()
	msDialog.MBPlowest = self.MBPlowest:Value()
	msHelper.debug = self.debug:Value()
	
	if msDialog.stepSize ~= 1 then
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
function msDialog:Run(moho)
	msDialog:Display(moho, msDialogDialog)
	if(msDialog.cancelled) then return end
end
