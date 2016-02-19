-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_ApplySwitchData"

-- **************************************************
-- General information about this script
-- **************************************************

MS_ApplySwitchData = {}

function MS_ApplySwitchData:Name()
	return "Apply Switch Data"
end

function MS_ApplySwitchData:Version()
	return "6.0"
end

function MS_ApplySwitchData:Description()
	return MOHO.Localize("/Scripts/Menu/ApplySwitchData/Description=Data file test script")
end

function MS_ApplySwitchData:Creator()
	return "Mitchel Soltys"
end

function MS_ApplySwitchData:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ApplySwitchData/ApplySwitchData=Apply Switch Data ..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

MS_ApplySwitchData.range_start = 1
MS_ApplySwitchData.range_end = 72
MS_ApplySwitchData.interval_min = 2
MS_ApplySwitchData.interval_max = 4
MS_ApplySwitchData.image_interval = 1
MS_ApplySwitchData.alwaysfirst = true
MS_ApplySwitchData.reverseorder = false

-- **************************************************
-- The guts of this script
-- **************************************************

function MS_ApplySwitchData:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end

function MS_ApplySwitchData:DeleteKeys()
	for frameC = MS_ApplySwitchData.range_start, DR_loopSwitch.range_end do
		switch:DeleteKey(frameC)
	end
end

function MS_ApplySwitchData:PrintLayerNames(switchLayer)
	for i = 1, switchLayer:CountLayers() do
		print("layer " .. i-1 .. " is named " .. switchLayer:Layer(i-1):Name())
	end
end

function MS_ApplySwitchData:Run(moho)
	--local path = LM.GUI.OpenFile(MOHO.Localize("/Scripts/Menu/ApplySwitchData/SelectDataFile=Select Data File"))
	--if (path == "") then
	--	return
	--end

    local switch = moho:LayerAsSwitch(moho.layer).SwitchValues()
	
	-- print("Number of switch Layers " .. switchLayer:CountLayers())
	-- MS_ApplySwitchData:PrintLayerNames(switchLayer)
	
--	local f = io.open(path, "r")
	--if (f == nil) then
		--return
	--end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	switch:SetValue(7,"AI") 

	--local line = f:read()
	--print(line)
 	--local frame = f:read("*n")
 	--local mouth
	--while (frame ~= nil) do
	--	mouth =f:read()
	--	print("frame " .. frame .." mouth " .. mouth)

		--frame = f:read("*n")
	--end

	--f:close()
end
