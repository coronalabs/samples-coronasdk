
-- Abstract: CollisionDetection
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Fish sprite images courtesy of Kenney; see http://kenney.nl/
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Collision Detection", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Local variables and forward references
local letterboxWidth = math.abs(display.screenOriginX)
local letterboxHeight = math.abs(display.screenOriginY)
local currentDrawMode = "normal"

-- Require libraries/plugins
local widget = require( "widget" )
local physics = require( "physics" )
physics.start()
physics.setDrawMode( currentDrawMode )

-- Set app font
local appFont = sampleUI.appFont

-- Create image sheet for fish
local sheetOptions = {
	width = 55,
	height = 42,
	numFrames = 2,
	sheetContentWidth = 110,
	sheetContentHeight = 42
}
local imageSheet = graphics.newImageSheet( "fish.png", sheetOptions )

-- Create "walls" around screen
local wallL = display.newRect( mainGroup, 0-letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallL.myName = "Left Wall"
wallL.anchorX = 1
physics.addBody( wallL, "static", { bounce=0.5, friction=0.1 } )

local wallR = display.newRect( mainGroup, 320+letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallR.myName = "Right Wall"
wallR.anchorX = 0
physics.addBody( wallR, "static", { bounce=0.5, friction=0.1 } )

local wallT = display.newRect( mainGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
wallT.myName = "Top Wall"
wallT.anchorY = 1
physics.addBody( wallT, "static", { bounce=0.5, friction=0.1 } )

local wallB = display.newRect( mainGroup, display.contentCenterX, 480+letterboxHeight, display.actualContentWidth, 20 )
wallB.myName = "Bottom Wall"
wallB.anchorY = 0
physics.addBody( wallB, "static", { bounce=0.5, friction=0.1 } )

-- Function to place a visual "burst" at the collision point and animate it
local function newBurst( collisionX, collisionY )

	local burst = display.newImageRect( mainGroup, "burst.png", 64, 64 )
	burst.x, burst.y = collisionX, collisionY
	burst.blendMode = "add"
	burst:toBack()
	transition.to( burst, { time=1000, rotation=45, alpha=0, transition=easing.outQuad,
		onComplete = function()
			display.remove( burst )
		end
	})
end

-- METHOD 1: "local" collision detection reports collisions between "self" and "event.other"
local function onLocalCollision( self, event )

	if ( event.phase == "began" ) then
		print( "LOCAL REPORT: " .. self.myName .. " & " .. event.other.myName )
		newBurst( event.x, event.y )
	end
end

-- METHOD 2: "global" collision detection uses a Runtime listener to report collisions between "event.object1" and "event.object2"
-- Note that the order of "event.object1" and "event.object2" may be reported arbitrarily in any collision
local function onGlobalCollision( event )

	if ( event.phase == "began" ) then
		print( "GLOBAL REPORT: " .. event.object1.myName .. " & " .. event.object2.myName )
		newBurst( event.x, event.y )
	end
end
Runtime:addEventListener( "collision", onGlobalCollision )

-- Create blue fish
for b = 1,2 do
	local blueFish = display.newSprite( mainGroup, imageSheet, { name="swim", start=1, count=2, time=200 } )
	blueFish.x, blueFish.y = letterboxWidth, 60*b
	blueFish:setFillColor( 0.8, 1, 1 )
	blueFish.myName = "Blue Fish " .. b
	blueFish.fill.effect = "filter.hue"
	blueFish.fill.effect.angle = 10
	blueFish:play()
	physics.addBody( blueFish, "dynamic", { bounce=1, friction=0, radius=20 } )
	blueFish.isFixedRotation = true
	blueFish:applyLinearImpulse( math.random(2,6)/50, 0, blueFish.x, blueFish.y )
	-- Add local collision detection to this fish (an alternative to global detection set via line 105)
	--blueFish.collision = onLocalCollision
	--blueFish:addEventListener( "collision" )
end

-- Create orange fish
for r = 1,2 do
	local orangeFish = display.newSprite( mainGroup, imageSheet, { name="swim", start=1, count=2, time=200 } )
	orangeFish.x, orangeFish.y = 320-letterboxWidth, 60*r
	orangeFish:setFillColor( 1, 1, 0.5 )
	orangeFish.myName = "Orange Fish " .. r
	orangeFish.fill.effect = "filter.hue"
	orangeFish.fill.effect.angle = 250
	orangeFish.xScale = -1
	orangeFish:play()
	physics.addBody( orangeFish, "dynamic", { bounce=1, friction=0, radius=20 } )
	orangeFish.isFixedRotation = true
	orangeFish:applyLinearImpulse( (math.random(2,6)/50)*-1, 0, orangeFish.x, orangeFish.y )
	-- Add local collision detection to this fish (an alternative to global detection set via line 105)
	--orangeFish.collision = onLocalCollision
	--orangeFish:addEventListener( "collision" )
end

-- Obtain collision positions in content coordinates
physics.setReportCollisionsInContentCoordinates( true )

-- Obtain an average of all collision positions
physics.setAverageCollisionPositions( true )

-- Physics "draw mode" buttons
local normalButton = widget.newButton(
{
	x = 60,
	y = 450 + letterboxHeight,
	label = "normal",
	id = "normal",
	shape = "rectangle",
	width = 90,
	height = 32,
	font = appFont,
	fontSize = 15,
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = function( event ) currentDrawMode = event.target.id; physics.setDrawMode( currentDrawMode ); end
})
mainGroup:insert( normalButton )

local hybridButton = widget.newButton(
{
	x = display.contentCenterX,
	y = 450 + letterboxHeight,
	label = "hybrid",
	id = "hybrid",
	shape = "rectangle",
	width = 90,
	height = 32,
	font = appFont,
	fontSize = 15,
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = function( event ) currentDrawMode = event.target.id; physics.setDrawMode( currentDrawMode ); end
})
mainGroup:insert( hybridButton )

local debugButton = widget.newButton(
{
	x = 260,
	y = 450 + letterboxHeight,
	label = "debug",
	id = "debug",
	shape = "rectangle",
	width = 90,
	height = 32,
	font = appFont,
	fontSize = 15,
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = function( event ) currentDrawMode = event.target.id; physics.setDrawMode( currentDrawMode ); end
})
mainGroup:insert( debugButton )

-- Include callback function for showing/hiding info box
-- In this sample, the physics draw mode is adjusted when appropriate
sampleUI.onInfoEvent = function( event )

	if ( event.action == "show" and event.phase == "will" ) then
		physics.setDrawMode( "normal" )
	elseif ( event.action == "hide" and event.phase == "did" ) then
		physics.setDrawMode( currentDrawMode )
	end
end
