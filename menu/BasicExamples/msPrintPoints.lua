-- playpen for trying things out
ScriptName = "msPrintPoints"
msPrintPoints = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintPoints:Name()
	return "PrintPoints ... "
end

function msPrintPoints:Version()
	return "1.0"
end

function msPrintPoints:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print the current position of all points on a vector layer.")
end

function msPrintPoints:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintPoints:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintPoints/PrintPoints=PrintPoints ... "))
end

function msPrintPoints:PrintPoints(moho)
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
		print("Point " .. i .. " position at frame " .. layer:CurFrame() .. " is: x = " .. position.x .. " y = " .. position.y)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintPoints:Run(moho)
	self:PrintPoints(moho)
end
