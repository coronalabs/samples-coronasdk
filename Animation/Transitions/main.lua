
-- Abstract: Transitions
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Fish sprite images courtesy of Kenney; see http://kenney.nl/
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Transitions / Easing", showBuildNum=false } )

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

-- Reference table for easing methods
local easingMethods = {
	{ "easing.linear", easing.linear },
	{ "easing.inSine", easing.inSine },
	{ "easing.outSine", easing.outSine },
	{ "easing.inOutSine", easing.inOutSine },
	{ "easing.inQuad", easing.inQuad },
	{ "easing.outQuad", easing.outQuad },
	{ "easing.inOutQuad", easing.inOutQuad },
	{ "easing.outInQuad", easing.outInQuad },
	{ "easing.inCubic", easing.inCubic },
	{ "easing.outCubic", easing.outCubic },
	{ "easing.inOutCubic", easing.inOutCubic },
	{ "easing.outInCubic", easing.outInCubic },
	{ "easing.inQuart", easing.inQuart },
	{ "easing.outQuart", easing.outQuart },
	{ "easing.inOutQuart", easing.inOutQuart },
	{ "easing.outInQuart", easing.outInQuart },
	{ "easing.inQuint", easing.inQuint },
	{ "easing.outQuint", easing.outQuint },
	{ "easing.inOutQuint", easing.inOutQuint },
	{ "easing.outInQuint", easing.outInQuint },
	{ "easing.inExpo", easing.inExpo },
	{ "easing.outExpo", easing.outExpo },
	{ "easing.inOutExpo", easing.inOutExpo },
	{ "easing.outInExpo", easing.outInExpo },
	{ "easing.inCirc", easing.inCirc },
	{ "easing.outCirc", easing.outCirc },
	{ "easing.inOutCirc", easing.inOutCirc },
	{ "easing.outInCirc", easing.outInCirc },
	{ "easing.inBack", easing.inBack },
	{ "easing.outBack", easing.outBack },
	{ "easing.inOutBack", easing.inOutBack },
	{ "easing.outInBack", easing.outInBack },
	{ "easing.inElastic", easing.inElastic },
	{ "easing.outElastic", easing.outElastic },
	{ "easing.inOutElastic", easing.inOutElastic },
	{ "easing.outInElastic", easing.outInElastic },
	{ "easing.inBounce", easing.inBounce },
	{ "easing.outBounce", easing.outBounce },
	{ "easing.inOutBounce", easing.inOutBounce },
	{ "easing.outInBounce", easing.outInBounce }
}

-- Create picker wheel for easing methods and transition time
local easingLabels = {}
for i = 1,#easingMethods do
	easingLabels[#easingLabels+1] = easingMethods[i][1]
end

local columnData = {
	{
		align = "left",
		width = 180-display.screenOriginX,
		labelPadding = 25,
		startIndex = 3,
		labels = easingLabels
	},
	{
		align = "center",
		width = 140-display.screenOriginX,
		labelPadding = 0,
		startIndex = 3,
		labels = { "250", "500", "1000", "2000" }
	}
}
local pickerWheel = widget.newPickerWheel(
{
	columns = columnData,
	style = "resizable",
	width = display.actualContentWidth,
	rowHeight = 32,
	font = appFont,
	fontSize = 15
})
mainGroup:insert( pickerWheel )
pickerWheel.x = display.contentCenterX
pickerWheel.y = display.contentHeight - display.screenOriginY - 80

-- Picker wheel column labels (above)
local label1 = display.newText( { parent=mainGroup, text="Easing Interpolation", x=display.screenOriginX+25, y=pickerWheel.contentBounds.yMin-18, width=180-display.screenOriginX, height=0, font=appFont, fontSize=15 } )
label1:setFillColor( 0.8 )
label1.anchorX = 0
local label2 = display.newText( { parent=mainGroup, text="Time (ms)", x=180, y=pickerWheel.contentBounds.yMin-18, width=140-display.screenOriginX, height=0, font=appFont, fontSize=15, align="center" } )
label2:setFillColor( 0.8 )
label2.anchorX = 0

-- Data for repeating series of transitions
local characterTransitions = {
	{ x=260, delay=400 },
	{ y=260, xScale=-0.8, delay=800 },
	{ xScale=-1, yScale=1, delay=400 },
	{ x=60, xScale=-0.6, yScale=0.6, delay=1200 },
	{ rotation=135, delay=400 },
	{ x=260, y=60, alpha=0, delay=400 },
	{ rotation=0, alpha=1, delay=800 },
	{ x=60, delay=400 },
	{ xScale=0.8, yScale=0.8, delay=400 }
}

-- Create character
local sheetOptions = {
	width = 55,
	height = 42,
	numFrames = 2,
	sheetContentWidth = 110,
	sheetContentHeight = 42
}
local imageSheet = graphics.newImageSheet( "fish.png", sheetOptions )
local character = display.newSprite( mainGroup, imageSheet, { name="swim", start=1, count=2, time=200 } )
character.x, character.y = 60, 60
character.xScale, character.yScale = 0.8, 0.8
character:play()

local currentTransition = 1

local function doNextTransition()

	-- Before next transition starts, gather settings from picker wheel
	local pickerValues = pickerWheel:getValues()

	-- Set up transition parameters
	local transData = characterTransitions[currentTransition]
	transData["time"] = tonumber(pickerValues[2].value)
	transData["transition"] = easingMethods[pickerValues[1].index][2]
	transData["onComplete"] = doNextTransition

	-- Initiate the transition
	transition.to( character, transData )

	-- Increment current transition (or reset to first)
	if ( currentTransition < #characterTransitions ) then
		currentTransition = currentTransition + 1
	else
		currentTransition = 1
	end
end

-- Initiate first transition
doNextTransition()
