-- STATUS
-- Currently Not working
-- Takes transformation information from the layer and applies it to sublayers
-- or points, if it's a vector layer.
-- This uses a general transformation matrix, but it doesn't seem to work as you might
-- expect. In particular the layer scale, rotate and translate operations are not
-- kept in a matrix. The matrix is probably intended primarily for 3d objects. Thus
-- it doesn't seem to consider layers as simply 2d variants of a 3d entities.
--
-- The code works for
-- single operations including
--      rotate, scale, translate, flip
-- combined operations
--      rotate, scale, translate, move origin any order, single vector layer


-- DOESN'T WORK FOR
-- Tranformations from the group layer.


ScriptName = "msGroupToLayerTransformNotWorking"
msGroupToLayerTransformNotWorking = {}
msGroupToLayerTransformNotWorking.matrix = LM.Matrix:new_local()

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msGroupToLayerTransformNotWorking:Name()
	return "msGroupToLayerTransformNotWorking ... "
end

function msGroupToLayerTransformNotWorking:Version()
	return "1.0"
end

function msGroupToLayerTransformNotWorking:Description()
	return "Removes scale from group and applies it to sub layers."
end

function msGroupToLayerTransformNotWorking:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msGroupToLayerTransformNotWorking:UILabel()
	return "GroupToLayerTransform ... "
end



function msGroupToLayerTransformNotWorking:TransformCurve(curve, matrix)
	local v = LM.Vector2:new_local()
	
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		v:Set(pt.fPos)
		matrix:Transform(v)
		pt.fAnimPos:SetValue(0, v)
	end
end


function msGroupToLayerTransformNotWorking:TransformAllCurves(vectorLayer, matrix)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:TransformCurve(mesh:Curve(i), matrix)
	end
end

function msGroupToLayerTransformNotWorking:RemoveLayerTransformation(layer)
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

function msGroupToLayerTransformNotWorking:TransformLayer(layer, parentMatrix, moho)
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

function msGroupToLayerTransformNotWorking:SelectLayer(layer, moho)
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
function msGroupToLayerTransformNotWorking:Run(moho)
	local matrix = LM.Matrix:new_local()
	matrix:Identity()
	self:TransformLayer(moho.layer, matrix, moho)
	-- This doesn't seem to help
	-- self:SelectLayer(moho.layer, moho)
end
