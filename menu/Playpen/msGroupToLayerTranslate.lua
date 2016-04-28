-- playpen for trying things out
ScriptName = "msGroupToLayerTranslate"
msGroupToLayerTranslate = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msGroupToLayerTranslate:Name()
	return "GroupToLayerTranslate ... "
end

function msGroupToLayerTranslate:Version()
	return "1.0"
end

function msGroupToLayerTranslate:Description()
	return "Removes Translation from group and applies it to sub layers."
end

function msGroupToLayerTranslate:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msGroupToLayerTranslate:UILabel()
	return "GroupToLayerTranslate ... "
end


function msGroupToLayerTranslate:RemoveLayerTranslation(layer)
	local vector = LM.Vector3:new_local()
    vector.x = 0
    vector.y = 0
    vector.z = 0
	layer.fTranslation:SetValue(0,vector)
end


function msGroupToLayerTranslate:TranslateCurve(curve, translation)
	local vector = LM.Vector2:new_local()
	vector:Set(translation.x,translation.y)
	-- print("vector x " .. vector.x .. " y " ..vector.y)
	
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		pt.fAnimPos:SetValue(0, pt.fPos + vector)
	end
end


function msGroupToLayerTranslate:TranslateAllCurves(vectorLayer, translation)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:TranslateCurve(mesh:Curve(i), translation)
	end
end

function msGroupToLayerTranslate:TranslateLayer(layer, translation)
	translation = translation + layer.fTranslation:GetValue(0)
	-- print("translation " .. translation.x .. ", " .. translation.y .. ", " .. translation.z)

	if layer:LayerType() == MOHO.LT_VECTOR then
		self:TranslateAllCurves(self.moho:LayerAsVector(layer), translation)
		self:RemoveLayerTranslation(layer)
	elseif layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:TranslateLayer(layer, translation)
		end
		self:RemoveLayerTranslation(group)
	else
		layer.fTranslation:SetValue(0, translation)
	end
end

function msGroupToLayerTranslate:SelectLayer(layer)
	self.moho:SetSelLayer(layer)
	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:SelectLayer(layer, self.moho)
		end
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msGroupToLayerTranslate:Run(moho)
	self.moho = moho
	-- starting with 0 translation, because the 
	-- TranslateLayer combines the incoming translation
	-- with the layer translation to translate properly
	local translation = LM.Vector3:new_local()
    translation.x = 0
    translation.y = 0
    translation.z = 0
	self:TranslateLayer(self.moho.layer, translation)
	self.moho:UpdateUI()
	-- This doesn't seem to help
	-- self:SelectLayer(self.moho.layer)
end
