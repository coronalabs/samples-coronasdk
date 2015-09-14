-- 
-- Abstract: Button Events sample app, showing different button properties and handlers.
-- (Also demonstrates the use of external libraries.)
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- This example shows you how to create buttons in various ways by using the widget library.
-- The project folder contains additional button graphics in various colors.
--
-- Supports Graphics 2.0

-- Require the widget library
local widget = require( "widget" )

local background = display.newImage("carbonfiber.jpg", true) -- flag overrides large image downscaling
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2

local roundedRect = display.newRoundedRect( 10, 50, 300, 40, 8 )
roundedRect.anchorX, roundedRect.anchorY = 0.0, 0.0 	-- simulate TopLeft alignment
roundedRect:setFillColor( 0/255, 0/255, 0/255, 170/255 )

local t = display.newText( "Waiting for button event...", 0, 0, native.systemFont, 18 )
t.x, t.y = display.contentCenterX, 70
-------------------------------------------------------------------------------
-- Create 5 buttons, using different optional attributes
-------------------------------------------------------------------------------


-- These are the functions triggered by the buttons

local button1Press = function( event )
	t.text = "Button 1 pressed"
end

local button1Release = function( event )
	t.text = "Button 1 released"
end


local buttonHandler = function( event )
	t.text = "id = " .. event.target.id .. ", phase = " .. event.phase
end


-- This button has individual press and release functions
-- (The label font defaults to native.systemFontBold if no font is specified)

local button1 = widget.newButton
{
	defaultFile = "buttonRed.png",
	overFile = "buttonRedOver.png",
	label = "Button 1 Label",
	emboss = true,
	onPress = button1Press,
	onRelease = button1Release,
}


-- These other four buttons share a single event handler function, identifying themselves by "id"
-- Note that if a general "onEvent" handler is assigned, it overrides the "onPress" and "onRelease" handling

-- Also, some label fonts may appear vertically offset in the Simulator, but not on device, due to
-- different device font rendering. The button object has an optional "offset" property for minor
-- vertical adjustment to the label position, if necessary (example: offset = -2)

local button2 = widget.newButton
{
	id = "button2",
	defaultFile = "buttonYellow.png",
	overFile = "buttonYellowOver.png",
	label = "Button 2 Label",
	labelColor = 
	{ 
		default = { 51, 51, 51, 255 },
	},
	font = native.systemFont,
	fontSize = 22,
	emboss = true,
	onEvent = buttonHandler,
}

local button3 = widget.newButton
{
	id = "button3",
	defaultFile = "buttonGray.png",
	overFile = "buttonBlue.png",
	label = "Button 3 Label",
	font = native.systemFont,
	fontSize = 28,
	emboss = true,
	onEvent = buttonHandler,
}

local buttonSmall = widget.newButton
{
	id = "smallBtn",
	defaultFile = "buttonBlueSmall.png",
	overFile = "buttonBlueSmallOver.png",
	label = " I'm Small",
	fontSize = 12,
	emboss = true,
	onEvent = buttonHandler,
}

-- Of course, buttons don't always have labels
local buttonArrow = widget.newButton
{
	id = "arrow",
	defaultFile = "buttonArrow.png",
	overFile = "buttonArrowOver.png",
	onEvent = buttonHandler,
}

button1.x = 160; button1.y = 160
button2.x = 160; button2.y = 240
button3.x = 160; button3.y = 320
buttonSmall.x = 85; buttonSmall.y = 400
buttonArrow.x = 250; buttonArrow.y = 400
