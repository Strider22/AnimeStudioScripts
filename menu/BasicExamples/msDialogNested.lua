-- FEEL FREE TO OVERWRITE THIS


ScriptName = "msDialogNested"
msDialogNested = {}

function msDialogNested:Description()
	return "NestedDialogs."
end


msDialogNested.BASE_STR = 2540

function msDialogNested:Name()
	return "msDialogNested"
end

function msDialogNested:Version()
	return "1.0"
end

function msDialogNested:Creator()
	return "Mitchel Soltys"
end

function msDialogNested:UILabel()
	return "Test ..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msDialogNested.boneLayer = nil


-- **************************************************
-- DialogExample dialog
-- **************************************************
local msCheckBoxDialog  ={}

function msCheckBoxDialog:new(moho,groupLayer)
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

function msCheckBoxDialog:UpdateWidgets()
end


function msCheckBoxDialog:OnOK()
	msDialogNested.checkList = self.checkList
end


local msDialogNestedDialog = {}


function msDialogNestedDialog:new(moho)
	local self, l = msDialog:SimpleDialog("Test", self)

	self.moho = moho
	self.boneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Bone Layers", nil, "Transitions Database")
	return self
end




function msDialogNestedDialog:UpdateWidgets()
	msDialog:SetMenuByLabel(self.boneMenu,msDialogNested.boneLayer)
end


function msDialogNestedDialog:OnOK()
	msDialogNested.boneLayer = self.boneMenu:FirstCheckedLabel()
end

function msDialogNested:GetGroupLayer(groupLayerName)
	local databaseLayer = self.moho:LayerAsGroup(self.moho.document:LayerByName("Transitions Database"))
	local layer = databaseLayer:LayerByName(groupLayerName)
	
	if not layer:IsGroupType()then
		print("layer ", groupLayerName, " needs to be a bone type")
	end
	return self.moho:LayerAsGroup(layer)
end




-- **************************************************
-- The guts of this script
-- **************************************************

function msDialogNested:Run(moho)
	self.moho = moho

	msDialog:Display(moho, msDialogNestedDialog)
	local dialog = msCheckBoxDialog:new(moho, self:GetGroupLayer(self.boneLayer))
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

	for k,v in pairs(self.checkList)do
		if(v:Value()) then 
			print(k)
		end
	end

	

end
