-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msEx3TranslateLayer"

-- **************************************************
-- General information about this script
-- **************************************************

msEx3TranslateLayer = {}

function msEx3TranslateLayer:UILabel()
	return(MOHO.Localize("/Scripts/Menu/TranslateLayer/TranslateLayer=Ex3 Translate Layer"))
end


-- **************************************************
-- The guts of this script
-- **************************************************

function msEx3TranslateLayer:Run(moho)
	print("Moving the layer 1 in x at frame 5")
	
	-- Get layer location at frame 0
	local layerLocation = LM.Vector3:new_local()
	layerLocation = moho.layer.fTranslation:GetValue(0)

	--Translate layer
    layerLocation.x = layerLocation.x + 1
	moho.layer.fTranslation:SetValue(5,layerLocation)
end

