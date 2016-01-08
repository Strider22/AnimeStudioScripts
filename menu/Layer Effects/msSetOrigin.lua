ScriptName = "msSetOrigin"
msSetOrigin = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msSetOrigin:Name()
	return "SetOrigin ... "
end

function msSetOrigin:Version()
	return "1.0"
end

function msSetOrigin:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Set the layer origin based on points.")
end

function msSetOrigin:Creator()
	return "Mitchel Soltys"
end

function msSetOrigin:UILabel()
	return(MOHO.Localize("/Scripts/Menu/SetOrigin/SetOrigin=Set Origin ... "))
end

msSetOrigin.AnimUL = false
msSetOrigin.AnimUC = false
msSetOrigin.AnimUR = false
msSetOrigin.AnimCL = false
msSetOrigin.AnimCC = false
msSetOrigin.AnimCR = false
msSetOrigin.AnimLL = false
msSetOrigin.AnimLC = false
msSetOrigin.AnimLR = false

msSetOriginDialog = {}

function msSetOriginDialog:new(moho)
print("in dialog")
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/SetOrigin/SetOrigin=Set Origin"), msSetOrigin)
	local l = d:GetLayout()
	d.moho = moho
	l:PushV(LM.GUI.ALIGN_LEFT)
			d.AnimUL = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positionul=Upper Left"), 50)
			l:AddChild(d.AnimUL, LM.GUI.ALIGN_LEFT)
			d.AnimUC = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positionuc=Upper Center"), 50)
			l:AddChild(d.AnimUC, LM.GUI.ALIGN_LEFT)
			d.AnimUR = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positionur=Upper Right"), 50)
			l:AddChild(d.AnimUR, LM.GUI.ALIGN_LEFT)
			d.AnimCL = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positioncl=Center Left"), 50)
			l:AddChild(d.AnimCL, LM.GUI.ALIGN_LEFT)
			d.AnimCC = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positioncc=Center Center"), 50)
			l:AddChild(d.AnimCC, LM.GUI.ALIGN_LEFT)
			d.AnimCR = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positioncr=Center Right"), 50)
			l:AddChild(d.AnimCR, LM.GUI.ALIGN_LEFT)
			d.AnimLL = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positionll=Lower Left"), 50)
			l:AddChild(d.AnimLL, LM.GUI.ALIGN_LEFT)
			d.AnimLC = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positionlc=Lower Center"), 50)
			l:AddChild(d.AnimLC, LM.GUI.ALIGN_LEFT)
			d.AnimLR = LM.GUI.RadioButton(MOHO.Localize("/Scripts/Menu/SetOrigin/Positionlr=Lower Right"), 50)
			l:AddChild(d.AnimLR, LM.GUI.ALIGN_LEFT)
		l:Pop()
	l:Pop()
	return d
end

function msSetOriginDialog:UpdateWidgets()
print("in update widgets")
	self.AnimUL:SetValue(msSetOrigin.AnimUL)
	self.AnimUL:SetValue(msSetOrigin.AnimUL)
	self.AnimUC:SetValue(msSetOrigin.AnimUC)
	self.AnimUR:SetValue(msSetOrigin.AnimUR)
	self.AnimCL:SetValue(msSetOrigin.AnimCL)
	self.AnimCC:SetValue(msSetOrigin.AnimCC)
	self.AnimCR:SetValue(msSetOrigin.AnimCR)
	self.AnimLL:SetValue(msSetOrigin.AnimLL)
	self.AnimLC:SetValue(msSetOrigin.AnimLC)
	self.AnimLR:SetValue(msSetOrigin.AnimLR)
end

function msSetOriginDialog:OnOK()
print("in on ok")
	msSetOrigin.AnimUL = self.AnimUL:Value()
	msSetOrigin.AnimUC = self.AnimUC:Value()
	msSetOrigin.AnimUR = self.AnimUR:Value()
	msSetOrigin.AnimCL = self.AnimCL:Value()
	msSetOrigin.AnimCC = self.AnimCC:Value()
	msSetOrigin.AnimCR = self.AnimCR:Value()
	msSetOrigin.AnimLL = self.AnimLL:Value()
	msSetOrigin.AnimLC = self.AnimLC:Value()
	msSetOrigin.AnimLR = self.AnimLR:Value()
	print("msSetOrigin.AnimUL " .. msSetOrigin.AnimUL)
end
function msSetOriginDialog:OnValidate()
end

-- function msSetOrigin:IsEnabled(moho)
	-- if moho.layer:LayerType() ~= MOHO.LT_VECTOR then
		-- return
	-- end
-- end

function msSetOrigin:SetOrigin(layer)
print("in set origin")
	if layer:LayerType() ~= MOHO.LT_VECTOR then
	print("layer type != vector")
		return
	end
	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	local v = LM.Vector2:new_local()
	local min = LM.Vector2:new_local()
	local max = LM.Vector2:new_local()
	mesh:SelectAll()
	local center = mesh:SelectedCenter()
	mesh:SelectedBounds(min,max)
	print("msSetOrigin.AnimUL " .. msSetOrigin.AnimUL)
	print("self.AnimUL " .. self.AnimUL)

	if self.AnimUL then
		v:Set(min.x,max.y)
	elseif self.AnimUC then
		v:Set(center.x,max.y)
	elseif self.AnimUR then
		v:Set(max.x,max.y)
	elseif self.AnimCL then
		v:Set(min.x,center.y)
	elseif self.AnimCC then
		v:Set(center.x,center.y)
	elseif self.AnimCR then
		v:Set(max.x,center.y)
	elseif self.AnimLL then
		v:Set(min.x,min.y)
	elseif self.AnimLC then
		v:Set(center.x,min.y)
	elseif self.AnimLR then
		v:Set(max.x,min.y)
	else 
	print("unknonw value")
		return
	end
	print("setting origin")
	layer:SetOrigin(v)
end

function msSetOrigin:SetOriginIncludingGroups(layer)
	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:SetOrigin(sublayer)
		end
	else
		self:SetOrigin(layer)
	end
	
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msSetOrigin:Run(moho)
	self.moho = moho
	local dlog = msSetOriginDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:SetOriginIncludingGroups(layer)
	end
	
end
