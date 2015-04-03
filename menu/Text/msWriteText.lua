--[[
**************************************************
**************************************************

Simple example printing text to a vector layer
**************************************************
**************************************************
]]

-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msWriteText"

-- **************************************************
-- General information about this script
-- **************************************************

msWriteText = {}

msWriteText.BASE_STR = 2510

function msWriteText:Name()
	return "Write Text"
end

function msWriteText:Version()
	return "1.0"
end

function msWriteText:Description()
	return MOHO.Localize("/Scripts/Menu/WriteText/Description=Writes text to a vector layer.")
end

function msWriteText:Creator()
	return "Mitchel Soltys"
end

function msWriteText:UILabel()
	return(MOHO.Localize("/Scripts/Menu/WriteText/WriteText=Write Text..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

msWriteText.font = "Accord SF Bold"

-- **************************************************
-- The guts of this script
-- **************************************************

function msWriteText:Run(moho)
	moho.document:SetDirty()
	moho.document:PrepUndo(NULL)

	MOHO.MohoGlobals.InsertText.FillCol.r = 0
	MOHO.MohoGlobals.InsertText.FillCol.g = 0
	MOHO.MohoGlobals.InsertText.FillCol.b = 0
	local layer = moho:CreateNewLayer(MOHO.LT_VECTOR, false)
	layer:SetName("Text Test")
	-- Make text visible from from 1 to 25
	layer.fVisibility:SetValue(0, false)
	layer.fVisibility:SetValue(1, true)
	layer.fVisibility:SetValue(25, false)
	moho:InsertText("This is my test text", self.font, false, false, true, true, 0)
end
