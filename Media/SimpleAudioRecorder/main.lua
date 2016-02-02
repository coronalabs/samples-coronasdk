-- Abstract: Echo - Simple Audio Recorder
--
-- Date: January 26, 2016
-- 
-- Version: 1.5
--
-- Changes:
--  1.1 - larger background image
--	1.2 - Replaced depreciated ui.lua with widget library, removed unused assets
--	1.3 - Changed audio.play to media.playSound for Android (to play the .3gp format)
--  1.4 - Android now defaults to recording to wav format which can be played with audio.* apis
--  1.5 - UI is now updated on EnterFrame events. This allows the UI to keep up with state 
--        changes occuring inside of the Corona Engine.
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Records audio and plays it back
--
-- Demonstrates:
--		recording = media.newRecording( file )
--		recording:startRecording()
--		recording:stopRecording()
--		result = recording:isRecording()
--		rate = recording:getSampleRate()
--
--
-- File dependencies: none
--
-- Limitations: 
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- iOS 5 -only workaround for known Apple bug (Bug ID:9948362 and 10508829)
local platVersion = system.getInfo( "platformVersion" )
platVersion = string.sub( platVersion, 1, 1 )
if system.getInfo( "platformName" ) == "iPhone OS" and platVersion == "5" then
	if audio.supportsSessionProperty then
	    audio.setSessionProperty(audio.MixMode, audio.PlayAndRecordMixMode)
	end
end

-------------------------------------------------------------------------------------
local widget = require("widget")

local isAndroid = false

local background = display.newImage("carbonfiber.jpg", centerX, centerY, true)

local dataFileName = "testfile"
if "simulator" == system.getInfo("environment") then
    dataFileName = dataFileName .. ".aif"
else
	local platformName = system.getInfo( "platformName" )
    if "iPhone OS" == platformName then
        dataFileName = dataFileName .. ".aif"
    elseif "Android" == platformName then
        dataFileName = dataFileName .. ".wav"
        isAndroid = true
    else
    	print("Unknown OS " .. platformName )
    end
end
print (dataFileName)


-- title
local title = display.newText( "Echo", centerX, 60, native.systemFont, 40 )
title:setFillColor( 1, 204/255, 102/255 )

local subTitle = display.newText( "Simple Audio Recorder", centerX, 0, native.systemFont, 22 )
subTitle.y = title.y + subTitle.contentHeight
subTitle:setFillColor( 1, 204/255, 102/255 )

--  recording status area
local roundedRect = display.newRoundedRect( 10, 160, 300, 80, 8 )
roundedRect.anchorX, roundedRect.anchorY = 0.0, 0.0
roundedRect:setFillColor( 0, 170/255 )

local recordingStatus = display.newText( " ", centerX, 195, native.systemFont, 32 )
recordingStatus:setFillColor( 10/255, 240/255, 102/255 )

-- sampling rate display
local samplingRate = display.newText( " ", centerX, 385, native.systemFont, 14 )
samplingRate:setFillColor( 130/266, 200/255, 1 )

local r                 -- media object for audio recording
local recButton         -- gui buttons
local fSoundPlaying = false   -- sound playback state
local fSoundPaused = false    -- sound pause state


-- Update the state dependent texts
local function updateStatus ( event )
    local statusText = " "
    local statusText2 = " "
    if r then
        local recString = ""
        local fRecording = r:isRecording ()
        if fRecording then 
            recString = "RECORDING" 
          	recButton:setLabel( "Stop recording")
        elseif fSoundPlaying then
            recString = "Playing"
            recButton:setLabel( "Pause playback") 
        elseif fSoundPaused then
            recString = "Paused"
            recButton:setLabel( "Resume playback") 
        else
            recString = "Idle"
            recButton:setLabel( "Record")
        end

        statusText =  recString 
        statusText2 = "Sampling rate: " .. tostring (r:getSampleRate() .. "Hz")
    end
    recordingStatus.text = statusText
    samplingRate.text = statusText2
    --s:setText (statusText)
    --s2:setText (statusText2)
end

-------------------------------------------------------------------------------
--  *** Event Handlers ***
-------------------------------------------------------------------------------

local function onCompleteSound (event)
    fSoundPlaying = false
    fSoundPaused = false
    
	-- Free the audio memory and close the file now that we are done playing it.
	audio.dispose(event.handle)
end
 
local function recButtonPress ( event )
    if fSoundPlaying then
        fSoundPlaying = false
        fSoundPaused = true
		audio.pause() -- pause all channels
    elseif fSoundPaused then
        fSoundPlaying = true   
        fSoundPaused = false
        audio.resume() -- resume all channels
    elseif r then
        if r:isRecording() then
            r:stopRecording()
            local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
            -- Play back the recording
            local file = io.open( filePath, "r" )
            
            if file then
                io.close( file )
                fSoundPlaying = true
                fSoundPaused = false
                
				playbackSoundHandle = audio.loadStream( dataFileName, system.DocumentsDirectory )
				audio.play( playbackSoundHandle, { onComplete=onCompleteSound } )
            end                
        else
            fSoundPlaying = false
            fSoundPaused = false
            r:startRecording()
        end
    end
end

-- Increase the sample rate if possible
-- Valid rates are 8000, 11025, 16000, 22050, 44100 but many devices do not
-- support all rates 
local rateUpButtonPress = function( event )
    local theRates = {8000, 11025, 16000, 22050, 44100}
    if not r:isRecording () and not fSoundPlaying and not fSoundPaused then
--        r:stopTuner()
        local f = r:getSampleRate()
        --  get next higher legal sampling rate
        local i, v = next (theRates, nil)                 
        while i do
            if v <= f then 
                i, v = next (theRates, i) 
            else
                i = nil
            end
        end    
        if v then 
            r:setSampleRate(v) 
        else
            r:setSampleRate(theRates[1])
        end   
--        r:startTuner()
    end
end

-- Decrease the sample rate if possible
-- Valid rates are 8000, 11025, 16000, 22050, 44100 but many devices do not
-- support all rates.
local rateDownButtonPress = function( event )
    local theRates = {44100, 22050, 16000, 11025, 8000}
    if not r:isRecording () and not fSoundPlaying and not fSoundPaused then
--        r:stopTuner()
        local f = r:getSampleRate()
        --  get next lower legal sampling rate
        local i, v = next (theRates, nil)                 
        while i do
                if v >= f then 
                    i, v = next (theRates, i) 
                else
                    i = nil
                end
        end    
        if v then 
            r:setSampleRate(v) 
        else
            r:setSampleRate(theRates[1])
        end            
--        r:startTuner()
    end
end


-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- Record Button
recButton = widget.newButton
{
	defaultFile = "buttonRed.png",
	overFile = "buttonRedOver.png",
	onPress = recButtonPress,
	label = "Record",
	fontSize = 20,
	emboss = true
}

--  increase sampling rate
local rateUpButton = widget.newButton
{
	defaultFile = "buttonArrowUp.png",		-- small arrow image
	overFile = "buttonArrowUpOver.png",
	onPress = rateUpButtonPress,
	id = "arrowUp"
}

-- decrease sampling rate
local rateDownButton = widget.newButton
{
	defaultFile = "buttonArrowDwn.png",		-- small arrow image
	overFile = "buttonArrowDwnOver.png",
	onPress = rateDownButtonPress,
	id = "arrowDwn"
}

-----------------------------------------------
-- *** Locate the buttons on the screen ***
-----------------------------------------------
recButton.x = 160; 		   recButton.y = 290
rateUpButton.x =   190;    rateUpButton.y =   420
rateDownButton.x = 140;     rateDownButton.y = 420


local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
r = media.newRecording(filePath)
Runtime:addEventListener( "enterFrame", updateStatus )                                                
                                
