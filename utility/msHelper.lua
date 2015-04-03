msHelper = {}

-- **************************************************
-- Deletes Keys on a mohoLayer from frame x to y
-- **************************************************
function msHelper:DeleteLayerKeys(mohoLayer, startFrame, endFrame)
	for frame = startFrame, endFrame do
		mohoLayer:DeleteKeysAtFrame(false,frame)
	end
end

msHelper.debug = false

function msHelper:Debug(string)
	if(self.debug) then
		print(string)
	end
end

function msHelper:PrepUndo(moho)
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
end