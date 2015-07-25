ScriptName = "msEx5StringManipulation"
msEx5StringManipulation = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msEx5StringManipulation:Name()
	return "5) String Manipulation..."
end

function msEx5StringManipulation:Version()
	return "1.0"
end

function msEx5StringManipulation:Description()
	return MOHO.Localize("/Scripts/Menu/Ex5StringManipulation/Description=Splits a string into words and prints it.")
end

function msEx5StringManipulation:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msEx5StringManipulation:UILabel()
	return(MOHO.Localize("/Scripts/Menu/StringManipulation/StringManipulation=5) String Manipulation..."))
end

-- Split a string into words. Print out each word
function msEx5StringManipulation:SplitStringIntoWords(myString)
	for i in string.gmatch(myString, "%S+") do
	  print(i)
	end
end

-- **************************************************
-- The guts of this script
-- **************************************************
function msEx5StringManipulation:Run(moho)
    msEx5StringManipulation:SplitStringIntoWords("This is my string to split into words")
end
