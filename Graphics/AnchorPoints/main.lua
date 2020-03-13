
-- Abstract: Anchor Points
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Anchor Points", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Create logo objects
local logo = display.newImageRect( mainGroup, "corona-logo.png", 150, 150 )
logo.x, logo.y = display.contentCenterX, display.contentCenterY
logo.anchorX = 0.5
logo.anchorY = 0.5

-- Create dot image to represent anchor point
local anchorDot = display.newImageRect( mainGroup, "dot.png", 32, 32 )
anchorDot.x, anchorDot.y = display.contentCenterX, display.contentCenterY
anchorDot.blendMode = "add"

-- Begin rotating logo indefinitely
transition.to( logo, { time=5000, rotation=360, iterations=0 } )

-- Function to detect touches on logo object
local function detectTouch( event )

	if ( "began" == event.phase ) then

		-- Reposition dot image
		anchorDot.x, anchorDot.y = event.x, event.y

		-- Re-map touch point from content space to logo object position/rotation
		local onLogoX, onLogoY = logo:contentToLocal( event.x, event.y )

		-- Reset anchor point on logo object
		logo.anchorX = ( onLogoX/logo.width + 0.5 )
		logo.anchorY = ( onLogoY/logo.height + 0.5 )

		-- Reposition logo object
		logo.x, logo.y = event.x, event.y
	end
end

-- Add touch listener to logo object
logo:addEventListener( "touch", detectTouch )
