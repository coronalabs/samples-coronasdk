--
-- Project: Compass
--
-- Date: August 19, 2010
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Compass sample app
--
-- Demonstrates: heading events, buttons, touch
--
-- File dependencies: none.
--
-- Target devices: iPhone 3GS or newer for compass data.
--
-- Update History:
--	v1.3	Added Simulator warning message
--	v1.4	Changed check from Simulator to system.hasEventSource( )
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Labels for digital display
local headingGeo = display.newText( "0°", 0, 0, native.systemFontBold, 38 )
headingGeo.anchorX = 1.0	-- right anchor
headingGeo:setFillColor( 35/255, 170/255, 1 )
headingGeo.x, headingGeo.y = 133 - headingGeo.contentWidth * 0.5, 72

local directionGeo = display.newText( "N", 0, 0, native.systemFontBold, 16 )
directionGeo.anchorX = 0.0	-- left anchor
directionGeo:setFillColor( 35/255, 170/255, 1 )
directionGeo.x, directionGeo.y = 106 + directionGeo.contentWidth * 0.5, 76

local headingMag = display.newText( "0°", 0, 0, native.systemFontBold, 38 )
headingMag.anchorX = 1.0	-- right anchor
headingMag:setFillColor( 153/255, 153/255, 153/255 )
headingMag.x, headingMag.y = 283 - headingMag.contentWidth * 0.5, 72

local directionMag = display.newText( "N", 0, 0, native.systemFontBold, 16 )
directionMag.anchorX = 0.0	-- left anchor
directionMag:setFillColor( 153/255, 153/255, 153/255 )
directionMag.x, directionMag.y = 256 + directionMag.contentWidth * 0.5, 76

local dial = display.newImage("compass_dial.png", display.contentCenterX, display.contentCenterY + 30)
local background = display.newImage("compass_bkg.png", display.contentCenterX, display.contentCenterY)

local compassMode = "geo"

local showGeo = function( event )
	if event.phase == "began" then
		print("geo")
		headingGeo:setFillColor( 35/255, 170/255, 1, 1 )
		directionGeo:setFillColor( 35/255, 170/255, 1)
		headingMag:setFillColor( 153/255, 153/255, 153/255 )
		directionMag:setFillColor( 153/255, 153/255, 153/255)
		compassMode = "geo"
	end
	
	return true
end

local showMag = function( event )
	if event.phase == "began" then
		print("mag")
		headingGeo:setFillColor( 153/255, 153/255, 153/255 )
		directionGeo:setFillColor( 153/255, 153/255, 153/255 )
		headingMag:setFillColor( 35/255, 170/255, 1 )
		directionMag:setFillColor( 35/255, 170/255, 1 )
		compassMode = "mag"
	end
	
	return true
end

-- Add touch events to textfields (for switching between geographic/magnetic display modes)
headingGeo:addEventListener( "touch", showGeo )
headingMag:addEventListener( "touch", showMag )

local directionForAngle = function( angle )
	local text

	if ( angle <= 22 or angle > 337 ) then
		text = "N"
	elseif ( angle > 22 and angle <= 67 ) then
		text = "NE"
	elseif ( angle > 67 and angle <= 112 ) then
		text = "E"
	elseif ( angle > 112 and angle <= 157 ) then
		text = "SE"
	elseif ( angle > 157 and angle <= 202 ) then
		text = "S"
	elseif ( angle > 202 and angle <= 247 ) then
		text = "SW"
	elseif ( angle > 247 and angle <= 292 ) then
		text = "W"
	elseif ( angle > 292 and angle <= 337 ) then
		text = "NW"
	end
	
	return text
end

local dstRotation = 0

local updateCompass = function( event )

	local angleMag, angleGeo
	
	-- Note: "magnetic" = magnetic north heading, and "geographic" = "true north" heading as seen on a map
	-- (The variance between these heading values depends on your position on the Earth)

	angleMag = event.magnetic

	-- Android does not support geographic headings, so we use magnetic headings for Android builds
	if system.getInfo( "platformName" ) ~= "Android" then
		angleGeo = event.geographic
	else
		angleGeo = angleMag
	end
	
	if ( "geo" == compassMode ) then
		dstRotation = -angleGeo
	else
		dstRotation = -angleMag
	end
	
	-- Format strings as whole numbers
	local valueGeo = string.format( '%.0f', angleGeo )
	local valueMag = string.format( '%.0f', angleMag )

	headingGeo.text  = valueGeo .. "°"
	directionGeo.text = directionForAngle( angleGeo )
	headingMag.text = valueMag .. "°"	
	directionMag.text = directionForAngle( angleMag )
end

local animateDial = function( event )
	local curRotation = dial.rotation
	local delta = dstRotation - curRotation
	
	if math.abs( delta ) >= 180 then
		if delta < -180 then
			delta = delta + 360
		elseif delta > 180 then
			delta = delta - 360
		end
	end

	dial.rotation = curRotation + delta*0.3
end

local didInitGPS = false
local initGPS = function( event )
	if ( not didInitGPS ) then
		didInitGPS = true

		-- We only need a single location event to calibrate "true north", then we can turn off GPS again
		local initDone = function( event )
			Runtime:removeEventListener( "location", initGPS )
		end

		-- Delay removal to let the hardware activate
		timer.performWithDelay( 1000, initDone )
	end
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Heading Events are not supported on Simulator
--
if not system.hasEventSource( "heading" ) then
	msg = display.newText( "Heading events not supported on this platform", 0, 20, native.systemFontBold, 12 )
	msg.x = display.contentCenterX		-- center title
	msg:setFillColor( 1,1,0 )
end

-- Location event listener
if system.getInfo( "platformName" ) ~= "Android" then
	Runtime:addEventListener( "location", initGPS )
end
-- This is not required if you only want the heading relative to magnetic north, but to calculate 
-- your "true north" offset, the iPhone needs at least one location reading. Location may already 
-- be cached by the OS, but if not, then geographic north heading defaults to "-1".
-- Again, this is not required for Android, since Android does not support true north headings.

-- Compass event listener
Runtime:addEventListener( "heading", updateCompass )

-- Adaptive tweening to smooth the dial animation
Runtime:addEventListener( "enterFrame", animateDial )
