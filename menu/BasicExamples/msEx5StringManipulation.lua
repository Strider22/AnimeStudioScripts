
ScriptName = "msEx5StringManipulation"
msEx5StringManipulation = {}

function msEx5StringManipulation:UILabel()
	return(MOHO.Localize("/Scripts/Menu/StringManipulation/StringManipulation=Ex5 String Manipulation..."))
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
