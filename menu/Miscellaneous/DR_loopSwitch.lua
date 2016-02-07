-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "DR_loopSwitch"

-- **************************************************
-- General information about this script
-- **************************************************

DR_loopSwitch = {}

function DR_loopSwitch:Name()
	return "Loop Switches"
end

function DR_loopSwitch:Version()
	return "1.2.1"
end

function DR_loopSwitch:Description()
	return "Loop the switches in the selected switch layer"
end

function DR_loopSwitch:Creator()
	return "David Rylander, 2008, GPL-2.0"
end

function DR_loopSwitch:UILabel()
	return("Loop Switches...")
end

-- **************************************************
-- Recurring values
-- **************************************************

DR_loopSwitch.range_start = 1
DR_loopSwitch.range_end = 72
DR_loopSwitch.interval_min = 2
DR_loopSwitch.interval_max = 4
DR_loopSwitch.image_interval = 1
DR_loopSwitch.alwaysfirst = true
DR_loopSwitch.reverseorder = false
--DR_loopSwitch.pingpong = false

-- **************************************************
-- Random dialog
-- **************************************************
local DR_randomDialog = {}


function DR_randomDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Loop Switches", DR_randomDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:PushH()
		l:PushV()
			l:AddChild(LM.GUI.StaticText("Range, from frame:"), LM.GUI.ALIGN_LEFT)
		l:AddChild(LM.GUI.StaticText("Range, to frame:"), LM.GUI.ALIGN_LEFT)
		l:AddChild(LM.GUI.StaticText("Interval, min:"), LM.GUI.ALIGN_LEFT)
		l:AddChild(LM.GUI.StaticText("Interval, max:"), LM.GUI.ALIGN_LEFT)
		l:AddChild(LM.GUI.StaticText("Image # interval:"), LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV()
			d.range_start = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
                        l:AddChild(d.range_start)
                        d.range_end = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
                        l:AddChild(d.range_end)
                        d.interval_min = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
                        l:AddChild(d.interval_min)
                        d.interval_max = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
                        l:AddChild(d.interval_max)
			d.image_interval = LM.GUI.TextControl(0, "0000", 0, LM.GUI.FIELD_UINT)
                        l:AddChild(d.image_interval)
		l:Pop()
	l:Pop()
        
        d.alwaysfirst = LM.GUI.CheckBox("Always key first keyframe in range.")
	l:AddChild(d.alwaysfirst, LM.GUI.ALIGN_LEFT)
        d.reverseorder = LM.GUI.CheckBox("Reverse Switch Keys.")
	l:AddChild(d.reverseorder, LM.GUI.ALIGN_LEFT)
        
        --[[d.pingpong = LM.GUI.CheckBox("Ping pong loop.")
	l:AddChild(d.pingpong, LM.GUI.ALIGN_LEFT)
        
        --d.startpopup = LM.GUI.PopupMenu(128, true)
        l:AddChild(d.startpopup)]]
        
        --IN, pingpong loop
        --IN, dropdown m. switches. Start with switch:

	return d
end

function DR_randomDialog:UpdateWidgets()
	self.range_start:SetValue(DR_loopSwitch.range_start)
	self.range_end:SetValue(DR_loopSwitch.range_end)
	self.interval_min:SetValue(DR_loopSwitch.interval_min)
	self.interval_max:SetValue(DR_loopSwitch.interval_max)
	self.image_interval:SetValue(DR_loopSwitch.image_interval)
        self.alwaysfirst:SetValue(DR_loopSwitch.alwaysfirst)
        self.reverseorder:SetValue(DR_loopSwitch.reverseorder)
        --self.pingpong:SetValue(DR_loopSwitch.pingpong)
end


function DR_randomDialog:OnOK()
	DR_loopSwitch.range_start = self.range_start:IntValue()
	DR_loopSwitch.range_end = self.range_end:IntValue()
	DR_loopSwitch.interval_min = self.interval_min:IntValue()
	DR_loopSwitch.interval_max = self.interval_max:IntValue()
	DR_loopSwitch.image_interval = self.image_interval:IntValue()
        DR_loopSwitch.alwaysfirst = self.alwaysfirst:Value()
        DR_loopSwitch.reverseorder = self.reverseorder:Value()
        --DR_loopSwitch.pingpong = self.pingpong:Value()

end


-- **************************************************
-- The guts of this script
-- **************************************************

function DR_loopSwitch:Run(moho)

      
	-- check if the layer is a switch layer
        if (moho.layer:LayerType() ~= MOHO.LT_SWITCH)
        then
        
	LM.GUI.Alert(LM.GUI.ALERT_INFO, "The selected layer is not a Switch Layer.", nil, nil, "OK", nil, nil)
        return
        end
        

        local dlog = DR_randomDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end
        
        
        moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
        
     
      local switchLayer =moho:LayerAsSwitch(moho.layer)
      local switch = switchLayer:SwitchValues()
      

 for frameI = DR_loopSwitch.range_start, DR_loopSwitch.range_end do --check for switches
		if switch:HasKey(frameI) then
			
                        
    local deletekeys = LM.GUI.Alert(LM.GUI.ALERT_WARNING, "The Switch Layer has switch keys in the selected range.", "These will be deleted if you proceed.", nil, "OK", "CANCEL", nil)
                     
                     
         if deletekeys == 1 then
         return
         end
        elseif deletekeyes == 0 then
    end         
  do break end  
 end
 
 
for frameC = DR_loopSwitch.range_start, DR_loopSwitch.range_end do
 switch:DeleteKey(frameC)
 end
 
 math.randomseed( os.time() )
math.random(); math.random(); math.random()
 
 frejm = (DR_loopSwitch.range_start)  --HÄR fixas...
 namenumber = 0
 namenumber_rev = switchLayer:CountLayers() -1

while frejm < (DR_loopSwitch.range_end) do
        
        if DR_loopSwitch.alwaysfirst == false then --not key first frame
        frejm = frejm + temp_interval
        end
        
        temp_interval = math.random(DR_loopSwitch.interval_min, DR_loopSwitch.interval_max)
        antal = switchLayer:CountLayers()
        
        if DR_loopSwitch.reverseorder == false then
        name = switchLayer:Layer(namenumber):Name()
        namenumber = namenumber +(DR_loopSwitch.image_interval)                      --Ping pong loop in!
        if namenumber > antal -1 then		
        namenumber = 0
        end
        
        elseif DR_loopSwitch.reverseorder == true then
	if namenumber_rev >= 0 then
        name = switchLayer:Layer(namenumber_rev):Name()
	end
        namenumber_rev = namenumber_rev -(DR_loopSwitch.image_interval)                      --Ping pong loop in!
        if namenumber_rev < 0 then
        namenumber_rev = antal -1
        end
end        
        
        
        switchLayer:SwitchValues():SetValue((frejm), (name)) 
        
        if DR_loopSwitch.alwaysfirst == true then --key first frame
        frejm = frejm + temp_interval
        end
        
        oldname = name
        moho:NewKeyframe(CHANNEL_SWITCH)
        MOHO.Redraw()
        

      end
end
