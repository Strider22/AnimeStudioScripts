-- playpen for trying things out
ScriptName = "msPrintPointInfo"
msPrintPointInfo = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintPointInfo:Name()
	return "PrintPointInfo ... "
end

function msPrintPointInfo:Version()
	return "1.0"
end

function msPrintPointInfo:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all points on a vector layer.")
end

function msPrintPointInfo:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintPointInfo:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintPointInfo/PrintPointInfo=PrintPointInfo ... "))
end

function msPrintPointInfo:PrintPointInfo(moho)
	local layer = moho.layer
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountPoints()-1 do
		local point = mesh:Point(i)
		local position = point.fPos;
		print("")
		print("Point " .. i .. " position at frame " .. layer:CurFrame() .. " is: x = " .. position.x .. " y = " .. position.y)
		print("Selected ? " .. tostring(point.fSelected))
		print("Binding " .. point.fParent)
		local animPos = point.fAnimPos
		for j = 0, animPos:CountKeys()-1 do
			local frame = animPos:GetKeyWhen(j)
			print("    key at frame " .. frame)
			local v = animPos:GetValueByID(j)
			print("         position is: x = " .. v.x .. " y = " .. v.y)
		end
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintPointInfo:Run(moho)
	self:PrintPointInfo(moho)
end
