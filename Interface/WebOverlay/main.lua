-- Project: WebOverlay
--
-- Date: September 10, 2010
--
-- Version: 1.4
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Displays a WebPopUp over the Fishies program, using local HTML as the source
--
-- Demonstrates: native.showWebPopup, checking for Corona Simulator & Andriod device
--
-- File dependencies: none
--
-- Target devices: Device
--
-- Limitations: WebPopUps don't work in Simulator (but do work in the Mac simulator)
--
-- Update History:
--	v1.4 	Use .wav sound
--
-- Comments: Displays a local HTML file as a WebPopUp. This is useful not only for web content,
-- but for easily displaying some scrolling, formatted text, such as an instructions page.
-- In this case, the background is transparent, allowing the content beneath to show through.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Determine if running on Corona Simulator
--
display.setStatusBar( display.HiddenStatusBar )
local isSimulator = "simulator" == system.getInfo("environment")
if system.getInfo( "platformName" ) == "Mac OS X" then isSimulator = false; end

local soundID = audio.loadSound ("bubble_strong_wav.wav")

local function listener( event )
	local shouldLoad = true

	local url = event.url
	if 1 == string.find( url, "corona:close" ) then
		-- Close the web popup
		shouldLoad = false
	end

	return shouldLoad
end

local options = { hasBackground=false, baseUrl=system.ResourceDirectory, urlRequest=listener }
native.showWebPopup( "localpage.html", options )


-- Everything below this line is the same as the "Fishies" sample app
-------------------------------------------------------------------------------

-- Seed randomizer
local seed = os.time();
math.randomseed( seed )

-- Background
local halfW = display.contentCenterX
local halfH = display.contentCenterY

local backgroundPortrait = display.newImage( "aquariumbackgroundIPhone.jpg", halfW, halfH )
local backgroundLandscape = display.newImage( "aquariumbackgroundIPhoneLandscape.jpg", halfH-80, halfW+80 )
backgroundLandscape.isVisible = false
local background = backgroundPortrait

-- Handle changes in orientation for the background images
local backgroundOrientation = function( event )
	-- TODO: This requires some setup, i.e. the landscape needs to be centered
	-- Need to add a centering operation.  For now, the position is hard coded
	local delta = event.delta
	if ( delta ~= 0 ) then
		local rotateParams = { rotation=-delta, time=500, delta=true }

		if ( delta == 90 or delta == -90 ) then
			local src = background

			-- toggle background to refer to correct dst
			background = ( backgroundLandscape == background and backgroundPortrait ) or backgroundLandscape
			background.rotation = src.rotation
			transition.dissolve( src, background )
			transition.to( src, rotateParams )
		else
			assert( 180 == delta or -180 == delta )
		end

		transition.to( background, rotateParams )

		audio.play( soundID )
	end
end

-- Add a global listener
Runtime:addEventListener( "orientation", backgroundOrientation )

-- Fishies
local numFish = 10
local file1 = "fish.small.red.png"
local file2 = "fish.small.blue.png"

-- Define touch listener for fish so that fish can behave like buttons.
-- The listener will receive an 'event' argument containing a "target" property
-- corresponding to the object that was the target of the interaction.
-- This eliminates closure overhead (i.e. the need to reference non-local variables )
local buttonListener = function( event )
	local group = event.target

	-- tap only triggers change from original to different color
	local topObject = group[1]

	if ( topObject.isVisible ) then
		local bottomObject = group[2]

		-- Dissolve to bottomObject (different color)
		transition.dissolve( topObject, bottomObject, 500 )

		-- Restore after some random delay
		transition.dissolve( bottomObject, topObject, 500, math.random( 3000, 10000 ) )
	end

	-- we handled it so return true to stop propagation
	return true
end


-- Create a table to store all the fish and register this table as the 
-- "enterFrame" listener to animate all the fish.
local bounceAnimation = {
	container = display.getCurrentStage(),
	reflectX = true,
}

-- Add fish to the screen
for i=1,numFish do
	-- create group which will represent our fish, storing both images (file1 and file2)
	local group = display.newGroup()

	local fishOriginal = display.newImage( file1 )
	group:insert( fishOriginal, true )  -- accessed in buttonListener as group[1]

	local fishDifferent = display.newImage( file2 )
	group:insert( fishDifferent, true ) -- accessed in buttonListener as group[2]
	fishDifferent.isVisible = false -- make file2 invisible

	-- move to random position in a 200x200 region in the middle of the screen
	group:translate( halfW + math.random( -100, 100 ), halfH + math.random( -100, 100 ) )

	-- connect buttonListener. touching the fish will cause it to change to file2's image
	group:addEventListener( "touch", buttonListener )

	-- assign each fish a random velocity
	group.vx = math.random( 1, 5 )
	group.vy = math.random( -2, 2 )

	-- add fish to animation group so that it will bounce
	bounceAnimation[ #bounceAnimation + 1 ] = group
end

-- Function to animate all the fish
function bounceAnimation:enterFrame( event )
	local container = self.container
	local containerBounds = container.contentBounds
	local xMin = containerBounds.xMin
	local xMax = containerBounds.xMax
	local yMin = containerBounds.yMin
	local yMax = containerBounds.yMax

	local orientation = self.currentOrientation
	local isLandscape = "landscapeLeft" == orientation or "landscapeRight" == orientation

	local reflectX = nil ~= self.reflectX
	local reflectY = nil ~= self.reflectY

	-- the fish groups are stored in integer arrays, so iterate through all the 
	-- integer arrays
	for i,v in ipairs( self ) do
		local object = v  -- the display object to animate, e.g. the fish group
		local vx = object.vx
		local vy = object.vy

		if ( isLandscape ) then
			if ( "landscapeLeft" == orientation ) then
				local vxOld = vx
				vx = -vy
				vy = vxOld
			elseif ( "landscapeRight" == orientation ) then
				local vxOld = vx
				vx = vy
				vy = -vxOld
			end
		elseif ( "portraitUpsideDown" == orientation ) then
			vx = -vx
			vy = -vy
		end

		-- TODO: for now, time is measured in frames instead of seconds...
		local dx = vx
		local dy = vy

		local bounds = object.contentBounds

		local flipX = false
		local flipY = false

		if (bounds.xMax + dx) > xMax then
			flipX = true
			dx = xMax - bounds.xMax
		elseif (bounds.xMin + dx) < xMin then
			flipX = true
			dx = xMin - bounds.xMin
		end

		if (bounds.yMax + dy) > yMax then
			flipY = true
			dy = yMax - bounds.yMax
		elseif (bounds.yMin + dy) < yMin then
			flipY = true
			dy = yMin - bounds.yMin
		end

		if ( isLandscape ) then flipX,flipY = flipY,flipX end
		if ( flipX ) then
			object.vx = -object.vx
			if ( reflectX ) then object:scale( -1, 1 ) end
		end
		if ( flipY ) then
			object.vy = -object.vy
			if ( reflectY ) then object:scale( 1, -1 ) end
		end

		object:translate( dx, dy )
	end
end

-- Handle orientation of the fish
function bounceAnimation:orientation( event )
	print( "bounceAnimation" )
	for k,v in pairs( event ) do
		print( "   " .. tostring( k ) .. "(" .. tostring( v ) .. ")" )
	end

	if ( event.delta ~= 0 ) then
		local rotateParameters = { rotation = -event.delta, time=500, delta=true }

		Runtime:removeEventListener( "enterFrame", self )
		self.currentOrientation = event.type

		for i,object in ipairs( self ) do
			transition.to( object, rotateParameters )
		end

		local function resume(event)
			Runtime:addEventListener( "enterFrame", self )
		end

		timer.performWithDelay( 500, resume )
	end
end

-- WebPopUp is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "WebPopUp not supported on Simulator!", 0, 0, native.systemFont, 14 )
	msg.x = display.contentWidth/2		-- center title
	msg.y = display.contentHeight/2		-- center title
	msg:setFillColor( 1,1,0 )
end

Runtime:addEventListener( "enterFrame", bounceAnimation );
Runtime:addEventListener( "orientation", bounceAnimation )

