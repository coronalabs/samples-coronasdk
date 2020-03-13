
-- Abstract: NewVideo
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Video licensed as Creative Commons Attribute 3.0: https://peach.blender.org
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="mediumgrey", title="New Video", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local msg
local video
local playButton, stopButton, seekButton, muteButton
local seekValue = 25
local timeOutput
local countTimer
local videoPaused = true
local videoHeight = display.actualContentHeight - 100
local videoRatio = 16/9  -- Video aspect ratio is 16:9

-- Create a "frame" which shows where video will appear
local videoFrame = display.newRect( mainGroup, display.contentCenterX, display.contentCenterY, videoHeight*videoRatio, videoHeight )
videoFrame:setFillColor( 0, 0, 0, 0.6 )

-- Function to enable or disable buttons
local function setButtonEnabled( button, isEnabled )
	button:setEnabled( isEnabled )
end

-- Function to update video time/duration output
local function updateTime( currentTime, totalTime )

	local ct, tt = 0, 0
	if ( tonumber(currentTime) and tonumber(totalTime) ) then
		ct = currentTime
		tt = totalTime
	else
		if ( video ~= nil ) then
			ct = video.currentTime
			tt = video.totalTime
		end
	end
	local currentMinutes = math.floor( ct / 60 )
	local currentSeconds = ct % 60
	local totalMinutes = math.floor( tt / 60 )
	local totalSeconds = tt % 60
	timeOutput.text = string.format( "%02d:%02d", currentMinutes, currentSeconds ) .. " / " .. string.format( "%02d:%02d", totalMinutes, totalSeconds )
end

-- Stop video function
local function stopVideo()

	if video then
		if ( countTimer ) then timer.cancel( countTimer ) end
		video:removeSelf()
		video = nil
		seekValue = 25
		videoFrame.isVisible = true
		playButton:setLabel( "Play" )
		seekButton:setLabel( "—" )
		muteButton:setLabel( "Mute" )
		updateTime( 0, 0 )
		msg.text = "Press play button to start video"
		setButtonEnabled( playButton, true )
		setButtonEnabled( stopButton, false )
		setButtonEnabled( seekButton, false )
		setButtonEnabled( muteButton, false )
	end
end

-- Play or pause video function
local function playVideo( event )

	-- Video object does not exist; create it, load video, and play it upon loading
	if ( video == nil ) then

		local function videoListener( event )
			if ( "ready" == event.phase ) then
				videoFrame.isVisible = false
				msg.text = ""
				video:play()
				videoPaused = false
				seekValue = 25
				playButton:setLabel( "Pause" )
				seekButton:setLabel( "Seek " .. seekValue .. "%" )
				setButtonEnabled( playButton, true )
				setButtonEnabled( stopButton, true )
				setButtonEnabled( seekButton, true )
				setButtonEnabled( muteButton, true )
				updateTime( 0, video.totalTime )
				countTimer = timer.performWithDelay( 1000, updateTime, 0 )
			elseif ( "ended" == event.phase ) then
				stopVideo()
			end
		end

		msg.text = "(loading)"
		video = native.newVideo( videoFrame.x, videoFrame.y, videoFrame.width, videoFrame.height )
		video:load( "https://www.coronalabs.com/video/bbb/BigBuckBunny_640x360.m4v", media.RemoteSource )
		video:addEventListener( "video", videoListener )
		setButtonEnabled( playButton, false )

	-- Video object already exists; handle pause and resume
	else
		if ( videoPaused == true ) then
			if ( countTimer ) then timer.resume( countTimer ) end
			video:play()
			videoPaused = false
			playButton:setLabel( "Pause" )
		else
			if ( countTimer ) then timer.pause( countTimer ) end
			video:pause()
			videoPaused = true
			playButton:setLabel( "Resume" )
		end
		updateTime( video.currentTime, video.totalTime )
	end
end

-- Mute/un-mute video function
local function muteVideo( event )

	if ( video ~= nil ) then
		if video.isMuted then
			video.isMuted = false
			muteButton:setLabel( "Mute" )
		else
			video.isMuted = true
			muteButton:setLabel( "UnMute" )
		end
	end
end

-- Seek video function
local function seekVideo( event )

	if ( video ~= nil ) then
		-- Seek to percentage of total time
		video:seek( video.totalTime * seekValue/100 )

		local nextSeekValue = 0
		if seekValue == 25 then
			nextSeekValue = 50
		elseif seekValue == 50 then
			nextSeekValue = 75
		elseif seekValue == 75 then
			seekButton:setLabel( "—" )
			setButtonEnabled( seekButton, false )
		end

		seekValue = nextSeekValue
		if ( seekValue ~= 0 ) then
			seekButton:setLabel( "Seek " .. seekValue .. "%" )
		end
	end
end

-- Callback function for showing/hiding info box
sampleUI.onInfoEvent = function( event )

	if ( video ~= nil ) then
		if ( event.action == "show" and event.phase == "will" ) then
			-- If video is playing, pause it
			if ( videoPaused == false ) then playVideo() end
			videoFrame.isVisible = true
			video.isVisible = false
		elseif ( event.action == "hide" and event.phase == "did" ) then
			videoFrame.isVisible = false
			video.isVisible = true
		end
	end
end

-- Create control buttons
playButton = widget.newButton(
{
	left = 0 + display.screenOriginX,
	top = display.contentHeight - display.screenOriginY - 32,
	width = 90,
	height = 32,
	shape = "rectangle",
	font = appFont,
	fontSize = 14,
	label = "Play",
	fillColor = { default={ 0,0,0,0.5 }, over={ 0,0,0,0.7 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = playVideo
})
mainGroup:insert( playButton )
playButton:setEnabled( false )

stopButton = widget.newButton(
{
	left = playButton.x + 47,
	top = display.contentHeight - display.screenOriginY - 32,
	width = 70,
	height = 32,
	shape = "rectangle",
	font = appFont,
	fontSize = 14,
	label = "Stop",
	fillColor = { default={ 0,0,0,0.5 }, over={ 0,0,0,0.7 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = stopVideo
})
mainGroup:insert( stopButton )
stopButton:setEnabled( false )

seekButton = widget.newButton(
{
	left = stopButton.x + 37,
	top = display.contentHeight - display.screenOriginY - 32,
	width = 104,
	height = 32,
	shape = "rectangle",
	font = appFont,
	fontSize = 14,
	label = "—",
	fillColor = { default={ 0,0,0,0.5 }, over={ 0,0,0,0.7 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = seekVideo
})
mainGroup:insert( seekButton )
seekButton:setEnabled( false )

muteButton = widget.newButton(
{
	left = seekButton.x + 54,
	top = display.contentHeight - display.screenOriginY - 32,
	width = 90,
	height = 32,
	shape = "rectangle",
	font = appFont,
	fontSize = 14,
	label = "Mute",
	fillColor = { default={ 0,0,0,0.5 }, over={ 0,0,0,0.7 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = muteVideo
})
mainGroup:insert( muteButton )
muteButton:setEnabled( false )

-- Create object to output video time/duration
local shade = display.newRect( mainGroup, muteButton.x+47, display.contentHeight-display.screenOriginY-32, display.actualContentWidth-360, 32 )
shade:setFillColor( 0, 0, 0, 0.5 )
shade.anchorX, shade.anchorY = 0, 0
timeOutput = display.newText( mainGroup, "", shade.x+(shade.width*0.5), shade.y+16, appFont, 14 )
updateTime( 0, 0 )
timeOutput.rightX = timeOutput.contentBounds.xMax
timeOutput.anchorX = 1
timeOutput.x = timeOutput.rightX
timeOutput:setFillColor( 1, 0.4, 0.25 )

-- Check if "native.newVideo()" is supported on platform
if ( system.getInfo("environment") == "simulator" and system.getInfo("platform") == "win32" ) then
	msg = display.newText( mainGroup, "Video objects not supported on this platform", display.contentCenterX, videoFrame.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
else
	msg = display.newText( mainGroup, "Press play button to start video", display.contentCenterX, videoFrame.y, appFont, 13 )
	msg:setFillColor( 1, 0.4, 0.25 )
	setButtonEnabled( playButton, true )
end

-- For tvOS, bind play/pause to the button on remote
if ( system.getInfo("platform") == "tvos" ) then
	local function onKeyEvent( event )
		if ( event.keyName == "buttonX" and event.phase=="down" ) then
			playVideo()
		end
		return false
	end
	Runtime:addEventListener( "key", onKeyEvent )
end
