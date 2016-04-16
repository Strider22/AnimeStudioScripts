-- playpen for trying things out
ScriptName = "msMatchSkeleton"
msMatchSkeleton = {}
msHelper.debug = false


-- **************************************************



-- NOT STARTED YET. COPY AND PASTE FROM rebind points




-- **************************************************




-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMatchSkeleton:Name()
	return "MatchSkeleton ... "
end

function msMatchSkeleton:Version()
	return "1.0"
end

function msMatchSkeleton:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all skeleton's on a bone layer.")
end

function msMatchSkeleton:Creator()
	return "Mitchel Soltys"
end

msMatchSkeleton.srcLayer = ""
msMatchSkeleton.destLayer = ""

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msMatchSkeletonDialog = {}


function msMatchSkeletonDialog:new(moho)
	local self, l = msDialog:SimpleDialog("RebindBoints", self)

	self.moho = moho

	self.srcBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Source Bone Layer")
	self.destBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Destination Bone Layer")

	return self
end




function msMatchSkeletonDialog:UpdateWidgets()
	self.srcBoneMenu:SetCheckedLabel(msMatchSkeleton.srcLayer, true)
	self.destBoneMenu:SetCheckedLabel(msMatchSkeleton.destLayer, true)
end


function msMatchSkeletonDialog:OnOK()
	msMatchSkeleton.srcLayer = self.srcBoneMenu:FirstCheckedLabel()
	msMatchSkeleton.destLayer = self.destBoneMenu:FirstCheckedLabel()
end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMatchSkeleton:UILabel()
	return(MOHO.Localize("/Scripts/Menu/MatchSkeleton/MatchSkeleton=MatchSkeleton ... "))
end

-- bone[id] = name
function msMatchSkeleton:BuildBoneList(layer)
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
function msMatchSkeleton:BuildPointMap(destBoneLayer,srcBoneList)
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

function msMatchSkeleton:MatchSkeleton(layer, pointMap)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local parentBone = layer:LayerParentBone()
	if parentBone >= 0 then 
		layer:SetLayerParentBone(pointMap[parentBone])
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


function msMatchSkeleton:DumpBoneList(boneList)
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
function msMatchSkeleton:Run(moho)

	self.moho = moho

	if (msDialog:Display(moho, msMatchSkeletonDialog) == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
	
	local boneList = self:BuildBoneList(moho.document:LayerByName(self.srcLayer))
	local pointMap = self:BuildPointMap(moho.document:LayerByName(self.destLayer), boneList)
	if pointMap == nil then 
		return
	end

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:MatchSkeleton(layer,pointMap)
	end

	
end
