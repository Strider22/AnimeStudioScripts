ScriptName = "msCopyAnimation"
msCopyAnimation = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msCopyAnimation:Name()
	return "Copy Animation ..."
end

function msCopyAnimation:Version()
	return "1.1"
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

msCopyAnimation.srcLayer = nil
msCopyAnimation.frameOffset = 1
msCopyAnimation.randomize = false
msCopyAnimation.accumulateOffsets = true
msCopyAnimation.copyToGroups = false
msCopyAnimation.offsetStartFrame = 2
msCopyAnimation.skipToStart = true

msCopyAnimationDialog = {}

function msCopyAnimationDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Copy Animation", msCopyAnimationDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Select Base Animation Layer"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Offset Amount"),LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Offset Start frame"),LM.GUI.ALIGN_LEFT)
		    d.skipToStart = LM.GUI.CheckBox("Skip to Start Frame")
			l:AddChild(d.skipToStart,LM.GUI.ALIGN_LEFT)
		    d.randomize = LM.GUI.CheckBox("Randomize Offsets")
			l:AddChild(d.randomize,LM.GUI.ALIGN_LEFT)
		    d.copyToGroups = LM.GUI.CheckBox("Copy to/from groups")
			l:AddChild(d.copyToGroups,LM.GUI.ALIGN_LEFT)
		    d.accumulateOffsets = LM.GUI.CheckBox("Accumulate Offsets")
			l:AddChild(d.accumulateOffsets,LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Select Layer")
			d.frameOffset = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.frameOffset)
			d.offsetStartFrame = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.offsetStartFrame)
		l:Pop()
	l:Pop()
	return d
end

function msCopyAnimationDialog:OnValidate()
	if (not self:Validate(self.frameOffset, 0, 1000)) then
		return false
	end
	return true
end

function msCopyAnimationDialog:UpdateWidgets()
	self.frameOffset:SetValue(msCopyAnimation.frameOffset)
	self.skipToStart:SetValue(msCopyAnimation.skipToStart)
	self.randomize:SetValue(msCopyAnimation.randomize)
	self.accumulateOffsets:SetValue(msCopyAnimation.accumulateOffsets)
	self.copyToGroups:SetValue(msCopyAnimation.copyToGroups)
	self.offsetStartFrame:SetValue(self.moho.frame)
end


function msCopyAnimationDialog:OnOK()
	msCopyAnimation.srcLayerName = self.menu:FirstCheckedLabel()
	msCopyAnimation.frameOffset = self.frameOffset:FloatValue()
	msCopyAnimation.skipToStart = self.skipToStart:Value()
	msCopyAnimation.randomize = self.randomize:Value()
	msCopyAnimation.accumulateOffsets = self.accumulateOffsets:Value()
	msCopyAnimation.copyToGroups = self.copyToGroups:Value()
	msCopyAnimation.offsetStartFrame = self.offsetStartFrame:FloatValue()
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
		
		local keyOffset = frameOffset
		if frame < self.offsetStartFrame then 
			if self.skipToStart then goto continue end
			keyOffset = 0
		end
		destChannel:SetValue(frame + keyOffset, srcChannel:GetValue(frame))
		srcChannel:GetKeyInterp(frame,interpSetting)
		destChannel:SetKeyInterp(frame+keyOffset,interpSetting)	
		::continue::
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
	destLayer:ClearAnimation(false,self.offsetStartFrame-1,false)
	if self.accumulateOffsets then
		self.totalFrameOffset = self.totalFrameOffset + self.frameOffset
	end
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
	if layer:Name() == self.srcLayerName then
		if self.srcLayer ~= nil then
			print("There are multiple layers with the same name as the base animation layer.")
			print("It could cause a problem. Taking the first layer encountered as base animation layer.")
		else
			self.srcLayer = layer
			return
		end
	end
	if self.copyToGroups and layer:IsGroupType() then
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
	moho.document:SetDirty()
	moho:SetCurFrame(0)
	self.srcLayer = nil
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
