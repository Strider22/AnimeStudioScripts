-- playpen for trying things out
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
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all skeleton's on a bone layer.")
end

function msScreenTransition:Creator()
	return "Mitchel Soltys"
end

msScreenTransition.srcLayer = ""
msScreenTransition.destLayer = ""

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msScreenTransitionDialog = {}


function msScreenTransitionDialog:new(moho)
	local self, l = msDialog:SimpleDialog("RebindBoints", self)

	self.moho = moho

	self.srcBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Source Bone Layer")
	self.destBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Destination Bone Layer")

	return self
end




function msScreenTransitionDialog:UpdateWidgets()
	self.srcBoneMenu:SetCheckedLabel(msScreenTransition.srcLayer, true)
	self.destBoneMenu:SetCheckedLabel(msScreenTransition.destLayer, true)
end


function msScreenTransitionDialog:OnOK()
	msScreenTransition.srcLayer = self.srcBoneMenu:FirstCheckedLabel()
	msScreenTransition.destLayer = self.destBoneMenu:FirstCheckedLabel()
end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msScreenTransition:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ScreenTransition/ScreenTransition=ScreenTransition ... "))
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

-- **************************************************
-- The guts of this script
-- **************************************************
-- -1 - unbound
-- -2 -flexi binding
-- >=0 - bone id (bones start at 0)
function msScreenTransition:Run(moho)

	self.moho = moho

	-- if (msDialog:Display(moho, msScreenTransitionDialog) == LM.GUI.MSG_CANCEL) then
		-- return
	-- end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
	moho:DuplicateLayer(moho.layer)
	moho:PlaceLayerBehindAnother(moho.layer, moho.document:LayerByName("Transitions Database"))
end
