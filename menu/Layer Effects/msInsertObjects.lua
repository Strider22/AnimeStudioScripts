-- playpen for trying things out
ScriptName = "msInsertObjects"
msInsertObjects = {}
msHelper.debug = false

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msInsertObjects:Name()
	return "InsertObjects ... "
end

function msInsertObjects:Version()
	return "1.0"
end

function msInsertObjects:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all skeleton's on a bone layer.")
end

function msInsertObjects:Creator()
	return "Mitchel Soltys"
end

msInsertObjects.transitionLayerList = nil
msInsertObjects.transitionLayer = nil
msInsertObjects.object1Layer = nil
msInsertObjects.object2Layer = nil

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msInsertObjectsDialog = {}


function msInsertObjectsDialog:new(moho)
	local self, l = msDialog:SimpleDialog("Transtions", self)

	self.moho = moho

	-- msInsertObjects:DumpLayerList(msInsertObjects.transitionLayerList)
	-- self.transitionMenu = msDialog:CreateLayerDropDownMenuFromList(moho, "Transition list", msInsertObjects.transitionLayerList)

	self.object1Menu = msDialog:CreateLayerDropDownMenu(moho, "Object 1")
	self.object2Menu = msDialog:CreateLayerDropDownMenu(moho, "Object 2")

	return self
end



function msInsertObjectsDialog:UpdateWidgets()
	self.object1Menu:SetCheckedLabel(msInsertObjects.object1Layer, true)
	self.object2Menu:SetCheckedLabel(msInsertObjects.object2Layer, true)
end


function msInsertObjectsDialog:OnOK()
	msInsertObjects.object1Layer = self.object1Menu:FirstCheckedLabel()
	msInsertObjects.object2Layer = self.object2Menu:FirstCheckedLabel()
end


-- function msInsertObjectsDialog:UpdateWidgets()
	-- self.transitionMenu:SetCheckedLabel(msInsertObjects.transitionLayer, true)
-- end


-- function msInsertObjectsDialog:OnOK()
	-- msInsertObjects.transitionLayer = self.TransitionMenu:FirstCheckedLabel()
-- end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msInsertObjects:UILabel()
	return(MOHO.Localize("/Scripts/Menu/InsertObjects/InsertObjects=InsertObjects ... "))
end

-- bone[id] = name
function msInsertObjects:BuildBoneList(layer)
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
function msInsertObjects:BuildPointMap(destBoneLayer,srcBoneList)
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


function msInsertObjects:InsertObjects(layer, pointMap)
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


function msInsertObjects:DumpBoneList(boneList)
	for k, v in pairs(boneList) do
		print("bone " .. k .. " is named " .. v)
	end
end

function msInsertObjects:SetVisibility(layer, frame)
	layer.fVisibility:SetValue(frame, true)
	layer.fVisibility:SetValue(1, false)
end

function msInsertObjects:SetBoneKeys(layer, frame, isInsertObjects)
	if (layer:LayerType() ~= MOHO.LT_BONE) then
		print("layer " .. layer:Name() .. " needs to be a bone layer")
		return
	end
	local boneChannel = self.moho:LayerAsBone(layer):Skeleton():Bone(0).fAnimAngle

	if isInsertObjects then
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

function msInsertObjects:CreateGroupLayer(groupName, groupType)
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

function msInsertObjects:DeleteUnselectedLayers(groupLayer, nameList)
	if not groupLayer:IsGroupType() then
		print("Layer " .. groupLayer:Name() .. " needs to be a group layer")
		return
	end

	groupLayer = self.moho:LayerAsGroup(groupLayer)
	for i = groupLayer:CountLayers()-1, 0, -1 do
		msHelper:Debug("in group layers layer is : " .. groupLayer:Layer(i):Name())
		local val = nameList[groupLayer:Layer(i):Name()]
		if val == nil then 
		  self.moho:DeleteLayer(groupLayer:Layer(i))
		end
	end
end

function msInsertObjects:CreateSelectedLayerList()
	local layerList = {}
	for i = 0, self.moho.document:CountSelectedLayers()-1 do
		local layer = self.moho.document:GetSelectedLayer(i)
		table.insert(layerList, layer)
	end
	return layerList
end

function msInsertObjects:CreateSelectedNamesList()
	local layerList = {}
	for i = 0, self.moho.document:CountSelectedLayers()-1 do
		local layer = self.moho.document:GetSelectedLayer(i)
		layerList[layer:Name()] = "selected"
	end
	return layerList
end


function msInsertObjects:CreateSubLayerList(layer)
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

function msInsertObjects:DumpLayerList(layerList)
	for k, layer in ipairs(layerList) do
		print("layer " .. layer:Name())
	end
end


-- **************************************************
-- The guts of this script
-- **************************************************
-- -1 - unbound
-- -2 -flexi binding
-- >=0 - bone id (bones start at 0)
function msInsertObjects:Run(moho)

	self.moho = moho
	-- self.transitionLayerList = self:CreateSubLayerList(self.moho.document:LayerByName("Transitions Database"))
	-- self:DumpLayerList(self.transitionLayerList)

	-- if (msDialog:Display(moho, msInsertObjectsDialog) == LM.GUI.MSG_CANCEL) then
		-- return
	-- end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

	local nameList = self:CreateSelectedNamesList()
	local layerList = self:CreateSelectedLayerList()
	-- local layerList = {}
	-- table.insert(layerList, moho.document:LayerByName(self.object1Layer))
	-- table.insert(layerList, moho.document:LayerByName(self.object2Layer))
	-- table.insert(layerList, self.object1Layer)
	-- table.insert(layerList, self.object2Layer)
	-- table.insert(layerList, "What")
	-- table.insert(layerList, "ever")

	
	-- SCREEN TRANSITION
	-- if moho.frame >= 1 then
		-- local transitionLayer = moho.layer:Parent()
		-- local databaseLayer = transitionLayer:Parent()
		-- local newLayer = moho:DuplicateLayer(transitionLayer)
		-- moho:PlaceLayerBehindAnother(newLayer, databaseLayer)
		-- databaseLayer:SetVisible(false)
		-- databaseLayer:Expand(false)
		-- self:SetVisibility(newLayer, moho.frame)
		-- self:SetBoneKeys(newLayer, moho.frame)
		-- self:DeleteUnselectedLayers(newLayer, nameList)
		
	-- else	
		-- print("The current frame needs to be greater than or equal to 1.")
	-- end
	
	-- OBJECT TRANSITION
	-- if moho.frame >= 1 then
		-- local transitionLayer = moho.layer:Parent()
		-- local databaseLayer = transitionLayer:Parent()
		-- local newLayer = moho:DuplicateLayer(transitionLayer)
		-- moho:PlaceLayerBehindAnother(newLayer, databaseLayer)
		-- databaseLayer:SetVisible(false)
		-- databaseLayer:Expand(false)
		-- self:SetVisibility(newLayer, moho.frame)
		-- self:SetBoneKeys(newLayer, moho.frame, true)
		-- self:DeleteUnselectedLayers(newLayer, nameList)

		local switchLayer = self:CreateGroupLayer("Objects", "Switch")
		for k, layer in ipairs(layerList) do
			local groupLayer = self:CreateGroupLayer("Object"..k, "Group")
			local objectLayer = moho:DuplicateLayer(layer)
			self.moho:PlaceLayerInGroup(groupLayer, switchLayer, true,true)
			self.moho:PlaceLayerInGroup(objectLayer, groupLayer, true,true)
		end
		
	-- else	
		-- print("The current frame needs to be greater than or equal to 1.")
	-- end
end
