-- Project: EventSound
--
-- Date: August 19, 2010
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Simulates a metronome that beeps every second
--
-- Demonstrates: media.playEventSound, switching formats based on device type
--
-- File dependencies: none
--
-- Target devices: Simulator and Device
--
-- Limitations:
--
-- Update History:
--	v1.1 	DetectsDetects Android device and switches to MP3 sound file (from CAF)
--  v1.2	Added sound completion listener
--  v1.3	Replaced MP3 and CAF files with WAV. Supports all platforms now.
--
-- Comments: CAF file for IOS device; MP3 for Android devices
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

display.setDefault( "background", 80/255 )
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- Preload the sound file (needed for Android)
local soundID = media.newEventSound( "beep.wav" )
local count = 0
local countText = display.newText( "0", centerX, centerY - 100, native.systemFontBold, 32 )

-- Sound completion listener
-- Update the event count on the screen
local function completion()
	count = count + 1
	print( "Event Sound Completed " .. count )
	countText.text = count
end

-- Play sound
--
local playBeep = function()
	media.playEventSound( soundID, completion )		-- Added completion listener
end

-- Displays App title
title = display.newText( "Event Sound", centerX, 30, native.systemFontBold, 20 )
title:setFillColor( 1, 1, 0 )

msg = display.newText( "Listen for sound every 1 second", centerX, centerY, native.systemFontBold, 14 )

-- Set up timer to play sound every second
--
timer.performWithDelay( 1000, playBeep, 0 )

-- Disable count text on Android
--
if ( system.getInfo( "platformName" ) == "Android" ) then
	countText.text = ""
	msg.text = msg.text .. "\n" .. "Event callback unsupported on Android"
end
