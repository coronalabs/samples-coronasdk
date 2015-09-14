-- Project: ScreenCaptureToFile
--
-- Date: June 6, 2011
--
-- Version: 1.4
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Screen Capture JPG saved to /Documents directory
--
-- Demonstrates: audio.play, display.save, tap, detecting device type
--
-- File dependencies: none
--
-- Target devices: Simulator and Device
--
-- Limitations:
--
-- Update History:
--	v1.1	Added app title and message saving JPG saved in /Documents directory
--			Supports Android with MP3 sound file.
-- 	v1.2 	Changed to use new audio API
-- 	v1.3 	Changed to only use .wav
--  v1.4    Scale the thumbnail according to the size of the captured image 
--
-- Comments: Stores the capture screen image as a JPG in the /Documents directory
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

local bkgd = display.newRect( centerX, centerY, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 0.5, 0, 0 )

local text = display.newText( "Tap anywhere to capture screen", centerX, centerY, nil, 16 )
text:setFillColor( 1, 1, 0 )

local soundID = audio.loadSound ("CameraShutter_wav.wav")

-- Create the Screen Capture
--
function bkgd:tap( event )
	audio.play( soundID )

	-- Capture the screen and save it to file.
	local baseDir = system.DocumentsDirectory
	display.save( display.currentStage, "entireScreen.jpg", baseDir, centerX, centerY )

	-- Create thumbnail
	local thumbnail = display.newGroup()
	local image = display.newImage( "entireScreen.jpg", baseDir )
	if image then
		-- Display screen capture image onscreen.
		thumbnail:insert( image, true )
        local thumbscale = 0.5 * display.contentWidth / image.width
		image:scale( thumbscale, thumbscale )
		local r = 10
		local border = display.newRoundedRect( 0, 0, image.contentWidth + 2*r, image.contentHeight + 2*r, r )
		border:setFillColor( 1,1,1,200/255 )
		thumbnail:insert( 1, border, true )
		thumbnail:translate( 0.5*display.contentWidth, 0.5*display.contentHeight )
		print( "File entireScreen.jpg was saved in the documents directory." )
	else
		-- Image file not found. This means that the screen capture failed.
		-- This can occur if the device does not support screen captures, such as the Droid.
		msg = display.newText( "Screen captures not supported.", 0, 400, native.systemFont, 16 )
		thumbnail:insert( msg, true )
		local r = 10
		local border = display.newRoundedRect( 0, 0, msg.contentWidth + 2*r, (msg.contentHeight*2) + 2*r, r )
		border:setFillColor( 0, 0, 0 )
		thumbnail:insert( 1, border, true )
		thumbnail:translate( 0.5*display.contentWidth, 0.5*display.contentHeight )
		print( "Platform does not support screen captures." )
	end
	
	text:removeSelf()		-- remove the Tap message from the screen
	msg = display.newText( "Screen JPG saved to /Documents", centerX, 400, native.systemFontBold, 14 )
	msg:setFillColor( 1,1,1 )
	
	-- Prevent future taps
	bkgd:removeEventListener( "tap", bkgd )

	return true
end

-- Displays App title
title = display.newText( "Capture Screen to File", centerX, 50, native.systemFontBold, 20 )
title:setFillColor( 1,1,1 )

-- Create the Tap listener
--
bkgd:addEventListener( "tap", bkgd )
