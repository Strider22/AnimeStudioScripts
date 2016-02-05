-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msSmartAnimation"

-- **************************************************
-- General information about this script
-- **************************************************

msSmartAnimation = {}

function msSmartAnimation:Name()
	return "Visibility Ticket"
end

function msSmartAnimation:Version()
	return "1.0"
end

function msSmartAnimation:Description()
	return MOHO.Localize("/Scripts/Tool/SmartAnimation/Description=Go to frame 1 turn visibility off then return and turn visibility on")
end

function msSmartAnimation:Creator()
	return "Mitchel Soltys, 2016"
end

function msSmartAnimation:UILabel()
	return(MOHO.Localize("/Scripts/Tool/SmartAnimation=Visibility Ticket"))
end

function msSmartAnimation:SetVisibility(layer)
	-- if layer:IsGroupType() then
		-- local group = self.moho:LayerAsGroup(layer)
		-- for i = 0, group:CountLayers()-1 do
			-- local sublayer = group:Layer(i)
			-- self:SetVisibility(sublayer)
		-- end
	-- else
		layer.fVisibility:SetValue(self.frame, true)
		layer.fVisibility:SetValue(1, false)
	-- end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msSmartAnimation:Run(moho)
	self.frame =  moho.frame
	self.moho = moho
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	if self.frame > 1 then
		for i = 0, moho.document:CountSelectedLayers()-1 do
			local layer = moho.document:GetSelectedLayer(i)
			self:SetVisibility(layer)
		end
	else	
		print(MOHO.Localize("/Scripts/Tool/SmartAnimation/Message=The current frame is less than or equal to 1."))
	end
end