--STATUS
-- works for
--   	single operation at a time
-- 		single depth of grouping
-- For example ike transforming had switch layers

ScriptName = "msGroupToLayerTransform"
msGroupToLayerTransform = {}

function msGroupToLayerTransform:UILabel()
	return "msGroupToLayerTransform ... "
end

function msGroupToLayerTransform:Description()
	return "Removes transform from group layer and applies it to sub layers. For example: Switch layers."
end

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msGroupToLayerTransform:Name()
	return "msGroupToLayerTransform ... "
end

function msGroupToLayerTransform:Version()
	return "1.0"
end

function msGroupToLayerTransform:Creator()
	return "Mitchel Soltys"
end




msGroupToLayerTransform.matrix = LM.Matrix:new_local()




function msGroupToLayerTransform:ResetOrigin(layer)
	local v = LM.Vector2:new_local()
	v:Set(0,0)
	layer:SetOrigin(v)
	if layer:IsGroupType() then
		local layerOrigin = layer:Origin()
		print(layer:Name(), "x ", layerOrigin.x, " y ", layerOrigin.y)
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:ResetOrigin(sublayer)
		end
	end
end


function msGroupToLayerTransform:TransformCurve(curve, translation, scale, rotX, rotY, rotZ)
	local v = LM.Vector2:new_local()
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		v:Set(pt.fPos)
		matrix:Transform(v)
		pt.fAnimPos:SetValue(0, v)
	end
end


function msGroupToLayerTransform:TransformAllCurves(vectorLayer, translation, scale, rotX, rotY, rotZ)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:TransformCurve(mesh:Curve(i), translation, scale, rotX, rotY, rotZ)
	end
end

function msGroupToLayerTransform:RemoveLayerTransformation(layer)
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

function msGroupToLayerTransform:TransformLayer(layer, translation, scale, rotX, rotY, rotZ, moho)
	translation = translation + layer.fTranslation:GetValue(0)
	scale.x = scale.x * layer.fScale:GetValue(0).x
	scale.y = scale.y * layer.fScale:GetValue(0).y
	scale.z = scale.y * layer.fScale:GetValue(0).z
	rotX = rotX + layer.fRotationX:GetValue(0)
	rotY = rotY + layer.fRotationY:GetValue(0)
	rotZ = rotZ + layer.fRotationZ:GetValue(0)
-- print("translation " .. translation.x .. ", " .. translation.y .. ", " .. translation.z)
-- print("scale " .. scale.x .. ", " .. scale.y .. ", " .. scale.z)
-- print("rotation " .. rotX .. ", " .. rotY .. ", " .. rotZ)

	-- if layer:LayerType() == MOHO.LT_VECTOR then
		-- self:TransformAllCurves(moho:LayerAsVector(layer), translation, scale, rotX, rotY, rotZ)
		-- self:RemoveLayerTransformation(layer)
	-- else
	if layer:IsGroupType() then
		local group = moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:TransformLayer(layer, translation, scale, rotX, rotY, rotZ, moho)
		end
		self:RemoveLayerTransformation(layer)
	else
		layer.fTranslation:SetValue(0, translation)
		layer.fScale:SetValue(0, scale)
		layer.fRotationX:SetValue(0, rotX)
		layer.fRotationY:SetValue(0, rotY)
		layer.fRotationZ:SetValue(0, rotZ)
	end
end

function msGroupToLayerTransform:SelectLayer(layer, moho)
print("slecting layer " .. layer:Name())
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
function msGroupToLayerTransform:Run(moho)
	self.moho = moho
	--	Reset the origin may not be needed. Just reset it manually
	--	however it's here in case
	--	self:ResetOrigin(moho.layer)

	local matrix = LM.Matrix:new_local()
	local translation = LM.Vector3:new_local()
	local scale = LM.Vector3:new_local()
	local rotX = 0
	local rotY = 0
	local rotZ = 0
    translation.x = 0
    translation.y = 0
    translation.z = 0
    scale.x = 1
    scale.y = 1
    scale.z = 1
	self:TransformLayer(moho.layer, translation, scale, rotX, rotY, rotZ, moho)

	-- This doesn't seem to help
	-- self:SelectLayer(moho.layer, moho)
end
