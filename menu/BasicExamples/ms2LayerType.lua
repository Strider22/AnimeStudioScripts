ScriptName = "msEx2LayerType"
msEx2LayerType = {}

function msEx2LayerType:UILabel()
	-- The label is localized for multiple language support
	return(MOHO.Localize("/Scripts/Menu/layerType/layerType=2) Layer type"))
end

function msEx2LayerType:ListLayerTypes()
	print("The layer types are ")
	print("MOHO.LT_UNKNOWN " .. MOHO.LT_UNKNOWN)
	print("MOHO.LT_VECTOR " .. MOHO.LT_VECTOR)
	print("MOHO.LT_IMAGE " .. MOHO.LT_IMAGE)
	print("MOHO.LT_GROUP " .. MOHO.LT_GROUP)
	print("MOHO.LT_BONE " .. MOHO.LT_BONE)
	print("MOHO.LT_SWITCH " .. MOHO.LT_SWITCH)
	print("MOHO.LT_PARTICLE " .. MOHO.LT_PARTICLE)
	print("MOHO.LT_NOTE " .. MOHO.LT_NOTE)
	print("MOHO.LT_3D " .. MOHO.LT_3D)
	print("MOHO.LT_AUDIO " .. MOHO.LT_AUDIO)
	print("MOHO.LT_PATCH " .. MOHO.LT_PATCH)
	print("MOHO.LT_TEXT " .. MOHO.LT_TEXT)
end
-- **************************************************
-- The guts of this script
-- **************************************************

function msEx2LayerType:Run(moho)
    msEx2LayerType:ListLayerTypes()
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

