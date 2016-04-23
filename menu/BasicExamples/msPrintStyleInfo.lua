-- playpen for trying things out
ScriptName = "msPrintStyleInfo"
msPrintStyleInfo = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintStyleInfo:Name()
	return "PrintStyleInfo ... "
end

function msPrintStyleInfo:Version()
	return "1.0"
end

function msPrintStyleInfo:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all points on a vector layer.")
end

function msPrintStyleInfo:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintStyleInfo:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintStyleInfo/PrintStyleInfo=PrintStyleInfo ... "))
end

function msPrintStyleInfo:PrintStyleInfo()
	-- local layer = self.moho.layer

	-- if layer:LayerType() ~= MOHO.LT_VECTOR then
		-- print("Select a vector layer")
		-- return
	-- end

	-- local vectorLayer = moho:LayerAsVector(layer)
	-- local mesh = vectorLayer:Mesh()
	-- for i = 0, mesh:CountShapes()-1 do
		-- local shape = mesh:Shape(i)
		-- local position = point.fPos;
		-- print("")
		-- print("Point " .. i .. " position at frame " .. layer:CurFrame() .. " is: x = " .. position.x .. " y = " .. position.y)
		-- print("Selected ? " .. tostring(point.fSelected))
		-- print("Binding " .. point.fParent)
		-- local animPos = point.fAnimPos
		-- for j = 0, animPos:CountKeys()-1 do
			-- local frame = animPos:GetKeyWhen(j)
			-- print("    key at frame " .. frame)
			-- local v = animPos:GetValueByID(j)
			-- print("         position is: x = " .. v.x .. " y = " .. v.y)
		-- end
	-- end
	print("num styles " .. self.moho.document:CountStyles())

	for i = 0, self.moho.document:CountStyles()-1 do
		local style = self.moho.document:StyleByID(i)
		print("style name " .. style.fName:Buffer())
		-- self:PrintTableValues(style)
		print(" uuid " .. style.fUUID:Buffer())
	end
end

function msPrintStyleInfo:PrintTableValues(t)
	for n, v in pairs(t) do
		print("n: ", n, " v: ",  v, " type " , type(v))
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintStyleInfo:Run(moho)
	self.moho = moho
	self:PrintStyleInfo()
end
