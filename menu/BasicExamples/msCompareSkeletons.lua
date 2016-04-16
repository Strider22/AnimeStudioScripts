-- playpen for trying things out
ScriptName = "msCompareSkeletons"
msCompareSkeletons = {}
msHelper.debug = false



-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msCompareSkeletons:Name()
	return "CompareSkeletons ... "
end

function msCompareSkeletons:Version()
	return "1.0"
end

function msCompareSkeletons:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all skeleton's on a bone layer.")
end

function msCompareSkeletons:Creator()
	return "Mitchel Soltys"
end

msCompareSkeletons.srcLayer = ""
msCompareSkeletons.destLayer = ""

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msCompareSkeletonsDialog = {}


function msCompareSkeletonsDialog:new(moho)
	local self, l = msDialog:SimpleDialog("RebindBoints", self)

	self.moho = moho

	self.srcBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Source Bone Layer")
	self.destBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Destination Bone Layer")

	return self
end




function msCompareSkeletonsDialog:UpdateWidgets()
	self.srcBoneMenu:SetCheckedLabel(msCompareSkeletons.srcLayer, true)
	self.destBoneMenu:SetCheckedLabel(msCompareSkeletons.destLayer, true)
end


function msCompareSkeletonsDialog:OnOK()
	msCompareSkeletons.srcLayer = self.srcBoneMenu:FirstCheckedLabel()
	msCompareSkeletons.destLayer = self.destBoneMenu:FirstCheckedLabel()
end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msCompareSkeletons:UILabel()
	return(MOHO.Localize("/Scripts/Menu/CompareSkeletons/CompareSkeletons=CompareSkeletons ... "))
end


function msCompareSkeletons:CompareSkeletons(srcLayer, destLayer)
	if srcLayer:LayerType() ~= MOHO.LT_BONE then
		print("Select a src bone layer")
		return
	end
	if destLayer:LayerType() ~= MOHO.LT_BONE then
		print("Select a dest bone layer")
		return
	end

	 
	local srcSkeleton = self.moho:LayerAsBone(srcLayer):Skeleton()
	local destSkeleton = self.moho:LayerAsBone(destLayer):Skeleton()
	if srcSkeleton:CountBones() ~= destSkeleton:CountBones() then
		print("src Bones = " .. srcSkeleton:CountBones() .. " dest bones = " ..destSkeleton:CountBones())
	end
	for i = 0, srcSkeleton:CountBones()-1 do
		local srcName = srcSkeleton:Bone(i):Name()
		local destName = destSkeleton:Bone(i):Name()
		if srcName ~= destName then
			print("bone i : src " .. srcName .. " dest " .. destName)
		end
	end
end



-- **************************************************
-- The guts of this script
-- **************************************************
-- -1 - unbound
-- -2 -flexi binding
-- >=0 - bone id (bones start at 0)
function msCompareSkeletons:Run(moho)

	self.moho = moho

	if (msDialog:Display(moho, msCompareSkeletonsDialog) == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
	
	self:CompareSkeletons(moho.document:LayerByName(self.srcLayer),moho.document:LayerByName(self.destLayer))
	
end
