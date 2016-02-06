ScriptName = "msDeleteAnimation"
msDeleteAnimation = {}
-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msDeleteAnimation:Name()
	return "Delete Animation ..."
end

function msDeleteAnimation:Version()
	return "1.0"
end

function msDeleteAnimation:Description()
	return "Deletes animation from selected layers, starting with the current Frame."
end

function msDeleteAnimation:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msDeleteAnimation:UILabel()
	return "Delete Animation ..."
end


function msDeleteAnimation:DeleteAnimation(destLayer, frame)
	destLayer:ClearAnimation(true,frame,false)
end


-- **************************************************
-- The guts of this script
-- **************************************************
function msDeleteAnimation:Run(moho)
	local layer = moho.layer
	self.moho = moho
	moho.document:SetDirty()

	for i = 0, moho.document:CountSelectedLayers()-1 do
		local layer = moho.document:GetSelectedLayer(i)
		self:DeleteAnimation(layer, layer:CurFrame())
	end
end
