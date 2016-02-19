-- Makes a copy of an action for all sublayers in a group. Especially helpful for smartbones. 
-- Code must be custom modified. Suppose you have a smart bone action defined for a smooth head turn. 
-- It defines all movements for a mouth switch layer. You now want to create a second smart bone, quick turn,
-- that switches directly between front and 34 view. The smooth head turn is not needed, but you want to copy 
-- all of the mouth point movements to the new smart bone aciton. This is the script you need.
ScriptName = "msCopyActionAcrossGroup"
msCopyActionAcrossGroup = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msCopyActionAcrossGroup:Name()
	return "CopyActionAcrossGroup ... "
end

function msCopyActionAcrossGroup:Version()
	return "1.0"
end

function msCopyActionAcrossGroup:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Makes a copy of an action for all sublayers in a group. See code")
end

function msCopyActionAcrossGroup:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msCopyActionAcrossGroup:UILabel()
	return(MOHO.Localize("/Scripts/Menu/CopyActionAcrossGroup/CopyActionAcrossGroup=CopyActionAcrossGroup ... "))
end

function msCopyActionAcrossGroup:CopyAction(layer, srcAction, destinationAction)
	layer:ActivateAction(destinationAction)
	layer:InsertAction(srcAction, 0, false)
end
-- **************************************************
-- The guts of this script
-- **************************************************
function msCopyActionAcrossGroup:Run(moho)

	if moho.layer:IsGroupType() then
		local group = moho:LayerAsGroup(moho.layer)
		for i = 0, group:CountLayers()-1 do
			local layer = group:Layer(i)
			self:CopyAction(layer, "head turn 2", "quick turn 2")
		end
	else
		print(moho.layer:Name() .. " is not a group layer.")		
	end

	-- Close all actions
	moho.document:SetCurrentDocAction(nil)
end
