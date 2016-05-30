ScriptName = "msPrintLayerNames"
msPrintLayerNames = {}

function msPrintLayerNames:Description()
	return "Prints the names of all layers"
end
function msPrintLayerNames:UILabel()
	return(ScriptName)
end

function msPrintLayerNames:Name()
	return ScriptName
end

function msPrintLayerNames:Version()
	return "1.0"
end

function msPrintLayerNames:Creator()
	return "Mitchel Soltys"
end

function msPrintLayerNames:PrintLayer(layer)
	print("layer ",layer:Name())

	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:PrintLayer(sublayer)
		end
	end
end

function msPrintLayerNames:PrintAllLayers()
	for i=0,self.moho.document:CountLayers()-1,1 do
		local layer = self.moho.document:LayerByAbsoluteID(i)
		self:PrintLayer(layer)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msPrintLayerNames:Run(moho)
	self.moho = moho
	self:PrintAllLayers()
end