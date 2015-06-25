-- Abstract: New Video sample app
-- 
-- Project: NewVideo
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Displays video from WWW.BIGBUCKBUNNY.ORG
--
-- Demonstrates: native.newVideo and all it's properties and methods
--
-- File dependencies: none
--
-- Target devices: iOS
--
-- Limitations: Does not work in the Mac or Windows simulator or on Android
--
-- Update History:
--	v1.0	8/10/2013	Initial release
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

local widget = require( "widget" )

display.setStatusBar( display.HiddenStatusBar )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local video			-- forward reference
local playButton, seekButton, muteButton, stopButton	-- forward references
local seekValue = 25		-- forward reference
local totalPlayTime

local videoPaused = false

display.setDefault( "background", 100/255 )

--local posterFrame = display.newImage( "Default.png", centerX, centerY )

local videoWidth = _W - 20
local videoHeight = _H - 40 

local stoppedTimeString = "----"
local runningTime = display.newText( stoppedTimeString, _W - 45, _H - 30, native.systemFont, 13 )
local totalTime = display.newText( stoppedTimeString, _W - 45, _H - 15, native.systemFont, 13 )

videoRatio = 180/320		-- used to create our video container based on video size (320 x 180)

local posterFrame = display.newRoundedRect( centerX, centerY - 20, _W, _H - 40, 20 )
posterFrame:setFillColor( 200/255 )

-- Determine if running on Corona Simulator or Android device
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Video is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "No Video on Simulator", centerX, 80, native.systemFontBold, 22 )
else
	msg = display.newText( "Press Play to start video", centerX, 60, native.systemFontBold, 22 )
--	posterFrame:addEventListener( "tap", posterFrame )		-- add Tap listener
end

msg:setFillColor( 0, 0, 1 )

-------------------------------
-- Enable/Disable Buttons
-------------------------------
--
-- Called when video is started or ended to enable/disable button touches
--
local function buttonsEnable( value )
	stopButton:setEnabled( value )
	seekButton:setEnabled( value )
	muteButton:setEnabled( value )
end

-------------------------------
-- Stop video (removes object)
-------------------------------
--
-- Called when Stop button pressed or video "done" listener
--
local function stopCtl( event )
	if video then
		video:removeSelf()
		video = nil
		seekValue = 25
		playButton:setLabel( "Play" )
		muteButton:setLabel( "Mute" )
		seekButton:setLabel( "Seek 25%" )
		runningTime.text = stoppedTimeString
		totalTime.text = stoppedTimeString
		msg.text = "Stopped"
		buttonsEnable( false )
	end
end

-------------------------------
-- Play or Pause the video
-------------------------------
--
function playCtl( event )

	if not video then
	
		local function videoListener( event )
			print( "Video Listener called: ", event.phase )
			if "ready" == event.phase then
				totalPlayTime = video.totalTime		-- get total video time (in seconds)
				totalTime.text = string.format( "Total: %.0f sec.", totalPlayTime )
			end
			if "ended" == event.phase then
				stopCtl( event )		-- remove and clean up the video player
				msg.text = "Video Done"
			end
		end
		
		msg.text = "Loading Video ..."		-- message will appear after the video finishes
		video = native.newVideo( display.contentCenterX, 140, videoWidth, videoWidth * videoRatio )
		video:load( "http://www.coronalabs.com/video/bbb/BigBuckBunny_640x360.m4v", media.RemoteSource )
		videoPaused = true
		video:addEventListener( "video", videoListener )
		buttonsEnable( true )
	end
	
	if videoPaused then	
		video:play()
		videoPaused = false
		playButton:setLabel( "Pause" )
	else
		video:pause()
		videoPaused = true
		playButton:setLabel( "Resume" )
	end
	
end

-------------------------------
-- Mute video sound
-------------------------------
--
local function muteCtl( event )
	if video then
		if video.isMuted then
			video.isMuted = false
			muteButton:setLabel( "Mute" )
		else
			video.isMuted = true
			muteButton:setLabel( "UnMute" )
		end
	end
end

-----------------------------------
-- Seek video (25%, 50%, 95%, 0%)
-----------------------------------
--
local function seekCtl( event )
	if video then
		local newSeekValue = 0
		
		if seekValue == 0 then
			newSeekValue = 25
		elseif seekValue == 25 then
			newSeekValue = 50
		elseif seekValue == 50 then
			newSeekValue = 95
		else
			newSeekValue = 0
		end
		
		video:seek( totalPlayTime * seekValue/100 )		-- seek to percentage of total time
		print( "seeking to ", totalPlayTime * seekValue/100 )
		seekValue = newSeekValue
		seekButton:setLabel( "Seek " .. seekValue .. "%" )
	end
end

-------------------------------
-- Create the buttons
-------------------------------

buttonTop = _H - 35
FONT_SIZE = 14

playButton = widget.newButton
	{
	    left = 5,
	    top = buttonTop,
		width = 90,
		height = 30,
		fontSize = FONT_SIZE,
		id = "playButton",
	    label = "Play",
	    onRelease = playCtl,
	}

stopButton = widget.newButton
	{
	    left = 100,
	    top = buttonTop,
		width = 90,
		height = 30,
		fontSize = FONT_SIZE,
		id = "stopButton",
	    label = "Stop",
	    onRelease = stopCtl,
	}
	
seekButton = widget.newButton
	{
	    left = 195,
	    top = buttonTop,
		width = 90,
		height = 30,
		fontSize = FONT_SIZE,
		id = "seekButton",
	    label = "Seek 25%",
	    onRelease = seekCtl,
	}

muteButton = widget.newButton
	{
	    left = 290,
	    top = buttonTop,
		width = 90,
		height = 30,
		fontSize = FONT_SIZE,
		id = "muteButton",
	    label = "Mute",
	    onRelease = muteCtl,
	}

buttonsEnable( false )		-- disable all but the Play button

-------------------------------------------------
-- Update the movie time on the screen
-------------------------------------------------
--
local function updateTime( event )
	-- Don't update the time if the video is not running
	if video then
		local currentTime = video.currentTime
		if currentTime > 0 and currentTime < 2 then
			-- Clear the "Loading" message once the video starts playing
			msg.text = ""
		end
		runningTime.text = string.format( "Time: %.0f sec.", currentTime )
	end
	
end

timer.performWithDelay( 1000, updateTime, 0 )
