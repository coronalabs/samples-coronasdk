
-- Abstract: CollisionFilters
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
sampleUI:newUI( { theme="darkgrey", title="Collision Filters", showBuildNum=false } )

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
local physics = require( "physics" )
physics.start()

-- Local variables and forward references
local letterboxWidth = math.abs(display.screenOriginX)
local letterboxHeight = math.abs(display.screenOriginY)

-- Create image sheet for fish
local sheetOptions = {
	width = 55,
	height = 42,
	numFrames = 2,
	sheetContentWidth = 110,
	sheetContentHeight = 42
}
local imageSheet = graphics.newImageSheet( "fish.png", sheetOptions )

-- Set up collision filters
local borderCollisionFilter = { categoryBits=1, maskBits=6 }
local blueCollisionFilter = { categoryBits=4, maskBits=5 }
local orangeCollisionFilter = { categoryBits=2, maskBits=3 }

-- Create "walls" around screen
local wallL = display.newRect( mainGroup, 0-letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallL.anchorX = 1
physics.addBody( wallL, "static", { bounce=0.5, friction=0.1, filter=borderCollisionFilter } )

local wallR = display.newRect( mainGroup, 320+letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallR.anchorX = 0
physics.addBody( wallR, "static", { bounce=0.5, friction=0.1, filter=borderCollisionFilter } )

local wallT = display.newRect( mainGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
wallT.anchorY = 1
physics.addBody( wallT, "static", { bounce=0.5, friction=0.1, filter=borderCollisionFilter } )

local wallB = display.newRect( mainGroup, display.contentCenterX, 480+letterboxHeight, display.actualContentWidth, 20 )
wallB.anchorY = 0
physics.addBody( wallB, "static", { bounce=0.5, friction=0.1, filter=borderCollisionFilter } )

-- Create blue fish
for b = 1,4 do
	local blueFish = display.newSprite( mainGroup, imageSheet, { name="swim", start=1, count=2, time=200 } )
	blueFish.x, blueFish.y = 20-letterboxWidth, 60*b
	blueFish:setFillColor( 0.8, 1, 1 )
	blueFish.fill.effect = "filter.hue"
	blueFish.fill.effect.angle = 10
	blueFish:play()
	physics.addBody( blueFish, "dynamic", { bounce=1, friction=0, radius=20, filter=blueCollisionFilter } )
	blueFish.isFixedRotation = true
	blueFish:applyLinearImpulse( math.random(2,6)/50, 0, blueFish.x, blueFish.y )
end

-- Create orange fish
for r = 1,4 do
	local orangeFish = display.newSprite( mainGroup, imageSheet, { name="swim", start=1, count=2, time=200 } )
	orangeFish.x, orangeFish.y = 300+letterboxWidth, 60*r
	orangeFish:setFillColor( 1, 1, 0.5 )
	orangeFish.fill.effect = "filter.hue"
	orangeFish.fill.effect.angle = 250
	orangeFish.xScale = -1
	orangeFish:play()
	physics.addBody( orangeFish, "dynamic", { bounce=1, friction=0, radius=20, filter=orangeCollisionFilter } )
	orangeFish.isFixedRotation = true
	orangeFish:applyLinearImpulse( (math.random(2,6)/50)*-1, 0, orangeFish.x, orangeFish.y )
end
