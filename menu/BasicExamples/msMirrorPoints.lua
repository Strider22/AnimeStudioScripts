-- This allows copying mirroring actions. It's similar to flip points, but does not swap the points, 
-- so it's more like a rubber band being stretched around a flipped outline. This is great for creating
-- actions for one turn and then simply mirroring those points. 
ScriptName = "msMirrorPoints"
msMirrorPoints = {}
msMirrorPoints.currentFrame = 0

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMirrorPoints:Name()
	return "MirrorPoints ... "
end

function msMirrorPoints:Version()
	return "1.0"
end

function msMirrorPoints:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Similar to flip, but points don't cross.")
end

function msMirrorPoints:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMirrorPoints:UILabel()
	return(MOHO.Localize("/Scripts/Menu/MirrorPoints/MirrorPoints=MirrorPoints ... "))
end



function msMirrorPoints:TransformCurve(curve, translation)
	local vector = LM.Vector2:new_local()
	vector:Set(translation.x,translation.y)
	-- print("vector x " .. vector.x .. " y " ..vector.y)
	
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		-- ignore z
		pt.fAnimPos:SetValue(self.currentFrame, pt.fPos + vector)
	end
end


function msMirrorPoints:TransformAllCurves(vectorLayer, translation)
	print("transform layer " .. vectorLayer:Name())
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:TransformCurve(mesh:Curve(i), translation)
	end
end

function msMirrorPoints:RemoveLayerTransformation(layer)
	local vector = LM.Vector3:new_local()
    vector.x = 0
    vector.y = 0
    vector.z = 0
	layer.fTranslation:SetValue(self.currentFrame,vector)
end

function msMirrorPoints:TransformLayer(layer, translation, moho)
	translation = translation + layer.fTranslation:GetValue(self.currentFrame)
-- print("translation " .. translation.x .. ", " .. translation.y .. ", " .. translation.z)

	if layer:LayerType() == MOHO.LT_VECTOR then
		self:TransformAllCurves(moho:LayerAsVector(layer), translation)
		self:RemoveLayerTransformation(layer)
	elseif layer:IsGroupType() then
		local group = moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:TransformLayer(layer, translation, moho)
		end
		self:RemoveLayerTransformation(layer)
	else
		layer.fTranslation:SetValue(self.currentFrame, translation)
	end
end

function msMirrorPoints:SelectLayer(layer, moho)
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
function msMirrorPoints:Run(moho)
	-- self.currentFrame = moho.layer:CurFrame()
	-- local translation = LM.Vector3:new_local()
    -- translation.x = 0
    -- translation.y = 0
    -- translation.z = 0
	-- self:TransformLayer(moho.layer, translation, moho)
	-- This doesn't seem to help
	-- self:SelectLayer(moho.layer, moho)
end
