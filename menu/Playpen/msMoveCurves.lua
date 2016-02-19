-- playpen for trying things out
ScriptName = "msMoveCurves"
msMoveCurves = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMoveCurves:Name()
	return "Move Curves ... "
end

function msMoveCurves:Version()
	return "1.0"
end

function msMoveCurves:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Moves all curves on a vector layer.")
end

function msMoveCurves:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMoveCurves:UILabel()
	return(MOHO.Localize("/Scripts/Menu/MoveCurves/MoveCurves=Move Curves ... "))
end

function msMoveCurves:MoveCurve(curve, x,y)

	local v = LM.Vector2:new_local()
	v:Set(x,y)
	
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		pt.fAnimPos:SetValue(0, pt.fPos + v)
	end
end

function msMoveCurves:MoveAllCurves(moho)
	local layer = moho.layer
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:MoveCurve(mesh:Curve(i), .5, -.2)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msMoveCurves:Run(moho)
	self:MoveAllCurves(moho)
end
