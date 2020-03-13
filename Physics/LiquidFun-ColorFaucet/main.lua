
-- Abstract: Liquid Fun - Color Faucet
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Color Faucet", showBuildNum=false } )

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

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )
local physics = require( "physics" )
physics.start()

-- Local variables and forward declarations
local letterboxWidth = math.abs(display.screenOriginX)
local letterboxHeight = math.abs(display.screenOriginY)
local touchBehavior = "move"
local previousTime = 0
local previousX = 0
local previousY = 0
local touchX = 0
local touchY = 0
local velocityX = 0
local velocityY = 0
local box

-- Create "walls and floor" around screen
local wallL = display.newRect( mainGroup, 0-letterboxWidth, display.contentCenterY+150, 20, display.actualContentHeight-150 )
wallL.anchorX = 1
physics.addBody( wallL, "static", { bounce=1, friction=0.1 } )

local wallR = display.newRect( mainGroup, 320+letterboxWidth, display.contentCenterY+150, 20, display.actualContentHeight-150 )
wallR.anchorX = 0
physics.addBody( wallR, "static", { bounce=1, friction=0.1 } )

local floor = display.newRect( mainGroup, display.contentCenterX, 480+letterboxHeight, display.actualContentWidth, 20 )
floor.anchorY = 0
physics.addBody( floor, "static", { bounce=0.4, friction=0.6 } )

-- Create the particle system
local particleSystem = physics.newParticleSystem(
{
	filename = "waterParticle.png",
	colorMixingStrength = 0.2,
	radius = 1.5,
	imageRadius = 4.5
})
mainGroup:insert( particleSystem )

-- Parameters for red particle faucet
local particleParamsRed = {
	x = 0-letterboxWidth,
	y = 150-letterboxHeight,
	velocityX = 110,
	velocityY = 80,
	color = { 1, 0, 0.2, 1 },
	lifetime = 48,
	flags = { "water", "colorMixing" }
}

-- Parameters for blue particle faucet
local particleParamsBlue =
{
	x = 320+letterboxWidth,
	y = 150-letterboxHeight,
	velocityX = -110,
	velocityY = 80,
	color = { 0.2, 0.4, 1, 1 },
	lifetime = 48,
	flags = { "water", "colorMixing" }
}

-- Generate particles on repeating timer
local function onTimer( event )
	particleSystem:createParticle( particleParamsRed )
	particleSystem:createParticle( particleParamsBlue )
end
timer.performWithDelay( 10, onTimer, 0 )

-- Function to query region or destroy particles in particle system
local function enterFrame( event )

	if ( touchBehavior == "move" ) then
		local region = particleSystem:queryRegion(
			box.x - 16,
			box.y - 16,
			box.x + 16,
			box.y + 16,
			{ velocityX=velocityX, velocityY=velocityY }
		)
	elseif ( touchBehavior == "destroy" ) then
		local region = particleSystem:destroyParticles(
		{
			x = box.x,
			y = box.y,
			halfWidth = 16,
			halfHeight = 16
		})
	end
end

-- Function to create/move/remove "touch box"
local function onTouch( event )

	local timeDelta = ( event.time / 1000 ) - previousTime
	if ( timeDelta > 0 ) then
		touchX = event.x
		touchY = event.y
		previousTime = ( event.time / 1000 )
		local positionDeltaX = touchX - previousX
		local positionDeltaY = touchY - previousY
		previousX = touchX
		previousY = touchY
		velocityX = ( positionDeltaX / timeDelta )
		velocityY = ( positionDeltaY / timeDelta )
	end

	if ( "began" == event.phase ) then

		Runtime:addEventListener( "enterFrame", enterFrame )
		velocityX = 0.0
		velocityY = 0.0
		box = display.newRect( mainGroup, event.x, event.y, 32, 32 )
		box.strokeWidth = 2
		box:setStrokeColor( 1, 0.4, 0.25 )
		box:setFillColor( 1, 0.4, 0.25, 0.2 )

	elseif ( "moved" == event.phase ) then

		if box then
			box.x = event.x
			box.y = event.y
		end

	elseif ( "ended" == event.phase or "cancelled" == event.phase ) then

		Runtime:removeEventListener( "enterFrame", enterFrame )
		display.remove( box )
		box = nil
	end
	return true
end
Runtime:addEventListener( "touch", onTouch )

-- Switches and labels
local switchGroup = display.newGroup()
mainGroup:insert( switchGroup )

local label1 = display.newText( switchGroup, "On touch:", 0, 0, appFont, 15 )
label1:setFillColor( 0.8 )
label1.anchorX = 1

local switch1 = widget.newSwitch(
{
	x = label1.x+26,
	y = 0,
	style = "radio",
	initialSwitchState = true,
	onEvent = function( event )
		Runtime:removeEventListener( "enterFrame", enterFrame )
		display.remove( box )
		box = nil
		if event.phase == "began" then
			touchBehavior = "move"
		end
	end
})
switchGroup:insert( switch1 )

local label2 = display.newText( switchGroup, "move/flick", switch1.x+22, 0, appFont, 15 )
label2.anchorX = 0

local switch2 = widget.newSwitch(
{
	x = label2.contentBounds.xMax+28,
	y = 0,
	style = "radio",
	initialSwitchState = false,
	onEvent = function( event )
		Runtime:removeEventListener( "enterFrame", enterFrame )
		display.remove( box )
		box = nil

		if event.phase == "began" then
			touchBehavior = "destroy"
		end
	end
})
switchGroup:insert( switch2 )

local label3 = display.newText( switchGroup, "destroy", switch2.x+22, 0, appFont, 15 )
label3.anchorX = 0

switchGroup.anchorChildren = true
switchGroup.x = display.contentCenterX
switchGroup.y = 80 - letterboxHeight
