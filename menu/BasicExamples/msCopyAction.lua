-- playpen for trying things out
ScriptName = "msCopyAction"
msCopyAction = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msCopyAction:Name()
	return "CopyAction ... "
end

function msCopyAction:Version()
	return "1.0"
end

function msCopyAction:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Removes transform from group and applies it to sub layers.")
end

function msCopyAction:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msCopyAction:UILabel()
	return(MOHO.Localize("/Scripts/Menu/CopyAction/CopyAction=CopyAction ... "))
end

-- Old code that supports pre 10.0
-- function SZ_ActivateMainline:Run(moho)
   -- if moho.layer:CurrentAction() ~= "" then
      -- local version = 9.0
      -- if moho.AppVersion ~= nil then
         -- local sVersion = string.gsub(moho:AppVersion(), "^(%d+)(%.%d+)(%..+)", "%1%2")
         -- version = tonumber(sVersion)
         -- print(sVersion)
      -- end
      -- if version >= 10.0 then
         -- moho.document:SetCurrentDocAction(nil)
      -- end
      -- moho.layer:ActivateAction(nil)
      -- moho.layer:UpdateCurFrame()
      -- moho:UpdateUI()
   -- end
-- end

-- function msCopyAction:CloseAction(layer)
	-- layer:ActivateAction("junk")
	-- layer:DeleteAction("junk")
-- end

function msCopyAction:CopyAction(layer, srcAction, destinationAction)
	layer:ActivateAction(destinationAction)
	layer:InsertAction(srcAction, 0, false)
end
-- **************************************************
-- The guts of this script
-- **************************************************
function msCopyAction:Run(moho)
	self:CopyAction(moho.layer, "head turn", "quick turn")
	moho.document:SetCurrentDocAction(nil)
end


