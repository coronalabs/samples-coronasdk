-- Abstract: MultiPuck sample project
-- Demonstrates multitouch and draggable phyics objects using "touch joints" in gameUI library
--
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- History
--  1.0		9/1/10		Initial version
--	1.1		5/13/11		Fixed bug with stuck pucks. Added "return" to dragBody()
--						Added "return true" to spawnDisk()
--  1.2     6/28/11     Call table.remove in removeOffscreenItems to keep allDisks as an array
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")
local gameUI = require("gameUI")
local easingx  = require("easingx")

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

popSound = audio.loadSound ("pop2_wav.wav")
labelFont = gameUI.newFontXP{ ios="Zapfino", android=native.systemFont }

system.activate( "multitouch" )

local bkg = display.newImage( "paper_bkg.png", centerX, centerY, true )

local myLabel = display.newText( "Touch screen to create pucks", centerX, 200, labelFont, 34 )
myLabel:setFillColor( 1, 1, 1, 180/250 )

local diskGfx = { "puck_yellow.png", "puck_green.png", "puck_red.png" }
local allDisks = {} -- empty table for storing objects

-- Automatic culling of offscreen objects
local function removeOffscreenItems()
	for i = 1, #allDisks do
		local oneDisk = allDisks[i]
		if (oneDisk and oneDisk.x) then
			if oneDisk.x < -100 or oneDisk.x > display.contentWidth + 100 or oneDisk.y < -100 or oneDisk.y > display.contentHeight + 100 then
				oneDisk:removeSelf()
                table.remove( allDisks, i ) 
 			end	
		end
	end
end

local function dragBody( event )
	return gameUI.dragBody( event )
	
	-- Substitute one of these lines for the line above to see what happens!
	--gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
	--gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
end

local function spawnDisk( event )
	local phase = event.phase
	
	if "ended" == phase then
		audio.play( popSound )
		myLabel.isVisible = false

		randImage = diskGfx[ math.random( 1, 3 ) ]
		allDisks[#allDisks + 1] = display.newImage( randImage )
		local disk = allDisks[#allDisks]
		disk.x = event.x; disk.y = event.y
		disk.rotation = math.random( 1, 360 )
		disk.xScale = 0.8; disk.yScale = 0.8
		
		transition.to(disk, { time = 500, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation
		
		physics.addBody( disk, { density=0.3, friction=0.6, radius=66.0 } )
		disk.linearDamping = 0.4
		disk.angularDamping = 0.6
		
		disk:addEventListener( "touch", dragBody ) -- make object draggable
	end
	
	return true
end

bkg:addEventListener( "touch", spawnDisk ) -- touch the screen to create disks
Runtime:addEventListener( "enterFrame", removeOffscreenItems ) -- clean up offscreen disks
