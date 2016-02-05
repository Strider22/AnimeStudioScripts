-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "LM_Automation"

-- **************************************************
-- General information about this script
-- **************************************************

LM_Automation = {}

function LM_Automation:Name()
	return "Automation Test"
end

function LM_Automation:Version()
	return "8.0"
end

function LM_Automation:Description()
	return MOHO.Localize("/Scripts/Menu/Automation/Description=Automation test script")
end

function LM_Automation:Creator()
	return "Smith Micro Software, Inc."
end

function LM_Automation:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Automation/AutomationTest=Automation Test"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function LM_Automation:Run(moho)
	--[[
	First up, examples of simple, single file operations.
	]]

	-- Create a new document
	--moho:FileNew()
	
	-- Open an existing document
	--moho:FileOpen("/AutomationTest.anme")
	
	-- Save the current document
	--moho:FileSave()
	
	-- Save the current document to a specified location
	--moho:FileSaveAs("/TestSave.anme")
	
	-- Render the current frame of the current document
	--moho:FileRender("/TestRender.png")
	
	--[[
	Next, scan an entire directory and render out a frame of each document in that directory
	]]
	
	if (LM.GUI.Alert(LM.GUI.ALERT_INFO,
		MOHO.Localize("/Scripts/Menu/Automation/Alert1=This script will scan all the files in a directory."),
		MOHO.Localize("/Scripts/Menu/Automation/Alert2=It will open each file, render a single frame, and move on to the next."),
		nil,
		MOHO.Localize("/Scripts/OK=OK"),
		MOHO.Localize("/Scripts/Cancel=Cancel"),
		nil) == 1) then
		return
	end

	local path = LM.GUI.OpenFile(MOHO.Localize("/Scripts/Menu/Automation/SelectProjectFile=Select Project File"))
	if (path == "") then
		return
	end

	path = string.reverse(path)
	local sepPos = string.find(path, "/")
	if (sepPos == nil) then
		sepPos = string.find(path, "\\")
	end
	if (sepPos == nil) then
		return
	end

	local scanDir = string.sub(path, sepPos + 1)
	scanDir = string.reverse(scanDir)
	--print(scanDir)

	moho:BeginFileListing(scanDir)
	local fileName = moho:GetNextFile()
	while fileName ~= nil do
		sepPos = string.find(fileName, ".", 1, true)
		if (sepPos ~= nil) then
			local extn = string.sub(fileName, sepPos + 1)
			if (extn == "anme") then
				fileName = scanDir .. "/" .. fileName
				--print(fileName)
				moho:FileOpen(fileName)
				fileName = string.reverse(fileName)
				sepPos = string.find(fileName, ".", 1, true)
				fileName = string.sub(fileName, sepPos)
				fileName = string.reverse(fileName) .. "png"
				--print(fileName)
				moho:FileRender(fileName)
			end
		end
		
		fileName = moho:GetNextFile()
	end
	moho:FileNew()
end
