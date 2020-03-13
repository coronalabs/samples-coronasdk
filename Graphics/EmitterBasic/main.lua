
-- Abstract: EmitterBasic
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Basic Emitter", showBuildNum=false } )

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
local emitterValues = {
	{ property="gravityy", label="Y Gravity", current=0, range=4000, offset=-2000, multiplier=40 },
	{ property="gravityx", label="X Gravity", current=0, range=4000, offset=-2000, multiplier=40 },
	{ property="speed", label="Speed", current=320, range=1000, offset=0, multiplier=10 },
	{ property="angle", label="Angle", current=-90, range=360, offset=-180, multiplier=3.6 }
}
local lbX = display.screenOriginX
local lbY = display.screenOriginY
local labelAlignX = 85 + lbX
local valueAlignX = 300 - lbX
local sliderWidth = 140 - lbX - lbX

-- Configure image sheet
local sheetOptions = {
	width = 77,
	height = 40,
	numFrames = 20,
	sheetContentWidth = 385,
	sheetContentHeight = 160
}
local stepperSheet = graphics.newImageSheet( "stepperSheet.png", sheetOptions )

-- Load module containing table of emitter params
local emitterParams = require( "emitter" )

-- Create and position emitter object
local emitter = display.newEmitter( emitterParams )
emitter.x = display.contentCenterX
emitter.y = display.contentCenterY - 50 - lbY
mainGroup:insert( emitter )


local function sliderListener( event )

	local index = emitterValues[event.target.indexValue]
	local propertyName = index.property
	local propertyValue = ( event.value * index.multiplier ) + index.offset
	event.target.valueLabel.text = propertyValue

	-- Update emitter property
	emitter[propertyName] = propertyValue
end


local function onStepperPress( event )

	local propertyNameStart = "startColor" .. event.target.id
	local propertyNameFinish = "finishColor" .. event.target.id

	local newVal = event.value / 10

	-- Set emitter values based on property
	if ( "increment" == event.phase or "decrement" == event.phase ) then
		emitter[propertyNameStart] = newVal
		emitter[propertyNameFinish] = newVal
	end
	-- Update stepper value label
	event.target.valueLabel.text = string.format( "%3.2f", newVal )
end


-- Slider controls and labels
for i = 1,#emitterValues do
	local label = display.newText( mainGroup, emitterValues[i].label, labelAlignX, 420-(i*36)-lbY, appFont, 16 )
	label.anchorX = 1
	local labelValue = display.newText( mainGroup, emitterValues[i].current, valueAlignX, label.y, appFont, 16 )
	labelValue:setFillColor( 0.7 )
	labelValue.anchorX = 1
	local slider = widget.newSlider(
	{
		id = emitterValues[i].property,
		left = labelAlignX + 20,
		width = sliderWidth,
		value = ( ( emitterValues[i].current - emitterValues[i].offset ) / emitterValues[i].range ) * 100,
		listener = sliderListener
	})
	slider.y = label.y
	slider.indexValue = i
	slider.valueLabel = labelValue
	mainGroup:insert( slider )
end

-- Stepper controls and labels
local count = 0
local steppers = { "Red", "Green", "Blue", "Alpha" }
for j = 1,#steppers do

	local propertyValue = "startColor" .. steppers[j]
	local stepper = widget.newStepper(
	{
		id = steppers[j],
		x = -30 + (j*76),
		y = 430 - lbY,
		initialValue = emitter[propertyValue] * 10,
		minimumValue = 1,
		maximumValue = 10,
		timerIncrementSpeed = 200,
		sheet = stepperSheet,
		defaultFrame = 1 + count,
		noMinusFrame = 2 + count,
		noPlusFrame = 3 + count,
		minusActiveFrame = 4 + count,
		plusActiveFrame = 5 + count,
		onPress = onStepperPress
	})
	local label = display.newText( mainGroup, string.format( "%3.2f", emitter[propertyValue] ), stepper.x, stepper.y+30, appFont, 16 )
	stepper.valueLabel = label
	mainGroup:insert( stepper )
	count = count + 5
end
