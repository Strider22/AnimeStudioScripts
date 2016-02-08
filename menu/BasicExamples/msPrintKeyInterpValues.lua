ScriptName = "msPrintKeyInterpValues"
msPrintKeyInterpValues = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintKeyInterpValues:Name()
	return "PrintKeyInterpValues ... "
end

function msPrintKeyInterpValues:Version()
	return "1.0"
end

function msPrintKeyInterpValues:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Similar to flip, but points don't cross.")
end

function msPrintKeyInterpValues:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintKeyInterpValues:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintKeyInterpValues/PrintKeyInterpValues=PrintKeyInterpValues ... "))
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintKeyInterpValues:Run(moho)
	local interpSetting = MOHO.InterpSetting:new_local()
	moho.layer.fScale:GetKeyInterp(moho.frame,interpSetting)
	
	-- for key,value in pairs(interpSetting) do print(key,value) end
	print("val1 " .. interpSetting.val1 .. " val2 " .. interpSetting.val2)
	-- if(interpSetting.val1 > 1000) then
	 -- print("backwards true ")
	-- end
end
