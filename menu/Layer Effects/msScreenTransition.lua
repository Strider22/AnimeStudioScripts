ScriptName = "msScreenTransition"
msScreenTransition = {}
msHelper.debug = false

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msScreenTransition:Name()
	return "ScreenTransition ... "
end

function msScreenTransition:Version()
	return "1.0"
end

function msScreenTransition:Description()
	return "Select screen transition from a database."
end

function msScreenTransition:Creator()
	return "Mitchel Soltys"
end

msScreenTransition.transitionLayerList = nil
msScreenTransition.transitionLayer = nil


-- **************************************************
-- Recurring values
-- **************************************************
msScreenTransition.boneLayer = nil


-- **************************************************
-- DialogExample dialog
-- **************************************************
local msScreenTransitionCheckboxDialog  ={}

function msScreenTransitionCheckboxDialog:new(moho,groupLayer)
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

function msScreenTransitionCheckboxDialog:UpdateWidgets()
end


function msScreenTransitionCheckboxDialog:OnOK()
	msScreenTransition.checkList = self.checkList
end


local msScreenTransitionDialog = {}


function msScreenTransitionDialog:new(moho)
	local self, l = msDialog:SimpleDialog("Test", self)

	self.moho = moho
	self.boneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Bone Layers", nil, "Transitions Database")
	return self
end




function msScreenTransitionDialog:UpdateWidgets()
	msDialog:SetMenuByLabel(self.boneMenu,msScreenTransition.boneLayer)
end


function msScreenTransitionDialog:OnOK()
	msScreenTransition.boneLayer = self.boneMenu:FirstCheckedLabel()
end


-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msScreenTransition:UILabel()
	return "ScreenTransition ... "
end

-- bone[id] = name
function msScreenTransition:BuildBoneList(layer)
	if layer:LayerType() ~= MOHO.LT_BONE then
		print("Select a bone layer".. layer:LayerType())
		return
	end

	local boneList = {}
	local boneLayer = self.moho:LayerAsBone(layer)
	local skeleton = boneLayer:Skeleton()
	for i = 0, skeleton:CountBones()-1 do
		local bone = skeleton:Bone(i)
		boneList[i] = bone:Name()
	end
	return boneList
end

-- point[id] = newPointId
function msScreenTransition:BuildPointMap(destBoneLayer,srcBoneList)
	if destBoneLayer:LayerType() ~= MOHO.LT_BONE then
		print("Select a bone layer")
		return
	end

	local skeleton = self.moho:LayerAsBone(destBoneLayer):Skeleton()
	local skeletonsrc = self.moho:LayerAsBone(self.moho.document:LayerByName(self.srcLayer)):Skeleton()
	local pointMap = {}
	local missingBones = false
	for k, v in pairs(srcBoneList) do
		msHelper:Debug("k: " .. k .. " v " .. v)
		msHelper:Debug("src " .. skeletonsrc:BoneID(skeletonsrc:BoneByName(v))) 
		msHelper:Debug(" dest " .. skeleton:BoneID(skeleton:BoneByName(v)))
		pointMap[k] = skeleton:BoneID(skeleton:BoneByName(v))
		msHelper:Debug("pointMap[" .. k .. "]=" .. pointMap[k])
		if(pointMap[k] < 0) then
			print("Bone " .. v .. " is not found in layer " .. destBoneLayer:Name())
			missingBones = true
		end
	end
	if missingBones then
		return nil
	end
	return pointMap
end


function msScreenTransition:ScreenTransition(layer, pointMap)
	-- check for layer binding
	local parentBone = layer:LayerParentBone()
	if parentBone >= 0 then 
		layer:SetLayerParentBone(pointMap[parentBone])
	end

	-- Point and flexi binding need vector layers
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		return
	end

	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountPoints()-1 do
		local point = mesh:Point(i)
		if point.fParent >= 0 then 
			point.fParent = pointMap[point.fParent]
		end
	end
end


function msScreenTransition:DumpBoneList(boneList)
	for k, v in pairs(boneList) do
		print("bone " .. k .. " is named " .. v)
	end
end

function msScreenTransition:SetVisibility(layer, frame)
	layer.fVisibility:SetValue(frame, true)
	layer.fVisibility:SetValue(1, false)
end

function msScreenTransition:SetBoneKeys(layer, frame)
	if (layer:LayerType() ~= MOHO.LT_BONE) then
		print("layer " .. layer:Name() .. " needs to be a bone layer")
		return
	end
	local boneChannel = self.moho:LayerAsBone(layer):Skeleton():Bone(0).fAnimAngle
	boneChannel:AddKey(frame)
	boneChannel:SetKeyInterp(frame,MOHO.INTERP_LINEAR, 0, 0)	
	boneChannel:SetValue(frame, math.rad(100))
	
	frame = frame + 40
	boneChannel:AddKey(frame)
	boneChannel:SetKeyInterp(frame,MOHO.INTERP_SMOOTH, 0, 0)	
	boneChannel:SetValue(frame, math.rad(180))
end

function msScreenTransition:CreateGroupLayer(groupName, groupType)
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

function msScreenTransition:DeleteUnselectedLayers(groupLayer, nameList)

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

function msScreenTransition:CreateSelectedLayerList()
	local layerList = {}
	for i = 0, self.moho.document:CountSelectedLayers()-1 do
		local layer = self.moho.document:GetSelectedLayer(i)
		table.insert(layerList, layer)
	end
	return layerList
end

function msScreenTransition:CreateSelectedNamesList()
	local layerList = {}
	for i = 0, self.moho.document:CountSelectedLayers()-1 do
		local layer = self.moho.document:GetSelectedLayer(i)
		layerList[layer:Name()] = "selected"
	end
	return layerList
end


function msScreenTransition:CreateSubLayerList(layer)
	if not layer:IsGroupType() then
		print("Layer " .. layer:Name() .. " needs to be a group layer")
		return
	end

	local groupLayer = self.moho:LayerAsGroup(layer)
	local layerList = {}
	for i = 0, groupLayer:CountLayers()-1 do
		table.insert(layerList, groupLayer:Layer(i))
	end
	return layerList
end

function msScreenTransition:DumpLayerList(layerList)
	for k, layer in ipairs(layerList) do
		print("layer " .. layer:Name())
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msScreenTransition:Run(moho)
	if moho.frame < 1 then
		print("The current frame needs to be greater than or equal to 1.")
		return
	end

	self.moho = moho
	msDialog:Display(moho, msScreenTransitionDialog)

	local databaseLayer = self.moho:LayerAsGroup(self.moho.document:LayerByName("Transitions Database"))
	local transitionLayer = databaseLayer:LayerByName(self.boneLayer)
	
	if not transitionLayer:IsGroupType()then
		print("layer ", groupLayerName, " needs to be a bone type")
	end
	
	transitionLayer = self.moho:LayerAsGroup(transitionLayer)
	
	local dialog = msScreenTransitionCheckboxDialog:new(moho, transitionLayer)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

	local newLayer = moho:DuplicateLayer(transitionLayer)
	moho:PlaceLayerBehindAnother(newLayer, databaseLayer)
	databaseLayer:SetVisible(false)
	databaseLayer:Expand(false)
	self:SetVisibility(newLayer, moho.frame)
	self:SetBoneKeys(newLayer, moho.frame)
	self:DeleteUnselectedLayers(newLayer, self.checkList)
end
