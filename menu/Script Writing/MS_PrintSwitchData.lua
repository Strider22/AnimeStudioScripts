-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_PrintSwitchData"

-- **************************************************
-- General information about this script
-- **************************************************

MS_PrintSwitchData = {}

function MS_PrintSwitchData:Name()
	return "Read Switch Data"
end

function MS_PrintSwitchData:Version()
	return "6.0"
end

function MS_PrintSwitchData:Description()
	return MOHO.Localize("/Scripts/Menu/PrintSwitchData/Description=Demo script to read a .dat file")
end

function MS_PrintSwitchData:Creator()
	return "Mitchel Soltys"
end

function MS_PrintSwitchData:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintSwitchData/PrintSwitchData=Print Switch Data ..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

MS_PrintSwitchData.range_start = 1
MS_PrintSwitchData.range_end = 72
MS_PrintSwitchData.interval_min = 2
MS_PrintSwitchData.interval_max = 4
MS_PrintSwitchData.image_interval = 1
MS_PrintSwitchData.alwaysfirst = true
MS_PrintSwitchData.reverseorder = false

-- **************************************************
-- The guts of this script
-- **************************************************

function MS_PrintSwitchData:IsEnabled(moho)
	return true
end

function MS_PrintSwitchData:Run(moho)
	local path = LM.GUI.OpenFile(MOHO.Localize("/Scripts/Menu/PrintSwitchData/SelectDataFile=Select Data File"))
	if (path == "") then
		return
	end

	local f = io.open(path, "r")
	if (f == nil) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	local line = f:read()
	print(line)
 	local frame = f:read("*n")
 	local mouth
	while (frame ~= nil) do
		mouth =f:read()
		print("frame " .. frame .." mouth " .. mouth)

		frame = f:read("*n")
	end

	f:close()
	print("Range Start" .. MS_PrintSwitchData.range_start)
end
