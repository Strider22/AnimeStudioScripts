-- playpen for trying things out
ScriptName = "msPrintCurvature"
msPrintCurvature = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintCurvature:Name()
	return "PrintCurvature ... "
end

function msPrintCurvature:Version()
	return "1.0"
end

function msPrintCurvature:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Removes transform from group and applies it to sub layers.")
end

function msPrintCurvature:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintCurvature:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintCurvature/PrintCurvature=PrintCurvature ... "))
end

function msPrintCurvature:PrintPointInfo(moho)
	local mesh = moho:LayerAsVector(moho.layer):Mesh()
	for i = 0, mesh:CountCurves()-1 do
		local curve = mesh:Curve(i)
		for j = 0, curve:CountPoints()-1 do
			-- local curvature = curve:Curvature(i)
			local point = curve:Point(i)
			local channel = point.fAnimPos 
			print("Curve " ..  i .. " point " .. j)
			for k = 0, channel:CountKeys()-1 do
				local frame = channel:GetKeyWhen(k)
				print("key " .. k .. " frame " .. frame)
			end
		end
	end
end

-- function msPrintCurvature:PrintPointCurvature(moho)
	-- local mesh = moho:LayerAsVector(moho.layer):Mesh()
	-- for i = 0, mesh:CountCurves()-1 do
		-- local curve = mesh:Curve(i)
		-- for j = 0, curve:CountPoints()-1 do
			-- local curvature = curve:Curvature(i)
				-- print("Curve " ..  i .. " point " .. j)
			-- for k = 0, curvature:CountKeys()-1 do
				-- local frame = curvature:GetKeyWhen(k)
				-- print("key " .. k .. " frame " .. frame)
			-- end
		-- end
	-- end
-- end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintCurvature:Run(moho)
	self:PrintPointInfo(moho)
end
