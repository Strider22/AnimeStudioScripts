ScriptName = "msPrintAnimation"
msPrintAnimation = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintAnimation:Name()
	return "Print Animation ..."
end

function msPrintAnimation:Version()
	return "1.0"
end

function msPrintAnimation:Description()
	return "Prints out animation information for the layer."
end

function msPrintAnimation:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintAnimation:UILabel()
	return "Print Animation ..."
end

function msPrintAnimation:MoveChannel(channel)
	for i = 0, channel:CountKeys()-1 do
		local frame = channel:GetKeyWhen(i)
		if frame > 0 then 
			channel:SetKeyWhen(i,frame + 5)
		end
	end
end

function msPrintAnimation:PrintChannels(moho, layer)
	for i = 0, layer:CountChannels()-2 do
		local chInfo = MOHO.MohoLayerChannel:new_local()
		layer:GetChannelInfo(i, chInfo)
		if (chInfo.subChannelCount == 1) then
			local ch = layer:Channel(i, 0, moho.document)
				-- print("Channel " .. i .. ": " .. chInfo.name:Buffer() .. " has "  .. ch:CountKeys() .. " Keyframes")
			if ch:CountKeys() > 1 then
				print("Channel " .. i .. ": " .. chInfo.name:Buffer() .. " Keyframes: " .. ch:CountKeys())
			end
		else
			print("Channel " .. i .. ": " .. chInfo.name:Buffer() .. " has subframes " )
			for subID = 0, chInfo.subChannelCount - 1 do
				local ch = moho.layer:Channel(i, subID, moho.document)
				if ch:CountKeys() > 1 then
					print("Sub Channel " .. subID .. " has " ..   ch:CountKeys() .. " Keyframes ")
				end
			end
		end
	end
end
-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintAnimation:Run(moho)
	local layer = moho.layer
	-- local channelInfo = MohoLayerChannel:new_local()
	-- print("num channels " .. layer:CountChannels())
	-- for i = 0, layer:CountChannels()-1 do
		-- local layer = layer:GetChannelInfo(i,channelInfo)
		-- print("channel info name " .. channelInfo.name)
	-- end
	-- print("layer key count " .. layer:CountLayerKeys())
	-- self:MoveChannel(layer.fTranslation)
	-- self:MoveChannel(layer.fRotationZ)
	-- self:MoveChannel(layer.fScale)
	print("layer key count " .. layer:CountLayerKeys())
	self:PrintChannels(moho, layer)
	print("Current action " .. layer:CurrentAction())
end
