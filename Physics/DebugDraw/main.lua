-- 
-- Abstract: DebugDraw sample project
-- Demonstrates physics.setDrawMode() and draggable objects using "touch joints"
-- 
-- Version: 1.3 (September 27, 2010) -- includes new "gameUI" library for dragging objects
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require("physics")
local gameUI = require("gameUI")
physics.start()

system.activate( "multitouch" )
display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImage( "night_sky.png", 160, 240 )

local instructionLabel = display.newText( "drag any object", centerX, 25, native.systemFontBold, 20 )
instructionLabel:setFillColor( 1, 1, 1, 40/255 )

local ground = display.newImage("ground.png", 160, 415 ) -- physical ground object
physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )

local grass2 = display.newImage("grass2.png", 160, 464) -- non-physical decorative overlay

local dragBody = gameUI.dragBody -- for use in touch event listener below

local function newCrate()	
	rand = math.random( 100 )
	local j

	if (rand < 45) then
		j = display.newImage("crate.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=0.9, friction=0.3, bounce=0.3 } )
		
	elseif (rand < 60) then
		j = display.newImage("crateB.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=1.4, friction=0.3, bounce=0.2 } )
		
	elseif (rand < 80) then
		j = display.newImage("rock.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=3.0, friction=0.3, bounce=0.1, radius=33 } )
		
	else
		j = display.newImage("crateC.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=0.3, friction=0.2, bounce=0.5 } )
		
	end

	j:addEventListener( "touch", dragBody )
end

local function drawNormal()
	physics.setDrawMode( "normal" )
end

local function drawDebug()
	physics.setDrawMode( "debug" )
end

local function drawHybrid()
	physics.setDrawMode( "hybrid" )
end

local function setPhysicsDrawMode( event )
	local newDrawMode = event.target.drawMode
	
	if event.phase == "began" then
		--Set the new draw mode
		physics.setDrawMode( newDrawMode )
	end
	
	return true
end


--Create 3 buttons to change between physics draw modes
local button = {}

button[1] = display.newImage( "smallButton.png", true )
button[1].drawMode = "normal"
button[1].label = display.newText( "Normal", 0, 0, native.systemFont, 16 )
button[1].x = 55
button[1].y = 450
button[1].label.x = button[1].x
button[1].label.y = button[1].y

button[2] = display.newImage( "smallButton.png", true )
button[2].drawMode = "debug"
button[2].label = display.newText( "Debug", 0, 0, native.systemFont, 16 )
button[2].x = 160
button[2].y = 450
button[2].label.x = button[2].x
button[2].label.y = button[2].y

button[3] = display.newImage( "smallButton.png", true )
button[3].drawMode = "hybrid"
button[3].label = display.newText( "Hybrid", 0, 0, native.systemFont, 16 )
button[3].x = 265
button[3].y = 450
button[3].label.x = button[3].x
button[3].label.y = button[3].y

for i = 1, #button do
	-- Make buttons into physics objects so they remain visible in "debug" draw mode
	physics.addBody( button[i], "static", { density=1.0 } )
	
	--Add event listener to all buttons
	button[i]:addEventListener( "touch", setPhysicsDrawMode )
end


local dropCrates = timer.performWithDelay( 500, newCrate, 120 )