ScriptName = "msInsertInGroup"
msInsertInGroup = {}

function msInsertInGroup:Description()
	return "Selected layers will be placed in group layers. You can select the type of the group."
end


function msInsertInGroup:Name()
	return "Insert Layers in Group"
end

function msInsertInGroup:Version()
	return "2.0"
end

function msInsertInGroup:Creator()
	return "Mitchel Soltys"
end

msInsertInGroup.groupType = "Bone"

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msInsertInGroup:UILabel()
	-- The label is localized for multiple language support
	return "Insert layers into groups"
end

msInsertInGroupDialog = {}

function msInsertInGroupDialog:new(moho)
	local d = LM.GUI.SimpleDialog("Insert In Group", msInsertInGroupDialog)
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

function msInsertInGroupDialog:UpdateWidgets()
	self.menu:SetCheckedLabel(msInsertInGroup.groupType, true)
end


function msInsertInGroupDialog:OnOK()
	msInsertInGroup.groupType = self.menu:FirstCheckedLabel()
end


function msInsertInGroupDialog:CreateDropDownMenu(moho, layout, title)
	local menu = LM.GUI.Menu(title)

	menu:AddItem("Bone", 0, MOHO.MSG_BASE + 0)
	menu:AddItem("Group", 0, MOHO.MSG_BASE + 1)
	menu:AddItem("Switch", 0, MOHO.MSG_BASE + 2)

	popup = LM.GUI.PopupMenu(256, true)
	popup:SetMenu(menu)
	layout:AddChild(popup)
	return menu
end



function msInsertInGroup:InsertLayerInGroup(layer)
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



-- **************************************************
-- The guts of this script
-- **************************************************

function msInsertInGroup:Run(moho)
	local dialog = msInsertInGroupDialog:new(moho)
	if (dialog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	self.moho = moho
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
        self:InsertLayerInGroup(layer)
	end
end
