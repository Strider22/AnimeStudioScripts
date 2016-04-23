-- playpen for trying things out
ScriptName = "msPalette"
msPalette = {}

-- **************************************************
-- This information is displayed in help | About scripts ... 
-- **************************************************
function msPalette:Name()
	return "Palette ... "
end

function msPalette:Version()
	return "1.0"
end

function msPalette:Description()
	return MOHO.Localize("/Scripts/Menu/MinimalScript/Description=Print complete information on all points on a vector layer.")
end

function msPalette:Creator()
	return "Mitchel Soltys"
end

-- **************************************************
-- This is the Script label in the GUI
-- **************************************************
function msPalette:UILabel()
	return(MOHO.Localize("/Scripts/Menu/Palette/Palette=Palette ... "))
end

function msPalette:ReassignStyle2(style,uuid)
	local name = style.fName:Buffer()
	local foundStyle = self.moho.document:Style(name)
	if(foundStyle.fUUID:Buffer() == uuid) then
		return style
	end
	return foundStyle
end


function msPalette:ReassignStyles2(layer)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local styleList = {}
	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountShapes()-1 do
		local shape = mesh:Shape(i)
		local name = shape.fInheritedStyle.fName:Buffer()
		if styleList[name] == nil then
			styleList[name] = "found"
		end
	end
	for n, v in pairs(styleList) do
		print("renaming " .. n .. " to " .. n.."1")
		self.moho.document:RenameStyle(n,n.."1",layer)
	end
	self.moho.document:RelinkStyles(layer)

end

function msPalette:ReassignStyle(style,uuid)
	local name = style.fName:Buffer()
	local foundStyle = self.moho.document:Style(name)
	if(foundStyle.fUUID:Buffer() == uuid) then
		return style
	end
	return foundStyle
end


function msPalette:ReassignStyles(layer)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountShapes()-1 do
		local shape = mesh:Shape(i)
		local uuid = shape.fInheritedStyle.fUUID:Buffer()
		shape.fInheritedStyle = self:ReassignStyle(shape.fInheritedStyle,uuid)
		-- shape.fInheritedStyle2 = self:ReassignStyle(shape.fInheritedStyle2)
	end
	-- self.moho.document:RelinkStyles(layer)
end


function msPalette:RemoveStyle(layer, style,uuid)
	local name = style.fName:Buffer()
	local foundStyle = self.moho.document:Style(name)
	if(not foundStyle.fUUID:Buffer() == uuid) then
		self.moho.document:RemoveStyle(style,layer)
	end
end
function msPalette:RemoveStyles2(layer)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountShapes()-1 do
		local shape = mesh:Shape(i)
		local uuid = shape.fInheritedStyle.fUUID:Buffer()
		self:RemoveStyle(layer, shape.fInheritedStyle,uuid)
		-- shape.fInheritedStyle2 = self:ReassignStyle(shape.fInheritedStyle2)
	end
end

function msPalette:RemoveStyles(layer)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountShapes()-1 do
		local shape = mesh:Shape(i)
		self.moho.document:RemoveStyle(shape.fInheritedStyle, layer)
		-- shape.fInheritedStyle2 = self:ReassignStyle(shape.fInheritedStyle2)
	end
end


function msPalette:PrintLayerShapeInfo(layer)
	if layer:LayerType() ~= MOHO.LT_VECTOR then
		print("Select a vector layer")
		return
	end

	local vectorLayer = self.moho:LayerAsVector(layer)
	local mesh = vectorLayer:Mesh()
	for i = 0, mesh:CountShapes()-1 do
		local shape = mesh:Shape(i)
		print("shape name " .. shape.fInheritedStyle.fName:Buffer())
		print("shape fUUID" .. shape.fInheritedStyle.fUUID:Buffer())
		print("style By Name fUUID " .. self.moho.document:Style(shape.fInheritedStyle.fName:Buffer()).fUUID:Buffer())
	end
end

function msPalette:PrintStyleInfo()
	for i = 0, self.moho.document:CountStyles()-1 do
		local style = self.moho.document:StyleByID(i)
		print("style name " .. style.fName:Buffer())
		print(" uuid " .. style.fUUID:Buffer())
	end
end

function msPalette:BuildStyleList()
	local styleList = {}
	for i = 0, self.moho.document:CountStyles()-1 do
		local style = self.moho.document:StyleByID(i)
		local styleName = style.fName:Buffer()
		styleList[styleName] = i
	end
	-- self:PrintTableStyles(styleList)
	self:PrintTableValues(styleList)
	return styleList
end

-- function msPalette:BuildStyleList()
	-- local styleList = {}
-- print("in build styles")
	-- for i = 0, self.moho.document:CountStyles()-1 do
		-- local style = self.moho.document:StyleByID(i)
		-- local styleName = style.fName:Buffer()
		-- local UUID = style.fUUID:Buffer()
		-- local styleRow = styleList[styleName]
		-- if styleRow == nil then
			-- styleList[styleName] = {}
		-- end
		-- table.insert(styleList[styleName], UUID)
		-- self:PrintTableStyles(styleList[styleName])
	-- end
	-- return styleList
-- end
function msPalette:PrintTableValues(t)
	for n, v in pairs(t) do
		print("n: ", n, " v: ",  v, " type " , type(v))
	end
end
function msPalette:PrintTableStyles(t)
	for n, style in pairs(t) do
		print("n: ", n, " style: ",  style.fName:Buffer())
	end
end

function msPalette:dumpStyleList(t)
	for name, value in pairs(t) do
		print("name: ", name)
		for k, v in ipairs(value) do
		  print("k ", k, " fUUID " , value.fName:Buffer())
		end
	end
end


--[[
	local styles = {}		-- array of styles [1...stylecoundt]
	local stylenames = {}	-- array of indices [stylename1..stylenamen}

	local gatherStyles -- the fumction varialbe must be defined before the definition to be visible inside the def.
	gatherStyles = function(Layer) ------------------------------------
		local result = true
		if not (Layer) then 
			print("Something is wrong: A Layer is nil in gatherStyles()...aborting")
			return false
		end

		if Layer:IsGroupType() then -- go throuhg sublayers
			for i = 0 , moho:LayerAsGroup(Layer):CountLayers() - 1 do
				result = gatherStyles(moho:LayerAsGroup(Layer):Layer(i))
			end
		elseif (Layer:LayerType() == MOHO.LT_VECTOR) then
			local mesh = moho:LayerAsVector(Layer):Mesh()
			local maxshape = mesh:CountShapes() - 1 
			for j = 0, maxshape do

				local function addstyle2tables(style) -- adds a shape to the arrays
					local stylename = style.fName:Buffer()
					if not (stylenames[stylename]) then -- we didn't have this style yet
						styles[#styles + 1] = style
						stylenames[stylename] = #styles
					end						
				end -- local function addstyle2tables(style)
				
				if (mesh:Shape(j).fInheritedStyle) then -- shape has an inherited style...
					addstyle2tables(mesh:Shape(j).fInheritedStyle)
				end
				if (mesh:Shape(j).fInheritedStyle2) then
					addstyle2tables(mesh:Shape(j).fInheritedStyle2)
				end				
			end
		end 
		return result
	end -- nested function gatherStyles --------------------------------------------------




-- search Layers for Styles	--------------------------------------
	local doc = moho.document
	if not doc then return
	end
	local maxlayer = doc:CountLayers() - 1
	
	print("Searching for styles...")
	-- einfacher: for i = 0, moho.document(CountStyles) Style(i) end
	for i = 0 , maxlayer  do
		if not gatherStyles(doc:Layer(i)) then return
		end
	end
]]--


-- **************************************************
-- The guts of this script
-- **************************************************
function msPalette:Run(moho)
	self.moho = moho
	-- local list = self:BuildStyleList()
	-- self:dumpStyleList(list)
	-- self:PrintStyleInfo()
	self:ReassignStyles2(moho.layer)
		moho:UpdateUI()
	-- self:RemoveStyles(moho.layer)
end
