-- 
-- Abstract: Camera sample app
-- 
-- Version: 1.2
-- 
-- Updated: September 21, 2011
--
-- Update History:
-- 	v1.1	Fixed logic problem where it said "session was cancelled".
--	v1.2	Added Android support.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.]
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local json = require('json')

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- Camera not supported on simulator.                    
local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
if (isXcodeSimulator) then
	 local alert = native.showAlert( "Information", "Camera API not available on iOS Simulator.", { "OK"})    
end

--
local bkgd = display.newRect( centerX, centerY, _W, _H )
bkgd:setFillColor( 0.5, 0, 0 )

local text = display.newText( "Tap anywhere to launch Camera", centerX, centerY, nil, 16 )

local sessionComplete = function(event)	
	local image = event.target

	print( "Camera ", ( image and "returned an image" ) or "session was cancelled" )
	print( "event name: " .. event.name )
	if image then
		print( "target: ", image._properties)
	else
		print( "event.target was nil" )
	end

	if image then
		-- center image on screen
		image.x = centerX
		image.y = centerY
		local w = image.width
		local h = image.height
		print( "w,h = ".. w .."," .. h )
	end
end

local listener = function( event )
	if media.hasSource( media.Camera ) then
		media.capturePhoto( { listener = sessionComplete } )
	else
		native.showAlert("Corona", "Camera not found.")
	end
	return true
end
bkgd:addEventListener( "tap", listener )
