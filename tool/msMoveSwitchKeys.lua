-- **************************************************
-- Provide Moho with the name of this script object
-- **************************************************

ScriptName = "msMoveSwitchKeys"

-- **************************************************
-- General information about this script
-- **************************************************

msMoveSwitchKeys = {}


function msMoveSwitchKeys:Name()
	return "Move Switch Key"
end

function msMoveSwitchKeys:Version()
	return "1.0"
end


function msMoveSwitchKeys:Description()
	return "Move mouse horizontally to move switch keys."
end


function msMoveSwitchKeys:Creator()
	return "Mitchel Soltys"
end

function msMoveSwitchKeys:UILabel()
	return "Move Switch Keys"
end



-- **************************************************
-- Recurring values
-- **************************************************
msMoveSwitchKeys.doRot=true
msMoveSwitchKeys.doPos=true
msMoveSwitchKeys.doScale=true
msMoveSwitchKeys.doFrame=0


-- **************************************************
-- The guts of this script
-- **************************************************

function msMoveSwitchKeys:IsEnabled(moho)
	if (moho.layer:LayerType() ~= MOHO.LT_BONE) then
		return false
	else
		return true
	end
end

function msMoveSwitchKeys:OnMouseDown(moho, mouseEvent)
	skel = moho:Skeleton()
	if (skel == nil) then
			return false
	end
	

	editFrame=self.startframeNR:Value()
	curFrame=moho.layer:CurFrame()

	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()

end


function msMoveSwitchKeys:OnMouseMoved(moho, mouseEvent)
skel = moho:Skeleton()
	if (skel == nil) then
			return false
	end
	
	mouseGenValue=mouseEvent.pt.x-mouseEvent.startPt.x
	
	if (self.doFrame==true) then
	
		if (mouseEvent.shiftKey) then
		newFrame=editFrame+math.floor(mouseGenValue)
		else
		newFrame=editFrame+math.floor(mouseGenValue/10)
		end
		if newFrame<0 then
		newFrame=0
		end
	else
		if (mouseEvent.shiftKey) then
		newFrame=curFrame+math.floor(mouseGenValue)
		else
		newFrame=curFrame+math.floor(mouseGenValue/10)
		end
		if newFrame<0 then
		newFrame=0
		end
	end
	
	for i = 0, skel:CountBones() - 1 do
		local newPosV=LM.Vector2:new_local()
		local newRot
		local newScale
		local bone = skel:Bone(i)
		if (bone.fSelected) then
		if (self.doPos==true) then
		newPosV=bone.fAnimPos:GetValue(newFrame)
		bone.fAnimPos:SetValue(curFrame, newPosV)
		end
		if (self.doRot==true) then
		newRot=bone.fAnimAngle:GetValue(newFrame)
		bone.fAnimAngle:SetValue(curFrame, newRot)
		end
		if (self.doScale==true) then
		newScale=bone.fAnimScale:GetValue(newFrame)
		bone.fAnimScale:SetValue(curFrame, newScale)
		end
		
		
		self.frameNR:SetValue(newFrame)
		
		
			
		end
	end
	moho.layer:UpdateCurFrame()
		mouseEvent.view:DrawMe()
end



function msMoveSwitchKeys:OnMouseUp(moho, mouseEvent)
skel = moho:Skeleton()
	if (skel == nil) then
			return false
	end
		moho:NewKeyframe(CHANNEL_BONE)
		moho:NewKeyframe(CHANNEL_BONE_S)
		moho:NewKeyframe(CHANNEL_BONE_T)
		moho:UpdateSelectedChannels()
		moho.layer:UpdateCurFrame()
end

function msMoveSwitchKeys:SetIt(moho, theValue)
skel = moho:Skeleton()
	if (skel == nil) then
			return false
	end
	curFrame=moho.layer:CurFrame()
	moho.document:PrepUndo(moho.layer)
	moho.document:SetDirty()
	for i = 0, skel:CountBones() - 1 do
		local newPosV=LM.Vector2:new_local()
		local newRot
		local newScale
		local bone = skel:Bone(i)
		if (bone.fSelected) then
		
		if (self.doPos==true) then
		newPosV=bone.fAnimPos:GetValue(theValue)
		bone.fAnimPos:SetValue(curFrame, newPosV)
		end
		if (self.doRot==true) then
		newRot=bone.fAnimAngle:GetValue(theValue)
		bone.fAnimAngle:SetValue(curFrame, newRot)
		end
		if (self.doScale==true) then
		newScale=bone.fAnimScale:GetValue(theValue)
		bone.fAnimScale:SetValue(curFrame, newScale)
		end

		end
	end
	
		moho:NewKeyframe(CHANNEL_BONE)
		moho:NewKeyframe(CHANNEL_BONE_S)
		moho:NewKeyframe(CHANNEL_BONE_T)
		moho:UpdateSelectedChannels()
		moho.layer:UpdateCurFrame()
		
end

function msMoveSwitchKeys:SelAll(moho, theValue)
skel = moho:Skeleton()
	if (skel == nil) then
			return false
	end
	skel:SelectAll()
	
	
end
----------------------------------------------------------------Menu

msMoveSwitchKeys.SETIT = MOHO.MSG_BASE
msMoveSwitchKeys.SELALL = MOHO.MSG_BASE+1
msMoveSwitchKeys.ROT = MOHO.MSG_BASE+2
msMoveSwitchKeys.POS = MOHO.MSG_BASE+3
msMoveSwitchKeys.SCALE = MOHO.MSG_BASE+4
msMoveSwitchKeys.FRAME = MOHO.MSG_BASE+5

function msMoveSwitchKeys:DoLayout(moho, layout)
self.selBut= LM.GUI.Button("Select all bones", self.SELALL)
	layout:AddChild(self.selBut)
	
	self.theText=LM.GUI.StaticText("Get value from frame:")
	layout:AddChild(self.theText)
	
	self.frameNR = LM.GUI.TextControl(0, "000000", 0, LM.GUI.FIELD_INT)
	self.frameNR:SetValue(0)
	layout:AddChild(self.frameNR)
	
	self.setBut= LM.GUI.Button("Set", self.SETIT)
	layout:AddChild(self.setBut)
	
	rotBox = LM.GUI.CheckBox("Get rotation", self.ROT)
	rotBox:SetValue(true)
	layout:AddChild(rotBox)
	
	
	posBox = LM.GUI.CheckBox("Get position", self.POS)
	layout:AddChild(posBox)
	posBox:SetValue(true)
	
	scaleBox = LM.GUI.CheckBox("Get scale", self.SCALE)
	layout:AddChild(scaleBox)
	scaleBox:SetValue(true)
	
	frameBox = LM.GUI.CheckBox("Always start on frame:", self.FRAME)
	layout:AddChild(frameBox)
	
	self.startframeNR = LM.GUI.TextControl(0, "000000", 0, LM.GUI.FIELD_INT)
	self.startframeNR:SetValue(0)
	layout:AddChild(self.startframeNR)
	
end

function msMoveSwitchKeys:HandleMessage(moho, view, msg)
	skel = moho:Skeleton()
	if (skel == nil) then
			return false
	end

	if (msg == self.SETIT) then
		msMoveSwitchKeys:SetIt(moho, self.frameNR:IntValue())
	end
	if (msg == self.SELALL) then
		msMoveSwitchKeys:SelAll(moho)
	end
	if (msg == self.ROT) then
		self.doRot=rotBox:Value()
	end
		if (msg == self.POS) then
		self.doPos=posBox:Value()
	end
		if (msg == self.SCALE) then
		self.doScale=scaleBox:Value()
	end
	if (msg == self.FRAME) then
		self.doFrame=frameBox:Value()
	end
end
