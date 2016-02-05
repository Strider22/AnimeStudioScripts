-- playpen for trying things out
ScriptName = "msPrintActions"
msPrintActions = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPrintActions:Name()
	return "PrintActions ... "
end

function msPrintActions:Version()
	return "1.0"
end

function msPrintActions:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Removes transform from group and applies it to sub layers.")
end

function msPrintActions:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPrintActions:UILabel()
	return(MOHO.Localize("/Scripts/Menu/PrintActions/PrintActions=PrintActions ... "))
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msPrintActions:Run(moho)
		for i=0, moho.layer:CountActions()-1 do
			print(moho.layer:ActionName(i))
		end
end
