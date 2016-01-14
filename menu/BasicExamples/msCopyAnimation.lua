ScriptName = "msCopyAnimation"
msCopyAnimation = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msCopyAnimation:Name()
	return "Copy Animation ..."
end

function msCopyAnimation:Version()
	return "1.0"
end

function msCopyAnimation:Description()
	return "Copies animation from one layer to all other selected layers. Make sure layer position, scale and rotation are initially 0."
end

function msCopyAnimation:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msCopyAnimation:UILabel()
	return "Copy Animation ..."
end

msCopyAnimation.srcLayer = ""
msCopyAnimation.frameOffset = 1
msCopyAnimation.randomize = false

msCopyAnimationDialog = {}

function msCopyAnimationDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Copy Animation", msCopyAnimationDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Select Base Animation Layer"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Frame Offset"),LM.GUI.ALIGN_LEFT)
		    d.randomize = LM.GUI.CheckBox("Randomize Offsets")
			l:AddChild(d.randomize)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Select Layer")
			d.frameOffset = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.frameOffset)
		l:Pop()
	l:Pop()
	return d
end

function msCopyAnimationDialog:OnValidate()
	if (not self:Validate(self.frameOffset, 1, 1000)) then
		return false
	end
	return true
end

function msCopyAnimationDialog:UpdateWidgets()
	self.frameOffset:SetValue(msCopyAnimation.frameOffset)
	self.randomize:SetValue(msCopyAnimation.randomize)
end

function msCopyAnimationDialog:OnOK()
	msCopyAnimation.srcLayer = self.moho.document:LayerByName(self.menu:FirstCheckedLabel())
	msCopyAnimation.frameOffset = self.frameOffset:FloatValue()
	msCopyAnimation.randomize = self.randomize:Value()
end


function msCopyAnimationDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		menu:AddItem(layer:Name(), 0, MOHO.MSG_BASE + i)
	end

	menu:SetChecked(MOHO.MSG_BASE, true)
	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end

function msCopyAnimation:CopyChannel(srcChannel, destChannel, frameOffset)
	if srcChannel:CountKeys() < 2 then
		return
	end
	local interpSetting = MOHO.InterpSetting:new_local()
	for i = 0, srcChannel:CountKeys()-1 do
		local frame = srcChannel:GetKeyWhen(i)
		destChannel:SetValue(frame + frameOffset, srcChannel:GetValue(frame))
		srcChannel:GetKeyInterp(frame,interpSetting)
		destChannel:SetKeyInterp(frame+frameOffset,interpSetting)
	end
	-- Set the initial frame to be 0
	-- destChannel:SetValue(frameOffset, destChannel:GetValue(0))
	
end
math.randomseed( os.time() )

function msCopyAnimation:ShuffleTable( t )
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function msCopyAnimation:CopyAnimation(destLayer)
	local srcLayer = self.srcLayer
	local frameOffset = self.totalFrameOffset
	self.totalFrameOffset = self.totalFrameOffset + self.frameOffset
	self:CopyChannel(srcLayer.fTranslation, destLayer.fTranslation, frameOffset)
	self:CopyChannel(srcLayer.fScale, destLayer.fScale, frameOffset)
	self:CopyChannel(srcLayer.fRotationZ, destLayer.fRotationZ, frameOffset)
	self:CopyChannel(srcLayer.fVisibility, destLayer.fVisibility, frameOffset)
	self:CopyChannel(srcLayer.fAlpha, destLayer.fAlpha, frameOffset)
end

function msCopyAnimation:IsEnabled(moho)
	if moho.document:CountSelectedLayers() < 2 then
		return false
	end
	return true
end

function msCopyAnimation:AddLayerToList(layer)
	if layer == self.srcLayer then
		return
	end
	if layer:IsGroupType() then
		local group = self.moho:LayerAsGroup(layer)
		for i = 0, group:CountLayers()-1 do
			local sublayer = group:Layer(i)
			self:AddLayerToList(sublayer)
		end
	else
		table.insert(self.layerList, layer)
	end
	
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msCopyAnimation:Run(moho)
	local layer = moho.layer
	self.moho = moho
	local dlog = msCopyAnimationDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end
	
	moho:SetCurFrame(0)
	
	self.layerList = {}
	self.totalFrameOffset = self.frameOffset
	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:AddLayerToList(layer)
	end
	if self.randomize then
		self:ShuffleTable(self.layerList)
	end
	for k, v in ipairs(self.layerList ) do
		self:CopyAnimation(v)
	end
end
