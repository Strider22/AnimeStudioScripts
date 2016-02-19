ScriptName = "msRotateFace"
msRotateFace = {}
function msRotateFace:Description()
	return "Rotate points as if they were on a face. Transform to a cylinder, rotate, transform back."
end


-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msRotateFace:Name()
	return "RotateFace"
end

function msRotateFace:Version()
	return "1.0"
end

function msRotateFace:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msRotateFace:UILabel()
	return("RotateFace ...")
end

-- function msRotateFace:RotateSelectePoints(moho, degres)
	-- local vectorLayer = moho:LayerAsVector(moho.layer)
	-- local mesh = vectorLayer:Mesh()
    -- local selList = MOHO.SelectedPointList(mesh)
	-- local v = LM.Vector2:new_local()
	-- local m = LM.Matrix:new_local()
	-- moho.layer:GetLayerTransform(0,m,moho.document)

	-- for i, pt in ipairs(selList) do
		-- v:Set(pt.fPos)
		-- m:Transform(v)
		-- pt.fAnimPos:SetValue(0, v)
	-- end
-- end


-- point:Print()

-- local halfWidth = 1
-- local origin = curvedTransform:Point(0,0,0)
-- origin:Print()

-- curvedTransform:rotatePointX(point, origin, 90)

-- point:Print()



-- **************************************************
-- The guts of this script
-- **************************************************
function msRotateFace:Run(moho)
	-- self:RotateSelectePoints(moho, 45)
	-- local point = msCurvedTransform:Point(0,1,0)
end
