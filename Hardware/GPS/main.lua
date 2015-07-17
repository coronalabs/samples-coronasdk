--
-- Project: GPS
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: GPS sample app, showing available location event properties
--
-- Demonstrates: locations events, buttons, touch
--
-- File dependencies:
--
-- Target devices: iPhone 3GS or newer for GPS data.
--
-- Limitations: Location events not supported on Simulator
--
-- Update History:
--	v1.2	8/19/10		Added Simulator warning message
--  v1.3	11/28/11	Added test for Location error & alert box
--	v1.4	7/13/15		Changed check from Simulator to system.hasEventSource( )
--
-- Comments: 
-- This example shows you how to access the various properties of the "location" events, which
-- are returned by the GPS listener. Devices without GPS will have less accurate location data
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" )

local currentLatitude = 0
local currentLongitude = 0

display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "anchorX", 0.0 )	-- default to Left anchor point

local background = display.newImage("gps_background.png")
background.anchorY = 0.0		-- Top anchor
local latitude = display.newText( "--", 0, 0, native.systemFont, 26 )

latitude.anchorX = 0
latitude.x, latitude.y = 135, 64
latitude:setFillColor( 1, 85/255, 85/255 )

local longitude = display.newText( "--", 0, 0, native.systemFont, 26 )
longitude.x, longitude.y = 135, latitude.y + 50
longitude:setFillColor( 1, 85/255, 85/255 )

local altitude = display.newText( "--", 0, 0, native.systemFont, 26 )
altitude.x, altitude.y = 135, longitude.y + 50
altitude:setFillColor( 1, 85/255, 85/255 )

local accuracy = display.newText( "--", 0, 0, native.systemFont, 26 )
accuracy.x, accuracy.y = 135, altitude.y + 50
accuracy:setFillColor( 1, 85/255, 85/255 )

local speed = display.newText( "--", 0, 0, native.systemFont, 26 )
speed.x, speed.y = 135, accuracy.y + 50
speed:setFillColor( 1, 85/255, 85/255 )

local direction = display.newText( "--", 0, 0, native.systemFont, 26 )
direction.x, direction.y = 135, speed.y + 50
direction:setFillColor( 1, 85/255, 85/255 )

local time = display.newText( "--", 0, 0, native.systemFont, 26 )
time.x, time.y = 135, direction.y + 50
time:setFillColor( 1, 85/255, 85/255 )

display.setDefault( "anchorX", 0.5 )	-- default to Center anchor point

local buttonPress = function( event )
	-- Show location on map
	mapURL = "http://maps.google.com/maps?q=Hello,+Corona!@" .. currentLatitude .. "," .. currentLongitude
	system.openURL( mapURL )
end

local button1 = widget.newButton
{
	defaultFile = "buttonRust.png",
	overFile = "buttonRustOver.png",
	label = "Show on Map",
	labelColor = 
	{ 
		default = { 200/255, 200/255, 200/255, 1}, 
		over = { 200/255, 200/255, 200/255, 128/255 } 
	},
	font = native.systemFontBold,
	fontSize = 22,
	emboss = true,
	onPress = buttonPress,
}
button1.x, button1.y = 160, 422

local locationHandler = function( event )

	-- Check for error (user may have turned off Location Services)
	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
		print( "Location error: " .. tostring( event.errorMessage ) )
	else
	
		local latitudeText = string.format( '%.4f', event.latitude )
		currentLatitude = latitudeText
		latitude.text = latitudeText
		
		local longitudeText = string.format( '%.4f', event.longitude )
		currentLongitude = longitudeText
		longitude.text = longitudeText
		
		local altitudeText = string.format( '%.3f', event.altitude )
		altitude.text = altitudeText
	
		local accuracyText = string.format( '%.3f', event.accuracy )
		accuracy.text = accuracyText
		
		local speedText = string.format( '%.3f', event.speed )
		speed.text = speedText
	
		local directionText = string.format( '%.3f', event.direction )
		direction.text = directionText
	
		-- Note: event.time is a Unix-style timestamp, expressed in seconds since Jan. 1, 1970
		local timeText = string.format( '%.0f', event.time )
		time.text = timeText 
		
	end
end

		
--
-- Check if this platform supports location events
--
if not system.hasEventSource( "location" ) then
	msg = display.newText( "Location events not supported on this platform", 0, 230, native.systemFontBold, 13 )
	msg.x = display.contentWidth/2		-- center title
	msg:setFillColor( 1,1,1 )
end

-- Activate location listener
Runtime:addEventListener( "location", locationHandler )
