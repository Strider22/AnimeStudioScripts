-- playpen for trying things out
ScriptName = "msTransformationTest"
msTransformationTest = {}
msTransformationTest.matrix = LM.Matrix:new_local()

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msTransformationTest:Name()
	return "TransformationTest ... "
end

function msTransformationTest:Version()
	return "1.0"
end

function msTransformationTest:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Removes transform from group and applies it to sub layers.")
end

function msTransformationTest:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msTransformationTest:UILabel()
	return(MOHO.Localize("/Scripts/Menu/TransformationTest/TransformationTest=TransformationTest ... "))
end




-- **************************************************
-- The guts of this script
-- **************************************************
function msTransformationTest:Run(moho)
	local vector = LM.Vector2:new_local()
    vector.x = 0
    vector.y = 0
	-- puts origin at middle of image, whereever it is
	-- moho.layer:SetOriginWithTransformCorrection(vector)
	-- puts origin at middle of image, but image is off somehwere
	local matrix = LM.Matrix:new_local()
	matrix:Translate(1,0,0)
	matrix:Transform(vector)
	moho.layer:SetOrigin(vector)
	-- local group = moho:LayerAsGroup(moho.layer)
	-- group:GetLayerTransform(0,matrix,moho.document)
	-- for i = 0, group:CountLayers()-1 do
		-- local layer = group:Layer(i)
	-- end

end
