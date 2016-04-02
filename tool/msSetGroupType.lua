ScriptName = "msSetGroupType"
msSetGroupType = {}

function msSetGroupType:Description()
	return "Allows you to select the type of a group layer."
end


function msSetGroupType:Name()
	return "SetGroupType"
end

function msSetGroupType:Version()
	return "1.0"
end

function msSetGroupType:Creator()
	return "Mitchel Soltys"
end

msSetGroupType.groupType = "Bone"

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msSetGroupType:UILabel()
	-- The label is localized for multiple language support
	return "Insert layers into groups"
end

msSetGroupTypeDialog = {}

function msSetGroupTypeDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Set Group Type", msSetGroupTypeDialog)
	local l = d:GetLayout()
	d.moho = moho
	l:PushH(LM.GUI.ALIGN_LEFT)
		l:PushV(LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText("Select group type"),LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV(LM.GUI.ALIGN_LEFT)
			d.menu = self:CreateDropDownMenu(moho, l, "Select group type")
		l:Pop()
	l:Pop()

	return d
end

function msSetGroupTypeDialog:UpdateWidgets()
	self.menu:SetCheckedLabel(msSetGroupType.groupType, true)
end


function msSetGroupTypeDialog:OnOK()
	msSetGroupType.groupType = self.menu:FirstCheckedLabel()
end


function msSetGroupTypeDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("Bone", 0, MOHO.MSG_BASE + 0)
	menu:AddItem("Group", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("Switch", 0, MOHO.MSG_BASE + 2)

	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end



function msSetGroupType:SetGroupType(layer)
	local groupLayer
	if (self.groupType == "Bone") then
		groupLayer = self.moho:CreateNewLayer(MOHO.LT_BONE, true)
	elseif (self.groupType == "Group") then
		groupLayer = self.moho:CreateNewLayer(MOHO.LT_GROUP, true)
	else
		groupLayer = self.moho:CreateNewLayer(MOHO.LT_SWITCH, true)
	end
	groupLayer:SetName(layer:Name())
	self.moho:PlaceLayerInGroup(layer, groupLayer, true,true)
end

-- function msEx7EnableForGroup:IsEnabled(moho)
	-- if moho.layer:IsGroupType() then
		-- return true
	-- end
	-- return false
-- end


-- **************************************************
-- The guts of this script
-- **************************************************

function msSetGroupType:Run(moho)
	local dialog = msSetGroupTypeDialog:new(moho)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	self.moho = moho
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
        self:SetGroupType(layer)
	end
end
