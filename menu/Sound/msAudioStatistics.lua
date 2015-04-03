-- **************************************************
-- Generates statistics on the audio layer
-- **************************************************

ScriptName = "msAudioStatistics"

-- **************************************************
-- General information about this script
-- **************************************************

msAudioStatistics = {}

msAudioStatistics.BASE_STR = 2530

function msAudioStatistics:Name()
	return "Audio Statistics"
end

function msAudioStatistics:Version()
	return "6.0"
end

function msAudioStatistics:Description()
	return MOHO.Localize("/Scripts/Menu/AudioStatistics/Description=Generates statistics on an audio file.")
end

function msAudioStatistics:Creator()
	return "Mitchel Soltys"
end

function msAudioStatistics:UILabel()
	return(MOHO.Localize("/Scripts/Menu/AudioStatistics/LayerAudioStatistics=Audio Statistics"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msAudioStatistics:IsEnabled(moho)
	return (moho.layer:LayerType() == MOHO.LT_AUDIO) 
end


function msAudioStatistics:Run(moho)

	local audioLayer = moho:LayerAsAudio(moho.layer)
	
	msAudioLayer:Init(moho, audioLayer, true, 48, 60, 1, .3)
	msAudioLayer:OutOfTheBoxStatistics()
	msAudioLayer:CompareFrameToAudioTime(106)
	
	print("")
	print("Statistics available after initialization")
	print("origin " .. msAudioLayer:FrameOrigin())
	print("span time " .. msAudioLayer:SpanTime())
	print("span Frames " .. msAudioLayer:SpanFrames())
	print("span max Amp " .. msAudioLayer:SpanMaxAmplitude())
	print("span RMS audio amplitude " .. msAudioLayer:SpanRMSAmplitude()) 
	print("start frame " .. msAudioLayer.startFrame) 
	print("Frame Shift " .. msAudioLayer.frameShift) 
	print("startTime " .. msAudioLayer.startTime) 

	msAudioLayer:BuildAmplitudeList()
	msAudioLayer:DumpAmplitudes2()
	
	
	-- Choose one of the get min max approaches
	-- audioValues, maxAmp = msAudioLayer:GetMinMaxBigChange()
	audioValues, maxAmp = msAudioLayer:GetMinMaxListTurn()
	
	
	msAudioLayer:DumpMinMaxList(audioValues)
	msAudioLayer:DumpMaxAmp(maxAmp)
	msAudioLayer:MarkFrames(audioValues)

end
