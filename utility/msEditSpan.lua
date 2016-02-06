-- **************************************************
-- Section that can be added to a dialog 
-- to support scripts needing control over a 
-- specific set of frames
-- **************************************************

msEditSpan = {}

msEditSpan.dialog = 0
msEditSpan.app = 0 

function msEditSpan:Init(dialog, app)
	self.dialog = dialog
	self.app = app
end

-- Assumes msDialog:Init has been called in the calling app
function msEditSpan:AddComponents(layout)
	layout:PushH(LM.GUI.ALIGN_LEFT)
		layout:PushV()			
			msDialog:AddText("StartFrame", "Start frame")
			msDialog:AddText("EndFrame", "End Frame")
		layout:Pop()
		layout:PushV()
			-- the 0.0000 is the initial value, but it's acually used for 
			-- formatting to set the textbox size appropriately
			self.dialog.startFrame = msDialog:AddTextControl(0, "0.0000", 0,
				LM.GUI.FIELD_UINT)
			self.dialog.endFrame =   msDialog:AddTextControl(0, "0.0000", 0,
				LM.GUI.FIELD_UINT)
		layout:Pop()
	layout:Pop()
	self.dialog.useAllFrames = msDialog:Control(LM.GUI.CheckBox, "Frames","Use all frames")
end



