-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msSwitchTile"

-- **************************************************
-- General information about this script
-- **************************************************

msSwitchTile = {}

msSwitchTile.BASE_STR = 2450

function msSwitchTile:Name()
	return "SwitchTile"
end

function msSwitchTile:Version()
	return "1.0"
end

function msSwitchTile:Description()
	return "Displays switch layers as tiles."
end

function msSwitchTile:Creator()
	return "Mitchel Soltys"
end

function msSwitchTile:UILabel()
	return"Switch Tile..."
end

-- **************************************************
-- Recurring values
-- **************************************************

msSwitchTile.tileMode = 1
msSwitchTile.radius = 0.5

-- **************************************************
-- Tile dialog
-- **************************************************

local msSwitchTileDialog = {}

msSwitchTileDialog.UPDATE = MOHO.MSG_BASE

function msSwitchTileDialog:new(moho)
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/Tile1/Title=Create Tile"), msSwitchTileDialog)
	local l = d:GetLayout()

	d.moho = moho

	d.preview = MOHO.MeshPreview(500, 500)
	l:AddChild(d.preview)

	return d
end

function msSwitchTileDialog:UpdateWidgets()
	self:UpdatePreview()
end

function msSwitchTileDialog:OnValidate()
	local b = true
	return b
end

function msSwitchTileDialog:HandleMessage(what)
	if (what == self.UPDATE) then
		self:UpdatePreview()
	end
end

function msSwitchTileDialog:OnOK()
end

function msSwitchTileDialog:UpdatePreview()
	local mesh = self.preview:Mesh()
	mesh:Clear()

	--msSwitchTile:BuildPolygon(mesh, tileMode)
	self.preview:CreateShape(true)
	self.preview:Refresh()
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msSwitchTile:IsEnabled(moho)
	if (moho.layer:CurrentAction() ~= "") then
		return false -- creating new objects in the middle of an action can lead to unexpected results
	end
	return true
end

function msSwitchTile:Run(moho)
	local dlog = msSwitchTileDialog:new(moho)
	if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		return
	end

	moho.document:SetDirty()
	moho.document:PrepUndo(nil)

--[[
	local group = moho:LayerAsGroup(moho:CreateNewLayer(MOHO.LT_GROUP, false))
	group:SetName(MOHO.Localize("/Scripts/Menu/Tile1/GroupName=Tile"))
	group:SetGroupMask(2)
	group:Metadata():Set("lm_tile_mode", self.tileMode)
	group:Metadata():Set("lm_tile_radius", self.radius)

	local layer = moho:CreateNewLayer(MOHO.LT_VECTOR, false)
	layer:SetName(MOHO.Localize("/Scripts/Menu/Tile1/MaskName=Mask"))
	moho:PlaceLayerInGroup(layer, group, true, false)
	layer:SetMaskingMode(MOHO.MM_ADD_MASK)
	layer:SetScaleCompensation(false)

	local mesh = moho:Mesh()
	if (mesh == nil) then
		return
	end

	self:BuildPolygon(mesh, self.tileMode)
	local shapeID = moho:CreateShape(true)
	if (shapeID >= 0) then
		local shape = mesh:Shape(shapeID)
		shape.fHasOutline = true
		shape.fMyStyle.fLineCol:SetValue(0, shape.fMyStyle.fFillCol:GetValue(0))
		shape.fMyStyle.fLineWidth = 1.5 / moho.document:Height()
	end

	layer = moho:CreateNewLayer(MOHO.LT_VECTOR, false)
	layer:SetName(MOHO.Localize("/Scripts/Menu/Tile1/DesignName=Design"))
	moho:PlaceLayerInGroup(layer, group, true, false)
	]]--
end

function msSwitchTile:BuildPolygon(mesh, tileMode)
	local expandedRadius = self.radius-- * 1.01
	local v = LM.Vector2:new_local()

	mesh:SelectNone()

	if (tileMode == 0) then
		v:Set(0, expandedRadius)
		mesh:AddLonePoint(v, 0)

		v:Set(0, expandedRadius)
		v:Rotate(math.rad(120))
		mesh:AppendPoint(v, 0)

		v:Set(0, expandedRadius)
		v:Rotate(math.rad(240))
		mesh:AppendPoint(v, 0)

		v:Set(0, expandedRadius)
		mesh:AppendPoint(v, 0)

		mesh:WeldPoints(0, 3, 0)

		for i = 0, 2 do
			mesh:Point(i):SetCurvature(MOHO.PEAKED, 0)
		end
	elseif (tileMode == 1) then
		v:Set(0, expandedRadius)
		mesh:AddLonePoint(v, 0)

		v:Set(0, expandedRadius)
		v:Rotate(-math.rad(120))
		mesh:AppendPoint(v, 0)

		v.x = 0
		mesh:AppendPoint(v, 0)

		v:Set(0, expandedRadius)
		mesh:AppendPoint(v, 0)

		mesh:WeldPoints(0, 3, 0)

		for i = 0, 2 do
			mesh:Point(i):SetCurvature(MOHO.PEAKED, 0)
		end
	elseif (tileMode == 2) then
		v:Set(expandedRadius, expandedRadius)
		mesh:AddLonePoint(v, 0)
		v:Set(expandedRadius, -expandedRadius)
		mesh:AppendPoint(v, 0)
		v:Set(-expandedRadius, -expandedRadius)
		mesh:AppendPoint(v, 0)
		v:Set(-expandedRadius, expandedRadius)
		mesh:AppendPoint(v, 0)
		v:Set(expandedRadius, expandedRadius)
		mesh:AppendPoint(v, 0)
		
		mesh:WeldPoints(0, 4, 0)
		for i = 0, 3 do
			mesh:Point(i):SetCurvature(MOHO.PEAKED, 0)
		end
	elseif (tileMode == 3) then
		local xRadius = expandedRadius * (1 + math.sqrt(5)) / 2
		v:Set(xRadius, expandedRadius)
		mesh:AddLonePoint(v, 0)
		v:Set(xRadius, -expandedRadius)
		mesh:AppendPoint(v, 0)
		v:Set(-xRadius, -expandedRadius)
		mesh:AppendPoint(v, 0)
		v:Set(-xRadius, expandedRadius)
		mesh:AppendPoint(v, 0)
		v:Set(xRadius, expandedRadius)
		mesh:AppendPoint(v, 0)
		
		mesh:WeldPoints(0, 4, 0)
		for i = 0, 3 do
			mesh:Point(i):SetCurvature(MOHO.PEAKED, 0)
		end
	end

	mesh:SelectAll()
end
