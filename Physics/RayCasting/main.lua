
-- Abstract: RayCasting
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Ray Casting", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local beamGroup = display.newGroup()
local mirrorGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set up physics engine
local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

-- Declare initial variables
local turret
local maxBeams = 50
local turretSpeed = 50

-- Load sound
local sndLaserHandle = audio.loadSound( "laser-blast.wav" )


local function clearObject( object )
	display.remove( object )
	object = nil
end


local function resetBeams()

	-- Clear all beams/bursts from display
	for i = beamGroup.numChildren,1,-1 do
		local child = beamGroup[i]
		display.remove( child )
		child = nil
	end

	-- Reset beam group alpha
	beamGroup.alpha = 1

	-- Restart turret rotating after firing is finished
	turret.angularVelocity = turretSpeed
end


local function drawBeam( startX, startY, endX, endY )

	-- Draw a series of overlapping lines to represent the beam
	local beam1 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
	local beam2 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
	local beam3 = display.newLine( beamGroup, startX, startY, endX, endY )
	beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
end


local function castRay( startX, startY, endX, endY )

	-- Perform ray cast
	local hits = physics.rayCast( startX, startY, endX, endY, "closest" )

	-- There is a hit; calculate the entire ray sequence (initial ray and reflections)
	if ( hits and beamGroup.numChildren <= maxBeams ) then

		-- Store first hit to variable (just the "closest" hit was requested, so use 'hits[1]')
		local hitFirst = hits[1]

		-- Store the hit X and Y position to local variables
		local hitX, hitY = hitFirst.position.x, hitFirst.position.y

		-- Place a visual "burst" at the hit point and animate it
		local burst = display.newImageRect( beamGroup, "burst.png", 64, 64 )
		burst.x, burst.y = hitX, hitY
		burst.blendMode = "add"
		transition.to( burst, { time=1000, rotation=45, alpha=0, transition=easing.outQuad, onComplete=clearObject } )

		-- Draw the next beam
		drawBeam( startX, startY, hitX, hitY )

		-- Check for and calculate the reflected ray
		local reflectX, reflectY = physics.reflectRay( startX, startY, hitFirst )
		local reflectLen = 1600
		local reflectEndX = ( hitX + ( reflectX * reflectLen ) )
		local reflectEndY = ( hitY + ( reflectY * reflectLen ) )

		-- If the ray is reflected, cast another ray
		if ( reflectX and reflectY ) then
			timer.performWithDelay( 40, function() castRay( hitX, hitY, reflectEndX, reflectEndY ); end )
		end

	-- Else, ray casting sequence is complete
	else

		-- Draw the final beam
		drawBeam( startX, startY, endX, endY )

		-- Fade out entire beam group after a short delay
		transition.to( beamGroup, { time=800, delay=400, alpha=0, onComplete=resetBeams } )
	end
end


local function fireOnTimer( event )

	-- Ensure that all previous beams/bursts are cleared/complete before firing
	if ( beamGroup.numChildren == 0 ) then

		-- Stop rotating turret as it fires
		turret.angularVelocity = 0

		-- Play laser sound
		audio.play( sndLaserHandle )

		-- Calculate ending x/y of beam
		local xDest = turret.x - (math.cos(math.rad(turret.rotation+90)) * 1600 )
		local yDest = turret.y - (math.sin(math.rad(turret.rotation+90)) * 1600 )

		-- Cast the initial ray
		castRay( turret.x, turret.y, xDest, yDest )
	end
end

-- Set up mirror positions relative to the center of the content area
local mirrorSet = {
	{ 0, -125, 90 },    -- top
	{ 105, -60, -35 },  -- right-upper
	{ 105, 60, 35 },    -- right-lower
	{ 0, 125, 90 },     -- bottom
	{ -105, -60, 35 },  -- left-upper
	{ -105, 60, -35 }   -- left-lower
}

local mirrors = {}

-- Create mirrors
for m = 1,#mirrorSet do
	local mirror = display.newImageRect( mirrorGroup, "mirror.png", 20, 80 )
	physics.addBody( mirror, "static", { shape={-9,-39,9,-39,9,39,-9,39} } )
	mirror.x = display.contentCenterX + mirrorSet[m][1]
	mirror.y = display.contentCenterY + mirrorSet[m][2]
	mirror.rotation = mirrorSet[m][3]
	mirrors[m] = mirror
end

-- Create turret
turret = display.newImageRect( mirrorGroup, "turret.png", 48, 48 )
physics.addBody( turret, "dynamic", { radius=18 } )
turret.x, turret.y = display.contentCenterX, display.contentCenterY

-- Start rotating turret
turret.angularVelocity = turretSpeed

-- Start repeating timer to fire beams
timer.performWithDelay( 2000, fireOnTimer, 0 )

-- Update the app layout on resize event
local function onResize( event )
	-- Change turret location
	turret.x, turret.y = display.contentCenterX, display.contentCenterY

	-- Update mirror locations
	for index, mirror in pairs(mirrors) do
		mirror.x = display.contentCenterX + mirrorSet[index][1]
		mirror.y = display.contentCenterY + mirrorSet[index][2]
	end

	-- Reset any beams, as they are drawn in the incorrect location now
	resetBeams()
end
Runtime:addEventListener( "resize", onResize )

-- On tvOS, make sure the app stays awake
-- Also ensure that the menu button exits the app
if ( system.getInfo( "platformName" ) == "tvOS" ) then
	system.activate( "controllerUserInteraction" )
	system.setIdleTimer( false )
end
