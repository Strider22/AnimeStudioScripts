-- This script will read a text file and print the lines
ScriptName = "msEx4ReadLines"
msEx4ReadLines = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEx4ReadLines:Name()
	return "4) Read Lines..."
end

function msEx4ReadLines:Version()
	return "1.0"
end

function msEx4ReadLines:Description()
	return MOHO.Localize("/Scripts/Menu/Ex4ReadLines/Description=This script will read a text file and print the lines.")
end

function msEx4ReadLines:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEx4ReadLines:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ReadLines/ReadLines=4) Read Lines..."))
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msEx4ReadLines:Run(moho)

	-- Open the file to display
	local path = LM.GUI.OpenFile(MOHO.Localize("/Scripts/Menu/ReadLines/SelectReadLinesFile=Select text File"))
	if (path == "") then
		return
	end

	local f = io.open(path, "r")
	if (f == nil) then
		return
	end

	--Read the first line of the file
	local line = f:read()
	while (line ~= nil) do
		print(line)
		line = f:read()
	end
	f:close()
end
