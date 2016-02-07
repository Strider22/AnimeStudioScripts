-- playpen for trying things out
ScriptName = "msMoveSelectedPoints"
msMoveSelectedPoints = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMoveSelectedPoints:Name()
	return "Move selected points"
end

function msMoveSelectedPoints:Version()
	return "1.0"
end

function msMoveSelectedPoints:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Moves selected points.")
end

function msMoveSelectedPoints:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMoveSelectedPoints:UILabel()
	return(MOHO.Localize("/Scripts/Menu/MoveSelectedPoints/MoveSelectedPoints=Move selected points "))
end

function msMoveSelectedPoints:MoveSelectePoints(mesh, x,y)
    local selList = MOHO.SelectedPointList(mesh)
	local v = LM.Vector2:new_local()
	v:Set(x,y)

	for i, pt in ipairs(selList) do
		pt.fAnimPos:SetValue(0, pt.fPos + v)
	end
end

function msMoveSelectedPoints:Shapes(moho)
	local mesh = moho:Mesh()
	self:MoveSelectePoints(mesh, .5, -.2)
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msMoveSelectedPoints:Run(moho)
	self:Shapes(moho)
end
