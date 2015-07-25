-- Moves the selected layer 1 unit in the x direction at frame 5
ScriptName = "msEx3TranslateLayer"
msEx3TranslateLayer = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEx3TranslateLayer:Name()
	return "3) Translate layer"
end

function msEx3TranslateLayer:Version()
	return "1.0"
end

function msEx3TranslateLayer:Description()
	return MOHO.Localize("/Scripts/Menu/Ex4TranslateLayer/Description=Moves the selected layer 1 unit in the x direction at frame 5.")
end

function msEx3TranslateLayer:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEx3TranslateLayer:UILabel()
	return(MOHO.Localize("/Scripts/Menu/TranslateLayer/TranslateLayer=3) Translate Layer"))
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msEx3TranslateLayer:Run(moho)
	print("Moving the layer 1 in x direction at frame 5")
	
	-- Get layer location at frame 0
	local layerLocation = LM.Vector3:new_local()
	layerLocation = moho.layer.fTranslation:GetValue(0)

	--Translate layer
    layerLocation.x = layerLocation.x + 1
	moho.layer.fTranslation:SetValue(5,layerLocation)
end

