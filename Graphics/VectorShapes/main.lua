
-- Abstract: VectorShapes
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Vector Shapes", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local letterboxWidth = math.abs(display.screenOriginX)
local shapeCenterY = display.contentCenterY - 75
local currentShapeIndex = 1
local pickerWheel
local currentShape
local prevShape
local tempShape

-- Function to update shape
local function updateShape( event )

	local values = pickerWheel:getValues()
	local swapShapes = false

	-- Handle selection of new shape
	if ( event and event.column == 1 ) then
		if ( event.row ~= currentShapeIndex ) then
			currentShapeIndex = event.row
			if ( currentShapeIndex == 1 ) then
				tempShape = display.newRect( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, 220, 160 )
			elseif ( currentShapeIndex == 2 ) then
				tempShape = display.newRoundedRect( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, 220, 160, 16 )
			elseif ( currentShapeIndex == 3 ) then
				tempShape = display.newCircle( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, 95 )
			elseif ( currentShapeIndex == 4 ) then
				tempShape = display.newPolygon( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, { 0,-75,95,90,-95,90 } )
			elseif ( currentShapeIndex == 5 ) then
				tempShape = display.newPolygon( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, { 0,-99,24.3,-31.5,94.5,-31.5,38.7,14.4,58.5,81,0,40.5,-58.5,81,-38.7,14.4,-94.5,-31.5,-24.3,-31.5 } )
			end
			tempShape.strokeWidth = 20
			prevShape = currentShape
			currentShape = tempShape
			tempShape = nil
			swapShapes = true
		end
	end

	-- Handle fill
	local fillValue
	if ( event and event.column == 2 ) then
		fillValue = event.row
	else
		fillValue = values[2].index
	end
	if ( fillValue == 1 ) then
		currentShape.fill = { 0.9, 0, 0.2 }
	elseif ( fillValue == 2 ) then
		currentShape.fill = { type="gradient", color1={ 0.9, 0, 0.2 }, color2={ 0.3, 0, 0.06 } }
	elseif ( fillValue == 3 ) then
		currentShape.fill = { type="image", filename="texture.jpg" }
		-- Calculate scale factor for the filled texture
		local scaleFactorX, scaleFactorY = 1, 1
		if ( currentShape.width > currentShape.height ) then
			scaleFactorY = currentShape.width / currentShape.height
		else
			scaleFactorX = currentShape.height / currentShape.width
		end
		currentShape.fill.scaleX = scaleFactorX
		currentShape.fill.scaleY = scaleFactorY
	end

	-- Handle stroke
	local strokeValue
	if ( event and event.column == 3 ) then
		strokeValue = event.row
	else
		strokeValue = values[3].index
	end
	if ( strokeValue == 1 ) then
		currentShape.stroke = { 1, 0.5, 0.2 }
	elseif ( strokeValue == 2 ) then
		currentShape.stroke = { type="gradient", color1={ 1, 0.5, 0.2 }, color2={ 1, 0.25, 0.05 } }
	end

	-- Swap shape positions (if necessary)
	if ( swapShapes == true and prevShape and currentShape ) then
		transition.to( prevShape, { time=500, x=display.contentCenterX-display.actualContentWidth, transition=easing.inQuart,
			onComplete = function()
				display.remove( prevShape )
				prevShape = nil
			end
		})
		transition.to( currentShape, { time=500, delay=320, x=display.contentCenterX, transition=easing.outQuart } )
	end
end

-- Create picker wheel for shapes, fill options, and stroke options
local columnData = {
	{
		align = "left",
		width = 130,
		labelPadding = 20,
		startIndex = 1,
		labels = { "Rectangle", "Rounded Rect", "Circle", "Triangle", "Star" }
	},
	{
		align = "center",
		width = 95,
		startIndex = 2,
		labels = { "solid", "gradient", "image" }
	},
	{
		align = "center",
		width = 95,
		startIndex = 1,
		labels = { "solid", "gradient" }
	}
}
pickerWheel = widget.newPickerWheel(
{
	columns = columnData,
	style = "resizable",
	width = display.actualContentWidth,
	rowHeight = 32,
	font = appFont,
	fontSize = 15,
	onValueSelected = updateShape
})
mainGroup:insert( pickerWheel )
pickerWheel.x = display.contentCenterX
pickerWheel.y = display.contentHeight - display.screenOriginY - 80

-- Picker wheel column labels (above)
local label1 = display.newText( { parent=mainGroup, text="Shape", x=20-letterboxWidth, y=pickerWheel.contentBounds.yMin-18, width=140, height=0, font=appFont, fontSize=15 } )
label1:setFillColor( 0.8 )
label1.anchorX = 0
local label2 = display.newText( { parent=mainGroup, text="Fill", x=130-letterboxWidth, y=pickerWheel.contentBounds.yMin-18, width=95, height=0, font=appFont, fontSize=15, align="center" } )
label2:setFillColor( 0.8 )
label2.anchorX = 0
local label3 = display.newText( { parent=mainGroup, text="Stroke", x=225-letterboxWidth, y=pickerWheel.contentBounds.yMin-18, width=95, height=0, font=appFont, fontSize=15, align="center" } )
label3:setFillColor( 0.8 )
label3.anchorX = 0

-- Create default current shape
currentShape = display.newRect( mainGroup, display.contentCenterX, shapeCenterY, 220, 160 )
currentShape.strokeWidth = 20
updateShape()
