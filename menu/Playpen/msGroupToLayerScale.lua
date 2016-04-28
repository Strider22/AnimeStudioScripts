-- playpen for trying things out
ScriptName = "msGroupToLayerScale"
msGroupToLayerScale = {}
msGroupToLayerScale.matrix = LM.Matrix:new_local()

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msGroupToLayerScale:Name()
	return "GroupToLayerScale ... "
end

function msGroupToLayerScale:Version()
	return "1.0"
end

function msGroupToLayerScale:Description()
	return "Removes scale from group and applies it to sub layers."
end

function msGroupToLayerScale:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msGroupToLayerScale:UILabel()
	return "GroupToLayerScale ... "
end



function msGroupToLayerScale:TransformCurve(curve, matrix)
	local v = LM.Vector2:new_local()
	
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		v:Set(pt.fPos)
		matrix:Transform(v)
		pt.fAnimPos:SetValue(0, v)
	end
end


function msGroupToLayerScale:TransformAllCurves(vectorLayer, matrix)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:TransformCurve(mesh:Curve(i), matrix)
	end
end

function msGroupToLayerScale:RemoveLayerTransformation(layer)
	local vector = LM.Vector3:new_local()
    vector.x = 0
    vector.y = 0
    vector.z = 0
	layer.fTranslation:SetValue(0,vector)
    vector.x = 1
    vector.y = 1
    vector.z = 1
	layer.fScale:SetValue(0,vector)
	layer.fRotationX:SetValue(0,0)
	layer.fRotationY:SetValue(0,0)
	layer.fRotationZ:SetValue(0,0)
end

function msGroupToLayerScale:TransformLayer(layer, parentMatrix, moho)
	local vector = LM.Vector2:new_local()
    vector.x = 0
    vector.y = 0
	layer:SetOriginWithTransformCorrection(vector)
	local matrix = LM.Matrix:new_local()
	matrix:Set(parentMatrix)
	local currentMatrix = LM.Matrix:new_local()
	layer:GetLayerTransform(0,currentMatrix,moho.document)
	matrix:Multiply(currentMatrix)
	if layer:LayerType() == MOHO.LT_VECTOR then
		self:TransformAllCurves(moho:LayerAsVector(layer), matrix)
	elseif layer:IsGroupType() then
		local group = moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:TransformLayer(layer, matrix, moho)
		end
	else
		print(layer:Name() .. " is neither a group layer nor a vector layer. It is not yet supported")		
	end
	self:RemoveLayerTransformation(layer)
end

function msGroupToLayerScale:SelectLayer(layer, moho)
	moho:SetSelLayer(layer)
	if layer:IsGroupType() then
		local group = moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:SelectLayer(layer, moho)
		end
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msGroupToLayerScale:Run(moho)
	local matrix = LM.Matrix:new_local()
	matrix:Identity()
	self:TransformLayer(moho.layer, matrix, moho)
	-- This doesn't seem to help
	-- self:SelectLayer(moho.layer, moho)
end
