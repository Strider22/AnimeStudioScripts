ScriptName = "msDisplaySwitchKeyInfo"
msDisplaySwitchKeyInfo = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msDisplaySwitchKeyInfo:Name()
	return "Display Switch Key Info"
end

function msDisplaySwitchKeyInfo:Version()
	return "1.0"
end

function msDisplaySwitchKeyInfo:Description()
	return MOHO.Localize("/Scripts/Menu/MoveGroupLayers/Description=Demonstrates how to move layers within a group.")
end

function msDisplaySwitchKeyInfo:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msDisplaySwitchKeyInfo:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/SwitchKeyInfo/SwitchKeyInfo=Display Switch Key Info"))
end

	
-- **************************************************
-- The guts of this script
-- **************************************************

function msDisplaySwitchKeyInfo:Run(moho)
	if moho.layer:LayerType() == MOHO.LT_SWITCH then
		-- the animChannel is the set of key values, the animation, for the
		-- animationType associated with the layer
		local animChannel = (moho:LayerAsSwitch(moho.layer)):SwitchValues()
		local numKeys = animChannel:CountKeys()
		print("There are ".. numKeys .. " keys associated with this layer.");

		print("Keys are at " )
		for id = 0, numKeys-1,1 do
			print("Key " .. id .. " at frame " .. animChannel:GetKeyWhen(id) .. " is " .. animChannel:GetValueByID(id))
		end
	else 
		print ("Layer is not a switch layer")
	end
end

