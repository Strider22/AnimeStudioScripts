ScriptName = "msMoveChannels"
msMoveChannels = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msMoveChannels:Name()
	return "Move Channels ..."
end

function msMoveChannels:Version()
	return "1.0"
end

function msMoveChannels:Description()
	return "Moves all channels with animation 5 frames right."
end

function msMoveChannels:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msMoveChannels:UILabel()
	return "Move Channels ..."
end

function msMoveChannels:MoveChannel(channel, amountToMove)
	for i = 0, channel:CountKeys()-1 do
		local frame = channel:GetKeyWhen(i)
		if frame > 0 then 
			channel:SetKeyWhen(i,frame + amountToMove)
		end
	end
end

function msMoveChannels:MoveAllChannels(moho, layer)
	for i = 0, layer:CountChannels()-2 do
		local chInfo = MOHO.MohoLayerChannel:new_local()
		layer:GetChannelInfo(i, chInfo)
		if (chInfo.subChannelCount == 1) then
			local ch = layer:Channel(i, 0, moho.document)
			self:MoveChannel(ch, 24)
		else
			local moves = 1
			-- Subchannels aer things like points
			for subID = 0, chInfo.subChannelCount - 1 do
				local ch = moho.layer:Channel(i, subID, moho.document)
				if ch:CountKeys() > 1 then
					print(" sub channel " .. subID .. " keys  " .. ch:CountKeys())
					self:MoveChannel(ch, moves * 6)
					moves = moves + 1
				end
			end
		end
	end
end



-- **************************************************
-- The guts of this script
-- **************************************************
function msMoveChannels:Run(moho)
	local layer = moho.layer
	self:MoveAllChannels(moho, layer)
end
