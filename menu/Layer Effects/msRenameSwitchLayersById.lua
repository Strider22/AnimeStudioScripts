-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msRenameSwitchLayersById"

-- **************************************************
-- General information about this script
-- **************************************************

msRenameSwitchLayersById = {}

function msRenameSwitchLayersById:Name()
	return "Rename Switch Layers By Id"
end

function msRenameSwitchLayersById:Description()
	return(MOHO.Localize("/Scripts/Menu/RenameById/Description=Renames layers under a switch layers based on their id"))
end

function msRenameSwitchLayersById:Version()
	return "1.0"
end

function msRenameSwitchLayersById:Creator()
	return "Mitchel Soltys"
end


function msRenameSwitchLayersById:UILabel()
	return(MOHO.Localize("/Scripts/Menu/RenameById/RenameById=Rename Switch Layers By Id"))
end

	
-- **************************************************
-- The guts of this script
-- **************************************************

function msRenameSwitchLayersById:Run(moho)
	if moho.layer:LayerType() == MOHO.LT_SWITCH then
		local layerCount = moho.layer:CountLayers()
		for i=0,layerCount-1,1 do
			-- Use the following line if you want to start at 1
			-- moho.layer:Layer(i):SetName("Layer ".. i+1)
			moho.layer:Layer(i):SetName("Layer ".. i)
		end
	else 
		print ("The selected layer is not a switch layer")
	end
end

