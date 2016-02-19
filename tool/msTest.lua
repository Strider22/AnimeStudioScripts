ScriptName = "msTest"
msTest = {}

function msTest:Description()
	return "Tool to test code."
end


function msTest:Name()
	return "Test "
end

function msTest:Version()
	return "1.0"
end

function msTest:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msTest:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Test/Test=Test "))
end

function msTest:MoveShape(mesh, x,y)
    local selList = MOHO.SelectedPointList(mesh)
	local v = LM.Vector2:new_local()
	v:Set(x,y)

	for i, pt in ipairs(selList) do
		pt.fAnimPos:SetValue(0, pt.fPos + v)
	end
end

function msTest:Shapes(moho)
	local mesh = moho:Mesh()
	self:MoveShape(mesh, .5, -.2)
end

function msTest:Text(moho)
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

function msTest:PrintResult(x)
	print("x " .. x .. " z " .. msCurvedTransform:yFromX(0.55, x))
	
end

function msTest:Rotate(x)
	local z = msCurvedTransform:zFromX(0.55,x)
	local point = msCurvedTransform:Point(x,0,z)
	msCurvedTransform:rotatePointY(point, self.origin, 30)
	-- z = msCurvedTransform:zFromX(0.55, point.x)
	return point.x
end

function msTest:MoveCurve(curve)

	-- local v = LM.Vector2:new_local()
	-- v:Set(x,y)
	
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		pt.fPos.x = self:Rotate(pt.fPos.x)
		pt.fAnimPos:SetValue(0, pt.fPos)
	end
end

function msTest:MoveAllCurves(moho)
	local layer = moho.layer
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:MoveCurve(mesh:Curve(i))
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msTest:Run(moho)
	-- self:Shapes(moho)
	self.origin = msCurvedTransform:Point(0,0,0)
	
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	-- self.origin:Print()
	-- self:Rotate(.56)
	-- self:Rotate(.55)
	-- self:Rotate(0.2)
	-- self:Rotate(0)
	-- self:Rotate(-.2)
	self:MoveAllCurves(moho)
end
