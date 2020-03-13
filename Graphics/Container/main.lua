
-- Abstract: Container
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Container", showBuildNum=false } )

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
local transformValues = {
	{ property="height", label="height", current=200, range=256, offset=0, multiplier=2.56 },
	{ property="width", label="width", current=100, range=184, offset=0, multiplier=1.84 },
	{ property="rotation", label="rotation", current=0, range=300, offset=-150, multiplier=3 }
}
local lbX = display.screenOriginX
local lbY = display.screenOriginY
local labelAlignX = 80 + lbX
local valueAlignX = 290 - lbX
local sliderWidth = 140 - lbX - lbX

-- Create container
local container = display.newContainer( 184, 256 )
mainGroup:insert( container )
container.width = 100
container.height = 200
container:translate( display.contentCenterX, display.contentCenterY-50 )

-- Add image to container
local background = display.newImageRect( container, "image.jpg", 184, 256 )
background.x, background.y = 0,0

local function sliderListener( event )

	local index = transformValues[event.target.indexValue]
	local propertyName = index.property
	local propertyValue = ( event.value * index.multiplier ) + index.offset
	event.target.valueLabel.text = math.round( propertyValue )

	-- Update container property
	container[propertyName] = propertyValue
end

-- Slider controls and labels
local sliderGroup = display.newGroup()
mainGroup:insert( sliderGroup )
for i = 1,#transformValues do
	local label = display.newText( sliderGroup, transformValues[i].label, labelAlignX, 480-(i*36)-lbY, appFont, 16 )
	label.anchorX = 1
	local labelValue = display.newText( sliderGroup, transformValues[i].current, valueAlignX, label.y, appFont, 16 )
	labelValue:setFillColor( 0.7 )
	labelValue.anchorX = 1
	local slider = widget.newSlider(
	{
		id = transformValues[i].property,
		left = labelAlignX + 20,
		width = sliderWidth,
		value = ( ( transformValues[i].current - transformValues[i].offset ) / transformValues[i].range ) * 100,
		listener = sliderListener
	})
	slider.y = label.y
	slider.indexValue = i
	slider.valueLabel = labelValue
	sliderGroup:insert( slider )
end
sliderGroup.anchorChildren = true
sliderGroup.x = display.contentCenterX
sliderGroup.y = 470 - (sliderGroup.height/2) - lbY
