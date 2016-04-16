-- playpen for trying things out
ScriptName = "msRebindPoints"
msRebindPoints = {}
msHelper.debug = false

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msRebindPoints:Name()
	return "RebindPoints ... "
end

function msRebindPoints:Version()
	return "1.0"
end

function msRebindPoints:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all skeleton's on a bone layer.")
end

function msRebindPoints:Creator()
	return "Mitchel Soltys"
end

msRebindPoints.srcLayer = ""
msRebindPoints.destLayer = ""

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msRebindPointsDialog = {}


function msRebindPointsDialog:new(moho)
	local self, l = msDialog:SimpleDialog("RebindBoints", self)

	self.moho = moho

	self.srcBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Source Bone Layer")
	self.destBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Destination Bone Layer")

	return self
end




function msRebindPointsDialog:UpdateWidgets()
	self.srcBoneMenu:SetCheckedLabel(msRebindPoints.srcLayer, true)
	self.destBoneMenu:SetCheckedLabel(msRebindPoints.destLayer, true)
end


function msRebindPointsDialog:OnOK()
	msRebindPoints.srcLayer = self.srcBoneMenu:FirstCheckedLabel()
	msRebindPoints.destLayer = self.destBoneMenu:FirstCheckedLabel()
end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msRebindPoints:UILabel()
	return(MOHO.Localize("/Scripts/Menu/RebindPoints/RebindPoints=RebindPoints ... "))
end

-- bone[id] = name
function msRebindPoints:BuildBoneList(layer)
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
function msRebindPoints:BuildPointMap(destBoneLayer,srcBoneList)
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

--[[
function msRebindPoints:ResetFlexiBones(srcLayer, destLayer, vectorLayer)
	if srcLayer:LayerType() ~= MOHO.LT_BONE then
		print("Select a src bone layer")
		return
	end
	if destLayer:LayerType() ~= MOHO.LT_BONE then
		print("Select a dest bone layer")
		return
	end
	-- Point and flexi binding need vector layers
	if vectorLayer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local flexiBones = vectorLayer:FlexiBoneSubset()
	print("flexi bones" .. flexiBones)
	
	 
	-- local srcSkeleton = self.moho:LayerAsBone(srcLayer):Skeleton()
	-- local destSkeleton = self.moho:LayerAsBone(destLayer):Skeleton()
	-- if srcSkeleton:CountBones() ~= destSkeleton:CountBones() then
		-- print("src Bones = " .. srcSkeleton:CountBones() .. " dest bones = " ..destSkeleton:CountBones())
	-- end
	-- for i = 0, srcSkeleton:CountBones()-1 do
		-- local srcName = srcSkeleton:Bone(i):Name()
		-- local destName = destSkeleton:Bone(i):Name()
		-- if srcName ~= destName then
			-- print("bone i : src " .. srcName .. " dest " .. destName)
		-- end
	-- end
end
]]--

function msRebindPoints:RebindPoints(layer, pointMap)
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


function msRebindPoints:DumpBoneList(boneList)
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
function msRebindPoints:Run(moho)

	self.moho = moho

	if (msDialog:Display(moho, msRebindPointsDialog) == LM.GUI.MSG_CANCEL) then
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
		self:RebindPoints(layer,pointMap)
	end

	
end
