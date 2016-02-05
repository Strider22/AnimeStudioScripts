ScriptName = "msSmartAnimation"
msSmartAnimation = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msSmartAnimation:Name()
	return "Smart Animation ..."
end

function msSmartAnimation:Version()
	return "1.1"
end

function msSmartAnimation:Description()
	return "Copies animation from one layer to all other selected layers. Make sure layer position, scale and rotation are initially 0."
end

function msSmartAnimation:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msSmartAnimation:UILabel()
	return "Smart Animation ..."
end

msSmartAnimation.srcLayer = nil
msSmartAnimation.frameOffset = 1
msSmartAnimation.randomize = false
msSmartAnimation.accumulateOffsets = true
msSmartAnimation.SmartToGroups = false
msSmartAnimation.offsetStartFrame = 2
msSmartAnimation.skipToStart = true

msSmartAnimationDialog = {}

function msSmartAnimationDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Smart Animation", msSmartAnimationDialog)
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
		    d.SmartToGroups = LM.GUI.CheckBox("Smart to/from groups")
			l:AddChild(d.SmartToGroups,LM.GUI.ALIGN_LEFT)
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

function msSmartAnimationDialog:OnValidate()
	if (not self:Validate(self.frameOffset, 0, 1000)) then
		return false
	end
	return true
end

function msSmartAnimationDialog:UpdateWidgets()
	self.frameOffset:SetValue(msSmartAnimation.frameOffset)
	self.skipToStart:SetValue(msSmartAnimation.skipToStart)
	self.randomize:SetValue(msSmartAnimation.randomize)
	self.accumulateOffsets:SetValue(msSmartAnimation.accumulateOffsets)
	self.SmartToGroups:SetValue(msSmartAnimation.SmartToGroups)
	self.offsetStartFrame:SetValue(self.moho.frame)
end


function msSmartAnimationDialog:OnOK()
	msSmartAnimation.srcLayerName = self.menu:FirstCheckedLabel()
	msSmartAnimation.frameOffset = self.frameOffset:FloatValue()
	msSmartAnimation.skipToStart = self.skipToStart:Value()
	msSmartAnimation.randomize = self.randomize:Value()
	msSmartAnimation.accumulateOffsets = self.accumulateOffsets:Value()
	msSmartAnimation.SmartToGroups = self.SmartToGroups:Value()
	msSmartAnimation.offsetStartFrame = self.offsetStartFrame:FloatValue()
end


function msSmartAnimationDialog:CreateDropDownMenu(moho, layout, title)
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

function msSmartAnimation:SmartChannel(srcChannel, destChannel, frameOffset)
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

function msSmartAnimation:ShuffleTable( t )
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function msSmartAnimation:SmartAnimation(destLayer)
	local srcLayer = self.srcLayer
	local frameOffset = self.totalFrameOffset
	destLayer:ClearAnimation(false,self.offsetStartFrame-1,false)
	if self.accumulateOffsets then
		self.totalFrameOffset = self.totalFrameOffset + self.frameOffset
	end
	self:SmartChannel(srcLayer.fTranslation, destLayer.fTranslation, frameOffset)
	self:SmartChannel(srcLayer.fScale, destLayer.fScale, frameOffset)
	self:SmartChannel(srcLayer.fRotationZ, destLayer.fRotationZ, frameOffset)
	self:SmartChannel(srcLayer.fVisibility, destLayer.fVisibility, frameOffset)
	self:SmartChannel(srcLayer.fAlpha, destLayer.fAlpha, frameOffset)
end

function msSmartAnimation:IsEnabled(moho)
	if moho.document:CountSelectedLayers() < 2 then
		return false
	end
	return true
end

function msSmartAnimation:AddLayerToList(layer)
	if layer:Name() == self.srcLayerName then
		if self.srcLayer ~= nil then
			print("There are multiple layers with the same name as the base animation layer.")
			print("It could cause a problem. Taking the first layer encountered as base animation layer.")
		else
			self.srcLayer = layer
			return
		end
	end
	if self.SmartToGroups and layer:IsGroupType() then
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
function msSmartAnimation:Run(moho)
	local layer = moho.layer
	self.moho = moho
	local dlog = msSmartAnimationDialog:new(moho)
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
		self:SmartAnimation(v)
	end
end
