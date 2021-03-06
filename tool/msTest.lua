-- FEEL FREE TO OVERWRITE THIS


ScriptName = "msTest"
msTest = {}

function msTest:Description()
	return "Basic Dialog using msDialog helper routines."
end


msTest.BASE_STR = 2540

function msTest:Name()
	return "msTest"
end

function msTest:Version()
	return "1.0"
end

function msTest:Creator()
	return "Mitchel Soltys"
end

function msTest:UILabel()
	return "Test ..."
end

-- **************************************************
-- Recurring values
-- **************************************************
msTest.selectLayer = nil
msTest.allLayer = nil
msTest.boneLayer = nil


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
	msTest.checkList = self.checkList
end


local msTestDialog = {}


function msTestDialog:new(moho)
	local self, l = msDialog:SimpleDialog("Test", self)

	self.moho = moho
	self.boneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Bone Layers", nil, "Transitions Database")
	return self
end




function msTestDialog:UpdateWidgets()
	msDialog:SetMenuByLabel(self.boneMenu,msTest.boneLayer)
end


function msTestDialog:OnOK()
	msTest.boneLayer = self.boneMenu:FirstCheckedLabel()
end

function msTest:GetGroupLayer(groupLayerName)
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

function msTest:Run(moho)
	self.moho = moho

	msDialog:Display(moho, msTestDialog)
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
