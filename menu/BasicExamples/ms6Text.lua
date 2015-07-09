-- This script will read a text file and print the lines
ScriptName = "msEx6Text"
msEx6Text = {}

function msEx6Text:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Text/Text=6) Text Layers"))
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msEx6Text:Run(moho)
	local center = true
	local lineOffset = 1
	local min = LM.Vector2:new_local()
	local max = LM.Vector2:new_local()
	
	local layer = moho:CreateNewLayer(MOHO.LT_VECTOR, false)
	layer:SetName("Hello")
	-- layer:ShowConstructionCurves(false)
	-- layer.fVisibility:SetValue(0, true)
	-- layer.fVisibility:SetValue(moho.frame, false)
	moho:InsertText("Hello", "Accord SF Bold", true, false, true, center, lineOffset)
	local mesh = moho:Mesh()
	mesh:SelectAll()
	mesh:SelectedBounds(min,max)
	print("min "..min.x .. ", " .. min.y .. " max " .. max.x .. ", ".. max.y)
end
