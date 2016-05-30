-- Compares two bone layer Skeletons to see if they are the same
-- Layers are selected via dialog
ScriptName = "msSkeletonCompare"
msSkeletonCompare = {}
msHelper.debug = false



-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msSkeletonCompare:Name()
	return "CompareSkeletons ... "
end

function msSkeletonCompare:Version()
	return "1.0"
end

function msSkeletonCompare:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Compares two bone layer Skeletons to see if they are the same.")
end

function msSkeletonCompare:Creator()
	return "Mitchel Soltys"
end

msSkeletonCompare.srcLayer = ""
msSkeletonCompare.destLayer = ""

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msSkeletonCompareDialog = {}


function msSkeletonCompareDialog:new(moho)
	local self, l = msDialog:SimpleDialog("RebindBoints", self)

	self.moho = moho

	self.srcBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Source Bone Layer")
	self.destBoneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Destination Bone Layer")

	return self
end




function msSkeletonCompareDialog:UpdateWidgets()
	self.srcBoneMenu:SetCheckedLabel(msSkeletonCompare.srcLayer, true)
	self.destBoneMenu:SetCheckedLabel(msSkeletonCompare.destLayer, true)
end


function msSkeletonCompareDialog:OnOK()
	msSkeletonCompare.srcLayer = self.srcBoneMenu:FirstCheckedLabel()
	msSkeletonCompare.destLayer = self.destBoneMenu:FirstCheckedLabel()
end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msSkeletonCompare:UILabel()
	return(MOHO.Localize("/Scripts/Menu/CompareSkeletons/CompareSkeletons=CompareSkeletons ... "))
end


function msSkeletonCompare:CompareSkeletons(srcLayer, destLayer)
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
function msSkeletonCompare:Run(moho)

	self.moho = moho

	if (msDialog:Display(moho, msSkeletonCompareDialog) == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
	
	self:CompareSkeletons(moho.document:LayerByName(self.srcLayer),moho.document:LayerByName(self.destLayer))
	
end
