-- playpen for trying things out
ScriptName = "msRotateSelectedPoints"
msRotateSelectedPoints = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msRotateSelectedPoints:Name()
	return "Rotate selected points"
end

function msRotateSelectedPoints:Version()
	return "1.0"
end

function msRotateSelectedPoints:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Rotate selected points.")
end

function msRotateSelectedPoints:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msRotateSelectedPoints:UILabel()
	return(MOHO.Localize("/Scripts/Menu/RotateSelectedPoints/RotateSelectedPoints=Rotate selected points "))
end

function msRotateSelectedPoints:RotateSelectePoints(moho, degres)
	local vectorLayer = moho:LayerAsVector(moho.layer)
	local mesh = vectorLayer:Mesh()
    local selList = MOHO.SelectedPointList(mesh)
	local v = LM.Vector2:new_local()
	local m = LM.Matrix:new_local()
	moho.layer:GetLayerTransform(0,m,moho.document)

	for i, pt in ipairs(selList) do
		v:Set(pt.fPos)
		m:Transform(v)
		pt.fAnimPos:SetValue(0, v)
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msRotateSelectedPoints:Run(moho)
	self:RotateSelectePoints(moho, 45)
end
