-- Project: Analytics
--
-- Date: November 16, 2010
--
-- Version: 1.1
--
-- File name: main.lua
--
-- Code type: SDK Test code
--
-- Author: Corona Labs
--
-- Demonstrates: analytics API
--
-- File dependencies: none
--
-- Target devices: iOS, Android
--
-- Limitations:
--
-- Update History:
--
-- 1.1 - Replaced depreciated ui library with widget library
--
-- Comments: 
--
--		This sample demonstrates the use of analytics in Corona.
--		To use it, you must first create an account on Flurry.
--		Go to www.flurry.com and sign up for an account. Once you have
--		logged in to flurry, go to Manage Applications. Click "Create a new app".
--		Choose iPhone, iPad, or Android as appropriate. This will create
--		an "Application key" which you must enter in the code below (we
--		recommend making a copy of this sample, rather than editing it directly).
--
--		Build your app for device and install it. When you run it, you can
--		optionally click on the buttons to create additional event types.
--		The analytics data is uploaded when you quit the app, or possibly
--		on next launch if there was a problem (such as no network).
--
--		Finally, in your Flurry account, choose "View analytics" to 
--		see the data created by your app.
--		Note that it takes some time for the analytics data to appear
--		in the Flurry statistics, it does not appear immediately.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local analytics = require( "analytics" )
local widget = require( "widget" )

-- Replace this string with your unique application key, obtained from www.flurry.com.
local application_key = "1234567890ABCDEFG"

analytics.init( application_key )

local buttonRelease1 = function( event )
	print( "Logging event 1" )
	-- When button 1 is pressed, it logs an event called "event1"
	analytics.logEvent("event1")
end

local buttonRelease2 = function( event )
	print( "Logging event 2" )
	-- When button 2 is pressed, it logs an event called "event2"
	analytics.logEvent("event2")
end

local buttonRelease3 = function( event )
	print( "Logging event 3" )
	-- When button 3 is pressed, it logs an event called "event3"
	analytics.logEvent("event3")
end

-- Create buttons for each event
local button1 = widget.newButton
{
	left = 10,
	top = 40,
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Log Event 1",
	labelColor = 
	{ 
		default = { 1, 1, 1 }, 
		over = { 1, 0, 0 } 
	},
	fontSize = 20,
	font = native.systemFontBold,
	onRelease = buttonRelease1
}

local button2 = widget.newButton
{
	left = 10,
	top = button1.y + 42, 
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Log Event 2",
	labelColor = 
	{ 
		default = { 1, 1, 1 }, 
		over = { 1, 0, 0 } 
	},
	fontSize = 20,
	font = native.systemFontBold,
	onRelease = buttonRelease2
}

local button3 = widget.newButton
{
	left = 10,
	top = button2.y + 42, 
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Log Event 3",
	labelColor = 
	{ 
		default = { 1, 1, 1 }, 
		over = { 1, 0, 0 } 
	},
	fontSize = 20,
	font = native.systemFontBold,
	onRelease = buttonRelease3
}
