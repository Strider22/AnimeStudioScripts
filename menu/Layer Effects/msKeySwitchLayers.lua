-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msKeySwitchLayers"

-- **************************************************
-- Creates a key frame for each layer in the switch layer.
-- Especially useful for creating switch layer bone controls.
-- **************************************************

msKeySwitchLayers = {}

function msKeySwitchLayers:Name()
	return "Key Switch Layers"
end

function msKeySwitchLayers:Version()
	return "1"
end

function msKeySwitchLayers:Description()
	return "Creates a key frame for each layer in the switch layer."
end

function msKeySwitchLayers:Creator()
	return "Mitchel Soltys, modified version of David Rylander's Loop Switches"
end

function msKeySwitchLayers:UILabel()
	return("Key Switch Layers")
end

-- **************************************************
-- Recurring values
-- **************************************************

msKeySwitchLayers.range_start = 1
msKeySwitchLayers.range_end = 100
msKeySwitchLayers.includeTop = true
msKeySwitchLayers.reverseorder = true

-- **************************************************
-- Random dialog
-- **************************************************
local msKeySwitchLayersDialog = {}


function msKeySwitchLayersDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Loop Switches", msKeySwitchLayersDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:PushH()
		l:PushV()
			l:AddChild(LM.GUI.StaticText("Range, from frame:"), LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Range, end frame:"), LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV()
			d.range_start = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.range_start)
			d.range_end = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.range_end)
		l:Pop()
	l:Pop()
        
    d.includeTop = LM.GUI.CheckBox("Include top layer.")
	l:AddChild(d.includeTop, LM.GUI.ALIGN_LEFT)
    d.reverseorder = LM.GUI.CheckBox("Reverse Switch Keys.")
	l:AddChild(d.reverseorder, LM.GUI.ALIGN_LEFT)

	return d
end

function msKeySwitchLayersDialog:UpdateWidgets()
	self.range_start:SetValue(msKeySwitchLayers.range_start)
	self.range_end:SetValue(msKeySwitchLayers.range_end)
    self.includeTop:SetValue(msKeySwitchLayers.includeTop)
    self.reverseorder:SetValue(msKeySwitchLayers.reverseorder)
end


function msKeySwitchLayersDialog:OnOK()
	msKeySwitchLayers.range_start = self.range_start:IntValue()
	msKeySwitchLayers.range_end = self.range_end:IntValue()
    msKeySwitchLayers.includeTop = self.includeTop:Value()
    msKeySwitchLayers.reverseorder = self.reverseorder:Value()
end

function msKeySwitchLayers:IsEnabled(moho)
	if (moho.layer:LayerType() ~= MOHO.LT_SWITCH) then
		return false
	end
	return true
end

function msKeySwitchLayers:Increment(startFrame, endFrame, numLayers)
	local numFrames = endFrame - startFrame + 1
	if numLayers > numFrames then
		LM.GUI.Alert(LM.GUI.ALERT_WARNING, "The Switch Layer has more layers than your range allows.", nil, nil, "OK", nil, nil)
		return -1
	end
	return math.floor((numFrames+1)/numLayers)
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msKeySwitchLayers:Run(moho)

    local dlog = msKeySwitchLayersDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end
        
        
    moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
        
    local switchLayer =moho:LayerAsSwitch(moho.layer)
    local switch = switchLayer:SwitchValues()
	local numLayers = switchLayer:CountLayers()
	local startFrame = msKeySwitchLayers.range_start
	local endFrame = msKeySwitchLayers.range_end
	local layer = 0
	local layerIncrement = 1
	
	if not self.includeTop then 
		numLayers = numLayers - 1
	end
	-- needs to come after include First
	if self.reverseorder then 
		layer = numLayers -1
		layerIncrement = -1
	end
	print("layer " .. layer .. " layer Increment  ".. layerIncrement .. " num Layers " .. numLayers)
	local frameIncrement = self:Increment(startFrame, endFrame, numLayers)
	if frameIncrement < 0 then 
		return
	end
	
	for frameI = startFrame, endFrame, frameIncrement do 
		if switch:HasKey(frameI) then
			local deletekeys = LM.GUI.Alert(LM.GUI.ALERT_WARNING, "The Switch Layer has switch keys in the selected range.", "These will be deleted if you proceed.", nil, "OK", "CANCEL", nil)
			if deletekeys == 1 then
				return
			end
        elseif deletekeyes == 0 then
		end         
		do break end  
	end
 
 
	for frameC = startFrame, endFrame, frameIncrement do
		switch:DeleteKey(frameC)
	end
 
	local frame = startFrame
	local layerCount = 0
	while layerCount < numLayers do
		name = switchLayer:Layer(layer):Name()
        switch:SetValue(frame, name) 
		print("frame " .. frame .. " name " .. name)
		layer = layer + layerIncrement
		frame = frame + frameIncrement
		layerCount = layerCount + 1
        
       
        -- moho:NewKeyframe(CHANNEL_SWITCH)
        -- MOHO.Redraw()
      end
end

