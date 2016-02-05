-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_TestScript"

-- **************************************************
-- General information about this script
-- **************************************************

MS_TestScript = {}

function MS_TestScript:Name()
	return "Apply Switch Data"
end

function MS_TestScript:Version()
	return "6.0"
end

function MS_TestScript:Description()
	return MOHO.Localize("/Scripts/Menu/TestScript/Description=Simple Shell to test different scripting ideas")
end

function MS_TestScript:Creator()
	return "Mitchel Soltys"
end

function MS_TestScript:UILabel()
	return(MOHO.Localize("/Scripts/Menu/TestScript/TestScript=Test Script"))
end

-- **************************************************
-- Recurring values
-- **************************************************

MS_TestScript.range_start = 1

-- **************************************************
-- The guts of this script
-- **************************************************

function MS_TestScript:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end

-- function MS_TestScript:DeleteKeys()
	-- for frameC = MS_TestScript.range_start, DR_loopSwitch.range_end do
		-- switch:DeleteKey(frameC)
	-- end
-- end
function MS_TestScript:DeleteKeys(switch, startFrame, endFrame)
print (startFrame .. " " .. endFrame)
	for frame = startFrame, endFrame do
		switch:DeleteKey(frame)
	end
end
function MS_TestScript:PrintLayerNames(switchLayer)
	for i = 1, switchLayer:CountLayers() do
		print("layer " .. i-1 .. " is named " .. switchLayer:Layer(i-1):Name())
	end
end
function MS_TestScript:DeleteKeys2(layer, startFrame, endFrame)
	for frame = startFrame, endFrame do
		layer:DeleteKeysAtFrame(true,frame)
	end
end

function MS_TestScript:Run(moho)

    local switchLayer = moho:LayerAsSwitch(moho.layer)
    local switch = switchLayer:SwitchValues()
	
	-- self:DeleteKeys(switch, 24, 48)
	self:DeleteKeys2(moho.layer, 24, 48)

end
