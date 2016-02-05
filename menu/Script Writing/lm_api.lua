-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_API"

-- **************************************************
-- General information about this script
-- **************************************************

LM_API = {}

function LM_API:Name()
	return "API"
end

function LM_API:Version()
	return "6.0"
end

function LM_API:Description()
	return MOHO.Localize("/Scripts/Menu/API/Description=Prints out the interfaces available to Lua scripts")
end

function LM_API:Creator()
	return "Smith Micro Software, Inc."
end

function LM_API:UILabel()
	return(MOHO.Localize("/Scripts/Menu/API/PrintAnimeStudioAPI=Print Anime Studio API"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_API:Run(moho)
	print("LM interfaces:")
	self:PrintTableValues(LM)

	print("LM.GUI interfaces:")
	self:PrintTableValues(LM.GUI)

	print("MOHO interfaces:")
	self:PrintTableValues(MOHO)
end

function LM_API:PrintTableValues(t)
	for n, v in pairs(t) do
		print("", n, v, type(v))
	end
end
