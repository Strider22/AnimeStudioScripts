-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msChannelInfo"

-- **************************************************
-- General information about this script
-- **************************************************

msChannelInfo = {}

function msChannelInfo:Name()
	return "List Channels"
end

function msChannelInfo:Version()
	return "8.0"
end

function msChannelInfo:Description()
	return MOHO.Localize("/Scripts/Menu/ListChannels/Description=Lists all the animation channels in the selected layer")
end

function msChannelInfo:Creator()
	return "Mitchel Soltys"
end

function msChannelInfo:UILabel()
	return(MOHO.Localize("/Scripts/Menu/ListChannels/ListChannels=List Channels"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msChannelInfo:Run(moho)
	local numCh = moho.layer:CountChannels()
	print(MOHO.Localize("/Scripts/Menu/ListChannels/NumberOfChannels=Number of animation channels in current layer: ") .. numCh)
	local numKeys = moho.layer:CountLayerKeys()
	print(MOHO.Localize("/Scripts/Menu/ListChannels/NumberOfChannels=number of layer keys: ") .. numKeys)

	-- for i = 0, numCh - 2 do
		-- local chInfo = MOHO.MohoLayerChannel:new_local()
		-- moho.layer:GetChannelInfo(i, chInfo)
		-- if (chInfo.subChannelCount == 1) then
			-- local ch = moho.layer:Channel(i, 0, moho.document)
			-- print(MOHO.Localize("/Scripts/Menu/ListChannels/Channel=Channel ") .. i .. ": " .. chInfo.name:Buffer() .. MOHO.Localize("/Scripts/Menu/ListChannels/Keyframes= Keyframes: ") .. ch:CountKeys())
		-- else
			-- print(MOHO.Localize("/Scripts/Menu/ListChannels/Channel=Channel ") .. i .. ": " .. chInfo.name:Buffer())
			-- for subID = 0, chInfo.subChannelCount - 1 do
				-- local ch = moho.layer:Channel(i, subID, moho.document)
				-- print(MOHO.Localize("/Scripts/Menu/ListChannels/SubChannel=    Sub-channel ") .. subID .. MOHO.Localize("/Scripts/Menu/ListChannels/Keyframes= Keyframes: ") .. ch:CountKeys())
			-- end
		-- end
	-- end
end
