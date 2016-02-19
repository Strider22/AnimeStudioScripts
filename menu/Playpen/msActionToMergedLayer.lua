-- This is helpful when you have a set of layers that you want to combine into a single 
-- switch layer.

ScriptName = "msActionToMergedLayer"
msActionToMergedLayer = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msActionToMergedLayer:Name()
	return "ActionToMergedLayer ... "
end

function msActionToMergedLayer:Version()
	return "1.0"
end

function msActionToMergedLayer:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Combines curves on all sub layers to a single layer.")
end

function msActionToMergedLayer:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msActionToMergedLayer:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ActionToMergedLayer/ActionToMergedLayer=ActionToMergedLayer ... "))
end

function msActionToMergedLayer:IsEnabled(moho)
	if moho.layer:IsGroupType() then
		return true
	end
	return false
end

function msActionToMergedLayer:ActionToMergedLayer(moho, actionLayer, newMesh, frame)
	local currentLayer = moho.layer
	local newMeshPoints = newMesh:CountPoints()
	local newMeshCurves = newMesh:CountCurves()
	moho:SetSelLayer(currentLayer)

	local oldMesh = moho:LayerAsVector(moho.layer):Mesh()
	if (oldMesh == nil) then
		return
	end
	newMesh:SelectNone()
	
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
				newMesh:Point(newMeshPoints + j):SetCurvature(curvature, 0)
			end
		end
		newMesh:AppendPoint(curve:Point(0).fPos, 0)
		-- Deal with closed or not closed objects
		newMesh:WeldPoints(newMeshPoints, newMesh:CountPoints()-1, 0)

		newMesh:SelectConnected()
		moho:SetSelLayer(actionLayer)
		local shapeId = moho:CreateShape(true)
		local shape = newMesh:ShapeByID(shapeId)
		shape = oldMesh:ShapeByID(0)
		newMesh:ShapeByID(shapeId):CopyStyleProperties(oldMesh:ShapeByID(0))
		-- Segments are not quite matching correctly, but out of time
		for j = 0, curve:CountSegments()-1 do
			if not curve:IsSegmentOn(j) then 
				newMesh:Curve(newMeshCurves + i):SetSegmentOn(j,false)
			end
		end
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msActionToMergedLayer:Run(moho)
	local frame =  moho.layer:CurFrame()
	local group = moho:LayerAsGroup(moho.layer)
	local actionLayerName = moho.layer:Name() .. frame
	local actionLayer = moho:CreateNewLayer(MOHO.LT_VECTOR)
	actionLayer:SetName(MOHO.Localize("/Scripts/Menu/ActionToMergedLayer/LayerName=" .. actionLayerName))
	local newMesh = moho:LayerAsVector(actionLayer):Mesh()
	for i = 0, group:CountLayers()-1 do
		moho:SetSelLayer(group:Layer(i))
		self:ActionToMergedLayer(moho,actionLayer, newMesh, frame)
	end

	-- Close all actions
	moho.document:SetCurrentDocAction(nil)
	moho:SetSelLayer(group)

	-- moho.document:PrepUndo(moho.layer)
	-- moho.document:SetDirty()
end
