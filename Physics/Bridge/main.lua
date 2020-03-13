
-- Abstract: Bridge
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Bridge", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set up physics engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 9.8 )
physics.setDrawMode( "normal" )

-- Set app font
local appFont = sampleUI.appFont

local msg = display.newText( mainGroup, "Touch bridge to break it; touch a ball to remove it", display.contentCenterX, 55+display.screenOriginY, appFont, 13 )
msg:setFillColor( 1, 0.4, 0.25 )

-- Function to break bridge
local function breakBridge( event )
	if ( "began" == event.phase ) then
		display.remove( event.target )
		event.target = nil
	end
	return true
end

-- Create left and right poles to mount bridge to
local poleLeft = display.newImageRect( mainGroup, "post.png", 40, 280 )
poleLeft.x, poleLeft.y = display.screenOriginX+20, display.contentCenterY+40
physics.addBody( poleLeft, "static" )
local poleRight = display.newImageRect( mainGroup, "post.png", 40, 280 )
poleRight.x, poleRight.y = 460-display.screenOriginX, display.contentCenterY+40
physics.addBody( poleRight, "static" )

-- Set number of bridge pieces and calculate size of each based on distance between poles
local numPieces = 16
local nextToJoin = poleLeft
local pieceWidth = ( (poleRight.x-(poleRight.width/2)+10) - (poleLeft.x+(poleLeft.width/2)-10) + ((numPieces-1)*10) ) / numPieces

-- Create bridge
for i = 1,numPieces do
	local piece = display.newRoundedRect( mainGroup, 0, display.contentCenterY, pieceWidth, 18, 3 )
	piece:toBack()

	piece:setFillColor( math.random(9,10)/10, math.random(0,2)/10, math.random(1,5)/10 )
	piece.x = nextToJoin.contentBounds.xMax + (piece.width/2) - 10
	physics.addBody( piece, { density=1.0, friction=0.4, bounce=0.2 } )
	physics.newJoint( "pivot", nextToJoin, piece, piece.contentBounds.xMin+(piece.height/2), piece.y )
	piece:addEventListener( "touch", breakBridge )  -- Assign touch listener to piece

	if ( i == numPieces ) then
		physics.newJoint( "pivot", poleRight, piece, poleRight.contentBounds.xMin+(piece.height/2), piece.y )
	else
		nextToJoin = piece
	end
end

-- Function to drop random balls
local function randomBall()

	local ball
	local choice = math.random( 10 )

	if ( choice < 8 ) then
		ball = display.newImageRect( mainGroup, "ball1.png", 40, 40 )
		ball.x = 60 + math.random(360)
		ball.y = -40 + display.screenOriginY
		physics.addBody( ball, { density=0.5, friction=0.6, bounce=0.5, radius=20 } )
	else
		ball = display.newImageRect( mainGroup, "ball2.png", 70, 70 )
		ball.x = 100 + math.random(280)
		ball.y = -70 + display.screenOriginY
		physics.addBody( ball, { density=2.0, friction=0.6, bounce=0.2, radius=35 } )
	end
	ball.angularVelocity = math.random(800) - 400
	ball.isSleepingAllowed = false
	ball:addEventListener( "touch",
		function( event )
			if ( "began" == event.phase ) then
				display.remove( ball )
			end
		end
	)
	ball:toBack()
end

-- Run the above function 12 times
timer.performWithDelay( 1500, randomBall, 12 )
