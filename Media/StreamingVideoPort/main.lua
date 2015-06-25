-- Abstract: Streaming Video Portrait sample app
-- 
-- Project: StreamingVideoPort
--
-- Date: August 13, 2013
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Displays video in portrait mode -- allows rotation on iOS with CoronaUseIOS6PortraitOnlyWorkaround
--			 Displays video from WWW.BIGBUCKBUNNY.ORG
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
--	Uses "CoronaUseIOS6PortraitOnlyWorkaround = true" to allow media.playVideo rotation on iOS
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

function posterFrame:tap( event )
	msg.text = "Video Done"		-- message will appear after the video finishes
	media.playVideo( "http://www.coronalabs.com/video/bbb/BigBuckBunny_640x360.m4v", media.RemoteSource, true )
end

-- Determine if running on Corona Simulator
-- Works in Mac Simulator but not Window Simulator
local isSimulator = "simulator" == system.getInfo("environment")
if system.getInfo( "platformName" ) == "Mac OS X" then isSimulator = false; end

-- Video is not supported on Windows Simulator
--
if isSimulator then
	msg = display.newText( "No Video on Simulator!", centerX, 85, native.systemFontBold, 22 )
else
	msg = display.newText( "Tap to start video", centerX, 85, native.systemFontBold, 22 )
	posterFrame:addEventListener( "tap", posterFrame )		-- add Tap listener
end

msg:setFillColor( 0,0,1 )
