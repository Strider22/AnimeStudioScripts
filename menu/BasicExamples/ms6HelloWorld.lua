-- Creates a vector layer and inserts Hello World as 2 words
ScriptName = "msEx6HelloWorld"
msEx6HelloWorld = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEx6HelloWorld:Name()
	return "6) Hello World"
end

function msEx6HelloWorld:Version()
	return "1.0"
end

function msEx6HelloWorld:Description()
	return MOHO.Localize("/Scripts/Menu/Ex6HelloWorld/Description=Creates a vector layer and inserts Hello World as 2 words.")
end

function msEx6HelloWorld:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEx6HelloWorld:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Text/Text=6) Hello World"))
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msEx6HelloWorld:Run(moho)
	local layer = moho:CreateNewLayer(MOHO.LT_VECTOR, false)
	layer:SetName("Hello World")
	-- moho doc found at http://www.animestudioscripting.com/moho/moho-classes/scriptinterface
	-- InsertText(const char *text, const char *font, bool fill, bool stroke, bool groupTogether, bool centerH, int32 lineOffset)
	moho:InsertText("Hello", "Accord Light SF Regular", true, false, true, false, 0)
	moho:InsertText("World", "Accord Light SF Regular", false, true, true, true, 1)
end
