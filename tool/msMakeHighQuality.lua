ScriptName = "msMakeHighQuality"
msMakeHighQuality = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMakeHighQuality:Name()
	return "Make High Quality ..."
end

function msMakeHighQuality:Version()
	return "1.0"
end

function msMakeHighQuality:Description()
	return "Sets the rendering quality level to higher for all images."
end

function msMakeHighQuality:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMakeHighQuality:UILabel()
	return "Make High Quality ..."
end


function msMakeHighQuality:MakeHighQualityIncludingGroups(layer)
	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:MakeHighQualityIncludingGroups(sublayer)
		end
	else
		if layer:LayerType() == MOHO.LT_IMAGE then 
			self.moho:LayerAsImage(layer):SetQualityLevel(2)
		else 
			print("Skipping layer " .. layer:Name() .. ", because it is not an image.")
		end
	end
	
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msMakeHighQuality:Run(moho)
	self.moho = moho
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:MakeHighQualityIncludingGroups(layer)
	end
end
