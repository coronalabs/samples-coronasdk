
-- Abstract: Orientation
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Orientation", showBuildNum=true } )

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

local label = display.newText( mainGroup, "portrait", display.contentCenterX, display.contentCenterY, appFont, 28 )
label:setFillColor( 1, 1, 1 )

local function onOrientationChange( event )

	-- Change label text to reflect current orientation
	label.text = event.type
	
	-- Re-center label on screen
	label.x = display.contentCenterX
	label.y = display.contentCenterY
end

-- Listen for "orientation" events
Runtime:addEventListener( "orientation", onOrientationChange )
