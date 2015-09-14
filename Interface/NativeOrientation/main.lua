-- 
-- Abstract: Native Orientation sample app, demonstrating orientation using build settings.
-- This example launches in landscape mode, but will auto-rotate both Corona and native UI elements.
-- To lock orientation, reduce the number of "supported" orientations in the build.settings file.
-- (Also see the build.settings file in this project.)
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" );

local function buttonHandler(event)
	myAlert = native.showAlert(
		"Alert!", 
		"This is either a desktop or device native alert dialog.",
		{ "Cancel", "OK" } 
	);
end
 
local blueButton = widget.newButton
{
    defaultFile = "buttonBlue.png",
    overFile = "buttonBlueOver.png",
    label = "Press for Alert",
    labelColor = 
	{ 
		default = { 1, 1, 1 }, 
	},
    font = native.systemFontBold,
    fontSize = 18,
    emboss = true,
	onRelease = buttonHandler,
}

blueButton.x = 160
blueButton.y = 50

local myLabel = display.newText( "Position (0,0) is the top left in all orientations.", 160, 90, native.systemFont, 13 )
myLabel:setFillColor( 102/255, 1, 102/255 )

-- Display current orientation using "system.orientation"
-- (default orientation is determined in build.settings file)

local orientationLabel = display.newText( "Orientation: (default)", 0, 90, native.systemFont, 15 )
orientationLabel.x, orientationLabel.y = myLabel.x, myLabel.y + myLabel.contentHeight
orientationLabel:setFillColor( 240/255, 240/255, 90/255 )


local function onOrientationChange( event )
	orientationLabel.text = "Orientation: " .. system.orientation
end

Runtime:addEventListener( "orientation", onOrientationChange )