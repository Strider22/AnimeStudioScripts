-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_PlaceSwitch"

-- **************************************************
-- General information about this script
-- **************************************************

MS_PlaceSwitch = {}

function MS_PlaceSwitch:Name()
	return "Apply Switch Data"
end

function MS_PlaceSwitch:Version()
	return "6.0"
end

function MS_PlaceSwitch:Description()
	return MOHO.Localize("/Scripts/Menu/PlaceSwitch/Description=Data file test script")
end

function MS_PlaceSwitch:Creator()
	return "Mitchel Soltys"
end

function MS_PlaceSwitch:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PlaceSwitch/PlaceSwitch=Place Switch"))
end

-- **************************************************
-- Recurring values
-- **************************************************

MS_PlaceSwitch.range_start = 1
MS_PlaceSwitch.range_end = 72
MS_PlaceSwitch.interval_min = 2
MS_PlaceSwitch.interval_max = 4
MS_PlaceSwitch.image_interval = 1
MS_PlaceSwitch.alwaysfirst = true
MS_PlaceSwitch.reverseorder = false

-- **************************************************
-- The guts of this script
-- **************************************************

function MS_PlaceSwitch:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end

function MS_PlaceSwitch:DeleteKeys()
	for frameC = MS_PlaceSwitch.range_start, DR_loopSwitch.range_end do
		switch:DeleteKey(frameC)
	end
end

function MS_PlaceSwitch:PrintLayerNames(switchLayer)
	for i = 1, switchLayer:CountLayers() do
		print("layer " .. i-1 .. " is named " .. switchLayer:Layer(i-1):Name())
	end
end

function MS_PlaceSwitch:Run(moho)
	--local path = LM.GUI.OpenFile(MOHO.Localize("/Scripts/Menu/PlaceSwitch/SelectDataFile=Select Data File"))
	--if (path == "") then
	--	return
	--end

    local switchLayer = moho:LayerAsSwitch(moho.layer)
    local switch = switchLayer:SwitchValues()
	
	-- print("Number of switch Layers " .. switchLayer:CountLayers())
	-- MS_PlaceSwitch:PrintLayerNames(switchLayer)
	
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
