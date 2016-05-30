-- playpen for trying things out
ScriptName = "msPrintSkelInfo"
msPrintSkelInfo = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintSkelInfo:Name()
	return "PrintSkelInfo ... "
end

function msPrintSkelInfo:Version()
	return "1.0"
end

function msPrintSkelInfo:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all skeleton's on a bone layer.")
end

function msPrintSkelInfo:Creator()
	return "Mitchel Soltys"
end

msPrintSkelInfo.boneLayer = 1

-- **************************************************
-- DialogExample dialog
-- **************************************************

local msPrintSkelInfoDialog = {}


function msPrintSkelInfoDialog:new(moho)
	local self, l = msDialog:SimpleDialog("Skeleton Info", self)

	self.moho = moho

	self.boneMenu = msDialog:CreateBoneLayerDropDownMenu(moho, "Select Bone Layer")

	return self
end




function msPrintSkelInfoDialog:UpdateWidgets()
	self.boneMenu:SetChecked(MOHO.MSG_BASE + msPrintSkelInfo.boneLayer, true)
end


function msPrintSkelInfoDialog:OnOK()
	msPrintSkelInfo.boneLayer = self.boneMenu:FirstChecked()
end





-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintSkelInfo:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintSkelInfo/PrintSkelInfo=PrintSkelInfo ... "))
end

function msPrintSkelInfo:PrintSkelInfo(moho)
	local layer = moho.document:Layer(self.boneLayer)
	if layer:LayerType() ~= MOHO.LT_BONE then
		print("Select a bone layer")
		return
	end

	local boneLayer = moho:LayerAsBone(layer)
	local skeleton = boneLayer:Skeleton()
	for i = 0, skeleton:CountBones()-1 do
		local bone = skeleton:Bone(i)
		print("")
		print("bone " .. i .. " is named " .. bone:Name())
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintSkelInfo:Run(moho)
    if (msDialog:Display(moho, msPrintSkelInfoDialog) == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(moho.layer)

	self:PrintSkelInfo(moho)
end
