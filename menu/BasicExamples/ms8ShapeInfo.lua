-- playpen for trying things out
ScriptName = "ms8ShapeInfo"
ms8ShapeInfo = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function ms8ShapeInfo:Name()
	return "8) Shape Info ... "
end

function ms8ShapeInfo:Version()
	return "1.0"
end

function ms8ShapeInfo:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Moves all shapes on a vector layer.")
end

function ms8ShapeInfo:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function ms8ShapeInfo:UILabel()
	return(MOHO.Localize("/Scripts/Menu/MoveShapes/MoveShapes=8) Shape Info ... "))
end

function ms8ShapeInfo:Shapes(moho)
	local min = LM.Vector2:new_local()
	local max = LM.Vector2:new_local()
	
	local layer = moho.layer
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end
	
	local vectorLayer = moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	print("num shapes = " .. mesh:CountShapes())
	print("num curves = " .. mesh:CountCurves())
	print("num points = " .. mesh:CountPoints())
	print("num groups = " .. mesh:CountGroups())
	mesh:SelectAll()
	mesh:SelectedBounds(min,max)
	print("min x = "..min.x .. ", y = " .. min.y .. " max x = " .. max.x .. ", y = ".. max.y)
end

-- **************************************************
-- The guts of this script
-- **************************************************
function ms8ShapeInfo:Run(moho)
	self:Shapes(moho)
end
