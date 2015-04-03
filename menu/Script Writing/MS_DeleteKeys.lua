-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "MS_DeleteKeys"

-- **************************************************
-- General information about this script
-- **************************************************

MS_DeleteKeys = {}

function MS_DeleteKeys:Name()
	return "Apply Switch Data"
end

function MS_DeleteKeys:Version()
	return "6.0"
end

function MS_DeleteKeys:Description()
	return MOHO.Localize("/Scripts/Menu/DeleteKeys/Description=Simple Shell to test different scripting ideas")
end

function MS_DeleteKeys:Creator()
	return "Mitchel Soltys"
end

function MS_DeleteKeys:UILabel()
	return(MOHO.Localize("/Scripts/Menu/DeleteKeys/DeleteKeys=Test Script"))
end


-- **************************************************
-- The guts of this script
-- **************************************************

-- function MS_DeleteKeys:IsEnabled(moho)
    -- return (moho.layer:LayerType() == MOHO.LT_SWITCH)
-- end


-- **************************************************
-- Deletes Keys based on a AnimChannel
-- **************************************************
function MS_DeleteKeys:DeleteAnimKeys(AnimChannel, startFrame, endFrame)
	for frame = startFrame, endFrame do
		AnimChannel:DeleteKey(frame)
	end
end

-- **************************************************
-- Deletes Keys based on a mohoLayer
-- I don't know about recursive, but that may refer to layer nesting
-- **************************************************
function MS_DeleteKeys:DeleteLayerKeys(mohoLayer, startFrame, endFrame, isResursive)
	for frame = startFrame, endFrame do
		mohoLayer:DeleteKeysAtFrame(isRecursive,frame)
	end
end

function MS_DeleteKeys:Run(moho)

    -- local switchLayer = moho:LayerAsSwitch(moho.layer)
    -- local switch = switchLayer:SwitchValues()
	
	-- self:DeleteAnimKeys(switch, 24, 48)
	self:DeleteLayerKeys(moho.layer, 24, 48, true)
	self:DeleteLayerKeys(moho.layer, 48, 72, false)

end
