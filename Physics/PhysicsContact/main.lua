
-- Abstract: PhysicsContact
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Physics Contact", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local worldGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set up physics engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 9.8 )
physics.setDrawMode( "normal" )

-- Declare initial variables
local letterboxWidth = math.abs(display.screenOriginX)
local letterboxHeight = math.abs(display.screenOriginY)

-- Create "walls" around screen
local wallL = display.newRect( worldGroup, 0-letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallL.anchorX = 1
physics.addBody( wallL, "static", { bounce=1, friction=0.1 } )

local wallR = display.newRect( worldGroup, 480+letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallR.anchorX = 0
physics.addBody( wallR, "static", { bounce=1, friction=0.1 } )

local wallT = display.newRect( worldGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
wallT.anchorY = 1
physics.addBody( wallT, "static", { bounce=0, friction=0 } )

local wallB = display.newRect( worldGroup, display.contentCenterX, 320+letterboxHeight, display.actualContentWidth, 20 )
wallB.anchorY = 0
physics.addBody( wallB, "static", { bounce=0.4, friction=0.6 } )

-- Create ball (character)
local char = display.newImageRect( worldGroup, "char.png", 40, 40 )
physics.addBody( char, "dynamic", { radius=20, bounce=0.3, friction=0.7 } )
char.x = 120 ; char.y = 170
char.alpha = 0.7
char:setLinearVelocity( 120,0 )
char.angularVelocity = 160


-- Create platforms
local function createPlatform( x, y )
	local platform = display.newImageRect( worldGroup, "platform.png", 140, 32 )
	physics.addBody( platform, "static", { bounce=0.3, friction=0.7 } )
	platform.collType = "passthrough"
	platform.x, platform.y = x, y
	platform:toBack()
end
createPlatform( 20, 120 )
createPlatform( 240, 120 )
createPlatform( 460, 120 )
createPlatform( 130, 230 )
createPlatform( 350, 230 )


local function localPreCollision( self, event )

	if ( "passthrough" == event.other.collType ) then

		-- Compare Y position of character "base" to platform top
		-- A slight increase (0.2) is added to account for collision location inconsistency
		-- If collision position is greater than platform top, void/disable the specific collision
		if ( self.y+(self.height*0.5) > event.other.y-(event.other.height*0.5)+0.2 ) then
			if event.contact then
				event.contact.isEnabled = false
			end
		end
	end
	return true
end


local function doJump( event )

	if ( "began" == event.phase ) then

		local diffX = event.x - char.x
		char:applyLinearImpulse( diffX/2000, -0.2, char.x, char.y )
	end
	return true
end


-- Add collision listener to character
char.preCollision = localPreCollision
char:addEventListener( "preCollision" )

-- Create an invisible touch-sensitive rectangle to handle screen touches
local touchRect = display.newRect( worldGroup, display.contentCenterX, sampleUI.titleBarBottom, 600, 400 )
touchRect.isVisible = false
touchRect.isHitTestable = true
touchRect.anchorY = 0
touchRect:addEventListener( "touch", doJump )
