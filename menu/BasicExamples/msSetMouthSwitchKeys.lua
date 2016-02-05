ScriptName = "msSetMouthSwitchKeys"
msSetMouthSwitchKeys = {}

-- **************************************************
-- This information is displayed in help | About scripts ...
-- **************************************************
function msSetMouthSwitchKeys:Name()
	return "Set Mouth Switch Keys"
end

function msSetMouthSwitchKeys:Description()
	return MOHO.Localize("/Scripts/Menu/SetMouthSwitchKeys/Description=Set a few keys in a mouth switch layer")
end

function msSetMouthSwitchKeys:Version()
	return "1.0"
end

function msSetMouthSwitchKeys:Creator()
	return "Mitchel Soltys"
end


-- **************************************************
-- This is the Script label in the GUI
-- **************************************************

function msSetMouthSwitchKeys:UILabel()
	return(MOHO.Localize("/Scripts/Menu/SetMouthSwitchKeys/SetMouthSwitchKeys=Set Mouth Switch Keys"))
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msSetMouthSwitchKeys:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end


function msSetMouthSwitchKeys:Run(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

	local switchLayer = moho:LayerAsSwitch(moho.layer)
    local switch = switchLayer:SwitchValues()

	-- Delete keys on this layer from frame 1 to 10
	for i = 1, 10 do
		switch:DeleteKey(i)
	end

	-- This code assumes that we are on a mouth switch folder
	-- so AI, O and MBP are assumed to exist
	-- the first argument is the frame, the second the name
	-- of the switch layer.

	switch:SetValue(1, "AI")
	switch:SetValue(5,"O")
	switch:SetValue(10, "MBP")
end
