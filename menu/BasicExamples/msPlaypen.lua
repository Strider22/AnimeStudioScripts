-- playpen for trying things out
ScriptName = "msPlaypen"
msPlaypen = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPlaypen:Name()
	return "Playpen "
end

function msPlaypen:Version()
	return "1.0"
end

function msPlaypen:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Prints out a simple message.")
end

function msPlaypen:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPlaypen:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Playpen/Playpen=Playpen "))
end

function msPlaypen:MoveShape(mesh, x,y)
    local selList = MOHO.SelectedPointList(mesh)
	local v = LM.Vector2:new_local()
	v:Set(x,y)

	for i, pt in ipairs(selList) do
		pt.fAnimPos:SetValue(0, pt.fPos + v)
	end
end

function msPlaypen:Shapes(moho)
	local mesh = moho:Mesh()
	self:MoveShape(mesh, .5, -.2)
end

function msPlaypen:Text(moho)
	local min = LM.Vector2:new_local()
	local max = LM.Vector2:new_local()
	
	local layer = moho:CreateNewLayer(MOHO.LT_VECTOR, false)
	layer:SetName("My Text")
	-- layer:ShowConstructionCurves(false)
	-- layer.fVisibility:SetValue(0, true)
	-- layer.fVisibility:SetValue(moho.frame, false)
	-- moho doc found at http://www.animestudioscripting.com/moho/moho-classes/scriptinterface
	-- InsertText(const char *text, const char *font, bool fill, bool stroke, bool groupTogether, bool centerH, int32 lineOffset)
	moho:InsertText("Hello", "Accord Light SF Regular", true, false, true, false, 0)
	moho:InsertText("World", "Accord Light SF Regular", true, false, true, false, 1)
	local mesh = moho:Mesh()
	print("num shapes" .. mesh:CountShapes())
	print("num curves" .. mesh:CountCurves())
	print("num groups" .. mesh:CountGroups())
	mesh:SelectAll()
	mesh:SelectedBounds(min,max)
	print("min "..min.x .. ", " .. min.y .. " max " .. max.x .. ", ".. max.y)
end
-- **************************************************
-- The guts of this script
-- **************************************************
function msPlaypen:Run(moho)
	self:Shapes(moho)
end
