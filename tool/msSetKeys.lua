ScriptName = "msSetKeys"
msSetKeys = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msSetKeys:Name()
	return "SetKeys ..."
end

function msSetKeys:Version()
	return "1.0"
end

function msSetKeys:Description()
	return "Sets the keys of current animation for all layers to a specified type"
end

function msSetKeys:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msSetKeys:UILabel()
	return "SetKeys ..."
end

msSetKeys.srcLayer = nil
msSetKeys.interp = MOHO.INTERP_STEP
msSetKeys.frameOffset = 1
msSetKeys.randomize = false
msSetKeys.accumulateOffsets = true
msSetKeys.copyToGroups = false
msSetKeys.offsetStartFrame = 2
msSetKeys.skipToStart = true

msSetKeysDialog = {}

function msSetKeysDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Copy Animation", msSetKeysDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Select Interpretation "),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Select Interp")
		l:Pop()
	l:Pop()
	return d
end

function msSetKeysDialog:OnValidate()
	return true
end

function msSetKeysDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE + msSetKeys.interp, true)
end


function msSetKeysDialog:OnOK()
	msSetKeys.interp = self.menu:FirstChecked()
end


function msSetKeysDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("Linear interpolation", 0, MOHO.MSG_BASE + MOHO.INTERP_LINEAR)
	menu:AddItem("Smooth interpolation", 0, MOHO.MSG_BASE + MOHO.INTERP_SMOOTH)
	menu:AddItem("Ease in/out interpolation", 0, MOHO.MSG_BASE + MOHO.INTERP_EASE)
	menu:AddItem("Step interpolation", 0, MOHO.MSG_BASE + MOHO.INTERP_STEP)
	menu:AddItem("Noisy interpolation", 0, MOHO.MSG_BASE + MOHO.INTERP_NOISY)
	menu:AddItem("Cycle interpolation", 0, MOHO.MSG_BASE + MOHO.INTERP_CYCLE)
	menu:AddItem("Reference an action", 0, MOHO.MSG_BASE + MOHO.INTERP_POSE)

	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end



function msSetKeys:CopyChannel(srcChannel, destChannel, frameOffset)
	if srcChannel:CountKeys() < 2 then
		return
	end
	local interpSetting = MOHO.InterpSetting:new_local()
	-- Set the initial frame to be 0
	-- destChannel:SetValue(frameOffset, destChannel:GetValue(0))
end


function msSetKeys:IsEnabled(moho)
	return true
end

function msSetKeys:SetCurveKeys(curve)
	for i = 1, curve:CountPoints(), 1 do
		local pt = curve:Point(i)
		local curvature = curve:Curvature(i)
		-- SET CURVATURE KEYS
		for j = 1, curvature:CountKeys()-1 do
			curvature:SetKeyInterpByID(j, self.interp, 0, 0)
		end
		-- SET POSITION KEYS
		for j = 1, pt.fAnimPos:CountKeys()-1 do
			pt.fAnimPos:SetKeyInterpByID(j, self.interp, 0, 0)
		end
		-- SET WIDTH KEYS
		for j = 1, pt.fWidth:CountKeys()-1 do
			pt.fWidth:SetKeyInterpByID(j, self.interp, 0, 0)
		end
	end
end

function msSetKeys:SetKeys(layer)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountCurves()-1 do
		self:SetCurveKeys(mesh:Curve(i))
	end
end

function msSetKeys:SetKeysForLayer(layer)
	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:SetKeysForLayer(sublayer)
		end
	else
		self:SetKeys(layer)
	end
	
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msSetKeys:Run(moho)
	local layer = moho.layer
	self.moho = moho
	local dlog = msSetKeysDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end
	moho.document:SetDirty()
	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:SetKeysForLayer(layer)
	end
end
