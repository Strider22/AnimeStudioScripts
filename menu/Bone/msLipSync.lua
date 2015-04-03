-- **************************************************
-- Reads a dialog file and generates bone angles 
-- required to generate automated lip sync
-- **************************************************

ScriptName = "msLipSync"

-- **************************************************
-- General information about this script
-- **************************************************

msLipSync = {}

msLipSync.BASE_STR = 2530

function msLipSync:Name()
	return "MS Lip Sync"
end

function msLipSync:Version()
	return "6.0"
end

function msLipSync:Description()
	return MOHO.Localize("/Scripts/Menu/LipSync/Description=Uses a dialog file to control the phoneme bone's movement.")
end

function msLipSync:Creator()
	return "Mitchel Soltys"
end

function msLipSync:UILabel()
	return(MOHO.Localize("/Scripts/Menu/BoneSound/LipSync=Lip Sync ..."))
end

-- **************************************************
-- Recurring values
-- **************************************************

msLipSync.audioLayer = 0
msLipSync.magnitude = 90
msLipSync.stepSize = 2

-- **************************************************
-- Bone Sound dialog
-- **************************************************

local msLipSyncDialog = {}

function msLipSyncDialog:new(moho)
	local d = LM.GUI.SimpleDialog(MOHO.Localize("/Scripts/Menu/BoneSound/Title=Lip Sync"), msLipSyncDialog)
	local l = d:GetLayout()

	d.moho = moho

	l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/BoneSound/SelectAudioLayer=Select audio layer:")), LM.GUI.ALIGN_LEFT)
	d.menu = LM.GUI.Menu(MOHO.Localize("/Scripts/Menu/BoneSound/SelectAudioLayer=Select audio layer:"))
	for i = 0, moho:CountAudioLayers() - 1 do
		local audioLayer = moho:GetAudioLayer(i)
		d.menu:AddItem(audioLayer:Name(), 0, MOHO.MSG_BASE + i)
	end
	d.menu:SetChecked(MOHO.MSG_BASE, true)

	d.popup = LM.GUI.PopupMenu(256, true)
	d.popup:SetMenu(d.menu)
	l:AddChild(d.popup)

	l:PushH(LM.GUI.ALIGN_CENTER)
		l:PushV()
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/BoneSound/MaxAngle=Max angle")), LM.GUI.ALIGN_LEFT)
			l:AddChild(LM.GUI.StaticText(MOHO.Localize("/Scripts/Menu/BoneSound/FrameStep=Frame step")), LM.GUI.ALIGN_LEFT)
		l:Pop()
		l:PushV()
			d.magnitude = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_FLOAT)
			l:AddChild(d.magnitude)
			d.stepSize = LM.GUI.TextControl(0, "0.0000", 0, LM.GUI.FIELD_UINT)
			l:AddChild(d.stepSize)
		l:Pop()
	l:Pop()

	return d
end

function msLipSyncDialog:UpdateWidgets()
	self.menu:SetChecked(MOHO.MSG_BASE, true)
	self.magnitude:SetValue(msLipSync.magnitude)
	self.stepSize:SetValue(msLipSync.stepSize)
end

function msLipSyncDialog:OnValidate()
	local b = true
	if (not self:Validate(self.magnitude, -3600, 3600)) then
		b = false
	end
	if (not self:Validate(self.stepSize, 1, 1000)) then
		b = false
	end
	return b
end

function msLipSyncDialog:OnOK()
	msLipSync.audioLayer = self.menu:FirstChecked()
	msLipSync.magnitude = self.magnitude:FloatValue()
	msLipSync.stepSize = self.stepSize:FloatValue()
end

-- **************************************************
-- The guts of this script
-- **************************************************

function msLipSync:IsEnabled(moho)
	if (moho.layer:LayerType() ~= MOHO.LT_BONE) then
		return false
	end
	if (moho:CountSelectedBones() < 1) then
		return false
	end
	return true
end

function msLipSync:replaceDoubles(str)
	str = string.gsub(str,"ee","e")
	str = string.gsub(str,"ea","e")
	str = string.gsub(str,"ai","a")
	str = string.gsub(str,"qu","w")
	str = string.gsub(str,"ed","d")
	str = string.gsub(str,"y","e")
	str = string.gsub(str,"br","b")
	str = string.gsub(str,"ck","k")
	str = string.gsub(str,"ch","k")
	str = string.gsub(str,"sh","s")
	str = string.gsub(str,"oa","o")
	str = string.gsub(str,"ey","e")
	str = string.gsub(str,"fr","f")
	str = string.gsub(str,"dr","d")
	str = string.gsub(str,"er","r")
	str = string.gsub(str,"wh","w")
	str = string.gsub(str,"ou","o")
	str = string.gsub(str,"re","r")
	str = string.gsub(str,"oi","o")
	str = string.gsub(str,"ow","o")
	str = string.gsub(str,"ay","a")
	str = string.gsub(str,"","")
	-- str = string.gsub(str,"","")
	return str
end

function msLipSync:angles()
end
-- function msLipSync:phonemeList(str)
	-- local list={}
	-- local lookAhead
	-- for i=1,string.len(str),1 do
		-- if     v == "a" then print("aah")
		-- elseif v == "e" then print("eee")
		-- elseif v == "i" then print("e")
		-- elseif v == "c" then print("etc")
		-- elseif v == "t" then print("tee")
		-- elseif v == "b" then print("mbp")
		-- elseif v == "d" then print("etc")
		-- elseif v == "j" then print("etc")
		-- elseif v == "k" then print("etc")
		-- elseif v == "s" then print("etc")
		-- elseif v == "w" then print("w")
		-- elseif v == "f" then print("eff")
		-- elseif v == "g" then print("gee")
		-- elseif v == "h" then print("aych")
		-- elseif v == "l" then print("el")
		-- elseif v == "m" then print("em")
		-- elseif v == "n" then print("en")
		-- elseif v == "o" then print("ooh")
		-- elseif v == "p" then print("pee")
		-- elseif v == "q" then print("queue")
		-- elseif v == "r" then print("arr")
		-- elseif v == "u" then print("you")
		-- elseif v == "v" then print("vee")
		-- elseif v == "x" then print("ex")
		-- elseif v == "y" then print("why")
		-- elseif v == "z" then print(is_canadian and "zed" or "zee")
		-- elseif v == "?" then print(is_canadian and "eh" or "")
		-- else                 print("blah")
    -- end

	-- end

-- end

function msLipSync:Run(moho)
	-- local skel = moho:Skeleton()
	-- if (skel == nil) then
		-- return
	-- end
	local path = LM.GUI.OpenFile("Select Data File")
	if (path == "") then
		return
	end

	local f = io.open(path, "r")
	if (f == nil) then
		return
	end

	print( "path" .. path.. "in msLipSync");
	-- ask user for the angle offset magnitude
	-- local dlog = msLipSyncDialog:new(moho)
	-- if (dlog:DoModal() == LM.GUI.MSG_CANCEL) then
		-- return
	-- end

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	local cmd = f:read()

	local startFrame = 54
	local endFrame = 120
	print("3 character " .. string.sub(cmd,3,3))
	
	while (cmd ~= nil) do
		print(cmd)
		local frameStep = (endFrame - startFrame)/string.len(cmd)
		print("string length = " .. string.len(cmd))
		print("frame step " .. frameStep)
		for i in string.gmatch(cmd, "%S+") do
		    print(self:replaceDoubles(string.lower(i)))
		end

--		print(string.sub(cmd, 1, 6))
		-- if (string.sub(cmd, 1, 6) == "moveto") then
			-- v.x = f:read("*n")
			-- v.y = f:read("*n")
			-- mesh:AddLonePoint(v, moho.layerFrame)
		-- elseif (string.sub(cmd, 1, 7) == "curveto") then
			-- v.x = f:read("*n")
			-- v.y = f:read("*n")
			-- mesh:AppendPoint(v, moho.layerFrame)
		-- end

		cmd = f:read()
	end

	f:close()

end
