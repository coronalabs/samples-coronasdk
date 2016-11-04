-- Abstract: SimpleMixer - Demonstrate new Corona audio API
--
-- Date: November 29, 2010
-- 
-- Version: 0.9 
--
-- Changes:
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: 
--
-- Demonstrates:
--      audio.dispose()
--      audio.getVolume()
--      audio.getDuration()
--      audio.isChannelPaused()
--      audio.loadSound()
--      audio.loadStream()
--      audio.pause()
--      audio.play()
--      audio.resume() 
--      audio.setVolume()
--      audio.totalChannels 
--      audio.freeChannels
--      audio.reservedChannels
--
-- File dependencies: slider.lua
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

local widget = require( "widget" )
require "slider"

display.setStatusBar( display.HiddenStatusBar )

local totalTime =  " "
local textInfo = {}
local fillChannel = ""
local audioChannels = {}
local audioChannel1 = ""
local audioChannel2 = ""
local audioChannel3 = ""
local audioChannel4 = ""

local buttonY = 480
local buttonX1 = 65
local buttonX2 = 180
local buttonX3 = 295
local buttonX4 = 410


-- slider elements  ---------------------------------
-- sliders for four channels, plus a horizontal master volume
sliderInfo =
{
	{ channel=1, x=buttonX1, y=340, dispx=115, bname="slider1", minValue = 1, maxValue = 0, isVertical=true }, 
	{ channel=2, x=buttonX2, y=340, bname="slider2", minValue = 1, maxValue = 0, isVertical=true },
	{ channel=3, x=buttonX3, y=340, bname="slider3", minValue = 1, maxValue = 0,isVertical=true },
	{ channel=4, x=buttonX4, y=340, bname="slider4", minValue = 1, maxValue = 0, isVertical=true } , 
  	{ channel=0, x=240, y=780, bname="slider6", minValue = 0, maxValue = 1, isVertical=false } 
}


-- slider handler routines
local function setChannelVolume(ch, v)
      audio.setVolume(v, { channel=ch} )
end      
      
local function onSlider( event )
	local phase = event.phase
    -- update all the sliders
	if "moved" == phase then        
		setChannelVolume(1, sliderInfo.theSliders[1].value)
        setChannelVolume(2, sliderInfo.theSliders[2].value)
        setChannelVolume(3, sliderInfo.theSliders[3].value)
        setChannelVolume(4, sliderInfo.theSliders[4].value)
        audio.setVolume(sliderInfo.theSliders[5].value)
	end

	return true
end



--text elements  ---------------------------------

myFont = native.systemFontBold

-- table holding all the text labels we will create
local textInfo = 
{
	{string="Simple Mixer: OpenAL", x=20, y=5, font=myFont, fsize=38, r=0, g=255, b=0, handle=""},
	{string="CH 1", x=buttonX1-30, y=buttonY+180, font=myFont, fsize=28, r=1, g=1, b=1, handle=""},
	{string="CH 2", x=buttonX2-30, y=buttonY+180, font=myFont, fsize=28, r=1, g=1, b=1, handle=""},
	{string="CH 3", x=buttonX3-30, y=buttonY+180, font=myFont, fsize=28, r=1, g=1, b=1, handle=""},
	{string="CH 4", x=buttonX4-30, y=buttonY+180, font=myFont, fsize=28, r=1, g=1, b=1, handle=""},
	{string="Fixed", x=buttonX1-30, y=buttonY+240, font=myFont, fsize=18, r=1, g=1, b=1, handle=""},
	{string="Fixed", x=buttonX2-30, y=buttonY+240, font=myFont, fsize=18, r=1, g=1, b=1, handle=""},
	{string="Assigned", x=buttonX3-30, y=buttonY+240, font=myFont, fsize=18, r=1, g=1, b=1, handle=""},
	{string="Assigned", x=buttonX4-30, y=buttonY+240, font=myFont, fsize=18, r=1, g=1, b=1, handle=""},
	{string="Master Volume", x=buttonX2-30, y=buttonY+330, font=myFont, fsize=28, r=1, g=1, b=1, handle=""},
    {string="CH1 length "..totalTime.."  ms", x=30, y=70, font=myFont, fsize=24, r=1, g=1, b=1, handle=""},
    {string="Total  "..audio.totalChannels, x=30, y=100, font=myFont, fsize=24, r=1, g=1, b=1, handle=""},
    {string="Free  "..audio.freeChannels, x=30, y=130, font=myFont, fsize=24, r=1, g=1, b=1, handle=""},
    {string="Reserved  "..audio.reservedChannels, x=30, y=160, font=myFont, fsize=24, r=1, g=1, b=1, handle=""},
    {string="50", x=440, y=790, font=myFont, fsize=24, r=1, g=1, b=1, handle=""},
    {string="50", x= 90, y=330, font=myFont, fsize=20, r=1, g=1, b=1, handle=""},
    {string="50", x=200, y=330, font=myFont, fsize=20, r=1, g=1, b=1, handle=""},
    {string="50", x=320, y=330, font=myFont, fsize=20, r=1, g=1, b=1, handle=""},
    {string="50", x=430, y=330, font=myFont, fsize=20, r=1, g=1, b=1, handle=""},
    {string="", x=360, y=130, font=myFont, fsize=18, r=1, g=1, b=1, handle=""},
    {string="", x=360, y=150, font=myFont, fsize=18, r=1, g=1, b=1, handle=""},
    -- these last four are the channel state labels
    {string="", x=buttonX1, y=buttonY+140, font=myFont, fsize=20, r=0, g=1, b=0, handle=""},
    {string="", x=buttonX2, y=buttonY+140, font=myFont, fsize=20, r=0, g=1, b=0, handle=""},
    {string="", x=buttonX3, y=buttonY+140, font=myFont, fsize=20, r=0, g=1, b=0, handle=""},
    {string="", x=buttonX4, y=buttonY+140, font=myFont, fsize=20, r=0, g=1, b=0, handle=""}
}


-- updater for channel state labels
function updateChannelLabel (index, isOn)
    local textIndexOffset = 21  
    if isOn then
        textInfo[textIndexOffset + index].handle:setFillColor( 0,1,0) 
        textInfo[textIndexOffset + index].handle.text = "ON"
    else 
        textInfo[textIndexOffset + index].handle:setFillColor( 1,1,0 )
        textInfo[textIndexOffset + index].handle.text = "PAUSE"
    end
end


-- button handlers
function pauseButtonPress( event )
    local myChannel = audioChannels[event.target.channel]
    local isChannelPaused = audio.isChannelPaused(myChannel)
    if isChannelPaused then
        audio.resume(myChannel) 
    else 
        audio.pause(myChannel)
    end
    updateChannelLabel (myChannel,  isChannelPaused)
end

function seekButtonPress( event )
    -- skip 4000 ms ahead
	audio.seek(4000, audioChannels[event.target.channel])
end

function backButtonPress( event )
	audio.rewind(audioChannels[event.target.channel])
end

function fillButtonPress( event )
    -- play the loop on next available channel 
    fillChannel = audio.play( ch5Sound )    
end

local defaultButton = "buttonBlue.png"
local buttonOver = "buttonBlueOver.png"
local buttonInfo =
{
    -- the four channels each have 3 buttons, plus there is a "fill" button
    -- that plays a sound on the next available channel
	{name="backButton1",  channel=1, x=buttonX1, y=buttonY,     
        default = defaultButton, over = buttonOver, onPress = backButtonPress, 
        text = "rewind", emboss = true, indicator=s1Text },
	{name="pauseButton1", channel=1, x=buttonX1, y=buttonY+50,  
        default = defaultButton, over = buttonOver, onPress = pauseButtonPress, 
        text = " = / > ", emboss = true },
	{name="seekButton1",  channel=1, x=buttonX1, y=buttonY+100,     
        default = defaultButton, over = buttonOver, onPress = seekButtonPress, 
        text = "seek", emboss = true },
	{name="backButton2",  channel=2, x=buttonX2, y=buttonY,     
        default = defaultButton, over = buttonOver, onPress = backButtonPress, 
        text = "rewind", emboss = true },
	{name="pauseButton2", channel=2, x=buttonX2, y=buttonY+50,  
        default = defaultButton, over = buttonOver, onPress = pauseButtonPress, 
        text = " = / > ", emboss = true },
	{name="seekButton2",  channel=2, x=buttonX2, y=buttonY+100, 
        default = defaultButton, over = buttonOver, onPress = seekButtonPress, 
        text = "seek", emboss = true },
	{name="backButton3",  channel=3, x=buttonX3, y=buttonY,     
        default = defaultButton, over = buttonOver, onPress = backButtonPress, 
        text = "rewind", emboss = true },
	{name="pauseButton3", channel=3, x=buttonX3, y=buttonY+50,  
        default = defaultButton, over = buttonOver, onPress = pauseButtonPress, 
        text = " = / > ", emboss = true },
	{name="seekButton3",  channel=3, x=buttonX3, y=buttonY+100, 
        default = defaultButton, over = buttonOver, onPress = seekButtonPress, 
        text = "seek", emboss = true },
	{name="backButton4",  channel=4, x=buttonX4, y=buttonY,     
        default = defaultButton, over = buttonOver, onPress = backButtonPress, 
        text = "rewind", emboss = true },
	{name="pauseButton4", channel=4, x=buttonX4, y=buttonY+50,  
        default = defaultButton, over = buttonOver, onPress = pauseButtonPress, 
        text = " = / > ", emboss = true },
	{name="seekButton4",  channel=4, x=buttonX4, y=buttonY+100, 
        default = defaultButton, over = buttonOver, onPress = seekButtonPress, 
        text = "seek", emboss = true },
	{name="fillButton", channel=0 ,x=300, y=160,  
        default = defaultButton, over = buttonOver, onPress = fillButtonPress, 
        text = "fill next", emboss = true },

}



-- ---------------------------------------------
-- callback to update channel state label when sound is done playing
function NarrationFinished(event)
    textInfo[23].handle.text = "DONE"
    textInfo[23].handle:setFillColor( 1,0,0 )
end



-- ---------------------------------------------
--  updates to do every refresh cycle

-- utility to change a slider position
-- todo:  merge into slider.lua
function updateSliderPosition (s, v)
 -- s is the slider as in slider.lua, v is the fractional value (0 to 1)
   if s.isVertical then
        local temp = - (s.thumbMax - s.thumbMin) * (v - 0.5) 
        s.thumbDefault.y = temp
        s.thumbOver.y = temp
    else
        local temp = (s.thumbMax - s.thumbMin)  * (v - 0.5)
        s.thumbDefault.x = temp
        s.thumbOver.x = temp
    end
end

function updateFrame()
   textInfo[11].handle.text =  "CH1 length "..totalTime.."  ms"
   textInfo[12].handle.text =  "Total  "    ..audio.totalChannels 
   textInfo[13].handle.text =  "Free  "     ..audio.freeChannels 
   textInfo[14].handle.text =  "Reserved  " ..audio.reservedChannels
   textInfo[15].handle.text = math.floor(audio.getVolume() * 100)                            -- master volume
   textInfo[16].handle.text = math.floor(audio.getVolume( { channel=1 } ) * 100)              -- volume CH 1
   textInfo[17].handle.text = math.floor(audio.getVolume( { channel=2 } ) * 100)              -- volume CH 2
   textInfo[18].handle.text = math.floor(audio.getVolume( { channel=3 } ) * 100)              -- volume CH 3
   textInfo[19].handle.text = math.floor(audio.getVolume( { channel=4 } ) * 100)              -- volume CH 4

   local availableChannel = audio.findFreeChannel()
   textInfo[20].handle.text = "First Free: "..availableChannel
   if (fillChannel ~= "") then
       textInfo[21].handle.text = "Last filled: "..fillChannel
   end
   
   
   -- make slider position reflect the current volume for each channel
    for i,s in ipairs( sliderInfo.theSliders ) do        
        if (s.channel > 0) then
            updateSliderPosition(s, audio.getVolume( { channel=s.channel } ))
        else
            -- master volume
            updateSliderPosition(s, audio.getVolume())            
        end
    end
    
end


-- -----------------------------------------------------------------------------
-- ui creation routines

function makeText()
    -- create text labels and store them back into textInfo table for future use
    -- Assumes the x,y values are TopLeft anchor points
    for i,item in ipairs( textInfo ) do
        item.handle =  display.newText(item.string, item.x, item.y, item.font, item.fsize )
        item.handle.anchorX, item.handle.anchorY = 0.0, 0.0
        item.handle:setFillColor( item.r,item.g,item.b )
    end
end

function makeSliders()
    sliderInfo.theSliders = {}
    -- Iterate through sliderInfo array 
    for i,item in ipairs( sliderInfo ) do
        if item.isVertical then
            trackGraph = "trackVertical.png"
            thumbD = "thumbVertical1.png"
            thumbDrag = "thumbVertical1.png"
        else
            trackGraph = "trackHoriz.png"
            thumbD = "thumbHorizontal1.png"
            thumbDrag = "thumbHorizontal1.png"
        end
        local mySlider = slider.newSlider( 
            { 
                track = trackGraph,
                thumbDefault = thumbD,
                thumbOver = thumbDrag,
                isVertical = item.isVertical,
                onEvent	= onSlider,
                minValue = item.minValue,
                maxValue = item.maxValue,
            } 
        )
        mySlider.x = item.x
        mySlider.y = item.y
        mySlider.channel = item.channel
        sliderInfo.theSliders[i] = mySlider
        sliderInfo.theSliders[i].value = 0.5
    end
end

function makeButtons()
    buttonInfo.theButtons = {}

    -- Iterate through buttonInfo table creating buttons and storing the
    -- references back in the table
    for i,item in ipairs( buttonInfo ) do
        local myButton = widget.newButton
		{ 
	    	defaultFile = item.default,
		    overFile = item.over,
		    label = item.text,
	        fontSize = 16,
		    emboss = item.emboss,
			onPress = item.onPress,
			labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0 } }
		}
        myButton.x = item.x
        myButton.y = item.y
        myButton.channel = item.channel
        buttonInfo.theButtons[i] = myButton
    end
end




-- --------------------------------
-- begin main code here
-- --------------------------------

-- load sound files

-- test the loadSound, loadStream and dispose methods
ch3Sound = audio.loadSound( "loop3.wav" )
backgroundMusic = audio.loadStream( "loop1.wav" )
audio.dispose( ch3Sound )
audio.dispose( backgroundMusic )
ch3Sound = nil               -- This clears the audio channel handle after dispose
backgroundMusic = nil                                

 
ch1Stream = audio.loadStream("loop1.wav")
ch2Stream = audio.loadStream("loop2.mp3")
ch3Sound = audio.loadSound("loop3.wav")
ch4Sound = audio.loadSound("loop4.wav")
ch5Sound = audio.loadSound("loop5.wav")
totalTime = audio.getDuration( ch1Stream ) 

-- draw UI elements
local bg = display.newRect( centerX, centerY, _W, _H )
bg:setFillColor( 50/255, 50/255, 50/255  )
makeSliders()
makeText()
makeButtons()

-- initialize the four main channels and their labels

-- play the loop on channel 1, loop infinitely, and fadein over 5 seconds 
updateChannelLabel(1, true)
audioChannels[1] = audio.play( ch1Stream, { channel=1, loops=-1, fadein=5000 }  )
setChannelVolume(1, 0.5)

-- play the speech on channel 2, for at most 30 seconds, and invoke a callback when the audio finishes playing
updateChannelLabel(2, true)
audioChannels[2] = audio.play( ch2Stream, { channel=2, duration=30000, onComplete=NarrationFinished } )  
setChannelVolume(2, 0.5)

-- play this loop on any available channel
updateChannelLabel(3, true)
audioChannels[3] = audio.play( ch3Sound, { loops=-1 } ) 
setChannelVolume(3, 0.5)

-- play the loop on next available channel, loop infinitely 
updateChannelLabel(4, true)
audioChannels[4] = audio.play( ch4Sound, { loops=-1 } ) 
setChannelVolume(4, 0.5)

-- set master volume
audio.setVolume(.5)         

Runtime:addEventListener("enterFrame", updateFrame)
