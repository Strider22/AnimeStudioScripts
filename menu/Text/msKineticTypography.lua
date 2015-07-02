-- This script will read a text file and print the lines
ScriptName = "msKineticTypography"
msKineticTypography = {}

function msKineticTypography:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ReadLines/ReadLines=Ex4 Read Lines..."))
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msKineticTypography:Run(moho)

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
