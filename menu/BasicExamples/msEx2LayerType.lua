ScriptName = "msEx2LayerType"
msEx2LayerType = {}

function msEx2LayerType:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/layerType/layerType=Ex2 Layer type"))
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msEx2LayerType:Run(moho)
	print("The currently selected layer is of type:")
	local layerType = moho.layer:LayerType()
	if layerType == MOHO.LT_SWITCH then print("switch layer")
	elseif layerType == MOHO.LT_VECTOR then print("vector layer")
	elseif layerType == MOHO.LT_BONE then print("bone layer")
	elseif layerType == MOHO.LT_GROUP then print("group layer")
	elseif layerType == MOHO.LT_AUDIO then print("audio layer")
	elseif layerType == MOHO.LT_UNKNOWN then print("unknown layer")
	else print (moho.layer:LayerType())
	end
end

