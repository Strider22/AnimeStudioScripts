-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msAPI"

-- **************************************************
-- General information about this script
-- **************************************************

msAPI = {}

function msAPI:Name()
	return "API"
end

function msAPI:Version()
	return "6.0"
end

function msAPI:Description()
	return MOHO.Localize("/Scripts/Menu/API/Description=Prints out the interfaces available to Lua scripts")
end

function msAPI:Creator()
	return "Smith Micro Software, Inc."
end

function msAPI:UILabel()
	return(MOHO.Localize("/Scripts/Menu/API/PrintAnimeStudioAPI=Print Anime Studio API"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msAPI:Run(moho)
	-- print("LM interfaces:")
	-- self:PrintTableValues(LM)

	-- print("LM.GUI interfaces:")
	-- self:PrintTableValues(LM.GUI)

	-- print("MOHO interfaces:")
	-- self:PrintTableValues(MOHO)
	-- print("MOHO view:")
	-- self:PrintTableValues(MohoView)
end

function msAPI:PrintTableValues(t)
	for n, v in pairs(t) do
		print("n: ", n, " v: ",  v, " type " , type(v))
	end
end
