ScriptName = "msTransition"
msTransition = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msTransition:Name()
	return "Transition ... "
end

function msTransition:Version()
	return "1.0"
end

function msTransition:Description()
	return "Create a screen or object transition."
end

function msTransition:UILabel()
	return "Transition ... "
end

function msTransition:Creator()
	return "Mitchel Soltys"
end


-- **************************************************
-- Recurring values
-- **************************************************
msTransition.boneLayer = nil
msTransition.isObjectTransition = false


-- **************************************************
-- Checkbox dialog
-- **************************************************
local msTransitionCheckboxDialog  ={}

function msTransitionCheckboxDialog:new(moho,groupLayer)
	local self, l = msDialog:SimpleDialog("Checkbox", self)
	self.moho = moho

	self.checkList = {}
	
	local msg = 0
	for i = groupLayer:CountLayers()-1,0,-1 do
		local layer = groupLayer:Layer(i)
	    self.checkList[layer:Name()] = msDialog:AddCheckBox(layer:Name())
	end

	return self
end

function msTransitionCheckboxDialog:UpdateWidgets()
end


function msTransitionCheckboxDialog:OnOK()
	msTransition.checkList = self.checkList
end


local msTransitionDialog = {}


-- **************************************************
-- Transition dialog
-- **************************************************
function msTransitionDialog:new(moho)
	local self, l = msDialog:SimpleDialog("Test", self)

	self.moho = moho
	self.boneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Select Transition", nil, "Transitions Database")
    self.isObjectTransition = msDialog:AddCheckBox("Object Transition")
	return self
end




function msTransitionDialog:UpdateWidgets()
	msDialog:SetMenuByLabel(self.boneMenu,msTransition.boneLayer)
	self.isObjectTransition:SetValue(msTransition.isObjectTransition)
end


function msTransitionDialog:OnOK()
	msTransition.boneLayer = self.boneMenu:FirstCheckedLabel()
	msTransition.isObjectTransition = self.isObjectTransition:Value()
end


-- **************************************************
-- The guts of this script
-- **************************************************


function msTransition:SetVisibility(layer, frame)
	layer.fVisibility:SetValue(frame, true)
	layer.fVisibility:SetValue(1, false)
end

function msTransition:SetBoneKeys(layer, frame, isObjectTransition)
	if (layer:LayerType() ~= MOHO.LT_BONE) then
		print("layer " .. layer:Name() .. " needs to be a bone layer")
		return
	end
	local boneChannel = self.moho:LayerAsBone(layer):Skeleton():Bone(0).fAnimAngle

	if isObjectTransition then
		boneChannel:AddKey(1)
		boneChannel:SetKeyInterp(1,MOHO.INTERP_LINEAR, 0, 0)	
		boneChannel:SetValue(1, math.rad(100))
	end

	boneChannel:AddKey(frame)
	boneChannel:SetKeyInterp(frame,MOHO.INTERP_LINEAR, 0, 0)	
	boneChannel:SetValue(frame, math.rad(100))
	
	frame = frame + 40
	boneChannel:AddKey(frame)
	boneChannel:SetKeyInterp(frame,MOHO.INTERP_SMOOTH, 0, 0)	
	boneChannel:SetValue(frame, math.rad(180))
end


function msTransition:DeleteUnselectedLayers(groupLayer, nameList)

	if not groupLayer:IsGroupType() then
		print("Layer " .. groupLayer:Name() .. " needs to be a group layer")
		return
	end

	groupLayer = self.moho:LayerAsGroup(groupLayer)
	for k,v in pairs(self.checkList)do
		if(not v:Value()) then 
		  self.moho:DeleteLayer(groupLayer:LayerByName(k))
		end
	end
end

function msTransition:CreateSelectedLayerList()
	local layerList = {}
	for i = 0, self.moho.document:CountSelectedLayers()-1 do
		local layer = self.moho.document:GetSelectedLayer(i)
		table.insert(layerList, layer)
	end
	return layerList
end

function msTransition:CreateGroupLayer(groupName, groupType)
	local groupLayer
	if (groupType == "Bone") then
		groupLayer = self.moho:CreateNewLayer(MOHO.LT_BONE, true)
	elseif (groupType == "Group") then
		groupLayer = self.moho:CreateNewLayer(MOHO.LT_GROUP, true)
	else
		groupLayer = self.moho:CreateNewLayer(MOHO.LT_SWITCH, true)
	end
	groupLayer:SetName(groupName)
	return groupLayer
end

function msTransition:Alert(message)
	LM.GUI.Alert(LM.GUI.ALERT_INFO,
		message,
		nil,
		nil,
		"Ok",
		nil,
		nil)
end

function msTransition:Run(moho)
	self.moho = moho
	if moho.frame < 1 then
		self:Alert("The current frame needs to be greater than or equal to 1.")
		return
	end

	msDialog:Display(moho, msTransitionDialog)
	if((self.moho.document:CountSelectedLayers() < 2) and (self.isObjectTransition)) then
		self:Alert("You need to select 2 layers for object transition.")
		return
	end
	local layerList = self:CreateSelectedLayerList()

	local databaseLayer = self.moho:LayerAsGroup(self.moho.document:LayerByName("Transitions Database"))
	local transitionLayer = databaseLayer:LayerByName(self.boneLayer)
	
	if not transitionLayer:IsGroupType()then
		self.Alert("layer ", groupLayerName, " needs to be a bone type")
	end
	
	transitionLayer = self.moho:LayerAsGroup(transitionLayer)
	
	local dialog = msTransitionCheckboxDialog:new(moho, transitionLayer)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

	local newLayer = moho:DuplicateLayer(transitionLayer)
	moho:PlaceLayerBehindAnother(newLayer, databaseLayer)
	databaseLayer:SetVisible(false)
	databaseLayer:Expand(false)
	if not self.isObjectTransition then
		self:SetVisibility(newLayer, moho.frame)
	end
	self:SetBoneKeys(newLayer, moho.frame, self.isObjectTransition)
	self:DeleteUnselectedLayers(newLayer, self.checkList)
	
	local switchLayer = self:CreateGroupLayer("Objects", "Switch")
	for k, layer in ipairs(layerList) do
		local groupLayer = self:CreateGroupLayer("Object".. k, "Group")
		local objectLayer = moho:DuplicateLayer(layer)
		self.moho:PlaceLayerInGroup(groupLayer, switchLayer, true,true)
		self.moho:PlaceLayerInGroup(objectLayer, groupLayer, true,true)
	end
	self.moho:PlaceLayerInGroup(switchLayer, newLayer, true,true)

end
