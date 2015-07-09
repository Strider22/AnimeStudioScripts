ScriptName = "msDisplaySwitchKeyInfo"
msDisplaySwitchKeyInfo = {}

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

