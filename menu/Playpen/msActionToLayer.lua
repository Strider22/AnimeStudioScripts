-- playpen for trying things out
ScriptName = "msActionToLayer"
msActionToLayer = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msActionToLayer:Name()
	return "ActionToLayer ... "
end

function msActionToLayer:Version()
	return "1.0"
end

function msActionToLayer:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Converts an action to a layer.")
end

function msActionToLayer:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msActionToLayer:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ActionToLayer/ActionToLayer=ActionToLayer ... "))
end

function msActionToLayer:IsEnabled(moho)
	if moho.layer:LayerType() ~= MOHO.LT_VECTOR  then
		return false
	end
	return true
end

function msActionToLayer:ActionToLayer(moho)
	local currentLayer = moho.layer
	local frame = currentLayer:CurFrame()
	local actionLayerName = currentLayer:Name() .. frame
	local actionLayer = moho:CreateNewLayer(MOHO.LT_VECTOR)
	actionLayer:SetName(MOHO.Localize("/Scripts/Menu/ActionToLayer/LayerName=" .. actionLayerName))
	moho:SetSelLayer(currentLayer)

	local oldMesh = moho:LayerAsVector(moho.layer):Mesh()
	local newMesh = moho:LayerAsVector(actionLayer):Mesh()
	-- mesh:SelectNone()
	for i = 0, oldMesh:CountCurves()-1 do
		local curve = oldMesh:Curve(i)
		for j = 0, curve:CountPoints()-1 do
			local position = curve:Point(j).fPos
			local curvature = curve:GetCurvature(j,frame)
			-- print("curvature " .. curvature)
			if (j == 0) then
				local firstPosition = position
				-- this was an attempt but it increases the count too much
				-- newMesh:AddPoint(position, -1, 0)
				newMesh:AddLonePoint(position, 0)
			else
				newMesh:AppendPoint(position, 0)
				newMesh:Point(j):SetCurvature(curvature, 0)
			end
		end
		newMesh:AppendPoint(curve:Point(0).fPos, 0)
		-- Deal with closed or not closed objects
		newMesh:WeldPoints(0, newMesh:CountPoints()-1, 0)

		newMesh:SelectConnected()
		moho:SetSelLayer(actionLayer)
		local shapeId = moho:CreateShape(true)
		local shape = newMesh:ShapeByID(shapeId)
		shape = oldMesh:ShapeByID(0)
		newMesh:ShapeByID(shapeId):CopyStyleProperties(oldMesh:ShapeByID(0))
		-- Segments are not quite matching correctly, but out of time
		for j = 0, curve:CountSegments()-1 do
			if not curve:IsSegmentOn(j) then 
				newMesh:Curve(i):SetSegmentOn(j,false)
			end
		end
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msActionToLayer:Run(moho)

	local mesh = moho:Mesh()
	if (mesh == nil) then
		return
	end
	
	-- moho.document:PrepUndo(moho.layer)
	-- moho.document:SetDirty()
	self:ActionToLayer(moho)
end
