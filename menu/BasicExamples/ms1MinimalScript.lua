ScriptName = "msMinimalScript"
msMinimalScript = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMinimalScript:Name()
	return "1) Minimal Script..."
end

function msMinimalScript:Version()
	return "1.0"
end

function msMinimalScript:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Prints out a simple message.")
end

function msMinimalScript:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMinimalScript:UILabel()
	return "1) Minimal Script..."
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msMinimalScript:Run(moho)
	print("A minimal script to print out a message")
end
