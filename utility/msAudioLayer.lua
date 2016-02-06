-- Enhancement of the audio layer. 
-- Handles subset of the audio layer. 
-- Provides several key processing routines, including min max 
-- calculations

msAudioLayer = {}

-- Member variables
msAudioLayer.audioLayer = 0
msAudioLayer.startFrame = 0
msAudioLayer.endFrame = 0
msAudioLayer.useAllFrames = true
msAudioLayer.stepSize = 0
msAudioLayer.stepTime = 0

-- frameShift is the amount you much adjust the project 
-- frame to get the audio frame. Think of it as the
-- project origin in audio coordinates.
msAudioLayer.frameShift = 0

-- tolerance is used in min max calculations
-- variations less than the tolerance we ignore it
-- given in decimal of percentage
msAudioLayer.tolerance = .3

function msAudioLayer:Init(moho, audioLayer, useAllFrames, startFrame, endFrame, stepSize, tolerance)
    self.moho = moho
	self.audioLayer = audioLayer
	self.frameShift = audioLayer:TotalTimingOffset()
	self.useAllFrames = useAllFrames
  	if useAllFrames then
		self.startFrame = 1 - self.frameShift
		self.endFrame = self.startFrame + audioLayer:LayerDuration()
	else
		self.startFrame = startFrame
		self.endFrame = endFrame
	end
	self.stepSize = stepSize
	self.stepTime = self.stepSize/ moho.document:Fps()
	self.startTime = self:FrameToAudioTime(self.startFrame)
	self.tolerance = tolerance
end

function msAudioLayer:FrameToAudioTime(frame)
	return self.audioLayer:FrameToAudioTime(frame, 1/self.moho.document:Fps())
end

-- Comparison function to test out Anime Studio values
-- versus hand calculated values
function msAudioLayer:CompareFrameToAudioTime(frame)
	local duration = 1/self.moho.document:Fps()

	-- my calculation
    local audioTime = (frame -1 + self.frameShift)/self.moho.document:Fps()

	-- anime studio calculation
	local asAudioTime = self.audioLayer:FrameToAudioTime(frame,duration)
	
	print("")
	print("Comparison of calculations")
	print("audio Time "..audioTime)
	print("as audio Time "..asAudioTime)

	print("amp " .. self.audioLayer:GetAmplitude(audioTime,duration))
	print("max amp " .. self.audioLayer:GetAmplitude(audioTime,duration))
	
end

function msAudioLayer:DeleteLayerKeys()
	msHelper:DeleteLayerKeys(self.moho.layer, self.startFrame, self.endFrame)
end

-- Delete Keys, not on the audio layer, but on an associated
-- layer passed in 
function msAudioLayer:DeleteAssociatedKeys(layer)
	msHelper:DeleteLayerKeys(layer, self.startFrame, self.endFrame)
end


-- Returns the frame where the audio starts
function msAudioLayer:FrameOrigin()
    return 1 - self.frameShift
end

-- Returns the number of frames associated with 
-- the editable region
function msAudioLayer:SpanFrames()
	return self.endFrame - self.startFrame
end

-- Returns time associated with 
-- the editable region
function msAudioLayer:SpanTime()
	return self:SpanFrames() / self.moho.document:Fps()
end

-- Not actually the best function
-- wraps the moho routine, but better to use GetMinMaxList to 
-- determine max as seen in the Anime Studio UI
function msAudioLayer:SpanMaxAmplitude()
	return self.audioLayer:GetMaxAmplitude(self.startTime, self:SpanTime())
end

function msAudioLayer:SpanRMSAmplitude()
	return self.audioLayer:GetRMSAmplitude(self.startTime, self:SpanTime())
end

function msAudioLayer:AmplitudeAt(audioTime)
	return self.audioLayer:GetAmplitude(audioTime, self.stepTime)
end

-- not currently used but added if needed
function msAudioLayer:RMSAmplitudeAt(audioTime)
	return self.audioLayer:GetRMSAmplitude(audioTime, self.stepTime)
end


-- Creates a list of results of audio sampling
-- also generates overll statistics
-- Runs through the editable audio section 
-- and applies the operation at each point 
function msAudioLayer:BuildAmplitudeList()
    local audioTime = self.startTime
	local list = {}
	local maxAmp = {frame = 0, amp = 0}
	local minAmp = {frame = 0, amp = 1000}
	local totalAmp = 0
	local i = 1
	local amp

	for frame = self.startFrame, self.endFrame, self.stepSize do
		amp = self:AmplitudeAt(audioTime)
		msHelper:Debug("frame " .. frame .. " amp " .. amp)
	
		list[i] = {frame = frame, amp = amp}
		totalAmp = totalAmp + amp
		if amp > maxAmp.amp then
			maxAmp.amp = amp
			maxAmp.frame = frame
		end
		if amp < minAmp.amp then
			minAmp.amp = amp
			minAmp.frame = frame
		end
		i = i + 1
		audioTime = audioTime + self.stepTime
	end
	self.amplitudeList = list
	self.maxAmp = maxAmp
	self.minAmp = minAmp
	self.averageAmp = totalAmp/i
	if(msHelper.debug) then
		self:DumpAmplitudes2()
	end;
end


-- Simple marking of audio layer just to see
-- the where frames are. Used for debugging
-- For a maximum mark it as a layer translation
-- For a minimum mark it as a layer rotation
function msAudioLayer:MarkFrames(audioValues)
	local baseOffset = self.moho.layer.fTranslation.value
	local angle = 0
	for k,v in ipairs(audioValues) do
		if v.type == "Max" then
			self.moho.layer.fTranslation:SetValue(v.frame, baseOffset)
		elseif v.type == "Min" then
			self.moho.layer.fRotationZ:SetValue(v.frame, 0)
		end
	end
end


-- Returns a list of all min max amplitude points in 
--   fields (frame, type, amp)
-- the editable audio region
-- Also returns a table of the max amplitude in the section
--   fields (frame, amp) 
function msAudioLayer:GetMinMaxListBigChange()

	msHelper:Debug("In GetMinMaxListBigChange");
	-- Get the amplitudes and min max
	self:BuildAmplitudeList()

	local list = {}
	local direction = 1
	-- weight is easier to multiply, tolerance is easier for the user
	-- to understand
	local weight = 1 - self.tolerance 
	local amp 
	local watermark = 0
	local downWaterMark = 0
	local downWaterMarkFrame = 0
	local watermarkFrame = 0
	local i = 1

	-- Calculation Algorithm
	for k,v in ipairs(self.amplitudeList) do
		amp = v.amp
		frame = v.frame
		if (direction == 1) then
			-- watermark increasing
			if amp > watermark then 
				watermark = amp
				watermarkFrame = frame
			-- Significant drop
			elseif amp < (weight * watermark) then
				list[i] = {["frame"] = watermarkFrame, 
					["type"] = "Max",
					["amp"] = watermark}
				i = i + 1
				-- mark big down tick
				list[i] = {["frame"] = frame, 
					["type"] = "Min",
					["amp"] = amp}
				i = i + 1
				downWaterMark = amp
				downWaterMarkFrame  = frame
				watermarkFrame = frame
				watermark = amp
				direction = -1
			end
		else 
			msHelper:Debug("dwm " .. (downWaterMark - amp) .. " size " .. self.tolerance * self.maxAmp.amp .. " frame " .. frame)
			-- Mark significant drops
			if ((downWaterMark - amp) > (self.tolerance * self.maxAmp.amp )) then
				list[i] = {["frame"] = frame, 
					["type"] = "Min",
					["amp"] = amp}
				i = i + 1
				msHelper:Debug("mark amp " ..  amp .. " frame " .. frame)
				downWaterMark = amp
				downWaterMarkFrame = frame
			end
			-- track reduction in amplitude
			if amp < watermark then 
				watermark = amp
				watermarkFrame = frame
			-- Mark big uptick and change direction
			elseif (amp * weight) >  watermark then
				list[i] = {["frame"] = downWaterMarkFrame, 
					["type"] = "Min",
					["amp"] = downWaterMark}
				i = i + 1
				watermarkFrame = frame
				watermark = amp
				direction = 1
			end
		end
	end
	if(msHelper.debug) then
		self:DumpMinMaxList(list);
	end;
	return list, self.maxAmp
	
end

-- Trying to find the global min max values.
-- Mark min or max only if the difference is greater than tolerance
-- Tolerance expected to be 50% or greater
function msAudioLayer:GetTrueMinMaxList()

	msHelper:Debug("In GetTrueMinMaxList");
	-- Get the amplitudes and min max
	self:BuildAmplitudeList()

	local list = {}
	local direction = 1
	local significantShift = (self.maxAmp.amp - self.minAmp.amp) * self.tolerance 
	local amp 
	local watermark = 0
	local watermarkFrame = 0
	local i = 1

	msHelper:Debug("significantShift " .. significantShift)
	-- Calculation Algorithm
	for k,v in ipairs(self.amplitudeList) do
		amp = v.amp
		frame = v.frame
		if (direction == 1) then
			msHelper:Debug("Direction up")
			if amp > watermark then 
				msHelper:Debug("watermark increasing - searching for max")
				watermark = amp
				watermarkFrame = frame
			-- Significant drop
			elseif (watermark - amp) > significantShift then
				msHelper:Debug("DownTurn from frame " .. watermarkFrame .. " to " .. frame)
				list[i] = {["frame"] = watermarkFrame, 
					["type"] = "Max",
					["amp"] = watermark}
				i = i + 1
				watermarkFrame = frame
				watermark = amp
				direction = -1
			end
		else 
			msHelper:Debug("Direction down")
			-- Mark significant drops
			if amp < watermark then 
				msHelper:Debug("watermark decreasing - searching for min")
				watermark = amp
				watermarkFrame = frame
			-- Significant increase
			elseif (amp - watermark) > significantShift then
				msHelper:Debug("Upturn from frame " .. watermarkFrame .. " to " .. frame)
				list[i] = {["frame"] = watermarkFrame, 
					["type"] = "Min",
					["amp"] = watermark}
				i = i + 1
				watermarkFrame = frame
				watermark = amp
				direction = 1
			end
		end
	end
	if(msHelper.debug) then
		self:DumpMinMaxList(list);
	end;
	return list, self.maxAmp
	
end

-- Create a min max list where change is a significant turn
-- Consider a min or max only when you go a significant amount
-- in the direction opposite of where you're headed .
function msAudioLayer:GetMinMaxListBigChange2()

	msHelper:Debug("In GetMinMaxListBigChange2");
	-- Get the amplitudes and min max
	self:BuildAmplitudeList()

	local list = {}
	local direction = 1
	-- weight is easier to multiply, tolerance is easier for the user
	-- to understand
	local significantShift = (self.maxAmp.amp - self.minAmp.amp) * self.tolerance 
	local amp 
	local watermark = 0
	local watermarkFrame = 0
	local i = 1

	msHelper:Debug("significantShift " .. significantShift)
	-- Calculation Algorithm
	for k,v in ipairs(self.amplitudeList) do
		amp = v.amp
		frame = v.frame
		if (direction == 1) then
			msHelper:Debug("Direction up")
			if amp > watermark then 
				msHelper:Debug("watermark increasing - searching for max")
				watermark = amp
				watermarkFrame = frame
			-- Significant drop
			elseif (watermark - amp) > significantShift then
				msHelper:Debug("DownTurn from frame " .. watermarkFrame .. " to " .. frame)
				list[i] = {["frame"] = watermarkFrame, 
					["type"] = "Max",
					["amp"] = watermark}
				i = i + 1
				-- mark big down tick
				list[i] = {["frame"] = frame, 
					["type"] = "Min",
					["amp"] = amp}
				i = i + 1
				watermarkFrame = frame
				watermark = amp
				direction = -1
			end
		else 
			msHelper:Debug("Direction down")
			-- Mark significant drops
			if ((watermark - amp) > significantShift ) then
				msHelper:Debug("Significant drop " .. watermarkFrame .. " to " .. frame)
				list[i] = {["frame"] = frame, 
					["type"] = "Min",
					["amp"] = amp}
				i = i + 1
				watermark = amp
				watermarkFrame = frame
			end
			-- track reduction in amplitude
			if amp < watermark then 
				watermark = amp
				watermarkFrame = frame
			-- Mark big uptick and change direction
			elseif (amp - watermark) >  significantShift then
				list[i] = {["frame"] = watermarkFrame, 
					["type"] = "Min",
					["amp"] = watermark}
				i = i + 1
				watermarkFrame = frame
				watermark = amp
				direction = 1
			end
		end
	end
	if(msHelper.debug) then
		self:DumpMinMaxList(list);
	end;
	return list, self.maxAmp
	
end



-- Returns a list of all min max amplitude points in 
--   fields (frame, type, amp)
-- the editable audio region
-- Also returns a table of the max amplitude in the section
--   fields (frame, amp) 
function msAudioLayer:GetMinMaxListTurn()

	msHelper:Debug("In GetMinMaxListTurn");
	-- Get the amplitudes and min max
	self:BuildAmplitudeList()

	local list = {}
	local direction = 1
	-- weight is easier to multiply, tolerance is easier for the user
	-- to understand
	local weight = 1 - self.tolerance 
	local amp 
	local watermark = 0
	local watermarkFrame = 0
	local i = 1

	-- Calculation Algorithm
	for k,v in ipairs(self.amplitudeList) do
		amp = v.amp
		frame = v.frame
		if (direction == 1) then
			-- watermark increasing
			if amp > watermark then 
				watermark = amp
				watermarkFrame = frame
			-- Significant drop
			elseif amp < (weight * watermark) then
				-- mark trailing when there's a change down.
				-- and the previous amplitude is > 10%
				if( watermark > .1 * self.maxAmp.amp) then 
					list[i] = {["frame"] = watermarkFrame, 
						["type"] = "Max",
						["amp"] = watermark}
					i = i + 1
				end
				watermarkFrame = frame
				watermark = amp
				direction = -1
			end
		else 
			msHelper:Debug("wm " .. (amp * weight) - watermark .. " amp " .. amp - (.1 *  self.maxAmp.amp) .. " frame " .. frame)
			-- track reduction in amplitude
			if amp < watermark then 
				watermark = amp
				watermarkFrame = frame
			-- Mark big uptick and amp > 10%
			elseif (amp * weight) >  watermark then
				if( amp > .1 * self.maxAmp.amp) then 
					list[i] = {["frame"] = watermarkFrame, 
						["type"] = "Min",
						["amp"] = watermark}
					i = i + 1
					direction = 1
				end
				watermarkFrame = frame
				watermark = amp
			end
		end
	end
	if(msHelper.debug) then
		self:DumpMinMaxList(list);
	end;
	return list, self.maxAmp
	
end


function msAudioLayer:DumpMinMaxList(table)
	print(" ")
	print("Min Max list")
	for k,v in pairs(table) do
		print("frame " .. v.frame .. " type " .. v.type .. " amp " .. v.amp)
	end
end

function msAudioLayer:DumpAudioList(table)
	print(" ")
	print("Audio List")
	for k,v in ipairs(table) do
		print("frame " .. v.frame ..  " amp " .. v.amp)
	end
end

function msAudioLayer:DumpMaxAmp(maxAmp)
	print(" ")
	print("Max Amp")
	print("frame " .. maxAmp.frame .. " amp " .. maxAmp.amp)
end


function msAudioLayer:DumpNestedTable(table)
	if table == nil then
		print ("table is nil ")
	end
	for k,v in pairs(table) do
		if k == nil then
			print("k is nil")
		end
		if v == nil then  
			print("v is nil")
		end
		if v ~= nil then
			self.DumpTable(nil,v)
		end
	end
	-- print("leaving DumpNestedTable")
end

function msAudioLayer:DumpTable(table)
	if table == nil then
		print ("table is nil ")
	end
	for k,v in pairs(table) do
		if k == nil then
			print("k is nil")
		end
		if v == nil then  
			print("v is nil")
		end
		print(k .. " " .. v)
	end
	print("")
	-- print("leaving loop")
end

function msAudioLayer:Dump()
  print("frameShift " .. self.frameShift)
  print("start " .. self.startFrame)
  print("endFrame " .. self.endFrame)
  print("stepSize " .. self.stepSize)
  print("timeStep " .. self.stepTime)
end

function msAudioLayer:DumpAmplitudes2()
	print("")
	print("Max Amp is " .. self.maxAmp.amp .. " at frame " .. self.maxAmp.frame)
	print("Min Amp is " .. self.minAmp.amp .. " at frame " .. self.minAmp.frame)
	print("Average Amp is " .. self.averageAmp)
	print("")
	print("Audio Amplitudes")
	for k,v in ipairs(self.amplitudeList) do
		print("frame " .. v.frame .. " amp " .. v.amp)
	end
end

function msAudioLayer:OutOfTheBoxStatistics()
	local audioDuration = self.audioLayer:LayerDuration()/self.moho.document:Fps()
	print("Out of the box statistics")
	print("Duration in frames " .. self.audioLayer:LayerDuration())
	print("Duration in seconds " .. audioDuration)
	print("")
	print("The following statistics are based on the entire audio layer")
	print("Maximum audio amplitude " .. self.audioLayer:MaxAmplitude())
	print("RMS audio amplitude " .. self.audioLayer:GetRMSAmplitude(0, audioDuration)) 
	print("Max audio amplitude " .. self.audioLayer:GetMaxAmplitude(0, audioDuration)) 
end


-- **************************************************************
--
--                    Deprecated methods
-- 
-- **************************************************************
function msAudioLayer:Amplitude(audioTime, duration)
	return msAudioLayer.audioLayer:GetAmplitude(audioTime, duration)
end


-- Runs through the editable audio section 
-- and applies the operation at each point 
function msAudioLayer:ProcessAudio(operation)
    audioTime = (self.startFrame -1 + self.frameShift)/self.moho.document:Fps();
	for frame = self.startFrame, self.endFrame, self.stepSize do
		amp = self.audioLayer:GetAmplitude(audioTime, self.stepTime)
		operation(nil, frame, amp)
		audioTime = audioTime + self.stepTime
	end
end

function msAudioLayer:DumpAmplitude(frame, amp)
	print("frame " .. frame .. " amp " .. amp)
end

function msAudioLayer:DumpAmplitudes()
	print("This funciton is deprecated see DumpAmplitudes2")
	print("Audio Amplitudes")
	self:ProcessAudio(self.DumpAmplitude)
end


