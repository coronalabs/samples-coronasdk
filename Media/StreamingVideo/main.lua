-- Abstract: Streaming Video sample app
-- 
-- Project: StreamingVideo
--
-- Date: August 13, 2013
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Displays video from WWW.BIGBUCKBUNNY.ORG
--
-- Demonstrates: media.playVideo, detection of Corona Simulator
--
-- File dependencies: none
--
-- Target devices: Mac Simulator, Android, and iOS
--
-- Limitations: Requires internet access
--
-- Update History:
--	v1.2	Detect running in simulator.
--			Added "Tap to start video" message
--	v1.3	Changed default orientation from portrait to landscape.
--			Looks better on Android this way.
--  v1.4	Added support for Mac OS X simulator.
--	v1.5	Changed streaming video and changed default.png file
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
--
-- Video licensed as Creative Commons Attribute 3.0.
-- WWW.BIGBUCKBUNNY.ORG
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar )

local posterFrame = display.newImage( "Default.png", centerX, centerY )
posterFrame:rotate(270)

function posterFrame:tap( event )
	timer.performWithDelay( 500, function() msg.text = "Video done"; end, 1 )		-- message will appear after the video finishes
	media.playVideo( "http://www.coronalabs.com/video/bbb/BigBuckBunny_640x360.m4v", media.RemoteSource, true )
end

-- Video is not supported on Windows Simulator
local notSupported = ( system.getInfo("environment") == "simulator" and system.getInfo( "platformName" ) == "Win" )

local boxY = 17
local textY = boxY - 1
local box = display.newRoundedRect( centerX, boxY, display.contentWidth - 20, 30, 6 )
box:setFillColor( 0.5, 0.5, 0.5, 0.5 )

if notSupported then
	msg = display.newText( "media.playVideo not supported in Simulator", centerX, textY, native.systemFontBold, 22 )
	msg:setFillColor( 1, 0, 0 )
else
	msg = display.newText( "Tap to start video", centerX, textY, native.systemFontBold, 22 )
	msg:setFillColor( 0,0,1 )
	posterFrame:addEventListener( "tap", posterFrame )		-- add Tap listener
end
