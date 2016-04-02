-- playpen for trying things out
ScriptName = "msRebindPoints"
msRebindPoints = {}

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

msRebindPoints.srcLayer = 1
msRebindPoints.destLayer = 1

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
	self.srcBoneMenu:SetChecked(MOHO.MSG_BASE + msRebindPoints.srcLayer, true)
	self.destBoneMenu:SetChecked(MOHO.MSG_BASE + msRebindPoints.destLayer, true)
end


function msRebindPointsDialog:OnOK()
	msRebindPoints.srcLayer = self.srcBoneMenu:FirstChecked()
	msRebindPoints.destLayer = self.destBoneMenu:FirstChecked()
end




-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msRebindPoints:UILabel()
	return(MOHO.Localize("/Scripts/Menu/RebindPoints/RebindPoints=RebindPoints ... "))
end

function msRebindPoints:BuildBoneMap(layer)
	if layer:LayerType() ~= MOHO.LT_BONE then
		print("Select a bone layer")
		return
	end

	local boneMap = {}
	local boneLayer = self.moho:LayerAsBone(layer)
	local skeleton = boneLayer:Skeleton()
	for i = 0, skeleton:CountBones()-1 do
		local bone = skeleton:Bone(i)
		boneMap[i] = bone:Name()
	end
	return boneMap
end

function msRebindPoints:Remap(layer,srcBoneMap)
	if layer:LayerType() ~= MOHO.LT_BONE then
		print("Select a bone layer")
		return
	end

	local boneMap = {}
	local boneLayer = self.moho:LayerAsBone(layer)
	local skeleton = boneLayer:Skeleton()
	for i = 0, skeleton:CountBones()-1 do
		local bone = skeleton:Bone(i)
		boneMap[i] = bone:Name()
	end
	return boneMap
end

function msRebindPoints:DumpBoneMap(boneMap)
	for k, v in pairs(boneMap) do
		print("bone " .. k .. " is named " .. v)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msRebindPoints:Run(moho)

	self.moho = moho

	if (msDialog:Display(moho, msRebindPointsDialog) == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)
	
	-- if moho.document:CountSelectedLayers() ~= 2 then 
		-- print("select 2 bone layers")
	-- end
		-- local layer = moho.document:GetSelectedLayer(i)
		-- self:AddLayerToList(layer)
	-- end

	local boneMap = self:BuildBoneMap(moho.document:Layer(self.srcLayer))
	-- local boneMap = self:BuildBoneMap(moho.document:GetSelectedLayer(0))
	
	self:DumpBoneMap(boneMap)
	
end
