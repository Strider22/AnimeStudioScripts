-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_Globals"

-- **************************************************
-- General information about this script
-- **************************************************

LM_Globals = {}

function LM_Globals:Name()
	return "Print Globals"
end

function LM_Globals:Version()
	return "6.0"
end

function LM_Globals:Description()
	return MOHO.Localize("/Scripts/Menu/Globals/Description=Print global variables in the Lua interpreter")
end

function LM_Globals:Creator()
	return "Smith Micro Software, Inc."
end

function LM_Globals:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Globals/PrintGlobals=Print Globals"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_Globals:Run(moho)
	print(MOHO.Localize("/Scripts/Menu/Globals/GlobalVariables=Global variables:"))
	self:PrintTableValues(_G)
end

function LM_Globals:PrintTableValues(t)
	for n, v in pairs(t) do
		print("", n, v, type(v))
	end
end
