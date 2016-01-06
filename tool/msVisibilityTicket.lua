-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msVisibilityTicket"

-- **************************************************
-- General information about this script
-- **************************************************

msVisibilityTicket = {}

function msVisibilityTicket:Name()
	return "Visibility Ticket"
end

function msVisibilityTicket:Version()
	return "1.0"
end

function msVisibilityTicket:Description()
	return MOHO.Localize("/Scripts/Tool/VisibilityTicket/Description=Goto frame 1 turn visibility off then return and turn visibility on")
end

function msVisibilityTicket:Creator()
	return "Mitchel Soltys, 2016"
end

function msVisibilityTicket:UILabel()
	return(MOHO.Localize("/Scripts/Tool/VisibilityTicket=Visibility Ticket"))
end

function msVisibilityTicket:SetVisibility(layer)
	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:SetVisibility(sublayer)
		end
	else
		layer.fVisibility:SetValue(self.frame, true)
		layer.fVisibility:SetValue(1, false)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msVisibilityTicket:Run(moho)
	self.frame =  moho.frame
	self.moho = moho
	if self.frame > 1 then
		self:SetVisibility(moho.layer)
	else	
		print(MOHO.Localize("/Scripts/Tool/VisibilityTicket/Message=The current frame is less than or equal to 1."))
	end
end