
-- Abstract: AudioPlayer
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Some audio files courtesy of Eric Matyas; see http://www.soundimage.org/
-- Other audio files courtesy of Freesound; see http://www.freesound.org
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Audio Player", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

-- Local variables and forward references
local centX = display.contentCenterX
local centY = display.contentCenterY
local letterboxWidth = math.abs(display.screenOriginX)
local totalHeight = (math.ceil((display.actualContentHeight-30)/4))*4
local onAudioComplete

-- Image sheet for controls
local controlSheet = graphics.newImageSheet( "controls.png", { width=28, height=28, numFrames=5, sheetContentWidth=140, sheetContentHeight=28 } )

-- Reserve two channels (one for background music, one for environmental effect)
audio.reserveChannels( 2 )

-- Function to handle various buttons
local function handleButton( event )

	local parentGroup = event.target.parent

	if ( event.target.id == "play" ) then

		if ( parentGroup.audioHandle ) then
			-- Set options for playback
			local options = {}
			if ( parentGroup.loopSwitch.isOn == true ) then options.loops = -1 else options.loops = 0 end
			if ( parentGroup.reservedChannel ) then options.channel = parentGroup.reservedChannel end
			-- Add listener reference for completion of audio
			options.onComplete = onAudioComplete
			-- Play or resume the audio
			if ( parentGroup.currentChannel ~= nil and audio.isChannelPaused( parentGroup.currentChannel ) == true ) then
				audio.resume( parentGroup.currentChannel )
			else
				parentGroup.currentChannel = audio.play( parentGroup.audioHandle, options )
				parentGroup.channelLabel.text = "channel: " .. tostring(parentGroup.currentChannel)
			end
			-- Set audio depending on slider value for the file group
			audio.setVolume( (parentGroup.volumeSlider.value/100), { channel=parentGroup.currentChannel } )
			-- Change button states
			parentGroup.stopButton:setEnabled( true )
			parentGroup.stopButton.alpha = 1
			parentGroup.pauseButton:setEnabled( true )
			parentGroup.pauseButton.alpha = 1
			parentGroup.playButton:setEnabled( false )
			parentGroup.playButton.alpha = 0.4
		end

	elseif ( event.target.id == "pause" ) then
	
		if ( parentGroup.currentChannel ~= nil ) then
			audio.pause( parentGroup.currentChannel )
			-- Change button states
			parentGroup.stopButton:setEnabled( true )
			parentGroup.stopButton.alpha = 1
			parentGroup.pauseButton:setEnabled( false )
			parentGroup.pauseButton.alpha = 0.4
			parentGroup.playButton:setEnabled( true )
			parentGroup.playButton.alpha = 1
		end
	
	elseif ( event.target.id == "stop" ) then

		if ( parentGroup.currentChannel ~= nil ) then
			audio.stop( parentGroup.currentChannel )
			audio.rewind( parentGroup.audioHandle )
			parentGroup.currentChannel = nil
			if not ( parentGroup.reservedChannel ) then
				parentGroup.channelLabel.text = "channel: (auto)"
			end
			-- Change button states
			parentGroup.stopButton:setEnabled( false )
			parentGroup.stopButton.alpha = 0.4
			parentGroup.pauseButton:setEnabled( false )
			parentGroup.pauseButton.alpha = 0.4
			parentGroup.playButton:setEnabled( true )
			parentGroup.playButton.alpha = 1
		end
	end
end

onAudioComplete = function( event )

	-- Loop through audio groups and check which group's audio completed
	for i = 1,mainGroup.numChildren do
		-- If group's channel equals completed channel, trigger "stop" on group
		if ( mainGroup[i].currentChannel == event.channel ) then
			handleButton( { target=mainGroup[i].stopButton } )
		end
	end
end

-- Function to handle volume sliders
local function sliderListener( event )

	local parentGroup = event.target.parent
	if ( parentGroup.currentChannel ~= nil and audio.isChannelActive( parentGroup.currentChannel ) ) then
		audio.setVolume( (event.value/100), { channel=parentGroup.currentChannel } )
	end
end

local function onSwitchPress( event )

	local parentGroup = event.target.parent
	-- Trigger "stop" on group since looping cannot be toggled during playback
	if ( parentGroup.currentChannel ~= nil and audio.isChannelActive( parentGroup.currentChannel ) ) then
		handleButton( { target=parentGroup.stopButton } )
	end
end

-- Function to create the distinct audio file groups for this sample
local function createAudioGroup( fileName, initialVolume, loadType, reservedChannel, loop, backColor1, backColor2, yPos )

	local audioGroup = display.newGroup() ; mainGroup:insert( audioGroup )
	local backRect = display.newRect( audioGroup, centX, 0, display.actualContentWidth, (totalHeight/4)-2 )
	backRect.fill = { type="gradient", color1=backColor1, color2=backColor2, direction="down" }
	backRect.anchorY = 0

	-- Set the reserved channel to be used for this file
	if ( reservedChannel ~= nil ) then
		audioGroup.reservedChannel = reservedChannel
	end

	-- Load the audio file based on the requested method
	if ( loadType == "stream" ) then
		audioGroup.audioHandle = audio.loadStream( fileName )
	else
		audioGroup.audioHandle = audio.loadSound( fileName )
	end

	local fileNameLabel = display.newText( audioGroup, fileName, 20-letterboxWidth, backRect.height/4, appFont, 17 )
	fileNameLabel.anchorX = 0

	local channelLabel = display.newText( audioGroup, "channel: (auto)", 20-letterboxWidth, (backRect.height/2)-5, appFont, 13 )
	if ( reservedChannel ~= nil ) then channelLabel.text = "channel: " .. tostring(reservedChannel) end
	channelLabel:setFillColor( 0.8 )
	channelLabel.anchorX = 0
	audioGroup.channelLabel = channelLabel

	local stopButton = widget.newButton(
    {
		x = 205 + letterboxWidth,
		y = backRect.height/4,
        width = 28,
        height = 28,
		id = "stop",
		sheet = controlSheet,
        defaultFrame = 1,
        overFrame = 1,
        label = "",
        onRelease = handleButton
    })
	audioGroup:insert( stopButton )
	audioGroup.stopButton = stopButton
	stopButton:setEnabled( false )
	stopButton.alpha = 0.4

	local pauseButton = widget.newButton(
    {
		x = 245 + letterboxWidth,
		y = backRect.height/4,
        width = 28,
        height = 28,
		id = "pause",
        sheet = controlSheet,
        defaultFrame = 2,
        overFrame = 2,
        label = "",
        onRelease = handleButton
    })
	audioGroup:insert( pauseButton )
	audioGroup.pauseButton = pauseButton
	pauseButton:setEnabled( false )
	pauseButton.alpha = 0.4

	local playButton = widget.newButton(
    {
		x = 285 + letterboxWidth,
		y = backRect.height/4,
        width = 28,
        height = 28,
		id = "play",
        sheet = controlSheet,
        defaultFrame = 3,
        overFrame = 3,
        label = "",
        onRelease = handleButton
    })
	audioGroup:insert( playButton )
	audioGroup.playButton = playButton

	local volumeSlider = widget.newSlider(
	{
		x = 100 - letterboxWidth,
		y = backRect.height - (backRect.height/4),
		width = 160,
		listener = sliderListener
	})
	audioGroup:insert( volumeSlider )
	audioGroup.volumeSlider = volumeSlider
	volumeSlider:setValue( initialVolume*100 )

	local loopSwitch = widget.newSwitch(
	{
		x = volumeSlider.x + 205,
		y = volumeSlider.y,
		style = "checkbox",
		sheet = controlSheet,
        frameOn = 5,
        frameOff = 4,
        initialSwitchState = loop,
		onPress = onSwitchPress
	})
	audioGroup:insert( loopSwitch )
	audioGroup.loopSwitch = loopSwitch
	local loopLabel = display.newText( audioGroup, "loop", loopSwitch.x+20, volumeSlider.y, appFont, 15 )
	loopLabel.anchorX = 0

	-- Position the group
	audioGroup.y = yPos + display.screenOriginY + 30
end

createAudioGroup( "Tranquility.mp3", 1.0, "stream", 1, true, {0,0.7,1,0.5}, {0,0.7,1,0}, 0 )
createAudioGroup( "Gentle-Rain.mp3", 0.35, "stream", 2, true, {0,0.72,0.92,0.5}, {0,0.72,0.92,0}, mainGroup.contentHeight+2 )
createAudioGroup( "Thunder.wav", 0.8, "sound", nil, false, {0,0.66,0.62,0.5}, {0,0.66,0.62,0}, mainGroup.contentHeight+2 )
createAudioGroup( "Crickets.wav", 0.3, "sound", nil, true, {0,0.55,0.32,0.5}, {0,0.55,0.32,0}, mainGroup.contentHeight+2 )
