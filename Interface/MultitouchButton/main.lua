--
-- Project: MutitouchButton
--
-- Date: August 19, 2010
--
-- Version: 1.2
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Multitouch Button sample app, shows how to allow multiple buttons to be pressed simultaneously
--
-- Demonstrates: Multitouch and use of external libraries
--
-- File dependencies:
--
-- Target devices: Devices only
--
-- Limitations: Mutitouch not supported on Simulator
--
-- Update History:
--	v1.2	Added Simulator warning message
--
-- Comments: Pinch and Zoom to scale the image on the screen.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------
                                                                
-- activate multitouch so multiple touches can press different buttons simultaneously
system.activate( "multitouch" )

local widget = require( "widget" )

local button1 = widget.newButton
{
	defaultFile = "buttonRed.png",
	overFile = "buttonRedOver.png",
	label = "Button 1",
	emboss = true
}

local button2 = widget.newButton
{
	defaultFile = "buttonRed.png",
	overFile = "buttonRedOver.png",
	label = "Button 2",
	emboss = true
}

local button3 = widget.newButton
{
	defaultFile = "buttonRed.png",
	overFile = "buttonRedOver.png",
	label = "Button 3",
	emboss = true
}

button1.x = 160; button1.y = 160
button2.x = 160; button2.y = 240
button3.x = 160; button3.y = 320

-- Displays App title
title = display.newText( "Multitouch Buttons", display.contentCenterX, 50, native.systemFontBold, 20 )
title:setFillColor( 1,1,0 )

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Multitouch Events not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Multitouch not supported on Simulator!", display.contentCenterX, 400, native.systemFontBold, 14 )
	msg:setFillColor( 1,1,0 )
end
