
-- Abstract: Clock
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Clock", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

-- Set local variables
local clockGroup = display.newGroup()
mainGroup:insert( clockGroup )

local hourField = display.newText( clockGroup, "", display.contentCenterX, 110, native.systemFont, 140 )
hourField:setFillColor( 1, 0, 0.1 )
hourField.anchorX = 0

local minuteField = display.newText( clockGroup, "", display.contentCenterX, 240, native.systemFont, 140 )
minuteField:setFillColor( 0.95, 0.1, 0.3 )
minuteField.anchorX = 0

local secondField = display.newText( clockGroup, "", display.contentCenterX, 370, native.systemFont, 140 )
secondField:setFillColor( 0.9, 0.2, 0.5 )
secondField.anchorX = 0

clockGroup.rotation = -10
clockGroup.anchorChildren = true
clockGroup.x, clockGroup.y = display.contentCenterX, display.contentCenterY

-- Function to update the time
local function updateTime()

	local time = os.date("*t")
	hourField.text = string.format( "%02d", time.hour )
	if ( time.hour > 12 ) then hourField.text = string.format( "%02d", (time.hour-12) ) end
	minuteField.text = string.format( "%02d", time.min )
	secondField.text = string.format( "%02d", time.sec )
end

-- Run function initially on startup so that correct time displays immediately
updateTime()

-- Update the clock once per second
local clockTimer = timer.performWithDelay( 1000, updateTime, 0 )
